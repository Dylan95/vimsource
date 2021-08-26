
"makes the cursor jump over tabs like in a normal text editor, becuase
"the way that vim does it by default is: "---|-", "----|"
"that drives me BATSHIT CRAZY!! and the listchars solution requires
"setting list, which disables linebreak from working.  
"And linebreak is really usefull.


let g:DCG_lastVirtCol = 1
let g:DCG_lastLine = 1


function DCG_tabMod()
	return((virtcol(".") - 1) % &tabstop)
endfunction

function DCG_tabRound()
	let mod = ((g:DCG_lastVirtCol - 1) % &tabstop)
	"echo col(".")
	"echo "mod " . mod
	if (mod < (&tabstop / 2))
		call cursor(line("."), col("."))
	else
		"echo "go right"
		call cursor(line("."), col(".") + 1)
	endif
endfunction

function DCG_tabLeft()
	let mod = DCG_tabMod()
	if (mod != 0)
		call cursor(line("."), col("."))
	endif
endfunction

function DCG_tabRight()
	let mod = DCG_tabMod()
	if (mod != 0)
		call cursor(line("."), col(".") + 1)
	endif
endfunction

function DCG_prettyTabs()
	let curr = getline(".")[col(".")-1]
	let b_tab = (curr == "\t")
	"
	"echo "real:(" . col('.') . " " . line('.') . ") b_tab:(" . b_tab . ") virtual:(" . virtcol(".") . ") last:(" . g:DCG_lastVirtCol . ")"
	"
	if &virtualedit == "all"
		if b_tab
			if(g:DCG_lastVirtCol < virtcol("."))
				call DCG_tabRight()
			else
				call DCG_tabLeft()
			endif
		else
			set virtualedit=onemore
			"if(getline(".")[col(".")-2] == "\t")
			if(col(".") == strlen(getline(".")))
				if(getline(".")[col(".")-2] == "\t")
					if(getline(".")[col(".")-1] == "\t")
						"echo "should jump"
						call cursor(line("."), col(".") + 1)
					endif
				endif
			endif
		endif
	else
		"the initial snap to a tab
		if b_tab
			set virtualedit=all
			if (line(".") != g:DCG_lastLine)
				call DCG_tabRound()
			endif
		endif
	endif
	"
	let g:DCG_lastVirtCol = virtcol(".")
	let g:DCG_lastLine = line(".")
endfunction

autocmd CursorMoved * :call DCG_prettyTabs()
autocmd BufEnter * :let g:DCG_lastVirtCol = virtcol(".")













