""""""""""""""""""""""""""""""""""""""""""
"                                        "
"                                        "
"                                        "
"                                        "
""""""""""""""""""""""""""""""""""""""""""
" 1. General {{{1
""""""""""""""""""""""""""""""""""""""""""
set shell=$SHELL

" compatibility for vim and neovim
if !has('nvim')
  set nocompatible
  " set term inside tmux for xterm-key on (nvim doesn't need this)
  if &term =~ '^screen\|^tmux' && exists('$TMUX')
    if &term =~ '256color'
      set term=xterm-256color
    else
      set term=xterm
    endif
  endif
  if &term =~ '256color'
    set t_ut=
  endif

  "" NOTE: Not woring
  "if exists('$TMUX')
    "set t_8f=[38;2;%lu;%lu;%lum]
    "set t_8b=[48;2;%lu;%lu;%lum]
  "endif
endif

" True color support
if has('termguicolors')
  set termguicolors
endif

" Neovim settings
let g:python3_host_prog = '/usr/bin/python3'

" Set to auto read when a file is changed from the outside
set autoread

filetype plugin on
""""""""""""""""""""""""""""""""""""""""""
" 2. Plugins {{{1
""""""""""""""""""""""""""""""""""""""""""
" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()
Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ayu-theme/ayu-vim'
" language plugins
Plug 'rust-lang/rust.vim'
Plug 'derekelkins/agda-vim'
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim'
call plug#end()
""""""""""""""""""""""""""""""""""""""""""
" 3. Fold {{{1
""""""""""""""""""""""""""""""""""""""""""
set foldmethod=marker
set foldcolumn=1

augroup match_folds
    autocmd!
    " VimEnter handles at start up, WinNew for each window created AFTER startup.
    " Regex matches { { { with an empty group in the middle so that vim does
    " not create a fold in this code, then either a 1 or 2 then a space. Then
    " zs is the start of the match which is the rest of the line then ze is
    " the end of the match. Refer to :help pattern-overview
    autocmd VimEnter,WinNew * let w:_foldlevel1_id = matchadd('_FoldLevel1', '{{\(\){1\ \zs.\+\ze', -1)
    autocmd VimEnter,WinNew * let w:_foldlevel2_id = matchadd('_FoldLevel2', '{{\(\){2\ \zs.\+\ze', -1)
augroup END

hi Folded               guifg=#FF9999 guibg=#005050 gui=bold,italic
hi FoldColumn           guifg=#FF9999 guibg=#005050 gui=bold
hi _FoldLevel1          guifg=#005050 guibg=#FF9999 gui=bold,italic
hi _FoldLevel2          guifg=#003030 guibg=#CC8080 gui=bold,italic
""""""""""""""""""""""""""""""""""""""""""
" 4. Tab, Indent {{{1
""""""""""""""""""""""""""""""""""""""""""
set tabstop=4
set expandtab
set shiftwidth=4
set shiftround
set autoindent
""""""""""""""""""""""""""""""""""""""""""
" 5. UI {{{1
""""""""""""""""""""""""""""""""""""""""""
:set number relativenumber
""""""""""""""""""""""""""""""""""""""""""
" 6. Color Theme {{{1
""""""""""""""""""""""""""""""""""""""""""
syntax on
set termguicolors
let ayucolor="dark"
colorscheme ayu
""""""""""""""""""""""""""""""""""""""""""
" 7. ALE Global Setting {{{1
""""""""""""""""""""""""""""""""""""""""""
let g:ale_fixers = {
\    '*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_fix_on_save = 1
let g:ale_disable_lsp=1

""""""""""""""""""""""""""""""""""""""""""
" }}}1
