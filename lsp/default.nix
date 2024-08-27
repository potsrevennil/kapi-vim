{ pkgs, ... }:
let
  nixPkgs = builtins.attrValues {
    inherit (pkgs)
      direnv
      nix-direnv

      # nix
      nixpkgs-fmt
      nixd
      deadnix
      statix;
  };

  vimPkgs = builtins.attrValues {
    inherit (pkgs)
      lua-language-server
      stylua;
    inherit (pkgs.lua54Packages)
      lua
      luarocks;
    inherit (pkgs.nodePackages)
      vim-language-server;
  };

  mkPkgs = builtins.attrValues {
    inherit (pkgs)
      prettierd
      taplo
      yaml-language-server;
  };

  pyPkgs = builtins.attrValues {
    inherit (pkgs.python311Packages)
      python
      python-lsp-server
      black;
  };

  shPkgs = builtins.attrValues {
    inherit (pkgs)
      shfmt
      shellcheck;
    inherit (pkgs.nodePackages)
      bash-language-server;
  };

  typstPkgs = builtins.attrValues {
    inherit (pkgs)
      typst
      typstyle
      typst-lsp;
  };

  goPkgs = builtins.attrValues {
    inherit (pkgs)
      go
      gopls
      golangci-lint
      gotools
      govulncheck;
  };
in
builtins.attrValues {
  inherit nixPkgs vimPkgs mkPkgs pyPkgs shPkgs goPkgs typstPkgs;
  inherit (pkgs)
    tokei
    codespell
    commitlint

    # rust
    rustup

    # haskell
    ghc
    haskell-language-server

    # C
    astyle

    # lean
    lean4;
}
