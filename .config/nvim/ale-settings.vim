" ALE config (Asynchronous Lint Engine)
augroup ale_group
    autocmd!
    " auto close error-list when it's the last buffer open
    autocmd QuitPre * if empty(&bt) | lclose | endif
augroup END

let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_fix_on_save = 0
" Show ale signs over gitsigns
let g:ale_sign_priority=30

"   Don't lint when text is changed
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
\   'typescript': [],
\   'python': ['flake8'],
\   'html': ['tidy'],
\   'sql': [],
\   'css': ['stylelint'],
\   'scss': ['stylelint'],
\   'rust': ['analyzer'],
\   'latex': ['chktex'],
\   'c': [],
\   'cpp': []
\}

"   Set fixers by file type
"   remove trailing lines and trim whitespaces for every file type
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'html': ['html-beautify'],
\   'css': ['stylelint'],
\   'scss': ['stylelint'],
\   'sql': ['pgformatter'],
\   'python': ['autopep8'],
\   'rust': ['rustfmt'],
\   'latex': ['chktex'],
\   'c': ['clang-format'],
\   'cpp': ['clang-format']
\}
augroup ale_settings_by_filetype
    autocmd!
    autocmd FileType python let b:ale_warn_about_trailing_whitespace = 0
augroup END

augroup ale_disable_by_filetype
    autocmd!
    " autocmd FileType svelte let b:ale_linters = {'javascript': [], 'typescript': [], 'svelte': ['stylelint'], 'css': ['stylelint'], 'scss': ['stylelint']}
    "       Cannot disable eslint for svelte without disabling eslint for
    "       javascript and typescript
     autocmd FileType html.javascript.jinja let b:ale_linters =
        \ {'html': [], 'css': ['stylelint'], 'scss': ['stylelint'], 'javascript': ['eslint'], 'typescript': ['eslint']}

    " Disable ALE lsp for specific files
    autocmd FileType typescript,sql,json,c,cc,c++,cpp let g:ale_lint_on_text_changed = 0
        \ | let g:ale_lint_on_insert_leave = 0
        \ | let g:ale_lint_on_save = 0
        \ | let g:ale_lint_on_enter = 0
augroup END

" Disable line too long warning for flake8
let g:ale_python_flake8_options = '--max-line-length 120 --ignore=E501'
let g:ale_python_autopep8_options = '--max-line-length 120'
let g:ale_html_beautify_options = '--indent-size 2 --max-preserve-newlines 2 --wrap-line-length 120'

" let g:ale_c_clangformat_options = "-style='{BasedOnStyle: WebKit, ColumnLimit: 120, BreakBeforeBraces: Stroustrup, IndentWidth: 4, IndentCaseLabels: false, PointerAlignment: Left, SpaceBeforeAssignmentOperators: true, AllowShortBlocksOnASingleLine: Never, AllowShortFunctionsOnASingleLine: None, AlwaysBreakTemplateDeclarations: Yes}'"
let g:ale_c_clangformat_options = "-style='{BasedOnStyle: WebKit, ColumnLimit: 120, BreakBeforeBraces: Stroustrup, IndentWidth: 4, IndentCaseLabels: false, PointerAlignment: Left, SpaceBeforeAssignmentOperators: true, AllowShortBlocksOnASingleLine: Never, AllowShortFunctionsOnASingleLine: InlineOnly, AlwaysBreakTemplateDeclarations: Yes}'"

let g:ale_rust_analyzer_executable = "$HOME/.config/coc/extensions/coc-rust-analyzer-data/rust-analyzer"
let g:ale_rust_rustfmt_options = "--config wrap_comments=true,format_code_in_doc_comments=true,overflow_delimited_expr=true"

let g:ale_javascript_prettier_use_local_config = 1
"let g:ale_javascript_prettier_executable = './node_modules/.bin/prettier'
"let g:ale_javascript_eslint_executable = './node_modules/.bin/eslint'

let g:ale_scss_stylelint_use_global = 1

let g:ale_html_tidy_options = "-config $HOME/projects/web/dotfiles/jinja/.tidyrc"
