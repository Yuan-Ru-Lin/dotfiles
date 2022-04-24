set nocompatible              " required
filetype off                  " required

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

Plugin 'VundleVim/Vundle.vim'
Plugin 'joshdick/onedark.vim'
Plugin 'vim-python/python-syntax'
let g:python_highlight_builtins = 1
let g:python_highlight_string_format = 1
let g:python_highlight_func_calls = 1
let g:python_highlight_file_headers_as_comments = 1
Plugin 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutFastWrap = '<C-e>'
let g:AutoPairsShortcutBackInsert = '<C-b>'
Plugin 'vim-syntastic/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_python_python_exec = 'python3'
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_checkers = ["g++"]
let g:syntastic_cpp_compiler = 'g++'
Plugin 'tpope/vim-eunuch'

syntax on
colorscheme onedark
filetype plugin indent on    " required

set exrc
nnoremap <LEADER>ev :vsplit $MYVIMRC<CR>
nnoremap <LEADER>sv :source $MYVIMRC<CR>

set backspace=indent,eol,start  " for backspace to work in insert mode

nnoremap <F9> :wa<CR>:!%:p<Enter>
inoremap <F9> <ESC>:wa<CR>:!%:p<Enter>

xnoremap << <gv
xnoremap >> >gv

autocmd! BufNewFile,BufRead *.dvc,dvc.lock setfiletype yaml
nnoremap <LocalLeader>r :w<CR>:!dvc repro <C-R>s<CR>
