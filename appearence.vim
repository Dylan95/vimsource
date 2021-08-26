
"as of this version of vim (7.4), setting listchars makes it impossible to use 
"line breaks, so I'm not using listchars.
"set list lcs=tab:\ \ 
				
set cursorline
hi CursorLine term=bold cterm=bold ctermbg=DarkGrey
"hi CursorLine cterm=NONE ctermbg=white ctermfg=white guibg=darkred guifg=white
"nnoremap <leader>l :set cursorline!
"autocmd InsertEnter * highlight CursorLine guibg=#000050 guifg=fg
"autocmd InsertLeave * highlight CursorLine guibg=#ff0000 guifg=fg
"
"set cursorcolumn
"autocmd InsertEnter * highlight CursorColumn ctermfg=White ctermbg=Yellow cterm=bold guifg=white guibg=yellow gui=bold
"autocmd InsertLeave * highlight CursorColumn ctermfg=Black ctermbg=Yellow cterm=bold guifg=Black guibg=yellow gui=NONE
	
set number
set ruler

















