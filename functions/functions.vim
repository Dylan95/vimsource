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
	"
	"call PrintToCommandLine(command)
	"redir =>output
	"exec "silent exec !" . a:command
	"redir END
	"
	let output = system(a:command)
	"
	"exec "!echo " . l:output
	"!echo l:output
	"exec "!echo -e \"" . l:output . "\""
	"redir =>&1
	"echo l:output
	"w !tee
	"redir END
	"
	"call PrintToCommandLine(output)
	"
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




