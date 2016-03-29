"window controls

nnoremap <silent> <Up> :wincmd k<CR>
nnoremap <silent> <Down> :wincmd j<CR>
nnoremap <silent> <Left> :wincmd h<CR>
nnoremap <silent> <Right> :wincmd l<CR>
nnoremap <silent> <S-Up> :resize +2<CR>
nnoremap <silent> <S-Down> :resize -2<CR>
nnoremap <silent> <S-Left> :vertical resize -2<CR>
nnoremap <silent> <S-Right> :vertical resize +2<CR>

nnoremap <silent> <C-Left> <C-w>v:enew<CR>
nnoremap <silent> <C-Right> <C-w>v:wincmd l<CR>:enew<CR>
nnoremap <silent> <C-Up> <C-w>s:enew<CR>
nnoremap <silent> <C-Down> <C-w>s:wincmd j<CR>:enew<CR>


"tabs

nnoremap <C-PageUp> :tabe<CR>
nnoremap <C-PageDown> :tabclose<CR>

nnoremap <PageUp> <C-PageDown>
nnoremap <PageDown> <C-PageUp>

nnoremap <A-PageUp> :exec "tabm ".tabpagenr()<CR>
nnoremap <A-PageDown> :tabm "tabm ".tabpagenr()-2<CR>









