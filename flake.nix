{
  description = "kapi-vim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          LuaConfig = pkgs.stdenv.mkDerivation {
            name = builtins.baseNameOf self;
            src = self;
            buildPhase = ''
              source $stdenv/setup
              mkdir -p $out
              cp -r ${self}/* $out/
            '';
          };
        in
        {
          # Per-system attributes can be defined here. The self' and inputs'
          # module parameters provide easy access to attributes of the same
          # system.

          # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
          packages.default = pkgs.wrapNeovim pkgs.neovim-unwrapped {
            viAlias = true;
            vimAlias = true;
            configure = {
              customRC =
                ''
                  lua package.path = "${LuaConfig}/lua/?.lua;${LuaConfig}/lua/?/init.lua;" .. package.path
                  execute "source ${LuaConfig}/init.lua"
                '';
              packages.kapi-vim = with pkgs.vimPlugins; {
                start = [
                  nvim-lspconfig
                  nvim-cmp
                  cmp-nvim-lsp
                  nvim-treesitter.withAllGrammars
                  telescope-nvim
                  mini-nvim
                  dracula-vim
                  hardtime-nvim
                  markdown-preview-nvim
                ];
                opt = [ ];
              };
            };
          };

          packages.lsp = with pkgs; buildEnv {
            name = "LSP";
            paths = [
              tokei

              # nix
              nixpkgs-fmt
              nixd

              # lua
              lua
              lua-language-server

              # shell
              nodePackages.bash-language-server
              shfmt
              shellcheck

              # toml, yaml
              taplo
              yaml-language-server
              codespell

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
              llvmPackages.clang
              clang-tools

              # python
              python3
              python311Packages.python-lsp-server
            ];
          };
        };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
