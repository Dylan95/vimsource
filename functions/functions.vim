let g:DCG_GDB_GreedyMatch = '\(.*\)'
let g:DCG_GDB_NonGreedyMatch = '\(.\{-}\)'

"functions:
"only designed to work for the ububtu's default terminal.
function DisableTerminalMeta()
	let c='a'
	while c <= 'z'
		exec "set <A-".c.">=\e".c
		exec "imap \e".c." <A-".c.">"
		let c = nr2char(1+char2nr(c))
	endwhile
	set timeout ttimeoutlen=50
endfunction

function DisableKeys(mode, ...)
	for key in a:000
		exec a:mode."noremap ".key." <NOP>"
	endfor
endfunction

"maps the modes: select what modes to use
function Map_select(k1, k2, ...)
	for mode in a:000
		exec mode."noremap ".a:k1." "a:k2 
	endfor
endfunction

"maps the keys for all modes
function Map_all(k1, k2)
	exec "call Map_select('".a:k1."', '".a:k2."', 'n', 'i', 'v', 's', 'c')"
	exec "call Map_select('".a:k1."', '".a:k2."', 'i', 'v', 's', 'c')"
endfunction

"maps the keys for normal and visual mode
function Map_nv(k1, k2)
	exec "call Map_select('".a:k1."', '".a:k2."', 'n', 'v')"
endfunction

"maps k1 in insert mode to execute k2 in normal mode
"then it returns to insert mode
function Map_esc(k1, k2)
	exec "inoremap ".a:k1." <Esc>"a:k2."i"
endfunction



"because 'exec "!echo " . l:variable' just doesn't work with multiple lines
"there doesn't seem to b a way to do it with printf either.
"it handles single quotes in an imperfect but very reliable and safe way:
"it replaces them with __QUOTE__
function PrintToCommandLine(variable)
	let sanitized = substitute(a:variable, "'", "__QUOTE__", "g")
	"let sanitized = a:variable
	let command = "silent !echo '" . substitute(l:sanitized, "\n", "\'\nsilent !echo \'", "g") . "\'"
	"echo l:command
	exec l:command
	"
	"vnew
	"put =a:variable
	"for i in range(1, line('$'))
	"	silent exec "!echo \'" . getline(i) . "\'"
	"endfor
	"q!
	"
	redraw!
endfunction

"return the results of the command
"and print the results to the command line
function ExecReturn(command)
	if a:command[0] == "!"
		echo "command badly formatted: it cannot start with \"!\""
		return ""
	endif
	"let l:tempTestTime = DCG_relTimeFloat()
	let output = system(a:command)
	"exec "!echo " . string(DCG_relTimeFloat()-l:tempTestTime)
	call DCG_superRefreshScreen()
	return output
endfunction


"echoes the command then executes it silently
"designed to look like it called directly on the command line
"usage: 'call ExecNorm("!ls")'
function ExecNorm(command)
	if a:command[0] == "!"
		echo "command badly formatted: it cannot start with \"!\""
	else
		silent exec "!echo ''"
		silent exec "!echo " . a:command
		exec "!" . a:command
		silent exec "!echo ''"
	endif
endfunction





function ReverseString(str)
	let result = ""
	let i = len(a:str)-1
	while(i >= 0)
		let result = result . a:str[i]
		let i -= 1
	endwhile
	return(result)
endfunction





function DCG_ReadFile(name)
	return(join(readfile(a:name), "\n"))
endfunction

"goes to the buffer if it exists
"returns: 1 if it exists, 0 otherwise
"function DCG_GotoBuff(name)
"endfunction

"finds the first window with a buffer with name 'name'
"usage:
"let [tabnr, winnr]=s:FindWinID('abc')
"execute "tabnext" tabnr
"execute winnr."wincmd w"
function DCG_FindWinName(bufName)
	for tabnr in range(1, tabpagenr('$'))
		let winnr = bufwinnr(a:bufName)
		if(winnr != -1)
			return [tabnr, winnr]
		endif
	endfor
	return [0, 0]
endfunction

"returns [currentTab, currentWindow]
function DCG_CurrentPos()
	return [tabpagenr(), winnr()]
endfunction

