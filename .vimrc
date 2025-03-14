" ---------------
" .VIMRC CONTENTS
" ---------------

" 01. _EDITOR_CONFIGS_
" 02. _PLUGINS_
" 03. _PLUGIN_SETTINGS_
" 04. _FUNCTIONS_
" 05. _KEYBINDINGS_
" 06. _LATE_IMPORTS_

" ------------------
" # _EDITOR_CONFIGS_
" ------------------

" Set leader keys (must be on top because plugins use it)
let mapleader="\<Space>"
let maplocalleader = ","

" Set .config dir to use based on editor (vim vs nvim)
if !has('nvim')
    let s:config_dir = $HOME . "/.vim"
else
    let s:config_dir = $HOME . "/.config/nvim"
endif

" ## General options
set novisualbell " Disable screen flashes
set encoding=UTF-8 " Set character encoding
set timeoutlen=800 " Shrink the window for time-outable commands
set nofoldenable " Start with all folds open
set mouse=nvchr " Enable mouse for all modes except insert mode
set scrolloff=4 " Set number of screen lines to always keep above and below the cursor
set undofile " Enable undo history
if !isdirectory(s:config_dir . "/undodir")
    :call mkdir(s:config_dir . "/undodir")
endif
let &undodir = s:config_dir . "/undodir" " Select the directory to keep undofiles
set splitright " Open vertical splits to right
set splitbelow " Open horizontal splits to below
set conceallevel=0 " Do not conceal text (e.g. Neorg symbols)
set ignorecase " By default ignore case when searching
set smartcase " If intentionally uppercase letters are used in search then override ignorecase
set hlsearch " Keep search highlight
set list " Show whitespace characters
set showcmd " show keypresses in status line

" ## Colors
set termguicolors " enable true-color support
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " set foreground color
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum" " set background color
set background=dark

" ## Line numbers
set relativenumber
set number
set nocursorline
set nocursorcolumn

" ## Whitespace settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" ## Visual settings
set showtabline=2 " Always show tab line

" ## Configs recommended by CoC
set hidden
set updatetime=300
set nobackup " Disable backup files
set nowritebackup " Disable backup files
set shortmess+=c " Disable hit ENTER prompts for completion
set signcolumn=yes " Always show sign column, otherwise it will shift text

" ## Commands
command! V e $MYVIMRC | cd %:h

" -----------
" # _PLUGINS_
" -----------

" 1. Download plugins with :PlugInstall
" 2. Downloaded plugins are located in ~/.vim/plugged

if !has('nvim')
    " If plugin manager vim-plug isn't installed, install it automatically
    if empty(glob('~/.vim/autoload/plug.vim'))
        echo "Downloading junegunn/vim-plug to manage plugins..."
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    call plug#begin('~/.vim/plugged')
        " Plugins shared with Neovim
        source $HOME/.vimrc.plugins

        " Vim only plugins
        Plug 'catppuccin/vim', { 'as': 'catppuccin' }
        Plug 'tpope/vim-vinegar'

    call plug#end()
else
    source $HOME/.config/nvim/plugins.vim
endif

augroup lang_indentation_by_filetype
    autocmd!
    autocmd Filetype css,scss,javascript,typescript,html,json,xml,norg,cmake
        \ setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype meson
        \ setlocal tabstop=4 shiftwidth=4 softtabstop=4
    autocmd BufRead,BufNewFile *.html setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup END

augroup editor_configs_vim_options
    autocmd!
    " Do not continue newlines with comment character
    autocmd FileType * set formatoptions-=cro

    " Set width to break lines
    autocmd FileType * set textwidth=120

    " Set in which file types should lines auto break
    autocmd FileType norg setlocal fo+=t
    autocmd FileType toml setlocal fo-=t

    " Set the filetype based on the file extension, overriding any
    " 'filetype' that has already been set
    autocmd BufRead,BufNewFile *.launch set filetype=xml

    " Set which files will use highlight from start of file (fix for Javascript
    " inside HTML syntax)
    autocmd BufRead,BufNewFile *.html syntax sync fromstart

