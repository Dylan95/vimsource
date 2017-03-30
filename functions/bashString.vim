

"returns str encoded in such a way that it can be passed as a command line argument using bash.
"bash uses the quote character for strings:
"	'
"and there is no escape character for the quote character.  So you can't pass that
"character itself in an argument to a command.
"
"this function changes the string in the following ways:
"1. ' becomes \Q
"2.	\ becomes \\
"function DCG_bashString_encode(str)
"endfunction


"function DCG_bashStringArg(str)
	""let l:str = a:str
	""let l:str = substitute(l:str, "\\", "\\\\", "g")
	""let l:str = substitute(l:str, "\n", "\\n", "g")
	""let l:str = substitute(l:str, "'", "\\'", "g")
	""return("$'" . l:str . "'")
	""
	"return(shellescape(a:str))
"endfunction





