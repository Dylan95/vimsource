
let s:comment = ""

"returns whether or not the current line is commented
function DCG_lineIsCommented()
	let l:commentLinePattern = "\s*" . s:comment . ".*"
	"return(getline(".") ~= "")
	return(getline(".") =~ l:commentLinePattern)
	"return(true)
endfunction

function DCG_commentLine()
	if(s:comment != "")
		"go to beginning of line motion
		execute "normal! ^"
		"insert comment
		execute "normal! i" . s:comment
		"go to beginning of line again
		execute "normal! ^"
	endif
endfunction

function DCG_uncommentLine()
	if(s:comment != "")
		if DCG_lineIsCommented()
			execute "normal! ^"
			execute "normal! d" . len(s:comment) . "l"
		endif
		execute "normal! ^"
	endif
endfunction	



function DCG_get_visual_selection_lines()
	let l:lineStart = line("'<") "start of the selection
	let l:lineEnd = line("'>") "end of the selection
	return join(getline(l:lineStart, l:lineEnd), "\n")
endfunction



function DCG_sendLineToGraveyard()
	call DCG_commentLine()
	let l:selection = getline(".")
	"
	"delete the last line into the black hole register
	exec "normal! \"_dd"
	"
	let l:pos = getpos(".")
	"go to end of file
	exec "normal! G"
	"put l:selection at end of file
	put =l:selection
	"return to position
	call setpos(".", l:pos)
endfunction

function DCG_sendRangeToGraveyard()
	let l:lineStart = line("'<") "start of the selection
	let l:lineEnd = line("'>") "end of the selection
	"
	call DCG_commentLine()
	"
	if(line(".") == l:lineEnd) "makes sure it only runs once
		let l:selection = DCG_get_visual_selection_lines()
		"
		"gv goes to the last visual selection. delete the selection (into the black hole register).
		exec "normal! gv" . "\"_d"
		"delete the last line into the black hole register
		exec "normal! \"_dd"
		"
		let l:pos = getpos(".")
		"go to end of file
		exec "normal! G"
		"put l:selection at end of file
		put =l:selection
		"return to position
		call setpos(".", l:pos)
	endif
endfunction



nnoremap <leader>cc :call DCG_commentLine()<CR>
vnoremap <leader>cc :call DCG_commentLine()<CR>

nnoremap <leader>cu :call DCG_uncommentLine()<CR>
vnoremap <leader>cu :call DCG_uncommentLine()<CR>

nnoremap <leader>cg :call DCG_sendLineToGraveyard()<CR>
vnoremap <leader>cg :call DCG_sendRangeToGraveyard()<CR>



autocmd FileType * :let s:comment = ""
"
autocmd FileType vim :let s:comment = "\""
autocmd FileType cs :let s:comment = "//"
autocmd FileType c :let s:comment = "//"
autocmd FileType cpp :let s:comment = "//"
autocmd FileType h :let s:comment = "//"
autocmd FileType hpp :let s:comment = "//"
autocmd FileType py :let s:comment = "#"


































		"
		"O opens a new line above the last one. 
		"x inserts an 'x' onto that line.  This is so that
		"vim doesn't delete the tabs
		"exec "normal! Ox"
		"delete the 'x' character
		"exec "normal! dl"




"function! s:get_visual_selection()
"  let [lnum1, col1] = getpos("'<")[1:2]
"  let [lnum2, col2] = getpos("'>")[1:2]
"  let lines = getline(lnum1, lnum2)
"  let lines[-1] = lines[-1][: col2 - 2]
"  let lines[0] = lines[0][col1 - 1:]
"  return join(lines, "\n")
"endfunction




"vnoremap <leader>cc :call DCG_modifySelection("DCG_commentLine")<CR>
"vnoremap <leader>cu :call DCG_modifySelection("DCG_uncommentLine")<CR>


"start,end: line numbers
"function DCG_modifyLines(start, end, funcName)
"	echo a:start
"	let l:i = a:start
"	while(l:i < a:end)
"		exec l:i . "G"
"		exec a:funcName
"		let l:i = l:i + 1
"	endwhile
"endfunction
"
"function DCG_modifySelection(funcName)
"	let l:lineStart = line(".")
"	let l:lineEnd = line(".")
"	call DCG_modifyLines(l:lineStart, l:lineEnd, a:funcName)
"endfunction


":command Inshtml :normal i //<ESC>
	":command Inshtml :normal i //^V<ESC>
	"if(col('.') != 1):
	"	:command Inshtml :normal i your text here^V<ESC>
	" char = getline('.')[col('.')-1]
	" if(char == '\n'){
		
	" }
	


"used to insure that DCG_sendLineToGraveyard is only
"does it's thing once.
"let s:b_graveyardReady = 1
"let s:selection = ""

"function dcg_insertText(str):
"	:command Inshtml :normal i a:str^V<ESC>

"function! s:get_visual_selection()
"  let [lnum1, col1] = getpos("'<")[1:2]
"  let [lnum2, col2] = getpos("'>")[1:2]
"  let lines = getline(lnum1, lnum2)
"  let lines[-1] = lines[-1][: col2 - 2]
"  let lines[0] = lines[0][col1 - 1:]
"  return join(lines, "\n")
"endfunction
	
