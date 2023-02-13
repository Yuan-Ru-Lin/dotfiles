set nocompatible              " required
filetype off                  " required

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

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

Plugin 'VundleVim/Vundle.vim'
Plugin 'joshdick/onedark.vim'
Plugin 'godlygeek/tabular'
Plugin 'preservim/vim-markdown'
let g:markdown_folding = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 0
let g:tex_conceal = ""
let g:vim_markdown_math = 1
let g:vim_markdown_conceal_code_blocks = 0
Plugin 'vim-python/python-syntax'
let g:python_highlight_builtins = 1
let g:python_highlight_string_format = 1
let g:python_highlight_func_calls = 1
let g:python_highlight_file_headers_as_comments = 1
Plugin 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutFastWrap = '<C-e>'
let g:AutoPairsShortcutBackInsert = '<C-b>'
Plugin 'JuliaEditorSupport/julia-vim'

syntax on
colorscheme onedark
filetype plugin indent on    " required

set exrc
nnoremap <LEADER>ev :vsplit $MYVIMRC<CR>
nnoremap <LEADER>sv :source $MYVIMRC<CR>

set backspace=indent,eol,start  " for backspace to work in insert mode
let g:netrw_banner = 0

nnoremap <F9> :wa<CR>:!%:p<Enter>
inoremap <F9> <ESC>:wa<CR>:!%:p<Enter>

xnoremap << <gv
xnoremap >> >gv

autocmd! BufNewFile,BufRead *.dvc,dvc.lock setfiletype yaml
nnoremap <LOCALLEADER>r :w<CR>:!dvc repro <CR>s<CR>

autocmd FileType tex nnoremap <LOCALLEADER>c :w<CR>:!pdflatex %:r && bibtex %:r && pdflatex %:r && pdflatex %:r<CR><CR>
autocmd FileType tex nnoremap <LOCALLEADER>o :!open %:r.pdf<CR><CR>
let g:tex_flavor = "latex"

autocmd FileType markdown nnoremap <LOCALLEADER>o :!open %<CR><CR>