augroup END

" -------------------
" # _PLUGIN_SETTINGS_
" -------------------

" ## Contents

" _auto_pairs_
" _gv_vim_
" _lightline_vim_
" _nerdcommenter_
" _python_syntax_
" _suda_vim_
" _undotree_
" _vim_auto_save_
" _vim_better_whitespace_
" _vim_closetag_
" _vim_cycle_
" _vim_floaterm_
" _vim_fugitive_
" _vim_indent_object_
" _vim_startify_
" _vim_surround_

" ------------------
" ## _vim_auto_save_
" ------------------

" ### Settings
let g:auto_save_silent = 1  " do not display the auto-save notification
let g:auto_save = 0 " auto-save off by default
let g:auto_save_events = ["InsertLeave", "TextChanged"] " set events to trigger auto-save

" ### Keybindings
noremap <M-s> :AutoSaveToggle<CR>
inoremap <M-s> <ESC>:AutoSaveToggle<CR>a

" -----------------
" ## _vim_startify_
" -----------------

" ### Settings
let g:startify_session_dir = s:config_dir . '/session'
let g:startify_session_persistence = 1

" -----------------
" ## _vim_surround_
" -----------------

" ### Keybindings
" Works with parentheses(), brackets [], quotes (double or single), XML tags <q> </q>  and more
" NOTE: Use vS) instead of vS( to surround without space
" Example:
" cs'<q>     : To change 'Hello' to <q>Hello</q>
" ds'        : To remove delimiters from 'Hello'
" dst        : To remove the surrounding tag
" cst<p>     : To change the surrounding tag to <p>
" vS         : In visual mode, S surrounds the selected (vSt for tag)

" ------------------
" ## _nerdcommenter_
" ------------------

" ### Settings
" Add spaces after comment delimiters by default
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
augroup nerdcommenter_group
    autocmd!
    autocmd FileType python let g:NERDDefaultAlign = 'left'
augroup END

" ### Keybindings
" [count]<leader>cc          : make lines commented
" [count]<leader>c<space>    : toggle line's comment status (commented/uncommented)
map <leader>cc <plug>NERDCommenterComment
map <leader>cu <plug>NERDCommenterUncomment
map <leader>ct <plug>NERDCommenterToggle
map <leader>cm <plug>NERDCommenterMinimal

" ---------------
" ## _auto_pairs_
" ---------------

" ### Settings
augroup auto_pairs_group
    autocmd!
    autocmd FileType norg let g:AutoPairsMapSpace = 0
augroup END
" fix coc-snippets inserting newline when selecting a snippet with enter
let g:AutoPairsMapCR = 0

" ### Keybindings
" <M-p> : Toggle auto-pairs
" <M-e> : Insert () or {} or [] before something then hit <M-e> to fast wrap
" <M-n> : Jump to next closed pair
" Use Ctrl-V) to insert paren without trigerring plugin
" Use x or DEL to delete the character inserted by the plugin

" -----------------
" ## _vim_floaterm_
" -----------------

" ### Settings
" Go back to the NORMAL mode using <C-\><C-N>
let g:floaterm_gitcommit='floaterm'
let g:floaterm_width=0.9
let g:floaterm_height=0.9
let g:floaterm_autoclose=1

" ### Keybindings
let g:floaterm_keymap_toggle = '<C-f>'

" -----------------
" ## _vim_closetag_
" -----------------

" ### Settings
" These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,phtml,xml'
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.xml'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" ### Keybindings
" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'

" ----------------------
" ## _vim_indent_object_
" ----------------------

" ### Keybindings
" Defines two new text objects to select only current indentation level
" <count>ai     An Indentation level and line above.
" <count>ii     Inner Indentation level (no line above).
" <count>aI     An Indentation level and lines above/below.

" --------------
" ## _vim_cycle_
" --------------

" ### Settings
augroup vim_cycle_group
    autocmd!
    autocmd FileType python call AddCycleGroup('python', ['True', 'False'])
augroup END

