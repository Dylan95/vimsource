
nnoremap e i

"call Map_select('fd', '<Esc>', 'i', 'v')
"inoremap fd <Esc>l
"vnoremap fd <Esc>
call Map_select('fd', '<Esc>l', 'i', 'v', 'c')

call DisableKeys('i', '<Right>', '<Left>', '<Up>', '<Down>')

map <F2> :mapclear \| so ~/_vimrc<CR>





