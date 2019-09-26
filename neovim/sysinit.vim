" vim + termguicolors
"let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" add trailing space in tmux
"set termguicolors

colorscheme nord
let g:airline_powerline_fonts = 1
" le colorscheme a deja loadé le theme
"let g:airline_theme = 'nord'
let g:nord_italic = 1
let g:nord_italic_comments = 1
" reduire le contraste des commentaires de 10%
let g:nord_comment_brightness = 10

set encoding=utf-8
set fileencodings=utf-8

set guicursor=

filetype off
filetype plugin indent off

set listchars=tab:>\ ,trail:-,nbsp:+,eol:$
autocmd FileType html setlocal shiftwidth=2 softtabstop=2 expandtab

" tabs are space
set expandtab
" number of spaces to use for autoindent
set shiftwidth=4
" number of spaces in tab when editing
set softtabstop=4
" vim
"syntax on
