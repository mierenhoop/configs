filetype plugin indent on

let &t_ve= "\e[?25h\e[?112c"

set t_Co=16

set nocompatible
set modeline
set noswapfile

set encoding=utf-8
set linebreak

" only noet when no file extension
set ai si ts=4 sw=4 sts=4 noet
set splitbelow splitright

set shortmess=I

set foldmethod=marker

" no switch case indent
set cino=:0

" for non-debian compiles
set backspace=indent,eol,start

autocmd FileType * setlocal et formatoptions+=jcro
autocmd FileType go setlocal noet
autocmd FileType lua setlocal ts=2 sw=2 sts=2
autocmd FileType c setlocal ts=2 sw=2 sts=2
autocmd FileType cpp setlocal ts=2 sw=2 sts=2
autocmd FileType moon setlocal ts=2 sw=2 sts=2
autocmd FileType fennel setlocal ts=2 sw=2 sts=2
autocmd FileType sh setlocal ts=2 sw=2 sts=2
autocmd FileType javascript setlocal ts=2 sw=2 sts=2
autocmd FileType css setlocal ts=2 sw=2 sts=2
autocmd FileType html setlocal ts=2 sw=2 sts=2
autocmd FileType proto setlocal ts=2 sw=2 sts=2
autocmd FileType make setlocal noet

set incsearch nohlsearch smartcase

syntax enable

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

autocmd FileType go setlocal formatprg=goimports
autocmd FileType c setlocal formatprg=clang-format
autocmd FileType cpp setlocal formatprg=clang-format
autocmd FileType proto setlocal formatprg=clang-format

autocmd FileType markdown setlocal textwidth=72

" format and keep cursor position
" nnoremap gq gggqG<c-o><c-o>
nnoremap gq gggqG

" nnoremap <space> zizz

" to paste:
" set paste

" ascii drawing:
" set ve=all
