{
  description = "kapi-vim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ flake-parts.flakeModules.easyOverlay ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, pkgs, ... }:
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
            plugins = [ pkgs.vimPlugins.lazy-nvim ];
          };

          wrapKapiVim = pkgs.wrapNeovimUnstable (
            pkgs.neovim-unwrapped.overrideAttrs (
              old: {
                buildInputs = old.buildInputs ++ builtins.attrValues { inherit (pkgs) tree-sitter ripgrep; };
              }
            )
          );

          lspPkgs = pkgs.callPackage ./lsp.nix { };
        in
        {
          # Per-system attributes can be defined here. The self' and inputs'
          # module parameters provide easy access to attributes of the same
          # system.

          # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
          overlayAttrs = {
            kapi-vim = config.packages.default;
            kapi-vim-base = config.packages.base;
            kapi-vim-lsp = config.packages.lsp;
          };

          # plug-and-play neovim, no additional setup needed
          packages.default =
            wrapKapiVim (kapiVimConfig // {
              wrapperArgs = [
                "--add-flags"
                ''-u ${kapiVimRC}/init.lua''
                "--add-flags"
                ''--cmd "set rtp^=${kapiVimRC}"''
              ];
            });

          # nvim with built-in dependencies, but without any configuration
          packages.base = wrapKapiVim kapiVimConfig;

          packages.lsp = lspPkgs;

          devShells.default = pkgs.mkShellNoCC
            {
              packages = lspPkgs;

              shellHook = ''
                export PATH=$PWD/bin:$PATH
              '';
            };
        };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
