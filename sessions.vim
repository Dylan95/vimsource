



"save session
nnoremap <A-s> :mksession! ~/.vim/sessions/sessionQ.vim<CR>
nnoremap <A-s>q :mksession! ~/.vim/sessions/sessionQ.vim<CR>
nnoremap <A-s>w :mksession! ~/.vim/sessions/sessionW.vim<CR>
nnoremap <A-s>e :mksession! ~/.vim/sessions/sessionE.vim<CR>
nnoremap <A-s>r :mksession! ~/.vim/sessions/sessionR.vim<CR>

"load session
nnoremap <A-o> :so ~/.vim/sessions/sessionQ.vim<CR>
nnoremap <A-o>q :so ~/.vim/sessions/sessionQ.vim<CR>
nnoremap <A-o>w :so ~/.vim/sessions/sessionW.vim<CR>
nnoremap <A-o>e :so ~/.vim/sessions/sessionE.vim<CR>
nnoremap <A-o>r :so ~/.vim/sessions/sessionR.vim<CR>

nnoremap <A-q> :wa \|
\ :mksession! ~/.vim/sessions/sessionQ.vim \|
\ :qa<CR>





















