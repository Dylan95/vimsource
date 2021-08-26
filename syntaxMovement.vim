

let s:group_ancestor = "group_ancestor"
let s:group_current = "group_current"
let s:group_siblings = "group_siblings"
let s:group_siblingStarts = "group_siblingStarts"
let s:group_errors = "group_errors"
let s:group_errorsStarts = "group_errorsStarts"
"
let s:matchNone = "/\%0l/"

let s:infoBuffer = "syntaxMovementInfoBuffer"


	
	
function DCG_matchRange(startLine, startCol, endLine, endCol)
	let l:startColInclude = a:startCol-1
	let l:endColInclude = a:endCol+1
	"
	if(a:startLine == a:endLine)
		return("\\%>" . l:startColInclude . "c" . "\\%<" . l:endColInclude . "c" . "\\%" . a:startLine . "l")
	else
		let l:afterStartLine = "\\%>" . a:startLine . "l"
		let l:beforeEndLine = "\\%<" . a:endLine . "l"
		let l:afterStartColOnStartLine = "\\%>" . l:startColInclude . "c" . "\\%" . a:startLine . "l"
		let l:beforeEndColOnEndLine = "\\%<" . l:endColInclude . "c" . "\\%" . a:endLine . "l"
		return((l:afterStartLine . "\\&" . l:beforeEndLine) . "\\|" . l:afterStartColOnStartLine . "\\|" . l:beforeEndColOnEndLine)
	endif
endfunction

function DCG_matchPosition(line, col)
	"return("\\%" . a:col . "c" . "\\%" . a:line)
	return(DCG_matchRange(a:line, a:col, a:line, a:col))
endfunction


"open the info buffer in the current window.
function DCG_treeOpenInfoBuffer()
	if(DCG_BuffExists(s:infoBuffer))
		call DCG_JumpToBuff(s:infoBuffer)
	else
		exec "file " . s:infoBuffer
	endif
endfunction


"function DCG_getData()
	"let l:jsonStr = ExecReturn(s:program . " " . DCG_bashStringArg(DCG_bufferToString()) . " " . line(".") . " " . col("."))
	"let s:syntaxData = json_decode(l:jsonStr)
	"call s:setGroup(s:group_current, s:nodePattern(s:syntaxData["current"]))
	""call s:setGroup(s:group_ancestor, s:nodePattern(s:syntaxData["ancestor"]))
	""call s:setGroup(s:group_siblings, s:siblingsPattern())
"endfunction

function s:siblingsPattern()
	let l:result = ""
	let l:allSiblings = s:syntaxData["left"] + s:syntaxData["right"]
	for node in l:allSiblings
		let l:result = l:result . s:nodePattern(node) . "\|"
	endfor
	"if(l:result != "")
	"	let l:result = strpart(l:result, 0, len(l:result - 2))
	"endif
	return(l:result)
endfunction
	
"function DCG_matchRange(start, end)
"	return(DCG_matchRange(start["line"], start["col"], end["line"], end["col"]))
"endfunction

function s:nodePattern(syntaxNode)
	return(DCG_matchRange(a:syntaxNode["start"]["line"], a:syntaxNode["start"]["col"], a:syntaxNode["end"]["line"], a:syntaxNode["end"]["col"] - 1))
endfunction
function s:nodePatternStart(syntaxNode)
	return(DCG_matchPosition(a:syntaxNode["start"]["line"], a:syntaxNode["start"]["col"]))
endfunction
function s:nodePatternAfterStart(syntaxNode)
	return(DCG_matchRange(a:syntaxNode["start"]["line"], a:syntaxNode["start"]["col"] + 1, a:syntaxNode["end"]["line"], a:syntaxNode["end"]["col"] - 1))
endfunction

function s:nodeListPattern(syntaxNodeList)
	let l:patterns = []
	for syntaxNode in a:syntaxNodeList
		let l:patt = s:nodePattern(syntaxNode)
		call add(l:patterns, l:patt)
		"call add(l:patterns, s:nodePattern(a:syntaxNode))
	endfor
	return(join(l:patterns, "|"))
endfunction

function s:setGroup(groupName, pattern)
	let l:deliminatedPattern = "/" . a:pattern . "/"
	exec "match " . a:groupName . " " . l:deliminatedPattern
