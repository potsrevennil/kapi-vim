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
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'kabouzeid/nvim-lspinstall'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'

" Language specific
Plug 'rust-lang/rust.vim'
Plug 'simrat39/rust-tools.nvim'
Plug 'Julian/lean.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'dense-analysis/ale'

" ui
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ayu-theme/ayu-vim'

" Fern related plugins
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'yuki-yano/fern-preview.vim'

"Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdcommenter'
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

let ayucolor="dark"
colorscheme ayu
"let g:airline#extensions#coc#enabled = 1
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

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
""""""""""""""""""""""""""""""""""""""""""
" 8. Fern Related Setup {{{1
""""""""""""""""""""""""""""""""""""""""""
let g:fern#renderer = "nerdfont"

nnoremap <C-t> :Fern . -drawer -toggle<CR>

function! s:init_fern() abort
  " Define NERDTree like mappings
  nmap <buffer> o <Plug>(fern-action-open:edit)
  nmap <buffer> go <Plug>(fern-action-open:edit)<C-w>p
  nmap <buffer> t <Plug>(fern-action-open:tabedit)
  nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
  nmap <buffer> i <Plug>(fern-action-open:split)
  nmap <buffer> gi <Plug>(fern-action-open:split)<C-w>p
  nmap <buffer> s <Plug>(fern-action-open:vsplit)
  nmap <buffer> gs <Plug>(fern-action-open:vsplit)<C-w>p
  nmap <buffer> ma <Plug>(fern-action-new-path)
  nmap <buffer> P gg

  nmap <buffer> C <Plug>(fern-action-enter)
  nmap <buffer> u <Plug>(fern-action-leave)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> R gg<Plug>(fern-action-reload)<C-o>
  nmap <buffer> cd <Plug>(fern-action-cd)
  nmap <buffer> CD gg<Plug>(fern-action-cd)<C-o>

  nmap <buffer> I <Plug>(fern-action-hide-toggle)

  nmap <buffer> q :<C-u>quit<CR>
endfunction

function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
endfunction

augroup fern-settings
  autocmd!
  autocmd FileType fern call s:init_fern()
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
