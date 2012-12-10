syntax on
:set expandtab
:set tabstop=2
:set shiftwidth=2
:set number
:set tw=80
:set wrap
highlight OverLength ctermbg=darkred ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
source ~/config-vc/vim/google.vim
