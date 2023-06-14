filetype plugin indent on

let &t_ve= "\e[?25h\e[?112c"

set t_Co=16

set nocompatible

set noswapfile
set autoindent
set smartindent
set encoding=utf-8
set linebreak
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set splitbelow splitright

set shortmess=I

set foldmethod=marker

autocmd FileType * setlocal formatoptions-=cro

autocmd FileType go setlocal shiftwidth=4 softtabstop=4 noexpandtab
autocmd FileType lua setlocal shiftwidth=2 softtabstop=2
autocmd FileType moon setlocal shiftwidth=2 softtabstop=2
autocmd FileType fennel setlocal shiftwidth=2 softtabstop=2
autocmd FileType make setlocal shiftwidth=8 softtabstop=8 noexpandtab

set incsearch
set nohlsearch
set smartcase

syntax enable

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" nnoremap <space> zizz