endfunction
function s:addToGroup(groupName, pattern)
	call matchadd(a:groupName, a:pattern)
	"exec "matchadd " . a:groupName . " " . a:pattern
endfunction

function s:initializeGroup(groupName, color)
	silent exec "highlight " . a:groupName . " ctermbg=" . a:color
endfunction

function s:clearGroup(groupName)
	call s:setGroup(a:groupName, s:matchNone)
endfunction



"intialize groups
call s:initializeGroup(s:group_ancestor, "darkred")
call s:initializeGroup(s:group_current, "blue")
call s:initializeGroup(s:group_siblings, "black")
call s:initializeGroup(s:group_siblingStarts, "green")
call s:initializeGroup(s:group_errors, "yellow")
call s:initializeGroup(s:group_errorsStarts, "white")



function s:isNull(jsonNode)
	return(type(a:jsonNode) == 7)
endfunction
	
function DCG_setView(viewJson)
	"echo a:viewJson
	let l:view = json_decode(a:viewJson)
	let l:current = l:view["current"]
	let l:resolveInfo = l:view["resolveInfo"]
	let l:siblings = l:view["siblings"]
	let l:errors = l:view["errors"]
	let l:pruners = l:view["pruners"]
	let l:childInfoList = l:view["childInfoList"]
	"
	call clearmatches()
	"
	if(!s:isNull(l:current))
		let l:cursorPos = l:current["start"]
		call cursor(l:cursorPos["line"], l:cursorPos["col"])
		call s:setGroup(s:group_current, s:nodePattern(l:current))
	endif
	"if(!s:isNull(l:ancestor))
		"call s:setGroup(s:group_ancestor, s:nodePattern(l:ancestor))
	"endif
	if(l:siblings != [])
		for sibling in l:siblings
			call s:addToGroup(s:group_siblings, s:nodePatternAfterStart(sibling))
			call s:addToGroup(s:group_siblingStarts, s:nodePatternStart(sibling))
		endfor
	endif
	"
	let l:errorInfoString = "errors:\n"
	if(l:errors != [])
		for error in l:errors
			"call s:addToGroup(s:group_errors, s:nodePatternAfterStart(error))
			call s:addToGroup(s:group_errorsStarts, s:nodePatternStart(error))
			let l:errorInfoString = l:errorInfoString . "type: " . error["type"] . ", message: " . error["message"] 
		endfor
	endif
	if(bufloaded(bufname(s:infoBuffer)))
		let l:childInfoString = ""
		for childInfo in childInfoList
			if(childInfo["isCurrent"])
				let l:childInfoString = l:childInfoString . "-> "
			else
				let l:childInfoString = l:childInfoString . "   "
			endif
			let l:childInfoString = l:childInfoString . childInfo["role"] . "\n"
		endfor
		let l:prunerInfoString = ""
		for pruner in pruners
			if(childInfo["isCurrent"])
				let l:prunerInfoString = l:prunerInfoString . "-> "
			else
				let l:prunerInfoString = l:prunerInfoString . "   "
			endif
			let l:prunerInfoString = l:prunerInfoString . pruner["name"] . "\n"
		endfor
		"echo l:childInfoList
		let l:memberInfo = ""
		if(!s:isNull(l:resolveInfo)) 
			let l:memberInfo = l:resolveInfo["member"]
		endif
		"echo l:memberInfo
		call DCG_SetBuffer(s:infoBuffer, l:childInfoString . "\n" . l:errorInfoString . "\n" . l:prunerInfoString . "\nresolveInfo: " . l:memberInfo)
	endif
endfunction

function s:action(methodName, args)
	call DCG_setView(json_decode(DCG_cstreeRMI(a:methodName, a:args))["args"][0])
	"echo DCG_cstreeRMI(a:methodName, a:args)
endfunction

function DCG_treeInitProject()
	call s:action("initProject", [])
endfunction
function DCG_treeUpdateText()
	call s:action("updateCurrentFile", [DCG_bufferToString()])
endfunction

function DCG_treeOpenFile()
	let l:path = expand("%:p")
	"exec "!echo " . l:path
	"call s:action("openFile", [l:path])
endfunction
autocmd BufReadPre * :call DCG_treeOpenFile()

function DCG_treeCloseFile()
	let l:path = expand("%:p")
	"exec "!echo " . l:path
	"call s:action("closeFile", [l:path])