" ### Keybindings
" Move cursor on a word and hit <C-n> or <C-m> to toggle between pair of
"   words or even increment-decrement a number
let g:cycle_no_mappings = 1
nnoremap <C-b> <Plug>CyclePrevious
nnoremap <C-n> <Plug>CycleNext

" ------------------
" ## _lightline_vim_
" ------------------

" ### Settings
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! GitStatus() abort
    return get(g:, 'coc_git_status', '')
endfunction

function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:p:.') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste', 'readonly' ],
      \             [ 'gitbranch', 'filename' ],
      \             [ 'cocstatus' ] ],
      \   'right': [['percent', 'lineinfo'],
      \             [ 'filetype', 'fileencoding' ],
      \             [ 'currentfunction', 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ]]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'gitbranch': 'GitStatus',
      \   'currentfunction': 'CocCurrentFunction',
      \   'filename': 'LightlineFilename',
      \ },
      \ 'component_expand': {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ },
      \ 'component_type': {
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \ }
      \ }

" ------------------
" ## _python_syntax_
" ------------------

" ### Settings
let g:python_highlight_all = 1

" -----------------
" ## _vim_fugitive_
" -----------------

" ### Keybindings
"   Enter :Git and then do g? to checkout all hotkeys
"   After :Git use cc to enter commit buffer
"   to add the file under cursor to .gitignore use {anynumber}gI
"   git status
nnoremap <leader>gs :G<CR>
"   solving merge conflicts
nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>

"   Diff against any and all direct ancestors (merge conflicts)
nnoremap <leader>gdf :Gvdiffsplit!<CR>

" -----------------------
" _vim_better_whitespace_
" -----------------------

" ### Settings
let g:better_whitespace_enabled=1
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=LightRed ctermfg=white guibg='#f9e2af' guifg=black

" ----------
" _undotree_
" ----------

" ### Keybindings
nnoremap <silent> <M-u> :UndotreeToggle<CR>

" -------------
" # _FUNCTIONS_
" -------------

" 01. _LongLineHighlightOn_
" 02. _ToggleBackground_
" 03. _TermForceCloseAll_

" ------------------------
" ## _LongLineHighlightOn_
" ------------------------
" https://gist.github.com/fgarcia/9704429#file-long_lines-vim
" https://stackoverflow.com/q/395114

function! LongLineHighlightOn()
    if exists("w:llh")
        call matchdelete(w:llh)
    endif

    highlight OverLength ctermbg=LightBlue ctermfg=black guibg='#89dceb' guifg=black
    autocmd ColorScheme * highlight OverLength ctermbg=LightBlue ctermfg=black guibg='#89dceb' guifg=black
    if &ft ==? 'css' || &ft ==? 'scss'
        let l:length = 90
        let w:llh = matchadd("OverLength", '\%' . (l:length + 1) . 'v')
    elseif &ft != 'floaterm' && &ft != 'fzf'
        let l:length = 120
        let w:llh = matchadd("OverLength", '\%' . (l:length + 1) . 'v')
    endif
endfunction

call LongLineHighlightOn()

" ---------------------
" ## _ToggleBackground_
" ---------------------