function DCG_JumpToBuff(buffName)
	let bufPos = DCG_FindWinName(a:buffName)
	call DCG_JumpTo(bufPos[0], bufPos[1])
endfunction
function DCG_JumpTo(tabnr, winnr)
	exec 'normal ' . a:tabnr . 'gt'
	exec a:winnr . 'wincmd w'
endfunction

function DCG_BuffExists(buffName)
	return(buffer_number(a:buffName) != -1)
endfunction



"sets the buffers contents to 'str'
function DCG_SetBuffer(buffName, str)
	if(bufloaded(bufname(a:buffName)))
		let l:currentBuffer = @%
		"
		call DCG_JumpToBuff(a:buffName)
		"exec 'buffer ' . a:buffName
		"delete all lines
		1,$d
		call DCG_InsertStr(a:str)
		"
		call DCG_JumpToBuff(l:currentBuffer)
	endif
endfunction
"append the buffer with 'str'
function DCG_AppendBuffer(buffName, str)
	let buff = @%
	if DCG_BuffExists(a:buffName)
		exec 'buffer ' . a:buffName
		call cursor(line('$'), col('$'))
		call DCG_InsertStr(a:str)
		exec 'buffer ' . l:buff
	endif
endfunction

function DCG_InsertStr(str)
	let pasteStr = @"
	let @" = a:str
	exec "normal! " . "P"
	exec "normal! " . "l"
	"call feedkeys('P', 'n')
	let @" = l:pasteStr
endfunction



function DCG_ListContains(lst, value)
	return(index(a:lst, a:value) >= 0)
endfunction

"return: the value with key 'key' if the key is in the dictionary.
"	and an empty list if it isn't.
function DCG_DictContains(dict, key)
	return(DCG_ListContains(keys(a:dict), a:key))
endfunction









"returns contents of buffer as a string
function DCG_bufferToString()
	return(join(getline(1, '$'), "\n"))
endfunction






"gets relative time as a float, accurate up to nanoseconds.
function DCG_relTimeFloat()
	let l:time = reltime()
	return(l:time[0] + (l:time[1] / 1000000.0))
endfunction


"a hacky fix to a particular bug that sometimes happens in vim.
"when a command executed using the "system" function takes any significan amount of time, 
"like tens of milliseconds, but vim continues to recieve input, 
"it will show the keystrokes below the bottom of the buffer,
"this will mess up the line numbers, among other things and is obnoxious, 
"but only in an asthetic way.
"so this basically writes a bunch of lines to the bottom of the buffer, 
"deletes the lines, and returns to the original positon, good as new.
function DCG_superRefreshScreen()
	let l:pos = getpos(".")
	let l:emptyLines = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	let l:i = 0
	while(l:i < winheight("."))
		let l:emptyLines = l:emptyLines . "\n"
		let l:i = l:i + 1
	endwhile
	silent exec "normal! G"
	call DCG_InsertStr(emptyLines)
	silent u
	call setpos(".", l:pos)
endfunction





"mode:
"	n: normal
"	i: insert
"	etc.
function DCG_waitingMap(mode, key, command)
	let l:mapCommand = a:mode . "noremap " . a:key . " "
	let l:setMap = "call DCG_waitingMap(" . "\\\"" . a:mode . "\\\"" . ", " . "\\\"" . a:key . "\\\"" . ", " . "\\\"" . a:command . "\\\"" . ")"
	let l:clearMap = l:mapCommand . "<NOP>"
	let l:multicommand = l:clearMap . " \\| " . a:command . " \\| " . l:setMap
	"exec l:mapCommand . ":exec \"" . l:multicommand . "\""
	silent exec l:mapCommand . ":silent exec \"" . l:multicommand . "\"<CR>"
	"echo l:multicommand
endfunction





















































"function DCG_superRefreshScreen()
	"let l:pos = getpos(".")
	"let l:emptyLines = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	"let l:i = 0
	"while(l:i < winheight("."))
		"let l:emptyLines = l:emptyLines . "\n"
		"let l:i = l:i + 1
	"endwhile
	"silent exec "normal! G"
	"call DCG_InsertStr(emptyLines)
	"silent exec "normal! G"
	"let l:delNum = len(l:emptyLines)-1
	"silent exec "normal! d" . l:delNum . "k"
	"call setpos(".", l:pos)
"endf


