""""""""""""""""""""""""""""""""""""""""""
"                                        "
"                                        "
"                                        "
"                                        "
""""""""""""""""""""""""""""""""""""""""""
" 1. General {{{1
""""""""""""""""""""""""""""""""""""""""""
set shell=$SHELL

" True color support
if has('termguicolors')
  set termguicolors
endif

" Neovim settings
let g:python3_host_prog = '/usr/bin/python3'

" TextEdit might fail if hidden is not set.
"set hidden
"set ma
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
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Fern related plugins
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'yuki-yano/fern-preview.vim'

"Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdcommenter'
Plug 'ayu-theme/ayu-vim'
Plug 'junegunn/fzf.vim'
call plug#end()
""""""""""""""""""""""""""""""""""""""""""
" 3. Fold {{{1
""""""""""""""""""""""""""""""""""""""""""
set foldmethod=marker
set foldcolumn=1
""""""""""""""""""""""""""""""""""""""""""
" 4. Tab, Indent {{{1
""""""""""""""""""""""""""""""""""""""""""
set tabstop=4
set expandtab
set shiftwidth=4
set shiftround
""""""""""""""""""""""""""""""""""""""""""
" 5. UI {{{1
""""""""""""""""""""""""""""""""""""""""""
set cmdheight=3
set number relativenumber
let g:airline_solarized_bg='dark'
let g:airline#extensions#tabline#enabled = 1

"let g:airline#extensions#coc#enabled = 1
""""""""""""""""""""""""""""""""""""""""""
" 5. Color Theme {{{1
""""""""""""""""""""""""""""""""""""""""""
let ayucolor="dark"
colorscheme ayu
""""""""""""""""""""""""""""""""""""""""""
" 6. Fern Related Setup {{{1
let g:fern#renderer = "nerdfont"

nnoremap <C-t> :Fern . -drawer -toggle<CR>

function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
endfunction

augroup fern-settings
  autocmd!
  autocmd FileType fern call s:fern_settings()
augroup END


""""""""""""""""""""""""""""""""""""""""""
" 10. ALE Global Setting {{{1
""""""""""""""""""""""""""""""""""""""""""
"let g:ale_fixers={
"\    '*': ['remove_trailing_lines', 'trim_whitespace'],
"\}
"let g:ale_fix_on_save=1
"let g:ale_disable_lsp=1

""""""""""""""""""""""""""""""""""""""""""
" }}}1
