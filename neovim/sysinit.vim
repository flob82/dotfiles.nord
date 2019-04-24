colorscheme nord
let g:Powerline_colorscheme='nord'
let g:airline_powerline_fonts = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1
" reduire le contraste des commentaires de 10%
set termguicolors
let g:nord_comment_brightness = 10

set encoding=utf-8
set fileencodings=utf-8

set mouse=c
set guicursor=

filetype off

set listchars=tab:>\ ,trail:-,nbsp:+,eol:$
autocmd FileType html setlocal shiftwidth=2 softtabstop=2 expandtab

" tabs are space
set expandtab
" number of spaces to use for autoindent
set shiftwidth=4
" number of spaces in tab when editing
set softtabstop=4

filetype plugin indent off
