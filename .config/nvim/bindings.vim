" <CR> means carriage return, another saying of <Enter>

let mapleader = "\<Space>"
let maplocalleader = "\<CR>"

" open bindings.vim buffer in new tab
nnoremap <silent> <leader>bb :tabnew ~/.config/nvim/bindings.vim<CR>

" source $MYVIMRC
nnoremap <leader>ss :source $MYVIMRC<CR>

" quit without saving
nnoremap qq :q<CR>
" quit after saving
nnoremap qw :wq<CR>
" save with Ctrl + S (might cause problems in some terminals, check my vim alias in .zshrc also)
noremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>a

" vim-auto-save
noremap <M-s> :AutoSaveToggle<CR>
inoremap <M-s> <ESC>:AutoSaveToggle<CR>a

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
nnoremap <silent> <C-M-l> :tabn<cr>
nnoremap <silent> <C-M-h> :tabp<cr>

" Resize vim windows
nnoremap <silent> <C-Down> :resize -2<CR>
nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Left> :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>

" Zoom into one pane
nnoremap <silent> <leader>z :tabnew %<CR>

" 'cd' towards the directory in which the current file is edited
" but only change the path for the current window
nnoremap <leader>cd :lcd %:h<CR>

" See changes before saving file
nnoremap <leader>df :w !diff % -<CR>

" Toggle background theme between light and dark
nnoremap <silent> <M-t> :call ToggleBackground()<CR>
" Enable long line highlight
nnoremap <silent> <leader>llh :call LongLineHighlightOn()<CR>

" PLUGINS
" COC (language server) bindings
source $HOME/.config/nvim/coc_bindings.vim

" coc-snippets bindings
imap <C-k> <Plug>(coc-snippets-expand-jump)
vmap <C-j> <Plug>(coc-snippets-select)
"   Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" ultisnips bindings
let g:UltiSnipsExpandTrigger="<C-tab>"

" ALE bindings (Asynchronous Lint Engine)
nmap <silent> [a <Plug>(ale_previous_wrap)
nmap <silent> ]a <Plug>(ale_next_wrap)
noremap <M-a> :call AleAutofixToggle()<CR>
let g:ale_fix_on_save = 0

function! AleAutofixToggle()
    if g:ale_fix_on_save
        echo "g:ale_fix_on_save = 0"
        let g:ale_fix_on_save = 0
    else
        echo "g:ale_fix_on_save = 1"
        let g:ale_fix_on_save = 1
    endif
endfunction


" vim-gitgutter bindings
"   Stage the hunk with <Leader>hs
"   Undo the hunk with <Leader>hu
"   Preview the hunk with <Leader>hp
nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" floaterm bindings
let g:floaterm_keymap_toggle = '<C-f>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_new    = '<F10>'

" fzf find bindings
"   Select multiple things with Shift + TAB
"   Open entries in split panes with TAB
"   Open entries in different tabs with Ctrl + T
nmap <leader>ff :Files<cr>
nmap <leader>ft :BTags<cr>
nmap <leader>fT :Tags<cr>
nmap <leader>fl :BLines<cr>
nmap <leader>fL :Lines<cr>
nmap <leader>fg :GFiles?<cr>
nmap <leader>fb :Buffers<cr>
nmap <leader>fc :BCommits<cr>
nmap <leader>fC :Commits<cr>

"   Change default bindings
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit'
    \ }

" fzf-checkout bindings
"   ctrl + d to delete the branch under cursor
"   alt + enter to track a remote branch locally
nnoremap <leader>gc :GBranches<CR>

" Clear previous search highlight
nnoremap <leader>h :noh<CR><esc>

" vim-livedown
nmap <leader>tm :LivedownToggle<CR>

" bracey.vim
nmap <leader>tb :Bracey<CR>


" Better multiple lines tabbing with < and >
vnoremap < <gv
vnoremap > >gv

" rainbow_parantheses
nnoremap <leader>tr :RainbowParentheses!!<CR>

" nvim-colorizer
nnoremap <leader>tc :ColorizerToggle<CR>

" vim-fugitive
"   Enter :Git and then do g? to checkout all hotkeys
"   After :Git use cc to enter commit buffer
"   to add the file under cursor to .gitignore use {anynumber}gI
"   git status
nnoremap <leader>gs :G<CR>
"   solving merge conflicts
nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>


" auto-pairs
"   <M-p> : Toggle auto-pairs
"   <M-e> : Insert () or {} or [] before something then hit <M-e> to fast wrap
"   <M-n> : Jump to next closed pair
"   Use Ctrl-V) to insert paren without trigerring plugin
"   Use x or DEL to delete the character inserted by the plugin

" nerdcommenter
"   [count]<leader>cc          : make lines commented
"   [count]<leader>c<space>    : toggle line's comment status (commented/uncommented)
map <leader>cc <plug>NERDCommenterComment
map <leader>cu <plug>NERDCommenterUncomment
map <leader>ct <plug>NERDCommenterToggle
map <leader>cm <plug>NERDCommenterMinimal

