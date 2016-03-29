"c/c++ autocomplete

let g:clang_library_path='/usr/lib/x86_64-linux-gnu'
"nnoremap <C-n> <Tab>


set pumheight=10             " so the complete menu doesn't get too big
set completeopt=menu,longest " menu, menuone, longest and preview
let g:SuperTabDefaultCompletionType='context'
let g:clang_complete_auto=1
"let g:clang_snippets=1       " use a snippet engine for placeholders
"let g:clang_snippets_engine='ultisnips'
let g:clang_auto_select=0    " automatically select and insert the first match


"let g:UltiSnipsSnippetsDir        = '~/.vim/snippets/'
"let g:UltiSnipsSnippetDirectories = ['UltiSnips', 'snippets']

"let g:UltiSnipsExpandTrigger       = '<C-CR>'
"let g:UltiSnipsJumpForwardTrigger  = '<C-m>'
"let g:UltiSnipsJumpBackwardTrigger = '<C-n>'
