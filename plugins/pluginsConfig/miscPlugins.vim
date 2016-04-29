"plugins config


"nerdtree
map <C-n> :NERDTreeToggle<CR>"
"
"changing the default mappings
"note: the mapping depends on whatever nerdtree decides
"to name the buffer it opens.  So it may not work depending 
"on the version.
"note: nerdtree#ui_glue#invokeKeyMap does a nerdtree action
"autocmd FileType nerdtree nmap <buffer> i :call nerdtree#ui_glue#invokeKeyMap("\<C-k\>")<CR>
"autocmd FileType nerdtree nmap <buffer> k :exec nerdtree#ui_glue#invokeKeyMap("<C-j>")<CR>
"autocmd FileType nerdtree nmap <buffer> j :exec nerdtree#ui_glue#invokeKeyMap("o")<CR>
"autocmd FileType nerdtree nmap <buffer> l :exec nerdtree#ui_glue#invokeKeyMap("o")<CR>
"
function DCG_NerdTreeAuto()
	"unmapping: making nerdtree less powerfull
	"call DisableKeys("n", "s", "e", "p")
	nnoremap <buffer> o <NOP>
	nnoremap <buffer> go <NOP>
	nnoremap <buffer> T <NOP>
	nnoremap <buffer> i <NOP>
	nnoremap <buffer> gi <NOP>
	nnoremap <buffer> s <NOP>
	nnoremap <buffer> gs <NOP>
	nnoremap <buffer> o <NOP>
	nnoremap <buffer> O <NOP>
	nnoremap <buffer> x <NOP>
	nnoremap <buffer> X <NOP>
	nnoremap <buffer> e <NOP>
	nnoremap <buffer> C <NOP>
	nnoremap <buffer> u <NOP>
	nnoremap <buffer> U <NOP>
	nnoremap <buffer> r <NOP>
	nnoremap <buffer> R <NOP>
	nnoremap <buffer> m <NOP>
	nnoremap <buffer> cd <NOP>
	nnoremap <buffer> CD <NOP>
	nnoremap <buffer> I <NOP>
	nnoremap <buffer> f <NOP>
	nnoremap <buffer> F <NOP>
	nnoremap <buffer> B <NOP>
	nnoremap <buffer> A <NOP>
	"new mappings
	"movement:
	nnoremap <buffer> I :call nerdtree#ui_glue#invokeKeyMap("\<C-k\>")<CR>
	nnoremap <buffer> K :call nerdtree#ui_glue#invokeKeyMap("\<C-j\>")<CR>
	nnoremap <buffer> i k
	nnoremap <buffer> k j
	nnoremap <buffer> l :call nerdtree#ui_glue#invokeKeyMap("o")<CR>
	nnoremap <buffer> j :call nerdtree#ui_glue#invokeKeyMap("o")<CR>
	"filesystem
	nnoremap <buffer> <A-i> :call nerdtree#ui_glue#invokeKeyMap("u")<CR>
	nnoremap <buffer> <A-k> :call nerdtree#ui_glue#invokeKeyMap("C")<CR>
	nnoremap <buffer> <C-r> :call nerdtree#ui_glue#invokeKeyMap("r")<CR>
	"filtering
	"for hidden files, cause I'm used to ubuntu's nautilus
	nnoremap <buffer> <C-h> :call nerdtree#ui_glue#invokeKeyMap("I")<CR>
endfunction
"
autocmd FileType nerdtree :call DCG_NerdTreeAuto()



"mkview, sometimes it will cause an error if you close a 
"buffer and others are open, but don't worry about it.
"
"autocmd BufWinLeave ?* silent mkview
"autocmd BufWinEnter ?* silent loadview


"easygrep
nnoremap <C-f> :Grep
nnoremap <C-h> :Replace



"vim-localvimrc
let g:localvimrc_name = ".lvimrc"
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0



"ctrlp
"nnoremap <F2> :call s:PrtClearCache()<Esc>








