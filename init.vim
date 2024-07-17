set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set splitright
set splitbelow

call plug#begin()

Plug 'jpalardy/vim-slime'
let g:slime_target = "neovim"

Plug 'jiangmiao/auto-pairs'
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', "`":"`", '```':'```', '"""':'"""', "'''":"'''", '$':'$'}
let g:AutoPairsShortcutFastWrap = '<C-e>'
Plug 'tpope/vim-surround'

Plug 'navarasu/onedark.nvim'
let g:onedark_config = {'style': 'darker'}

" Julia
Plug 'JuliaEditorSupport/julia-vim'
runtime macros/matchit.vim

" Python
Plug 'vim-scripts/indentpython.vim'

" Typst
Plug 'kaarmu/typst.vim'
Plug 'chomosuke/typst-preview.nvim'

" text-obj
Plug 'kana/vim-textobj-user'
Plug 'sgur/vim-textobj-parameter'
Plug 'lucapette/vim-textobj-underscore'
Plug 'fvictorio/vim-textobj-backticks'
Plug 'glts/vim-textobj-comment'

Plug 'vimlab/split-term.vim'

call plug#end()

silent! colorscheme onedark

nnoremap <LEADER>ev :vsplit $MYVIMRC<CR>
nnoremap <LEADER>sv :source $MYVIMRC<CR>

let g:netrw_banner = 0

autocmd FileType python nnoremap <buffer> <F9> :wa<CR>:!%:p<CR>
autocmd FileType python inoremap <buffer> <F9> <ESC>:wa<CR>:!%:p<CR>
autocmd FileType typst  nnoremap <buffer> <F9> :TypstPreview<CR>

xnoremap << <gv
xnoremap >> >gv
