call pathogen#infect()

filetype on
filetype plugin indent on
syntax on
set nocompatible
set ignorecase
set smartcase
set hlsearch
set modelines=0
set wildmenu
set wildmode=longest:full

set expandtab
set tabstop=2
set shiftwidth=2
set number
set smarttab

vmap <Tab> >gv
vmap <S-Tab> <gv
inoremap <S-Tab> <C-D>

set lbr "word wrap
set tw=80

set ai "Auto indent
set si "Smart indent
set wrap

cabbr <expr> %% expand('%:p:h')

"yank and paste go to a register delete and cut does not share
noremap  y "-y
noremap  Y "-Y
noremap  p "-p
noremap  P "-P
vnoremap y "-y
vnoremap Y "-Y
vnoremap p "-p
vnoremap P "-P

" scrolling
inoremap <C-E> <C-X><C-E> "scrolling on insert
inoremap <C-Y> <C-X><C-Y>
set scrolloff=3 " keep three lines between the cursor and the edge of the screen

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = " " " Leader is the space key
let g:mapleader = " "
"auto indent for brackets
inoremap {<CR> {<CR>}<Esc>O
" easier write
nmap <leader>w :w!<cr>
" easier quit
nmap <leader>q :q<cr>
" silence search highlighting
nnoremap <leader>sh :nohlsearch<Bar>:echo<CR>
"paste from outside buffer
nnoremap <leader>p :set paste<CR>"+p:set nopaste<CR>
"copy to outside buffer
vnoremap <leader>y "+y
"select all
nnoremap <leader>a ggVG
nnoremap <leader>cf :CommandTFlush<CR>

" tab navigation like firefox
"nnoremap <C-S-Tab> :tabprevious<CR>
"nnoremap <M-S-}> :tabnext<CR>
map } gt
map { gT

set mouse=a

highlight OverLength ctermbg=darkred ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
source ~/config-vc/vim/setting.vim 
