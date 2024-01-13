" copied from https://github.com/neovim/neovim/blob/master/runtime/ftplugin/nix.vim
" removed once this is merged into nvim stable release
"
if exists("b:did_ftplugin")
  finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

let b:undo_ftplugin = "setl commentstring< comments<"

setlocal comments=:#
setlocal commentstring=#\ %s
