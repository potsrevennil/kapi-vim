# Kapi Vim

## Introduction

Ka-pi(咖啡) means coffee in my native language. Hoping that my configuration will be customized and general enough,
so that the installation won't take longer time than making a cup of coffee.

## Table of Contents

## Plugins

https://github.com/potsrevennil/kapi-vim/blob/09950fe0fbd2eac223c23563495d1aacf85f0174/flake.nix#L52-L66

## Usage

- `nix build github:potsrevennil/kapi-vim#lsp` for installing lsp runtime dependencies
- `nix run github:potsrevennil/kapi-vim` for trying out the neovim configuration
- `nix-shell -p github:potsrevennil/kapi-vim` for trying out the neovim configuration in a temporary nix shell
- `nix profile install github:potsrevennil/kapi-vim` for installing the neovim configuration
- check [kapi-sysconf](https://github.com/potsrevennil/kapi-sysconf) for how to integrate with other flake modules
