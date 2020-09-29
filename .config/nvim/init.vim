set shell=$SHELL
set encoding=UTF-8

" Importing other configs
source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/lightline.vim
source $HOME/.config/nvim/bindings.vim
" Colors
syntax on   " Enable syntax highlighting
set t_8f=^[[38;2;%lu;%lu;%lum        " set foreground color
set t_8b=^[[48;2;%lu;%lu;%lum        " set background color
set background=dark
colorscheme gruvbox
set t_Co=256                         " Enable 256 colors
set termguicolors                    " Enable GUI colors for the terminal to get truecolor

" Recommended by CoC
set hidden
set updatetime=300
set nobackup    " Disables backup files
set nowritebackup   " Disables backup files
set cmdheight=2 " height of command-line at the bottom
set shortmess+=c
set signcolumn=yes "always show sign column, otherwise it will shift text

set showtabline=2

" Show line numbers and make current line bold
" Don't wrap lines
set number
set cursorline
highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
highlight CursorLineNR cterm=bold
set nowrap

" Disable newline continution of comments
set formatoptions-=cro

let g:python3_host_prog='/usr/bin/python3' "set python3 path

set ignorecase
set smartcase
set mouse=a

set undofile
set undodir=~/.config/nvim/undodir

set inccommand=nosplit
set splitright
set splitbelow

set conceallevel=0

" Whitespace configs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set smartindent

" Disable sql-complete
let g:omni_sql_no_default_maps = 1

" Language-specific
"augroup langindentation
"	autocmd Filetype go setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
"	autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
"	autocmd Filetype css setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
"	autocmd Filetype scss setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
"	autocmd Filetype javascript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
"	autocmd Filetype html setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
"	autocmd Filetype htmldjango setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
"	autocmd Filetype handlebars setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
"	autocmd Filetype ember setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
"	autocmd Filetype json setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
"	autocmd Filetype yaml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
"	autocmd Filetype xml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
"	autocmd Filetype lua setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
"augroup END
