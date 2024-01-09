# Kapi Vim

## Introduction

Ka-pi(咖啡) means coffee in my native language. Hoping that my configuration will be customized and gernal enough,
so that the installation won't take longer time than making a cup of coffee.

## Table of Contents

## Plugins

https://github.com/potsrevennil/kapi-vim/blob/ec44714a274468d23bd242e99028fb31c38e1142/flake.nix#L44-L54

## Usage

- `nix build github:potsrevennil/kapi-vim#lsp` for installing lsp runtime dependencies
- `nix run github:potsrevennil/kapi-vim` for trying out the neovim configuration
- `nix-shell -p github:potsrevennil/kapi-vim` for trying out the neovim configuration in a temporary nix shell
- `nix profile install github:potsrevennil/kapi-vim` for installing the neovim configuration
- check [kapi-sysconf](https://github.com/potsrevennil/kapi-sysconf) for how to integrate with other flake modules