" vim-surround
"   Works with parentheses(), brackets [], quotes (double or single), XML tags <q> </q>  and more
"   NOTE: Use vS) instead of vS( to surround without space
"   Example:
"   cs'<q>     : To change 'Hello' to <q>Hello</q>
"   ds'        : To remove delimiters from 'Hello'
"   dst        : To remove the surrounding tag
"   cst<p>     : To change the surrounding tag to <p>
"   vS         : In visual mode, S surrounds the selected (vSt for tag)

" vim-closetag
"   Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'

" emmet-vim
"   All commands and bindings:  https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL
"   Trigger key ,,      you can also use autocomplete to select abbreviation
"   Example: Write one of the keywords listed below, go to normal mod and
"            press ,,
"   remove a tag                : <C-y>k
"   update image's size         : <C-y>i
"   make anchor from a URL      : <C-y>a
"   make quoted text from a URL : <C-y>A
"
"   tag expansion               : div
"   nested tag expansion        : div>div1>div2>div3
"   creating lists              : div#mylist>li*10>{List Item} (list with 10
"                                                               items)
"   creating lists with indices : div#mylist>li*10>{List Item $}
"   creating sibling tags       : div+h1+h2
"   shortcuts                   : bq, btn, hdr, ftr
"   ID expansion                : tag_name#id_name
"   class expansion             : tag_name.class_name
"   default class expansion     : .class_name (div is assumed as tag)
"   multi class expansion       : .class1.class2
"   ID & class expansion        : #myid.myclass
let g:user_emmet_leader_key=','

" vim-cycle
"   Move cursor on a word and hit <C-A> or <C-X> to toggle between pair of
"       words or even increment-decrement a number

" vim-indent-object
"   Defines two new text objects to select only current indentation level
"   <count>ai 	An Indentation level and line above.
"   <count>ii 	Inner Indentation level (no line above).
"   <count>aI 	An Indentation level and lines above/below.


" vim-dadbod config
"   Setup:
"       let b:db = "postgresql://[username[:password]@][host][:port][/dbname]"
"   In visual mode:
"       select the query and press <leader>db to execute the query
"   In normal mode:
"       press <leader>dbb to execute query on the line
"       press <leader>db + text-object to run the queries by specifying text
"        object
xnoremap <expr> <Plug>(DBExe)     db#op_exec()
nnoremap <expr> <Plug>(DBExe)     db#op_exec()
nnoremap <expr> <Plug>(DBExeLine) db#op_exec() . '_'

xmap <leader>db  <Plug>(DBExe)
nmap <leader>db  <Plug>(DBExe)
omap <leader>db  <Plug>(DBExe)
nmap <leader>dbb <Plug>(DBExeLine)

" vim-cmake config
nnoremap <leader>cg :CMakeGenerate<CR>
nnoremap <leader>cb :CMakeBuild<CR>
nnoremap <leader>co :CMakeOpen<CR>

augroup vim_cmake_group
    " autoclose vim-cmake window after successfull build
    autocmd! User CMakeBuildSucceeded CMakeClose
augroup END

" neorg config
nnoremap <silent> <localleader>nm :Neorg inject-metadata<CR>
nnoremap <silent> <localleader>t :Neorg toc left <CR> :vertical resize 50<CR>
nnoremap <silent> <localleader>a i
"   insert anchor
nnoremap <silent> <localleader>a i<C-v>{<C-v>}<Esc>h"+p
"   autoindent file
" nnoremap <silent> <localleader>i :normal! gg <CR> :%normal! i<Esc><C-o>
nnoremap <silent> <localleader>i gg=G<C-o>

" nvim-tree config
nnoremap <silent> <C-c> :NvimTreeToggle<CR>
nnoremap <silent> <leader>pv :NvimTreeFindFile!<CR>

" debugprint.nvim config
lua << EOF
vim.keymap.set("n", "<Leader>dpp", function()
    return require('debugprint').debugprint()
end, {
    expr = true,
})
vim.keymap.set("n", "<Leader>dpP", function()
    return require('debugprint').debugprint({ above = true })
end, {
    expr = true,
})
vim.keymap.set({"n", "v"}, "<Leader>dpv", function()
    return require('debugprint').debugprint({ variable = true })
end, {
    expr = true,
})
vim.keymap.set({"n", "v"}, "<Leader>dpV", function()
    return require('debugprint').debugprint({ above = true, variable = true })
end, {
    expr = true,
})
vim.keymap.set("n", "<Leader>dpo", function()
    return require('debugprint').debugprint({ motion = true })
end, {
    expr = true,
})
vim.keymap.set("n", "<Leader>dpO", function()
    return require('debugprint').debugprint({ above = true, motion = true })
end, {
    expr = true,
})
EOF

" refactoring.nvim config
lua << EOF
-- prompt for a refactor to apply when the remap is triggered
vim.keymap.set(
    {"n", "x"},
    "<leader>rr",
    function() require('refactoring').select_refactor() end
)
-- Note that not all refactor support both normal and visual mode
EOF
