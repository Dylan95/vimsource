

"returns the last identifier in the string
function s:getLastIdentifier(str)
	let rev = ReverseString(str)
	return(ReverseString(matchstr(rev, '\(\d\|\h\)*\h')))
endfunction


"gets the identifier currently under the cursor
"regular expressions would be a better way to do this, but I'm not sure
"how to count the number of parentheses that way.
"return: {functionIdentifier, argNumber}
function s:getContainingFunction()
	let endLine = line(".")
	let endCol = col(".")
	let line = end
	let col = end
	"
	let parenCount = 0
	let argCount = 0
	" 
	while(line > 0)
		let lineStr = getline(line)
		"
		while(col > 0)
			let char = lineStr[col]
			"
			if(char == ",")
				argCount += 1
			else if(char == "(")
				parenCount -= 1
			else if(char == ")")
				parenCount += 1
			endif
			"
			if(parenCount == -1)
				return([s:getLastIdentifier(strpart(a:lineStr, 0, col)), argCount])
			endif
			"
			col -= 1
		endwhile
		col -= 1
	endwhile
endfunction




function s:cc_getValue(matchStr, target)
	return(substitute(matchStr, "\'" . target . "\': \'\(.*\)\'", '\1'))
endfunction
function s:cc_getType(matchStr)
	return(substitute(matchStr, "\'menu\': \'\(.*\) ", '\1'))
endfunction




"returns a list of 
function s:ClangCompleteMatch()
	let id = s:getLastIdentifier(strpart(a:lineStr, 0, col(".")))
	if(id == "")
		return(s:ClangMatchParam())
	else
		return(s:ClangMatchId(id))
	endif
endfunction

"return matches for a function based on the parameter list
function s:ClangMatchParam()
	funcInfo = s:getContainingFunction()
	funcId = funcInfo[0]
	paramNum = funcInfo[1]
endfunction

"match an identifier without a parameter list
"it might be a function or a variable
function s:ClangMatchId(id)
	let matches = ClangComplete(0, id)
	let i = 0
	while(i < len(matches))
		let match = matches[i]
		let kind = 
	endwhile
endfunction



























