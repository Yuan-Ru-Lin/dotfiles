set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set splitright
set splitbelow

set conceallevel=2

set smartcase
set wildmode=list:longest,full " See https://zhuanlan.zhihu.com/p/87021392
set wildignore=*.dll,*.exe,*.jpg,*.gif,*.png

call plug#begin('~/.local/share/nvim/site/plugged')

Plug 'joshdick/onedark.vim'
let g:onedark_termcolors = 256

Plug 'JuliaEditorSupport/julia-vim'

call plug#end()

syntax on
colorscheme onedark
