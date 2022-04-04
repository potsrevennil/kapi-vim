# nerd-fonts installation
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
# should set the font of iterm2 afterwards

# languages

## bash
npm i -g bash-language-server
go install mvdan.cc/sh/v3/cmd/shfmt@latest

## go
go install honnef.co/go/tools/cmd/staticcheck@latest

## haskell
cabal install apply-refact

## lua
brew install cmake luarocks lua-language-server
cargo install stylua

## python
brew install pipx
pipx install 'python-lsp-server[all]'
pipx ensurepath
pipx install flake8
pipx install autopep8
pipx install yapf

## rust
brew install rust-analyzer

## typescript
npm install -g prettier
npm install -g eslint

# fzf
brew install the_silver_searcher
brew install ripgrep
brew install bat
brew install git-delta
