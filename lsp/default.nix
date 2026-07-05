{ languages ? import ./languages.nix
, enable_config ? languages.config
, enable_python ? languages.python
, enable_shell ? languages.shell
, enable_typst ? languages.typst
, enable_c ? languages.c
, enable_rust ? languages.rust
, enable_go ? languages.go
, enable_js ? languages.js
, enable_haskell ? languages.haskell
, enable_lean ? languages.lean
, lib
, direnv
, nix-direnv
, nixpkgs-fmt
, nixd
, deadnix
, statix
, lua54Packages
  # , vim-language-server
, bash-language-server
, lua-language-server
, stylua
, prettierd
, taplo
, yaml-language-server
, python3Packages
, shfmt
, shellcheck
, typst
, typstyle
, tinymist
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
, nodejs
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

  configPkgs = [
    prettierd
    taplo
    yaml-language-server
  ];

  pyPkgs = builtins.attrValues {
    inherit (python3Packages)
      python
      python-lsp-server
      black;
  };

  shPkgs = [ shfmt shellcheck bash-language-server ];

  typstPkgs = [
    typst
    typstyle
    tinymist
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

  jsPkgs = [ nodejs ];
in
nixPkgs
++ vimPkgs
++ lib.optionals enable_config configPkgs
++ lib.optionals enable_python pyPkgs
++ lib.optionals enable_shell shPkgs
++ lib.optionals enable_c cPkgs
++ lib.optionals enable_rust rustPkgs
++ lib.optionals enable_go goPkgs
++ lib.optionals enable_js jsPkgs
++ lib.optionals enable_haskell hsPkgs
++ lib.optionals enable_lean leanPkgs
++ lib.optionals enable_typst typstPkgs
++ [
  tokei
  codespell
  commitlint
]