endfunction
autocmd BufDelete * :call DCG_treeCloseFile()

function DCG_treeGoToNodeAtPosition()
	call s:action("selectNodeAt", [line("."), col(".")])
endfunction
function DCG_treeMoveLeft()
	call s:action("moveLeft", ["1"])
endfunction
function DCG_treeMoveRight()
	call s:action("moveRight", ["1"])
endfunction
function DCG_treeMoveFarLeft()
	call s:action("moveFarLeft", [])
endfunction
function DCG_treeMoveFarRight()
	call s:action("moveFarRight", [])
endfunction
function DCG_treeAscend()
	call s:action("ascend", [])
endfunction
function DCG_treeDescend()
	call s:action("descend", [])
endfunction
"function DCG_treeUpdateView()
"	call s:action("updateView")
"endfunction
function DCG_treeQuit()
	call s:action("quit", [])
endfunction



nnoremap <leader>to :call DCG_treeOpenInfoBuffer()<CR>

nnoremap <leader>ti :call DCG_initProject()<CR>

nnoremap <leader>tu :call DCG_treeUpdateText()<CR>

nnoremap <leader>tg :call DCG_treeGoToNodeAtPosition()<CR>
nnoremap <A-i> :call DCG_treeAscend()<CR>
nnoremap <A-k> :call DCG_treeDescend()<CR>
nnoremap <A-j> :call DCG_treeMoveLeft()<CR>
nnoremap <A-l> :call DCG_treeMoveRight()<CR>


"nnoremap <leader>tp :call DCG_treeSetProject()<CR>
"nnoremap <leader>tf :call DCG_treeSetFile()<CR>




















"	
"	
""nnoremap <leader>tu :call DCG_treeUpdateText()<CR>
""nnoremap <leader>tg :call DCG_treeGoToNodeAtPosition()<CR>
""nnoremap <leader>ti :call DCG_treeAscend()<CR>
""nnoremap <leader>tk :call DCG_treeDescend()<CR>
""
""nnoremap <leader>tml :call DCG_treeMoveLeft()<CR>
""nnoremap <leader>tmr :call DCG_treeMoveRight()<CR>
""nnoremap <leader>tmb :call DCG_treeMoveFarLeft()<CR>
""nnoremap <leader>tme :call DCG_treeMoveFarRight()<CR>
""
""nnoremap <leader>to :call DCG_treeOpenInfoBuffer()<CR>
"
"
"nnoremap <leader>ts :call DCG_runServer()<CR>
"
"call DCG_waitingMap("n", "<leader>tu", "call DCG_treeUpdateText()")
""nnoremap <leader>tu :call DCG_treeUpdateText()<CR>
"
"nnoremap <leader>tg :call DCG_treeGoToNodeAtPosition()<CR>
"
"call DCG_waitingMap("n", "<A-i>", "call DCG_treeAscend()")
""nnoremap <A-i> :call DCG_treeAscend()<CR>
"call DCG_waitingMap("n", "<A-k>", "call DCG_treeDescend()")
""nnoremap <A-k> :call DCG_treeDescend()<CR>
"
"call DCG_waitingMap("n", "<A-j>", "call DCG_treeMoveLeft()")
""nnoremap <A-j> :call DCG_treeMoveLeft()<CR>
"call DCG_waitingMap("n", "<A-l>", "call DCG_treeMoveRight()")
""nnoremap <A-l> :call DCG_treeMoveRight()<CR>
"
""nnoremap <leader>tmb :call DCG_treeMoveFarLeft()<CR>
""nnoremap <leader>tme :call DCG_treeMoveFarRight()<CR>
"
"nnoremap <leader>to :call DCG_treeOpenInfoBuffer()<CR>
"







































"
"
"let s:matchNone = "/\%0l/"
"
""function DCG_matchRange(startLine, startCol, endLine, endCol)
	"""return("/\%<40l" + "\&" + "\%>17l" + "\|" + "\%>3/")
	"""return("/\%<40l\&\%>17l\|\%>3c\%14l\|\%<10c\%44l/")
	""let l:afterStartLine = "\%>" . a:startLine . "l"
	""let l:beforeEndLine = "\%<" . a:endLine . "l"
	""let l:afterStartColOnStartLine = "\%>" . a:startCol-1 . "c" . "\%" . a:startLine . "l"
	""let l:beforeEndColOnEndLine = "\%<" . a:endCol+1 . "c" . "\%" . a:endLine . "l"
	""return("/" . (l:afterStartLine . "\&" . l:beforeEndLine) . "\|" . l:afterStartColOnStartLine . "\|" . l:beforeEndColOnEndLine . "/")
