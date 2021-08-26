"c/c++ autocomplete

let g:glang_use_library = 1
let g:clang_library_path='/usr/lib/x86_64-linux-gnu'

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
let g:clang_complete_copen = 0
" 0 - do not highlight the warnings and errors 
" 1 - highlight the warnings and errors the same way clang does it 
"let g:clang_hl_errors = 1
"
let g:clang_periodic_quickfix = 0
"
" 0 - do not do some snippets magic on code placeholders like function argument, 
"     template argument, template parameters, etc. 
" 1 - do some snippets magic on code placeholders like function argument, 
"     template argument, template parameters, etc. 
let g:clang_snippets = 0
" The snippets engine (clang_complete, ultisnips... see the snippets 
" subdirectory). 
let g:clang_snippets_engine = "clang_complete" " breaks <C-i>
"let g:clang_snippets_engine = "ultisnips"
"
"Note: This option is specific to clang_complete snippets engine.
"If equal to 1, clang_complete will use vim 7.3 conceal feature to hide the
"snippet placeholders.
let g:clang_conceal_snippets = 0
"
"If equal to 1, it will add optional arguments to the function call snippet.
"Snippet replaceable object will not be only the argument, but the preceding
"comma will be included as well, so you can press backspace to delete the
"optional argument, while the replaceable is selected.
"Example: foo($`T param1`, $`T param2`$`, T optional_param`)
"Default: 0
let g:clang_complete_optional_args_in_snippets = 1
"
"set conceallevel=2
"set concealcursor=vin
"set pumheight=20
"
"set completeopt=menu,menuone

"function DCG_handleTab()
"    if(pumvisible())
"		feedkeys("i<C-n>", "n")
"	else
"		feedkeys("<C-x><C-u>", "n")
"	endif
"endfunction
"<C-x><C-u> causes clang_complete LaunchCompletion to be called
inoremap <S-Tab> <C-x><C-u>
"inoremap <expr> <TAB> ((pumvisible())?("<C-n>"):("<TAB>"))
"inoremap <TAB> ((pumvisible())?("<C-n>"):("<C-x><C-u>"))
"inoremap <expr> <buffer> <Tab> <SID>LaunchCompletion()
"inoremap <Tab> ((pumvisible())?("<C-n>"):("<DOWN>"))
"inoremap <Tab> <Esc>:call DCG_handleTab()
"inoremap <expr> <Tab> ((pumvisible())?("<C-n>"):("<Tab>"))
"nnoremap <Tab> <NOP>
autocmd FileType * inoremap <expr> <Tab> ((pumvisible())?("<C-n>"):("<Tab>"))

"function ConfigureClangSnippets()
"	let g:clang_snippets = 1
"	let g:clang_snippets_engine = "clang_complete"
"endfunction
"I know this is horribly hacky, but for some reason when I try to 
"set it normally it unmaps <C-i>, and continues to automatically unmap it.
"so remapping it won't work.
"autocmd CursorMoved * :call ConfigureClangSnippets()

"au CursorMovedI,CursorMoved,CursorHold,CursorHoldI nnoremap <C-i> k
"let g:clang_make_default_keymappings = 0

"nnoremap <F3> :call g:ClangUpdateQuickFix()<CR>

" SuperTab completion fall-back 
"let g:SuperTabDefaultCompletionType='<c-x><c-u><c-p>'


"let g:UltiSnipsSnippetsDir        = '~/.vim/snippets/'
"let g:UltiSnipsSnippetDirectories = ['UltiSnips', 'snippets']

"let g:UltiSnipsExpandTrigger       = '<C-CR>'
"let g:UltiSnipsJumpForwardTrigger  = '<C-m>'
"let g:UltiSnipsJumpBackwardTrigger = '<C-n>'


"if popup menu is open, select it's current 
"function EnterCheck(){
"	if(pumvisible())
"}

function! DCG_ShouldComplete()
  if (getline('.') =~ '#\s*\(include\|import\)')
    return 0
  else
    if col('.') == 1
      return 1
    endif
    for l:id in synstack(line('.'), col('.') - 1)
      if match(synIDattr(l:id, 'name'), '\CComment\|String\|Number')
            \ != -1
        return 0
      endif
    endfor
    return 1
  endif
endfunction

function! DCG_LaunchCompletion()
  let l:result = ""
  if DCG_ShouldComplete()
    let l:result = "\<C-X>\<C-U>"
    if g:clang_auto_select != 2
      let l:result .= "\<C-P>"
    endif
    if g:clang_auto_select == 1
      let l:result .= "\<C-R>=(pumvisible() ? \"\\<Down>\" : '')\<CR>"
    endif
  endif
  return l:result
endfunction

inoremap <expr> <UP> ((pumvisible())?("<C-p>"):("<UP>"))
inoremap <expr> <DOWN> ((pumvisible())?("<C-n>"):("<DOWN>"))

"set pumheight=10             " so the complete menu doesn't get too big
"set completeopt=menu,longest " menu, menuone, longest and preview
"let g:SuperTabDefaultCompletionType='context'
"let g:clang_complete_auto=0  " I can start the autocompletion myself, thanks..
"let g:clang_snippets=1       " use a snippet engine for placeholders
"let g:clang_snippets_engine='ultisnips'
"let g:clang_auto_select=2    " automatically select and insert the first match





"for vim-clang
"nnoremap <F3> :call g:ClangSyntaxCheck()<CR>





"source ~/.vimsource/clangCompleteWindow.vim











