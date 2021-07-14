call plug#begin()

Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ayu-theme/ayu-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}


"language plugins
Plug 'rust-lang/rust.vim'
Plug 'derekelkins/agda-vim'
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}
Plug 'dense-analysis/ale'


call plug#end()

filetype plugin on

set shell=bash\ -i

set tabstop=4
set expandtab
set shiftwidth=4
set shiftround
set autoindent

syntax on
set termguicolors
let ayucolor="dark"
colorscheme ayu

let g:ale_fixers = {
\    '*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_fix_on_save = 1


:set number relativenumber
" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
