
"add to this array to register new callback functions
let g:DCG_pulseEvents = []

set updatetime=1000

function DCG_pulse()
	"
	"exec '!echo ' . localtime() . ' >> testfile.txt'
	"echo localtime()
	for event in g:DCG_pulseEvents
		call function(event)()
	endfor
	"
	call feedkeys('f\e', 'n')
endfunction

"autocmd CursorHold * call DCG_pulse()
