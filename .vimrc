set nocompatible              " be iMproved, required
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
let g:AutoPairs = {'(':')', '$':'$', '[':']', '{':'}','"':'"'}
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutFastWrap = "•"
let g:AutoPairsShortcutBackInsert = '¶'
Plugin 'vim-syntastic/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['python']
let g:syntastic_python_python_exec = 'python3'
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_include_dirs = ['/cvmfs/belle.cern.ch/el7/externals/v01-09-01/include/root/']
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libc++'
Plugin 'tpope/vim-fugitive'
set statusline+=%{FugitiveStatusline()}

syntax on
colorscheme onedark
filetype plugin indent on     " required
set backspace=indent,eol,start  " for backspace to work in insert mode"
vnoremap <C-r> "hy:%s/<C-r>h//g<left><left><left>
nnoremap <F9> :w<CR>:!%:p<Enter>
xnoremap << <gv
xnoremap >> >gv

