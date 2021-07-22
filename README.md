# Kapi Vim

## Introduction
  Ka-pi means "咖啡", which is coffee, in my native language. Hoping that my configuration will be customized and gernal enough,
  so that the installation won't take longer time than making a cup of coffee.
  
## Table of Contents


## Plugins

- Plugin management via [vim-plug](https://github.com/junegunn/vim-plug)
- Common config for Neovim's native LSP [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- LSP install manager [nvim-lspinstall](https://github.com/kabouzeid/nvim-lspinstall)
- Status line via [vim-airline](https://github.com/vim-airline/vim-airline)
- Status line color scheme [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)
- File browser with [fern](https://github.com/lambdalisue/fern.vim)
- Pretty icons with file browser [nerdfont](https://github.com/lambdalisue/nerdfont.vim) and [fern-renderer-nerdfont](https://github.com/lambdalisue/fern-renderer-nerdfont.vim)
- Preview file for File browser [fern-preview.vim](https://github.com/yuki-yano/fern-preview.vim)
- Code commenting via [nerdcommenter](https://github.com/preservim/nerdcommenter)
- Fuzzy finder [fzf](https://github.com/junegunn/fzf)

## Requirements

### fzf
- The Silver Searcher
    ```sh
    brew install the_silver_searcher
    ```

- ripgrep
    ```sh
    brew install ripgrep
    ```

- bat
    ```sh
    brew install bat
    ```

- delta
    ```sh 
    brew install git-delta
    ```

### nerd font
```sh
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
# should set the font of iterm2 afterwards
```

## Customize

- fern 
    - For more customized configuration example for fern please refer to [fern tips](https://github.com/lambdalisue/fern.vim/wiki/Tips)
