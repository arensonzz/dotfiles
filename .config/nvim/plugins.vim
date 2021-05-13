"If plugin manager vim-plug isn't installed, install it automatically
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Disable ALE lsp for specific files
"autocmd FileType python let b:ale_disable_lsp = 1

call plug#begin('~/.config/nvim/plugged')

Plug '907th/vim-auto-save'
Plug 'mhinz/vim-startify' "changes default vim starting screen

Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'


Plug 'liuchengxu/vista.vim' "viewer and finder for LSP symbols and tags
Plug 'junegunn/goyo.vim' "distraction-free writing

Plug 'itchyny/lightline.vim' "configurable statusline/tabline
Plug 'maximbaz/lightline-ale'

" git plugins
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

Plug 'tpope/vim-surround' "change surroundings like single or double quotes to different things (cs) or delete them (ds) easily, docs at :help surround
Plug 'scrooloose/nerdcommenter'

Plug 'mattn/emmet-vim' " good for html tags
Plug 'othree/html5.vim', {'for': ['html', 'html5', 'htm']}


Plug 'norcalli/nvim-colorizer.lua'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'Yggdroot/indentLine'

" Syntax highlighting
Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'plasticboy/vim-markdown', { 'for': ['markdown', 'md'] }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'dense-analysis/ale'

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'jiangmiao/auto-pairs'

Plug 'honza/vim-snippets'
Plug 'voldikss/vim-floaterm' "floating terminal for vim
Plug 'alvan/vim-closetag'  " auto close HTML tags

" Plug 'morhetz/gruvbox', { 'as': 'gruvbox' } "vim theme
Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'jeffkreeftmeijer/vim-numbertoggle' "automatically toggles between hybrid and absolute line numbers
Plug 'michaeljsmith/vim-indent-object' "adds an object to select everything at an indent level

Plug 'zef/vim-cycle' "ability to cycle through some group of words, easy edit

call plug#end()

function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" gruvbox config
" let g:gruvbox_italic=1 "enables italic support of gruvbox

" goyo config
let g:goyo_width = 120

" vista config
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1


" fzf config
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-i': 'split',
  \ 'ctrl-s': 'vsplit' }
let g:fzf_tags_command = 'ctags -R'
let g:fzf_layout = {'up':'~80%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5} }
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" nerdtree config
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "x",
    \ "Staged"    : "✚",
    \ "Untracked" : "o",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "D",
    \ "Dirty"     : "~",
    \ "Clean"     : "*",
    \ 'Ignored'   : '&',
    \ "Unknown"   : "?"
    \ }
"   automatically close nerdtree if it's the last buffer open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"   vim-devicons ignore deprecated warning
let g:NERDTreeGitStatusLogLevel = 3

" nerdcommenter config
"   Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" vim-markdown config
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
" markdown-preview config
" let g:mkdp_browser = '/mnt/c/Firefox/firefox.exe'
let g:mkdp_browser='wsl-open'

" ALE (Asynchronous Lint Engine)
"   auto close error-list when it's the last buffer open
autocmd QuitPre * if empty(&bt) | lclose | endif

let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_fix_on_save = 1

" Don't lint when text is changed
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%code%] %s [%severity%]'

let g:ale_open_list = 0
let g:ale_list_window_size = 5
"   Commands to disable ALE fixers temporarily
command! ALEDisableFixersBuffer let b:ale_fix_on_save=0
command! ALEEnableFixersBuffer  let b:ale_fix_on_save=1

highlight ALEError ctermbg=White
highlight ALEError ctermfg=DarkRed
highlight ALEWarning ctermbg=LightYellow
highlight ALEWarning ctermfg=Darkmagenta

"   Set linters by file type
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['flake8'],
\   'html': ['tidy'],
\   'css': ['stylelint']
\}
"   Set fixers by file type
"   remove trailing lines and trim whitespaces for every file type
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'html': ['prettier'],
\   'css': ['stylelint'],
\   'python': ['autopep8']
\}
autocmd FileType python let b:ale_warn_about_trailing_whitespace = 0
" Disable line too long warning for flake8
let g:ale_python_flake8_options = '--ignore=E501'

autocmd FileType json let g:indentLine_conceallevel = 0

" coc config
"   coc extensions to install automatically
let g:coc_user_config = {}
let g:coc_global_extensions = [
    \ 'coc-json',
    \ 'coc-xml',
    \ 'coc-marketplace',
    \ 'coc-git',
    \ 'coc-vimlsp',
    \ 'coc-jedi',
    \ 'coc-eslint',
    \ 'coc-clangd',
    \ 'coc-snippets',
    \ 'coc-emmet',
    \ 'coc-tsserver',
    \ 'coc-html',
    \ 'coc-css'
    \ ]
" change line highlighting from line number only to line only for CocList
augroup mygroup
  autocmd!
  "     Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  "     Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
"   Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
"   Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')
"   Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
"   Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
"   Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
"   Close the preview window when completion is done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" python syntax
let g:python_highlight_all = 1

" rainbow_parentheses config
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
"   Auto activate RainbowParentheses
autocmd FileType * RainbowParentheses

" vim-floaterm config
"   Go back to the NORMAL mode using <C-\><C-N>
let g:floaterm_gitcommit='floaterm'
let g:floaterm_width=0.9
let g:floaterm_height=0.9

" vim-auto-save config
let g:auto_save_silent = 1  " do not display the auto-save notification
let g:auto_save = 0 " auto-save off by default
" FileTypes to enable auto_save
"autocmd FileType python let b:auto_save = 1

let g:auto_save_events = ["InsertLeave", "TextChanged"] " set events to trigger auto-save

" vim-closetag config
"   These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,phtml,xml'
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.xml'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" emmet-vim config
let g:user_emmet_mode='nv' " only enable emmet in normal mode

" vim-cycle config
autocmd FileType python call AddCycleGroup('python', ['True', 'False'])
