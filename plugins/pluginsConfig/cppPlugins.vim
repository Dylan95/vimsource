"c/c++ autocomplete

let g:glang_use_library = 1
let g:clang_library_path='/usr/lib/x86_64-linux-gnu'
"nnoremap <C-n> <Tab>

" let g:clang_user_options='|| exit 0'

" 0 - Select nothing 
" 1 - Automatically select the first entry in the popup menu, but do not 
" insert it into the code. 
" 2 - Automatically select the first entry in the popup menu, and insert it 
" into the code. 
let g:clang_auto_select = 0
" 0 - do not complete after ->, ., :: 
" 1 - automatically complete after ->, ., :: 
let g:clang_complete_auto = 1
" 0 - do not open quickfix window on error. 
" 1 - open quickfix window on error. 
let g:clang_complete_copen = 1
" 0 - do not highlight the warnings and errors 
" 1 - highlight the warnings and errors the same way clang does it 
let g:clang_hl_errors = 1
" 0 - do not do some snippets magic on code placeholders like function argument, 
"     template argument, template parameters, etc. 
" 1 - do some snippets magic on code placeholders like function argument, 
"     template argument, template parameters, etc. 
let g:clang_snippets = 1
" The snippets engine (clang_complete, ultisnips... see the snippets 
" subdirectory). 
let g:clang_snippets_engine = "clang_complete"

nnoremap <F3> :call g:ClangUpdateQuickFix()<CR>

" SuperTab completion fall-back 
"let g:SuperTabDefaultCompletionType='<c-x><c-u><c-p>'


"let g:UltiSnipsSnippetsDir        = '~/.vim/snippets/'
"let g:UltiSnipsSnippetDirectories = ['UltiSnips', 'snippets']

"let g:UltiSnipsExpandTrigger       = '<C-CR>'
"let g:UltiSnipsJumpForwardTrigger  = '<C-m>'
"let g:UltiSnipsJumpBackwardTrigger = '<C-n>'















