# Kapi Vim

## Introduction
  Ka-pi(咖啡) means coffee in my native language. Hoping that my configuration will be customized and gernal enough,
  so that the installation won't take longer time than making a cup of coffee.
  
## Table of Contents


## Plugins

- Plugin management via [vim-plug](https://github.com/junegunn/vim-plug)
<!--- Auto Completion for nvim via [nvim-compe](https://github.com/hrsh7th/nvim-compe)-->
- Common config for Neovim's native LSP via [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
<!--- plenary [plenary](https://github.com/nvim-lua/plenary.nvim)-->
<!--- Highlighting via [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)-->
- Asynchronous Lint Engine [ale](https://github.com/dense-analysis/ale)
- Language specific plugins
    - [markdown preview](https://github.com/iamcco/markdown-preview.nvim)
    - [rust-lang](https://github.com/rust-lang/rust.vim) and [rust-tools](https://github.com/simrat39/rust-tools.nvim)
    <!--- [lean](https://github.com/Julian/lean.nvim)-->
- Status line via [vim-airline](https://github.com/vim-airline/vim-airline)
- Status line color scheme using [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)
- color scheme [iceberg](https://github.com/cocopon/iceberg.vim)
- Code commenting via [nerdcommenter](https://github.com/preservim/nerdcommenter)
<!--- Fuzzy finder via [fzf](https://github.com/junegunn/fzf)-->

## Requirements

### haskell language server
- Follow the installation instruction [here](https://github.com/haskell/haskell-language-server#installatio)
- install [apply-refact](https://github.com/mpickering/apply-refact)

### rust analyzer
```sh
brew install rust-analyzer
```

<!--### fzf-->
<!--- The Silver Searcher-->
<!--```sh-->
<!--brew install the_silver_searcher-->
<!--```-->

<!--- ripgrep-->
<!--```sh-->
<!--brew install ripgrep-->
<!--```-->

<!--- bat-->
<!--```sh-->
<!--brew install bat-->
<!--```-->

<!--- delta-->
<!--```sh -->
<!--brew install git-delta-->
<!--```-->

### nerd font
```sh
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
# should set the font of iterm2 afterwards
```