""endfunction
""
""return("/\\%<40l\\&\\%>17l\\|\\%>3c\\%14l\\|\\%<10c\\%44l/")
"function DCG_matchRange(startLine, startCol, endLine, endCol)
	"let l:startColInclude = a:startCol-1
	"let l:endColInclude = a:endCol+1
	""
	"if(a:startLine == a:endLine)
"		"return("/" . "\\%>" . l:startColInclude . "c" . "\\%<" . l:endColInclude . "c" . "\\%" . a:startLine . "l" . "/")
"	"else
"		"let l:afterStartLine = "\\%>" . a:startLine . "l"
"		"let l:beforeEndLine = "\\%<" . a:endLine . "l"
"		"let l:afterStartColOnStartLine = "\\%>" . l:startColInclude . "c" . "\\%" . a:startLine . "l"
"		"let l:beforeEndColOnEndLine = "\\%<" . l:endColInclude . "c" . "\\%" . a:endLine . "l"
"		"return("/" . (l:afterStartLine . "\\&" . l:beforeEndLine) . "\\|" . l:afterStartColOnStartLine . "\\|" . l:beforeEndColOnEndLine . "/")
"	"endif
""endfunction
""
""
""
""let s:program = "~/cs_projects/projects/CSTree/CSTree/bin/Debug/CSTree.exe"
"""
""let s:syntaxData = {}
"""
""let s:group_ancestor = "group_ancestor"
""let s:group_current = "group_current"
""let s:group_siblings = "group_siblings"
""
""function DCG_getData()
"	"let l:filename = @%
"	"let l:jsonStr = ExecReturn(s:program . " " . l:filename . " " . line(".") . " " . col("."))
"	""echo l:jsonStr
"	""let s:data = json_decode(l:jsonStr)
"	""let l:temp = json_decode(l:jsonStrFoobar)
"	"let s:syntaxData = json_decode(l:jsonStr)
"	""let l:curr = s:syntaxData["current"]
"	"call s:setGroup(s:group_current, s:nodePattern(s:syntaxData["current"]))
"	""call s:setGroup(s:group_ancestor, s:nodePattern(s:syntaxData["ancestor"]))
"	""call s:setGroup(s:group_siblings, s:siblingsPattern())
""endfunction
"""function DCG_getData2()
"	""let l:jsonStr = ExecReturn(s:program . " " . expand('%:r') . " " . line(".") . " " . col("."))
"	""let s:data = json_decode(l:jsonStr)
"	""call s:setGroup(s:group_current, s:nodePattern(s:data["current"]))
"""endfunction
""function DCG_getData3()
"	"let l:jsonStr = ExecReturn(s:program . " " . expand('%:r') . " " . line(".") . " " . col("."))
"	"let s:data = json_decode(l:jsonStr)
"	"let l:pattern = s:nodePattern(s:data["current"])
"	"return l:pattern
"	""echo l:pattern
""endfunction
""
""function s:siblingsPattern()
"	"let l:result = ""
"	"let l:allSiblings = s:syntaxData["left"] + s:syntaxData["right"]
"	"for node in l:allSiblings
"		"let l:result = l:result . s:nodePattern(node) . "\|"
"	"endfor
"	"if(l:result != "")
"		"let l:result = strpart(l:result, 0, len(l:result - 2))
"	"endif
"	"return(l:result)
""endfunction
""
""function s:nodePattern(syntaxNode)
"	""echo DCG_matchRange(a:syntaxNode["start"]["line"], a:syntaxNode["start"]["col"], a:syntaxNode["end"]["line"], a:syntaxNode["end"]["col"])
"	"echo "ls " . a:syntaxNode["start"]["line"] . " cs " . a:syntaxNode["start"]["col"] . " le " . a:syntaxNode["end"]["line"] . " ce " . a:syntaxNode["end"]["col"]
"	"return(DCG_matchRange(a:syntaxNode["start"]["line"], a:syntaxNode["start"]["col"], a:syntaxNode["end"]["line"], a:syntaxNode["end"]["col"]))
""endfunction
""
""function s:setGroup(groupName, pattern)
"	""silent exec "normal! :" . "match " . a:groupName . " " . a:pattern . "<CR>"
"	"let l:command = "match " . a:groupName . " " . a:pattern
"	""echo l:command
"	"exec l:command
""endfunction
""
""function s:initializeGroup(groupName, color)
"	"silent exec "highlight " . a:groupName . " ctermbg=" . a:color
""endfunction
""
""function s:clearGroup(groupName)
"	"call setGroup(a:groupName, s:matchNone)
""endfunction
""
""
""
""
"""intialize groups
""call s:initializeGroup(s:group_ancestor, "darkred")
""call s:initializeGroup(s:group_current, "blue")
""call s:initializeGroup(s:group_siblings, "black")
""
"""highlight group_ancestor ctermbg=darkred
"""call s:initializeGroup(s:group_ancestor, "darkred")
"""call s:initializeGroup(s:group_current, "blue")
"""call s:initializeGroup(s:group_siblings, "black")
""
""
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
"
"
"
"
"
"
"
"
""
""function initSyntaxRegions(name)
""
""
""
""
""
""
""
""
""
""
""let s:data = None
""
"""let s:current = None
"""let s:ancestor_role = None
"""let s:lst_left = None
"""let s:lst_right = None
""
""
""function DCG_getData()
"	"let l:jsonStr = ExecReturn(expand('%:r'), line("."), col("."))
"	"let s:data = json_decode(l:jsonStr)
""endfunction
""
""
""function s:afterPosPatterm(line, col)
"	"call matchadd()
"	"call matchadd()
""endfunction
""
""
""function s:highlightSyntax(syntaxNode){
""	
""}
""
""
""function DCG_highlightCurrent(){
"	"call s:highlightSyntax(s:data["current"])
""}
"
"
"
""always clear before modifying syntax region 
"
"
"     "59  syntax region foobar5 start="\%23l" end="\%30l"
"     "61  hi foobar5 ctermbg=Black
"     "69  syntax clear foobar5
"     "59  syntax region foobar5 start="\%15l" end="\%30l"
"     "69  syntax clear foobar5
"
"
""
""syntax region foobar start="\%17l" end="\%19l"
"     "39  syntax region foobar start="\%17l" end="\%19l" ctermbg="blue"
"     "40  syntax region foobar start="\%18l" end="\%19l" ctermbg="blue"
"     "41  syntax region foobar start="\%18l" end="\%19l"
"     "42  syntax region foobar2 start="\%23l" end="\%25l"
"     "43  hi foobar2
"     "44  hi foobar2 ctermbg="red"
"     "45  hi foobar2 ctermbg=Blue
"     "46  syntax region foobar2 start="\%23l\%5c" end="\%28l\%7c"
"     "47  hi foobar2 ctermbg=Black
"     "48  syntax region foobar3 start="\%23l\%5c" end="\%28l\%7c"
"     "51  syntax region foobar3 start="\%23l\%5c" end="\%28l"
"     "53  syntax region foobar3 start="\%23l\%5v" end="\%28l"
"     "54  hi foobar3 ctermbg=Black
"     "55  syntax region foobar4 start="\%23l" end="\%28l"
"     "56  hi foobar4 ctermbg=Black
"     "57  syntax region foobar5 start="\%23l" end="\%29l"
"     "59  syntax region foobar5 start="\%23l" end="\%30l"
"     "61  hi foobar5 ctermbg=Black
"     "63  help group-name
"     "64  hi default link foobar5
"     "65  hi default link foobar5 Error
"     "66  noh
"     "67  h color
"     "68  h syn-clear
"     "69  syntax clear foobar5
"     "70  syntax clear foobar4
"     "71  syntax clear foobar3
"     "72  syntax clear foobar2
"     "73  syntax clear foobar1
"     "78  hi foobar6
"     "79  hi foobar5
"     "80  hi clear foobar5
"     "83  syntax reset
"     "84  e syntaxMovement.vim
"     "86  syntax region foobar5 start="\%23l\%1v" end="\%30l"
"     "87  hi foobar5 ctermbg=Blue
"     "88  syntax clear foobar
"     "89  hi foobar5 ctermbg=clear
"     "90  hi foobar5 ctermbg=Clear
"">    92  history
"
"
"
""
""let s:program = "~/cs_projects/projects/CSTree/CSTree/bin/Debug/CSTree.exe"
"""
""let s:syntaxData = {}
"""
""let s:group_ancestor = "group_ancestor"
""let s:group_current = "group_current"
""let s:group_siblings = "group_siblings"
"""
""let s:matchNone = "/\%0l/"
""
""
""
""function DCG_matchRange(startLine, startCol, endLine, endCol)
"	"let l:startColInclude = a:startCol-1
"	"let l:endColInclude = a:endCol+1
"	""
"	"if(a:startLine == a:endLine)
"		"return("/" . "\\%>" . l:startColInclude . "c" . "\\%<" . l:endColInclude . "c" . "\\%" . a:startLine . "l" . "/")
"	"else
"		"let l:afterStartLine = "\\%>" . a:startLine . "l"
"		"let l:beforeEndLine = "\\%<" . a:endLine . "l"
"		"let l:afterStartColOnStartLine = "\\%>" . l:startColInclude . "c" . "\\%" . a:startLine . "l"
"		"let l:beforeEndColOnEndLine = "\\%<" . l:endColInclude . "c" . "\\%" . a:endLine . "l"
"		"return("/" . (l:afterStartLine . "\\&" . l:beforeEndLine) . "\\|" . l:afterStartColOnStartLine . "\\|" . l:beforeEndColOnEndLine . "/")
"	"endif
""endfunction
""
""
""
""function DCG_getData()
"	""let l:filename = @%
"	""let l:jsonStr = ExecReturn(s:program . " " . l:filename . " " . line(".") . " " . col("."))
"	""echo DCG_bashStringArg(DCG_bufferToString())
"	"let l:jsonStr = ExecReturn(s:program . " " . DCG_bashStringArg(DCG_bufferToString()) . " " . line(".") . " " . col("."))
"	""echo l:jsonStr
"	"let s:syntaxData = json_decode(l:jsonStr)
"	"call s:setGroup(s:group_current, s:nodePattern(s:syntaxData["current"]))
"	""call s:setGroup(s:group_ancestor, s:nodePattern(s:syntaxData["ancestor"]))
"	""call s:setGroup(s:group_siblings, s:siblingsPattern())
""endfunction
""
""function s:siblingsPattern()
"	"let l:result = ""
"	"let l:allSiblings = s:syntaxData["left"] + s:syntaxData["right"]
"	"for node in l:allSiblings
"		"let l:result = l:result . s:nodePattern(node) . "\|"
"	"endfor
"	"if(l:result != "")
"		"let l:result = strpart(l:result, 0, len(l:result - 2))
"	"endif
"	"return(l:result)
""endfunction
""
""function s:nodePattern(syntaxNode)
"	"return(DCG_matchRange(a:syntaxNode["start"]["line"], a:syntaxNode["start"]["col"], a:syntaxNode["end"]["line"], a:syntaxNode["end"]["col"]))
""endfunction
""
""function s:setGroup(groupName, pattern)
"	"exec "match " . a:groupName . " " . a:pattern
""endfunction
""
""function s:initializeGroup(groupName, color)
"	"silent exec "highlight " . a:groupName . " ctermbg=" . a:color
""endfunction
""
""function s:clearGroup(groupName)
"	"call setGroup(a:groupName, s:matchNone)
""endfunction
""
""
""
"""intialize groups
""call s:initializeGroup(s:group_ancestor, "darkred")
""call s:initializeGroup(s:group_current, "blue")
""call s:initializeGroup(s:group_siblings, "black")
""
""
"let s:program = "~/cs_projects/projects/old3/CSTree_Client/CSTree_Client/bin/Debug/CSTree_Client.exe"
""
"let s:group_ancestor = "group_ancestor"
"let s:group_current = "group_current"
"let s:group_siblings = "group_siblings"
"let s:group_siblingStarts = "group_siblingStarts"
""
"let s:matchNone = "/\%0l/"
"
"let s:infoBuffer = "syntaxMovementInfoBuffer"
"
"
"function DCG_matchRange(startLine, startCol, endLine, endCol)
"	let l:startColInclude = a:startCol-1
"	let l:endColInclude = a:endCol+1
"	"
"	if(a:startLine == a:endLine)
"		return("\\%>" . l:startColInclude . "c" . "\\%<" . l:endColInclude . "c" . "\\%" . a:startLine . "l")
"	else
"		let l:afterStartLine = "\\%>" . a:startLine . "l"
"		let l:beforeEndLine = "\\%<" . a:endLine . "l"
"		let l:afterStartColOnStartLine = "\\%>" . l:startColInclude . "c" . "\\%" . a:startLine . "l"
"		let l:beforeEndColOnEndLine = "\\%<" . l:endColInclude . "c" . "\\%" . a:endLine . "l"
"		return((l:afterStartLine . "\\&" . l:beforeEndLine) . "\\|" . l:afterStartColOnStartLine . "\\|" . l:beforeEndColOnEndLine)
"	endif
"endfunction
"
"function DCG_matchPosition(line, col)
"	"return("\\%" . a:col . "c" . "\\%" . a:line)
"	return(DCG_matchRange(a:line, a:col, a:line, a:col))
"endfunction
"
"
""open the info buffer in the current window.
"function DCG_treeOpenInfoBuffer()
"	if(DCG_BuffExists(s:infoBuffer)):
"		call DCG_JumpToBuff(s:infoBuffer)
"	else:
"		exec "normal! :" . "file " . s:infoBuffer
"	endif
"endfunction
"
"
""function DCG_getData()
"	"let l:jsonStr = ExecReturn(s:program . " " . DCG_bashStringArg(DCG_bufferToString()) . " " . line(".") . " " . col("."))
"	"let s:syntaxData = json_decode(l:jsonStr)
"	"call s:setGroup(s:group_current, s:nodePattern(s:syntaxData["current"]))
"	""call s:setGroup(s:group_ancestor, s:nodePattern(s:syntaxData["ancestor"]))
"	""call s:setGroup(s:group_siblings, s:siblingsPattern())
""endfunction
"
"function s:siblingsPattern()
"	let l:result = ""
"	let l:allSiblings = s:syntaxData["left"] + s:syntaxData["right"]
"	for node in l:allSiblings
"		let l:result = l:result . s:nodePattern(node) . "\|"
"	endfor
"	"if(l:result != "")
"	"	let l:result = strpart(l:result, 0, len(l:result - 2))
"	"endif
"	return(l:result)
"endfunction
"
"function s:nodePattern(syntaxNode)
"	return(DCG_matchRange(a:syntaxNode["start"]["line"], a:syntaxNode["start"]["col"], a:syntaxNode["end"]["line"], a:syntaxNode["end"]["col"] - 1))
"endfunction
"function s:nodePatternStart(syntaxNode)
"	return(DCG_matchPosition(a:syntaxNode["start"]["line"], a:syntaxNode["start"]["col"]))
"endfunction
"function s:nodePatternAfterStart(syntaxNode)
"	return(DCG_matchRange(a:syntaxNode["start"]["line"], a:syntaxNode["start"]["col"] + 1, a:syntaxNode["end"]["line"], a:syntaxNode["end"]["col"] - 1))
"endfunction
"
"function s:nodeListPattern(syntaxNodeList)
"	let l:patterns = []
"	for syntaxNode in a:syntaxNodeList
"		let l:patt = s:nodePattern(syntaxNode)
"		call add(l:patterns, l:patt)
"		"call add(l:patterns, s:nodePattern(a:syntaxNode))
"	endfor
"	return(join(l:patterns, "|"))
"endfunction
"
"function s:setGroup(groupName, pattern)
"	let l:deliminatedPattern = "/" . a:pattern . "/"
"	exec "match " . a:groupName . " " . l:deliminatedPattern
"endfunction
"function s:addToGroup(groupName, pattern)
"	call matchadd(a:groupName, a:pattern)
"	"exec "matchadd " . a:groupName . " " . a:pattern
"endfunction
"
"function s:initializeGroup(groupName, color)
"	silent exec "highlight " . a:groupName . " ctermbg=" . a:color
"endfunction
"
"function s:clearGroup(groupName)
"	call s:setGroup(a:groupName, s:matchNone)
"endfunction
"
"
"
""intialize groups
"call s:initializeGroup(s:group_ancestor, "darkred")
"call s:initializeGroup(s:group_current, "blue")
"call s:initializeGroup(s:group_siblings, "black")
"call s:initializeGroup(s:group_siblingStarts, "green")
"
"
"
"function s:isNull(jsonNode)
"	return(type(a:jsonNode) == 7)
"endfunction
"	
"function DCG_setView(viewJson)
"	"echo a:viewJson
"	let l:view = json_decode(a:viewJson)
"	let l:current = l:view["current"]
"	let l:ancestor = l:view["ancestor"]
"	let l:siblings = l:view["siblings"]
"	let l:childInfoList = l:view["childInfoList"]
"	"echo l:current
"	"echo type(l:current)
"	"
"	call clearmatches()
"	"
"	if(!s:isNull(l:current))
"		let l:cursorPos = l:current["start"]
"		call cursor(l:cursorPos["line"], l:cursorPos["col"])
"		call s:setGroup(s:group_current, s:nodePattern(l:current))
"	endif
"	if(!s:isNull(l:ancestor))
"		"call s:setGroup(s:group_ancestor, s:nodePattern(l:ancestor))
"	endif
"	if(l:siblings != [])
"		"call s:clearGroup(s:group_siblings)
"		"call s:setGroup(s:group_siblings, s:matchNone)
"		"
"		"call s:setGroup(s:group_siblings, s:nodePattern(l:siblings[4]))
"		"
"		for sibling in l:siblings
"			"call s:addToGroup(s:group_siblings, s:nodePattern(sibling))
"			"
"			call s:addToGroup(s:group_siblings, s:nodePatternAfterStart(sibling))
"			call s:addToGroup(s:group_siblingStarts, s:nodePatternStart(sibling))
"			"
"			"call matchadd(s:group_siblings, s:nodePattern(sibling))
"			"call matchadd(s:group_siblings, s:nodePattern(sibling))
"		endfor
"		"
"		"call s:setGroup(s:group_siblings, s:nodeListPattern(l:siblings))
"		"echo s:nodeListPattern(l:siblings)
"		"echo l:siblings[0]
"		"echo s:nodePattern(l:siblings[0])
"		"let l:sib = l:siblings[0]
"		"call s:setGroup(s:group_siblings, s:nodePattern(l:sib));
"		"call s:setGroup(s:group_siblings, s:nodePattern(l:sib))
"	endif
"	if(DCG_BuffExists(s:infoBuffer))
"		childInfoString = ""
"		for childInfo in childInfoList
"			if(childInfo["isCurrent"])
"				childInfoString = childInfoString . "-> "
"			else
"				childInfoString = childInfoString . "   "
"			endif
"			childInfoString = childInfoString . childInfo["role"] . "\n"
"		endfor
"		call DCG_SetBuffer(s:infoBuffer, childInfoString)
"	endif
"	"echo s:nodeListPattern(s:siblings)
"	"if(s:current != v:null)
"	"	echo "aaaaaaaaaaaaaaaaaaa"
"	"endif
"	"echo s:current
"	"call DCG_setGroup(s:group_current, s:nodePattern(s:view["current"]))
"endfunction
"function DCG_actionArg(methodName, message)
"	call DCG_setView(ExecReturn(s:program . " " . a:methodName . " " . DCG_bashStringArg(a:message)))
"endfunction
"function DCG_action(methodName)
"	call DCG_setView(ExecReturn(s:program . " " . a:methodName))
"endfunction
"
"function DCG_treeUpdateText()
"	call DCG_actionArg("UpdateText", DCG_bufferToString())
"endfunction
"function DCG_treeGoToNodeAtPosition()
"	call DCG_actionArg("GoToNodeAtPosition", json_encode({'line':line("."), 'col':col(".")}))
"endfunction
"function DCG_treeMove()
"	call DCG_actionArg("Move", "0")
"endfunction
"function DCG_treeAscend()
"	call DCG_action("Ascend")
"endfunction
"function DCG_treeDescend()
"	call DCG_action("Descend")
"endfunction
"function DCG_treeUpdateView()
"	call DCG_action("UpdateView")
"endfunction
"function DCG_treeQuit()
"	call DCG_action("Quit")
"endfunction
"
"nnoremap <leater>tu :call DCG_treeUpdateText()
"nnoremap <leater>tg :call DCG_treeGoToNodeAtPosition()
"nnoremap <leater>tm :call DCG_treeMove()
"nnoremap <leater>ti :call DCG_treeAscend()
"nnoremap <leater>tk :call DCG_treeDescend()
"
"nnoremap <leater>to :call DCG_treeOpenInfoBuffer()



