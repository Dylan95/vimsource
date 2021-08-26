"author: Dylan Gundlach

"LOAD VIMSOURCE

let vimsourceDir = '~/.vimsource/'
let pluginsDir = vimsourceDir . 'plugins/'
let gdbDir = vimsourceDir . 'plugins/'

function DCG_SourceAll(dir)
	let files = a:dir . '*.vim'
	for f in split(glob(l:files), '\n')
		exec 'source ' . f
	endfor
endfunction

exec 'source ' . vimsourceDir . 'functions/functions.vim'
exec 'source ' . vimsourceDir . 'functions/bashString.vim'

exec 'source ' . vimsourceDir . 'pulse.vim'

exec 'source ' . vimsourceDir . 'settings.vim'

exec 'source ' . vimsourceDir . 'appearence.vim'
exec 'source ' . vimsourceDir . 'editing.vim'
exec 'source ' . vimsourceDir . 'folding.vim'
exec 'source ' . vimsourceDir . 'git.vim'
exec 'source ' . vimsourceDir . 'misc.vim'
exec 'source ' . vimsourceDir . 'movement.vim'
exec 'source ' . vimsourceDir . 'searchReplace.vim'
exec 'source ' . vimsourceDir . 'sessions.vim'
exec 'source ' . vimsourceDir . 'tabsAndWindows.vim'

exec 'source ' . vimsourceDir . 'prettyTabs.vim'

exec 'source ' . vimsourceDir . 'comments_cs.vim'

exec 'source ' . vimsourceDir . 'textobjects.vim'

exec 'source ' . vimsourceDir . 'syntaxMovement.vim'
exec 'source ' . vimsourceDir . 'syntaxMovementInterface.vim'




exec 'source ' . vimsourceDir . 'filetypes/autoloadFiletype.vim'

exec 'source ' . pluginsDir . 'loadPlugins.vim'
exec 'source ' . pluginsDir . 'pluginsConfig/conqueTerm.vim'
exec 'source ' . pluginsDir . 'pluginsConfig/miscPlugins.vim'
exec 'source ' . pluginsDir . 'pluginsConfig/cppPlugins.vim'
exec 'source ' . pluginsDir . 'pluginsConfig/javaPlugins.vim'





"allow alt and ctrl to be used with ubuntu's terminal
call DisableTerminalMeta()






let g:OmniSharp_server_type = 'v1'
let g:OmniSharp_server_type = 'roslyn'













"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'












"this keeps indents for empty lines.
"it does this by inserting and deleting a character each time a line is inserted
inoremap <CR> <CR>x<BS>
"inoremap <CR> <CR>x

nnoremap O Ox<BS><ESC>l




function DCG_cloneLineBelow()
	let l:selection = getline(".")
	"
	let l:pos = getpos(".")
	"put l:selection after the current line
	put =l:selection
	call setpos(".", l:pos)
endfunction

function DCG_cloneSelectionBelow()
	let l:lineStart = line("'<") "start of the selection
	let l:lineEnd = line("'>") "end of the selection
	"
	if(line(".") == l:lineEnd) "makes sure it only runs once
		let l:selection = DCG_get_visual_selection_lines()
		"
		"let l:pos = getpos(".")
		"go to end of file
		"exec ":" . l:lineEnd
		"put l:selection at end of file
		put =l:selection
		"return to position
		"call setpos(".", l:pos)
		"
		"gv goes to the last visual selection. delete the selection (into the black hole register).
		"exec "normal! gv" . "\"_d"
		exec "normal! gv"
	endif
endfunction


"duplicate line
nnoremap <leader>d :call DCG_cloneLineBelow()<CR>
vnoremap <leader>d :call DCG_cloneSelectionBelow()<CR>






"disables all easymotion plug shortcuts (there are a lot and I only need a few)
nmap <leader><leader> <NOP>
nmap <leader><leader> <Plug>(easymotion-w)
"word above/below
nmap <leader>i <Plug>(easymotion-k)
vmap <leader>i <Plug>(easymotion-k)
nmap <leader>k <Plug>(easymotion-j)
vmap <leader>k <Plug>(easymotion-j)
"word in line
nmap <leader>j <Plug>(easymotion-b)
vmap <leader>j <Plug>(easymotion-b)
nmap <leader>l <Plug>(easymotion-w)
vmap <leader>l <Plug>(easymotion-w)

nmap <leader><leader>s :w<CR>


nnoremap <leader>P :set paste!<CR>
nnoremap <leader><leader>P :set paste!<CR>


"nessecary for FOOT_SHIFT which uses F9 to get rid of unwanted keys because I don't know the proper way to do it.
nnoremap <F9> <NOP>
vnoremap <F9> <NOP>
snoremap <F9> <NOP>
xnoremap <F9> <NOP>
inoremap <F9> <NOP>
cnoremap <F9> <NOP>
onoremap <F9> <NOP>
nnoremap <S-F9> <NOP>
vnoremap <S-F9> <NOP>
snoremap <S-F9> <NOP>
xnoremap <S-F9> <NOP>
inoremap <S-F9> <NOP>
cnoremap <S-F9> <NOP>
onoremap <S-F9> <NOP>
nnoremap <C-F9> <NOP>
vnoremap <C-F9> <NOP>
snoremap <C-F9> <NOP>
xnoremap <C-F9> <NOP>
inoremap <C-F9> <NOP>
cnoremap <C-F9> <NOP>
onoremap <C-F9> <NOP>
nnoremap <M-F9> <NOP>
vnoremap <M-F9> <NOP>
snoremap <M-F9> <NOP>
xnoremap <M-F9> <NOP>
inoremap <M-F9> <NOP>
cnoremap <M-F9> <NOP>
onoremap <M-F9> <NOP>




































