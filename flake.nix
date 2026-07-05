{
  description = "kapi-vim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ flake-parts.flakeModules.easyOverlay ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, pkgs, system, lib, ... }:
        let
          kapiVimRC = pkgs.stdenv.mkDerivation {
            name = "kapi-vim-rc";
            src = ./.;
            buildPhase = ''
              mkdir -p $out
              cp -r ftdetect $out/
              cp -r lua $out/
              cp -r init.lua $out/
              cp -r filetype.lua $out/
              cp -r lazy-lock.json $out/
            '';
          };

          kapiVimConfig = pkgs.neovimUtils.makeNeovimConfig {
            viAlias = true;
            vimAlias = true;
            wrapRc = false;
            plugins = [ ];
          };

          # Same config-wired-in flags packages.bundle uses, so packages.lite
          # is also plug-and-play (needed for the neovim CI smoke test to
          # mean anything -- a toolchain-only package has no init.lua to
          # actually attach an LSP against).
          bundleConf = kapiVimConfig // {
            wrapperArgs = [
              "--add-flags"
              ''-u ${kapiVimRC}/init.lua''
              "--add-flags"
              ''--cmd "set rtp^=${kapiVimRC}"''
            ];
          };

          # Single source of truth for every per-language toggle name and its
          # default (shared with lsp/default.nix). Kept import-only -- no
          # `pkgs` needed -- so packages.lite (below) can derive "every
          # language off" from just the attribute names.
          languages = import ./lsp/languages.nix;

          wrapKapiVim =
            { pname, conf }:
            { enable_config ? languages.config
            , enable_python ? languages.python
            , enable_shell ? languages.shell
            , enable_typst ? languages.typst
            , enable_c ? languages.c
            , enable_rust ? languages.rust
            , enable_go ? languages.go
            , enable_js ? languages.js
            , enable_haskell ? languages.haskell
            , enable_lean ? languages.lean
            }@toggles: pkgs.buildEnv {
              name = pname;
              paths =
                pkgs.callPackage ./lsp toggles ++
                builtins.attrValues {
                  nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped conf;
                  inherit (pkgs)
                    tree-sitter
                    ripgrep;
                };
            };

          # Every enable_<language> toggle forced off, derived from the
          # registry -- adding a language to lsp/languages.nix means
          # packages.lite automatically excludes it too, no edits here.
          allLanguagesOff = lib.genAttrs
            (map (name: "enable_${name}") (builtins.attrNames languages))
            (_: false);

          # packages.bundle's language selection: everything off by default,
          # except whatever's named in $KAPI_VIM_LANGS (comma-separated,
          # e.g. "python,go"). Reading the env var requires --impure; without
          # it builtins.getEnv silently returns "", so a plain `nix build
          # .#bundle` (no --impure) is always the minimal, all-off build --
          # KAPI_VIM_LANGS only takes effect when explicitly opted into with
          # --impure, e.g.:
          #   KAPI_VIM_LANGS=python,go nix run --impure .#bundle
          bundleLanguages =
            let
              requested =
                let raw = builtins.getEnv "KAPI_VIM_LANGS";
                in if raw == "" then [ ] else lib.splitString "," raw;
            in
            allLanguagesOff // lib.genAttrs (map (name: "enable_${name}") requested) (_: true);
        in
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config = lib.mkForce {
              allowUnfree = true;
            };

          };
          # Per-system attributes can be defined here. The self' and inputs'
          # module parameters provide easy access to attributes of the same
          # system.

          # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
          overlayAttrs = {
            kapi-vim = config.packages.default;
            kapi-vim-bundle = config.packages.bundle;
          };

          packages = {
            # nvim with built-in dependencies, but without any configuration
            default = pkgs.lib.makeOverridable
              (wrapKapiVim {
                pname = "kapi-vim";
                conf = kapiVimConfig;
              })
              { };

            # Plug-and-play neovim (config baked in) for on-demand use --
            # e.g. a temporary Linux VM you're bringing up for a specific
            # task -- where you want to choose which LSPs come along rather
            # than get every one of them. Every language is off unless
            # named in $KAPI_VIM_LANGS; see bundleLanguages above.
            bundle = pkgs.lib.makeOverridable
              (wrapKapiVim { pname = "kapi-vim-bundle"; conf = bundleConf; })
              bundleLanguages;

            # plug-and-play neovim with every language toggle off (derived
            # from lsp/languages.nix, so this list can never drift from what
            # lsp/default.nix actually knows how to gate) -- just the base
            # nixd + lua-language-server + editor tooling, fast enough for
            # CI to build and smoke-test on every run. default/bundle (the
            # full, every-language experience) are exercised in a separate,
            # slower workflow.
            lite = pkgs.lib.makeOverridable
              (wrapKapiVim { pname = "kapi-vim-lite"; conf = bundleConf; })
              allLanguagesOff;
          };

          devShells.default = pkgs.mkShellNoCC
            {
              packages = [ config.packages.default ];

              shellHook = ''
                export PATH=$PWD/bin:$PATH
              '';
            };

          # Lean shell for CI: the same tools bin/style and .pre-commit-config.yaml
          # already use, without pulling in the full LSP/language toolchain from
          # ./lsp, so `nix develop .#ci` stays small.
          devShells.ci = pkgs.mkShellNoCC
            {
              packages = builtins.attrValues {
                inherit (pkgs)
                  nixpkgs-fmt
                  deadnix
                  statix
                  stylua
                  shfmt
                  shellcheck
                  taplo
                  codespell;
              };
            };
        };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
