
"
"function s:anythingExceptRegex(regex):
"	return("/^\(" . "\(" . regex "\)" . "\@!.\)*$)")
"endfunction
"
"function s:optionalChar(char)
"	return("\(" . char . "\)" . "\?")
"endfunction
"
"function s:getc()
"	return(getline(".")[col(".")-1])
"endfunction
"
"
"
"function s:passQuotes(quoteChar, movement)
"	exec "normal! f/" . anythingExceptRegex("\\") . l:c . "n"
"	noh
"endfunction
"
"function s:passRecursiveNesting(count, charBegin, charEnd, charExit, movement)
"	let l:c = getc()
"	"while not at the end of the file
"	while(l:c != getpos("$"))
"		if((a:count == 0) && (l:c == charExit)):
"			break
"		endif
"		if((l:c == "\"") || (l:c == "'"))
"		else if(l:c == charBegin)
"			a:count = a:count + 1
"		endif
"		else if(l:c == charEnd)
"			a:count = a:count - 1
"		endif
"		else
"			exec "normal! " . movement
"		endif
"	endwhile
"endfunction
"
"
"
"function s:arg_begin():
"	call s:passRecursiveNesting(-1, '(', ')', ',', 'h')
"endfunction
"
"function s:arg_end():
"	call s:passRecursiveNesting(1, '(', ')', ',', 'h')
"endfunction
"
"
"
"function s:
"
"
"
"
"
"
"
"
"
"









