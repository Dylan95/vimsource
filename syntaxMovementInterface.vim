

"let s:pipesDir = "/tmp/cstree/"
let s:pipeIn = ""
let s:pipeOut = ""

"let s:directProtocol = "protocol=direct"
"let s:prefixProtocol = "protocol=prefix"

let s:server = "/home/dylan/cs_projects/projects/CSTree/CSTree_Server/CSTree_Server/bin/Debug/CSTree_Server.exe"
let s:serverSpawner = "/home/dylan/cs_projects/projects/CSTree/ServerSpawner/ServerSpawner/bin/Debug/ServerSpawner.exe"
let s:client = "/home/dylan/cs_projects/projects/CSTree/CSTree_Client/CSTree_Client/bin/Debug/CSTree_Client.exe"
let s:recieveProg = "/home/dylan/cs_projects/projects/CSTree/CSTree_Client_recieveString/dcg_build_system/build/DEBUG/bin/program.exc"

function s:startServer()
	let l:pipesJson = system(s:serverSpawner . " " . shellescape(s:server))
	let l:pipesDict = json_decode(l:pipesJson)
	let s:pipeIn = l:pipesDict["pipeInPath"]
	let s:pipeOut = l:pipesDict["pipeOutPath"]
endfunction
function s:startServer_debug()
	let s:pipeIn = "/tmp/lineIn.pipe"
	let s:pipeOut = "/tmp/lineOut.pipe"
endfunction
"call s:startServer()
call s:startServer_debug()

function s:leave()
	call DCG_cstreeRMI("exit")
endfunction
autocmd VimLeave :call s:leave() 

let g:DCG_syntaxMovement_useCS = 0

"should work on all systems
"function s:cstree_client_string(str)
	""todo: fix0
	"let l:setContext = DCG_bashStringArg("setCD") . " " . DCG_bashStringArg(getcwd()) . " " . DCG_bashStringArg("setCurrentFile") . " " . DCG_bashStringArg(expand("%:p"))
	"return(ExecReturn(s:client . " " . s:pipeIn . " " . s:pipeOut . " " . a:str))
"endfunction
"function s:cstree_client(methodName)
	"return(s:cstree_client_string(DCG_bashStringArg(a:methodName)))
"endfunction
"function s:cstree_client2(methodName, arg)
	""echo a:arg
	"return(s:cstree_client_string(DCG_bashStringArg(a:methodName) . " " . DCG_bashStringArg(a:arg)))
"endfunction

function s:formatString(str)
	return(string(strlen(a:str)) . " " . a:str)
endfunction
function s:formatRMI(methodName, args)
	return(json_encode({"methodName": a:methodName, "args": a:args}))
endfunction
function s:formatRMIString(methodName, args)
	return(s:formatString(s:formatRMI(a:methodName, a:args)))
endfunction

function s:spinlock_get(filename)
	return("until lockfile " . a:filename . ".lock; do sleep 0.001; done")
endfunction
function s:spinlock_release(filename)
	return("rm -f " . a:filename . ".lock")
endfunction

"faster but less portable
function s:cstree_recieveProg(methodName, args)
	let l:setContext = s:formatRMIString("setCD", [getcwd()]) . s:formatRMIString("setCurrentFile", [expand("%:p")])
	let l:rmi = s:formatRMIString(a:methodName, a:args)
	let l:message = shellescape(l:setContext . l:rmi . s:formatRMIString("updateView", []))
	let l:sendMessage = "echo " . l:message . " > " . s:pipeIn
	let l:recieveMessage = s:recieveProg . " " . s:pipeOut
	"
	"exec "!echo " . l:sendMessage
	"exec "!echo " . s:pipeOut
	"exec "!echo " . DCG_bashStringArg(l:message)
	"
	"warning: doesn't lock recources.  Race condition.  Todo: fix.
	"return(ExecReturn(l:sendMessage . " && " . s:recieveProg))
	"
	"locks the pipes so there's no race condition.
	"return(ExecReturn(s:spinlock_get(s:pipeIn) . " ; " . s:spinlock_get(s:pipeOut) . " ; " . l:sendMessage . " ; " . s:recieveProg . " ; " . s:spinlock_release(s:pipeIn) . " ; " . s:spinlock_release(s:pipeOut)))
	"temporary, to make debugging easier
	"return(l:sendMessage . " && " . l:recieveMessage)
	return(ExecReturn(l:sendMessage . " && " . l:recieveMessage))
	"return(ExecReturn(l:sendMessage . " && " . "sleep 1" . " && " . "cat " . s:pipeOut))
	"return(l:sendMessage)
	"return("echo " . DCG_bashStringArg(l:setContext . l:rmi . s:formatRMIString("updateView", [])) . " > " . s:pipeIn)
endfunction


function DCG_cstreeRMI(methodName, args)
	"if(g:DCG_syntaxMovement_useCS == 1)
		"return(s:cstree_client(a:methodName))
	"else
		return(s:cstree_recieveProg(a:methodName, a:args))
	"endif
endfunction








































"
"function DCG_cstreeRMI(methodName, args)
	"if(s:serverRunning == 1)
		""if(g:DCG_syntaxMovement_useCS == 1)
			""return(s:cstree_client(a:methodName))
		""else
			"return(s:cstree_recieveProg(a:methodName, a:args))
		""endif
	"endif
"endfunction
"
""function s:getProtocol()
	""if(g:DCG_syntaxMovement_useCS == 0)
		""return(s:prefixProtocol)
	""else
		""return(s:directProtocol)
	""endif
""endfunction
"function DCG_cstree_runServer()
	""exec "!" . "gnome-terminal -x " . s:server . " " . s:getProtocol() . " " . s:pipeIn . " " . s:pipeOut
	""echo "!" . "gnome-terminal -x " . s:server . " " . s:getProtocol() . " " . s:pipeIn . " " . s:pipeOut
"endfunction
"



