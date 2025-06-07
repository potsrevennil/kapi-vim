{
  description = "kapi-vim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

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
          # Per-system attributes can be defined here. The self' and inputs'
          # module parameters provide easy access to attributes of the same
          # system.

          # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
          overlayAttrs = {
            kapi-vim = config.packages.default;
            kapi-vim-bundle = config.packages.bundle;
          };

          # nvim with built-in dependencies, but without any configuration
          packages.default = pkgs.lib.makeOverridable
            (wrapKapiVim {
              pname = "kapi-vim";
              conf = kapiVimConfig;
            })
            { };

          # plug-and-play neovim, no additional setup needed
          packages.bundle = pkgs.lib.makeOverridable
            (wrapKapiVim {
              pname = "kapi-vim-bundle";
              conf = kapiVimConfig // {
                wrapperArgs = [
                  "--add-flags"
                  ''-u ${kapiVimRC}/init.lua''
                  "--add-flags"
                  ''--cmd "set rtp^=${kapiVimRC}"''
                ];
              };
            })
            { };

          devShells.default = pkgs.mkShellNoCC
            {
              packages = [ config.packages.default ];

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
