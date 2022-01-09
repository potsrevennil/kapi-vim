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

" vsplit the new buffer on the right side
set splitright

" split the new buffer below
set splitbelow

set mouse=a

" fuzzy file finding
" provide tab-completion for all file-related tasks
set path+=**


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
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'

" Language specific
Plug 'neovim/nvim-lspconfig'
Plug 'rust-lang/rust.vim'
Plug 'simrat39/rust-tools.nvim'
Plug 'Julian/lean.nvim'
Plug 'neovimhaskell/haskell-vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'dense-analysis/ale'
"Plug 'instant-markdown/vim-instant-markdown'

" ui
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ayu-theme/ayu-vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'cocopon/iceberg.vim'


Plug 'preservim/nerdcommenter'
Plug 'jbyuki/venn.nvim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
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

syntax on
filetype plugin indent on
"let ayucolor="dark"
colorscheme iceberg
""""""""""""""""""""""""""""""""""""""""""
" 6. Terminal Setting {{{1
""""""""""""""""""""""""""""""""""""""""""

" split terminal vertically or horizontally
nmap <C-v><C-t> :vs<bar>te<CR>
nnoremap <C-s><C-t> :sp<bar>te<CR>


" Leave the terminal mode
tnoremap <Esc> <C-\><C-n>

""""""""""""""""""""""""""""""""""""""""""
" 7. LSP {{{1
""""""""""""""""""""""""""""""""""""""""""
lua require("lsp-config")
lua require("nvim-compe")
lua require("treesitter-config")

map <A-,> <C-o>
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

""""""""""""""""""""""""""""""""""""""""""
" 8. netrw Related Setup {{{1
""""""""""""""""""""""""""""""""""""""""""
let g:netrw_liststyle   = 3
let g:netrw_insize      = 30
nmap <A-f> :15Lexplore<CR>

" cheat sheet
" netrw-mf : mark file/dir
" netrw-mF : unmark file/dir
" netrw-a : hide marked file/dir
" netrw-d : mkdir
" netrw-D : rm -r marked files/dir
" netrw-- : going up (dir)
" netrw-% : open new file
" netrw-qf : diplay file info
" netrw-ms : source the file
" netrw-R : rename the file
""""""""""""""""""""""""""""""""""""""""""
" 10. ALE Global Setting {{{1
""""""""""""""""""""""""""""""""""""""""""
"let g:ale_fixers={
"\    '*': ['remove_trailing_lines', 'trim_whitespace'],
"\}
let g:ale_fix_on_save=1
"let g:ale_disable_lsp=1

""""""""""""""""""""""""""""""""""""""""""
" }}}1
