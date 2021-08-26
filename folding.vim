"folding

"function SwapFoldMode()	
"	if &foldmethod=='manual'
"		set foldmethod=syntax
"		echo "syntax fold mode"
"	else
"		set foldmethod=manual
"		echo "manual fold mode"
"	endif
"endfunction

function SwapFoldCol()
	if &foldcolumn==1
		set foldcolumn=0
	else
		set foldcolumn=1
	endif
endfunction

call Map_select(',<Space>', 'za', 'n', 'v') 
"close all folds
nnoremap zc zm


nnoremap <A-z> :call SwapFoldCol()<CR>


"set foldcolumn=1
"set foldmethod=manual