function! ToggleBackground()
    if &background =~? 'dark'
        echo "Changing to light theme..."
        echo ""

        if !has('nvim')
            colorscheme catppuccin_latte
            let g:lightline.colorscheme = 'catppuccin_latte'
        else
            colorscheme catppuccin
            let g:lightline.colorscheme = 'catppuccin'
            let g:lightline#colorscheme#catppuccin#palette = {'inactive': {'right': [['#bcc0cc', '#eff1f5', 146, 231], ['#9ca0b0', '#eff1f5', 145, 231]], 'middle': [['#bcc0cc', '#eff1f5', 146, 231]], 'left': [['#1e66f5', '#eff1f5', 27, 231], ['#9ca0b0', '#eff1f5', 145, 231]]}, 'replace': {'left': [['e6e9ef', '#d20f39', 189, 161], ['#1e66f5', '#eff1f5', 27, 231]]}, 'normal': {'right': [['#9ca0b0', '#eff1f5', 145, 231], ['#1e66f5', '#ccd0da', 27, 188]], 'middle': [['#1e66f5', '#e6e9ef', 27, 189]], 'warning': [['#e6e9ef', '#df8e1d', 189, 172]], 'left': [['#e6e9ef', '#1e66f5', 189, 27], ['#1e66f5', '#eff1f5', 27, 231]], 'error': [['#e6e9ef', '#d20f39', 189, 161]]}, 'tabline': {'right': [['#bcc0cc', '#eff1f5', 146, 231], ['#9ca0b0', '#eff1f5', 145, 231]], 'middle': [['#bcc0cc', '#eff1f5', 146, 231]], 'left': [['#9ca0b0', '#eff1f5', 145, 231], ['#9ca0b0', '#eff1f5', 145, 231]], 'tabsel': [['#1e66f5', '#bcc0cc', 27, 146], ['#9ca0b0', '#eff1f5', 145, 231]]}, 'visual': {'left': [['#e6e9ef', '#8839ef', 189, 99], ['1e66f5', '#eff1f5', 27, 231]]}, 'insert': {'left': [['#e6e9ef', '#179299', 189, 30], ['#1e66f5', '#eff1f5', 27, 231]]}}
        endif

        set background=light
    else
        echo "Changing to dark theme..."
        echo ""

        if !has('nvim')
            colorscheme catppuccin_mocha
            let g:lightline.colorscheme = 'catppuccin_mocha'
        else
            colorscheme catppuccin
            let g:lightline.colorscheme = 'catppuccin'
            let g:lightline#colorscheme#catppuccin#palette = {'inactive': {'right': [['#45475a', '#1e1e2e', 59, 16], ['#6c7086', '#1e1e2e', 60, 16]], 'middle': [['#45475a', '#1e1e2e', 59, 16]], 'left': [['#89b4fa', '#1e1e2e', 111, 16], ['#6c7086', '#1e1e2e', 60, 16]]}, 'replace': {'left': [['#181825', '#f38ba8', 16, 211], ['#89b4fa', '#1e1e2e', 111, 16]]}, 'normal': {'right': [['#6c7086', '#1e1e2e', 60, 16], ['#89b4fa', '#313244', 111, 59]], 'middle': [['#89b4fa', '#181825', 111, 16]], 'warning': [['#181825', '#f9e2af', 16, 223]], 'left': [['#181825', '#89b4fa', 16, 111], ['#89b4fa', '#1e1e2e', 111, 16]], 'error': [['#181825', '#f38ba8', 16, 211]]}, 'tabline': {'right': [['#45475a', '#1e1e2e', 59, 16], ['#6c7086', '#1e1e2e', 60, 16]], 'middle': [['#45475a', '#1e1e2e', 59, 16]], 'left': [['#6c7086', '#1e1e2e', 60, 16], ['#6c7086', '#1e1e2e', 60, 16]], 'tabsel': [['#89b4fa', '#45475a', 111, 59], ['#6c7086', '#1e1e2e', 60, 16]]}, 'visual': {'left': [['#181825', '#cba6f7', 16, 183], ['#89b4fa', '#1e1e2e', 111, 16]]}, 'insert': {'left': [['#181825', '#94e2d5', 16, 116], ['#89b4fa', '#1e1e2e', 111, 16]]}}
        endif

        set background=dark
    endif

    try
        call lightline#init()
        call lightline#colorscheme()
        call lightline#update()
    catch
    endtry
endfunction

command! ToggleBackground call ToggleBackground()

" ----------------------
" ## _TermForceCloseAll_
" ----------------------
" https://www.reddit.com/r/vim/comments/fwedfx/comment/fmnwar1

function! s:TermForceCloseAll() abort
    let term_bufs = filter(range(1, bufnr('$')), 'getbufvar(v:val, "&buftype") == "terminal"')
    for t in term_bufs
        execute "bd! " t
    endfor
endfunction

