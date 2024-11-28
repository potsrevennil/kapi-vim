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
