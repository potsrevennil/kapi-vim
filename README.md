# Kapi Vim

## Introduction

Ka-pi(咖啡) means coffee in my native language. Hoping that my configuration will be customized and general enough,
so that the installation won't take longer time than making a cup of coffee.

## Plugins

https://github.com/potsrevennil/kapi-vim/blob/702ba0e14e0776db24d08924b2695d4d8c4efea9/lazy-lock.json#L1-L21

## Usage

- `nix run github:potsrevennil/kapi-vim` for trying out the neovim configuration
- `nix build github:potsrevennil/kapi-vim#bundle` for an opinionated Neovim configuration, including LSP runtime dependencies.
- `nix profile install github:potsrevennil/kapi-vim#bundle` for installing the neovim configuration to system path
- check [kapi-sysconf](https://github.com/potsrevennil/kapi-sysconf) for how to integrate with other flake modules

## Language toolchains

The packages ship editor-wide tooling only: nixd, lua-language-server, plus the config (prettierd, taplo, yaml-language-server), shell, typst and js (nodejs) toggles. Per-language toolchains (python, c, rust, go, haskell, lean) are off by default, because their server, formatter and linter have to match each project's compiler and CI. Provide them from the project's flake devShell and load it with direnv before starting `nvim`; the config only names the tools, so it picks up whatever is first on `PATH`, and skips any that are missing without warnings.

On a machine without project flakes, turn languages on explicitly:

- `KAPI_VIM_LANGS=python,go nix run --impure github:potsrevennil/kapi-vim#bundle`
- `kapi-vim.override { enable_go = true; }` when consuming the package or overlay