if !has('nvim')
    " NOTE: If Floaterm term buffer is running it causes Vim to not close with :qall
    augroup term_force_close_all
        autocmd!
        " TODO: it causes term to close when any window is closed even if you don't exit Vim
        autocmd QuitPre * call <sid>TermForceCloseAll()
    augroup END
endif

" ---------------
" # _KEYBINDINGS_
" ---------------

" Source $MYVIMRC
nnoremap <leader>ss :source $MYVIMRC<CR>

" Quit without saving
nnoremap qq :q<CR>

" Quit after saving
nnoremap qw :wq<CR>

" Save with Ctrl + S
noremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>a

" Copy-paste bindings for system clipboard (+)
nnoremap <Leader>yy "+y
vnoremap <Leader>yy "+y

nnoremap <Leader>pp "+p
vnoremap <Leader>pp "+p

" Quickly insert an empty new line without entering insert mode
nnoremap <Leader>o o<Esc>k
nnoremap <Leader>O O<Esc>j

" Change vim window focus
map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-j> <C-w>j
map <C-k> <C-w>k

" Move between tabs
nnoremap <silent> <C-M-l> :tabn<CR>
nnoremap <silent> <C-M-h> :tabp<CR>

" Resize vim windows
nnoremap <silent> <C-Down> :resize -2<CR>
nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Left> :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>

" Zoom into one pane
nnoremap <silent> <Leader>z :tabnew %<CR>

" 'cd' towards the directory in which the current file is edited
nnoremap <Leader>cd :cd %:h<CR>

" See changes before saving file
nnoremap <Leader>df :w !diff % -<CR>

" Better multiple lines tabbing with < and >
vnoremap < <gv
vnoremap > >gv

" See buffers
nnoremap <Leader>fb :Buffers!<CR>

" Open netrw
if !has('nvim')
    nnoremap <C-c> :Lexplore 30<CR>
endif

" Move in quickfix list (copen)
nnoremap <silent> [c :cprevious<CR>
nnoremap <silent> ]c :cnext<CR>
" Move in location list (lopen)
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>

" Clear highlighting of 'hlsearch' and call :diffupdate
nnoremap <silent> <leader>h :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><leader>h

" Toggle background theme between light and dark
nnoremap <M-t> :ToggleBackground<CR>

" Set bindings for default Vim autocompletion support
" :help ins-completion
" <C-n>         : start word completion from file
" <C-x><C-o>    : start omni completion
if !has('nvim')
    " Exit pum without inserting with <Esc>
    inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
    " Select with <CR>
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
    " Use <Tab> and <S-Tab> to view completion suggestions
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : exists("g:loaded_snips")
        \ ? "\<C-r>=TriggerSnippet()\<CR>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : exists("g:loaded_snips")
        \ ? "\<C-r>=BackwardsSnippet()\<CR>" : "\<S-Tab>"
endif

" Fix meta keybindings in Vim
if !has('nvim')
    execute "set <M-a>=\ea"
    execute "set <M-e>=\ee"
    execute "set <M-n>=\en"
    execute "set <M-p>=\ep"
    execute "set <M-s>=\es"
    execute "set <M-t>=\et"
    execute "set <M-u>=\eu"
endif

" Auto-indent whole file
nnoremap <silent> <localleader>== gg=G<C-o>

" ----------------
" # _LATE_IMPORTS_
" ----------------

" ## Set colorscheme and trigger highlight groups defined with "autocmd ColorScheme"
"    (must be on the bottom to trigger autocmds)
if !has('nvim')
    colorscheme catppuccin_mocha
    let g:lightline.colorscheme = 'catppuccin_mocha'
else
    colorscheme catppuccin
    let g:lightline.colorscheme = 'catppuccin'
endif

" ## Import settings not tracked by Git
if !has('nvim') && !empty(glob("$HOME/.vimrc.gitignore"))
    source $HOME/.vimrc.gitignore
elseif has('nvim') && !empty(glob("$HOME/.config/nvim/gitignore.vim"))
    source $HOME/.config/nvim/gitignore.vim
endif
