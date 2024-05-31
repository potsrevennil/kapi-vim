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
          nvimConfig = pkgs.stdenv.mkDerivation {
            name = "nvim-config";
            src = ./.;
            buildPhase = ''
              mkdir -p $out
              cp -r ftdetect $out/
              cp -r ftplugin $out/
              cp -r lua $out/
              cp -r init.lua $out/
            '';
          };

          sharedPkgs = builtins.attrValues {
            inherit (pkgs)
              tokei

              direnv
              nix-direnv

              nixpkgs-fmt
              nixd
              deadnix
              statix

              lua
              lua-language-server
              stylua

              taplo
              codespell
              commitlint;

            inherit (pkgs.nodePackages)
              vim-language-server;
          };
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
          packages.default = pkgs.symlinkJoin {
            name = "kapi-vim";
            paths = [
              (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
                viAlias = true;
                vimAlias = true;
                wrapperArgs = [
                  "--add-flags"
                  ''-u ${nvimConfig}/init.lua''
                  "--add-flags"
                  ''--cmd "set rtp^=${nvimConfig}"''
                ];
                wrapRc = false;
                packpathDirs.myNeovimPackages = with pkgs.vimPlugins; {
                  start = [
                    nvim-lspconfig
                    none-ls-nvim
                    nvim-cmp
                    cmp-nvim-lsp
                    luasnip
                    nvim-treesitter.withAllGrammars
                    telescope-nvim
                    dracula-vim
                    hardtime-nvim
                    markdown-preview-nvim
                    vim-startuptime
                    lean-nvim
                  ];
                };
              })
              pkgs.ripgrep
            ];
          };

          # nvim with built-in dependencies, customize to your liking
          packages.base = pkgs.symlinkJoin {
            name = "kapi-vim-base";
            paths = [
              (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
                viAlias = true;
                vimAlias = true;
                wrapRc = false;
                packpathDirs.myNeovimPackages = with pkgs.vimPlugins; {
                  start = [
                    nvim-lspconfig
                    none-ls-nvim
                    nvim-cmp
                    cmp-nvim-lsp
                    luasnip
                    nvim-treesitter.withAllGrammars
                    telescope-nvim
                    mini-nvim
                    dracula-vim
                    hardtime-nvim
                    markdown-preview-nvim
                    vim-startuptime
                    lean-nvim
                  ];
                };
              })
              pkgs.ripgrep
            ];
          };

          packages.lsp = pkgs.buildEnv
            {
              name = "kapi-vim-lsp";
              paths = sharedPkgs ++ builtins.attrValues {
                inherit (pkgs)
                  # shell
                  shfmt
                  shellcheck

                  # toml, yaml
                  yaml-language-server

                  #typst
                  typst
                  typst-lsp
                  typstfmt

                  # rust
                  rustup

                  # go
                  go
                  gopls
                  golangci-lint
                  gotools
                  govulncheck

                  # haskell
                  ghc
                  haskell-language-server

                  # C
                  # clang-tools
                  astyle

                  # lean
                  lean4;

                # inherit (pkgs.llvmPackages)
                #   clang;

                inherit (pkgs.python311Packages)
                  python
                  python-lsp-server
                  black;

                inherit (pkgs.nodePackages)
                  bash-language-server;
              };
            };

          devShells. default = pkgs.mkShellNoCC
            {
              packages = sharedPkgs;

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
