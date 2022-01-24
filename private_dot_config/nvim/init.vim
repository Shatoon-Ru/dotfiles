set number

set filetype=pascal
set syntax=pascal
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab
set smartindent

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/site/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'vim-airline/vim-airline'

Plug 'ryanoasis/vim-devicons'

Plug 'morhetz/gruvbox' 

Plug 'lyokha/vim-xkbswitch'

Plug 'vim-airline/vim-airline-themes'

Plug 'vim-scripts/fpc.vim'


call plug#end()

"themes
colorscheme gruvbox
set bg=dark

nnoremap <C-n> :NERDTreeToggle<CR>

" AIRLINE
let g:airline_powerline_fonts = 1 "Включить поддержку Powerline шрифтов
let g:airline#extensions#keymap#enabled = 0 "Не показывать текущий маппинг
let g:airline_section_z = "\ue0a1:%l/%L Col:%c" "Кастомная графа положения курсора
let g:Powerline_symbols='unicode' "Поддержка unicode
let g:airline#extensions#xkblayout#enabled = 0

let g:XkbSwitchEnabled = 1

let g:airline_theme='luna'
