

"" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

"" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 0

"" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

"" Set a language to use its alternate delimiters by default
"" let g:NERDAltDelims_java = 1

"" Add your own custom formats or override the defaults
"" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

"" Allow commenting and inverting empty lines (useful when commenting a region)
"let g:NERDCommentEmptyLines = 1

"" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1


"nnoremap <leader>c 


"original mapping
"n  ,ca           <Plug>NERDCommenterAltDelims
"n  ,cu           <Plug>NERDCommenterUncomment
"n  ,cb           <Plug>NERDCommenterAlignBoth
"n  ,cl           <Plug>NERDCommenterAlignLeft
"n  ,cA           <Plug>NERDCommenterAppend
"n  ,cy           <Plug>NERDCommenterYank
"n  ,cs           <Plug>NERDCommenterSexy
"n  ,ci           <Plug>NERDCommenterInvert
"n  ,c$           <Plug>NERDCommenterToEOL
"n  ,cn           <Plug>NERDCommenterNested
"n  ,cm           <Plug>NERDCommenterMinimal
"n  ,c<Space>     <Plug>NERDCommenterToggle
"n  ,cc           <Plug>NERDCommenterComment

nnoremap <leader>ca NOP
nnoremap <leader>cu NOP
nnoremap <leader>cb NOP
nnoremap <leader>cl NOP
nnoremap <leader>cA NOP
nnoremap <leader>cy NOP
nnoremap <leader>cs NOP
nnoremap <leader>ci NOP
nnoremap <leader>c$ NOP
nnoremap <leader>cn NOP
nnoremap <leader>cm NOP
nnoremap <leader>c<Space> NOP
nnoremap <leader>cc NOP


nnoremap <leader> cc <PLUG>NERDCommenterInvert
nnoremap <leader> cy <PLUG>NERDCommenterYank
nnoremap <leader> cn <PLUG>NERDCommenterNested
nnoremap <leader> cm <PLUG>NERDCommenterMinimal
nnoremap <leader> ci <PLUG>NERDCommenterInvert
"nnoremap <leader> cc <PLUG>NERDCommenterComment
"nnoremap <leader> cu <PLUG>NERDCommenterUncomment



