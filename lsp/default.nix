{ enable_markdown ? true
, enable_python ? true
, enable_shell ? true
, enable_typst ? true
, enable_c ? true
, enable_rust ? true
, enable_go ? true
, enable_haskell ? false
, enable_lean ? false
, lib
, direnv
, nix-direnv
, nixpkgs-fmt
, nixd
, deadnix
, statix
, lua54Packages
  # , vim-language-server
, nodePackages
, lua-language-server
, stylua
, prettierd
, taplo
, yaml-language-server
, python311Packages
, shfmt
, shellcheck
, typst
, typstyle
, typst-lsp
, go
, gopls
, golangci-lint
, gotools
, govulncheck
, rustup
, ghc
, haskell-language-server
, clang-tools
, elan
, tokei
, codespell
, commitlint
, ...
}:
let
  nixPkgs = [
    direnv
    nix-direnv

    # nix
    nixpkgs-fmt
    nixd
    deadnix
    statix
  ];

  vimPkgs = [ lua-language-server stylua ] ++ builtins.attrValues {
    # inherit vim-language-server;
    inherit (lua54Packages)
      lua
      luarocks;
  };

  mkPkgs = [
    prettierd
    taplo
    yaml-language-server
  ];

  pyPkgs = builtins.attrValues {
    inherit (python311Packages)
      python
      python-lsp-server
      black;
  };

  shPkgs = [ shfmt shellcheck ] ++ builtins.attrValues {
    inherit (nodePackages)
      bash-language-server;
  };

  typstPkgs = [
    typst
    typstyle
    typst-lsp
  ];

  goPkgs = [
    go
    gopls
    golangci-lint
    gotools
    govulncheck
  ];

  rustPkgs = [
    rustup
  ];

  hsPkgs = [
    ghc
    haskell-language-server
  ];

  cPkgs = [
    clang-tools
  ];

  leanPkgs = [
    elan
  ];
in
nixPkgs
++ vimPkgs
++ lib.optionals enable_markdown mkPkgs
++ lib.optionals enable_python pyPkgs
++ lib.optionals enable_shell shPkgs
++ lib.optionals enable_c cPkgs
++ lib.optionals enable_rust rustPkgs
++ lib.optionals enable_go goPkgs
++ lib.optionals enable_haskell hsPkgs
++ lib.optionals enable_lean leanPkgs
++ lib.optionals enable_typst typstPkgs
++ [
  tokei
  codespell
  commitlint
]
