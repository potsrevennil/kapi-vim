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

          wrapKapiVim =
            { pname, conf }:
            { enable_markdown ? true
            , enable_python ? true
            , enable_shell ? true
            , enable_typst ? true
            , enable_c ? true
            , enable_rust ? true
            , enable_go ? true
            , enable_haskell ? false
            , enable_lean ? false
            }: pkgs.buildEnv {
              name = pname;
              paths =
                pkgs.callPackage ./lsp
                  {
                    inherit enable_markdown enable_python enable_shell enable_typst enable_c enable_rust enable_go enable_haskell enable_lean;
                  } ++
                builtins.attrValues {
                  nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped conf;
                  inherit (pkgs)
                    tree-sitter
                    ripgrep;
                };
            };
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

            # plug-and-play neovim, no additional setup needed
            bundle = pkgs.lib.makeOverridable
              (wrapKapiVim { pname = "kapi-vim-bundle"; conf = bundleConf; })
              { };

            # plug-and-play neovim with every default-on language toggle off
            # (haskell/lean are already off by default) -- just the base
            # nixd + lua-language-server + editor tooling, fast enough for
            # CI to build and smoke-test on every run. default/bundle (the
            # full, every-language experience) are exercised in a separate,
            # slower workflow.
            lite = pkgs.lib.makeOverridable
              (wrapKapiVim { pname = "kapi-vim-lite"; conf = bundleConf; })
              {
                enable_markdown = false;
                enable_python = false;
                enable_shell = false;
                enable_typst = false;
                enable_c = false;
                enable_rust = false;
                enable_go = false;
              };
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
