"settings:

"very important, allows autocommands based on file type
"needed for many plugins, and some of my own vimsource as well.
filetype plugin indent on
filetype plugin on

syntax on

set nocompatible

"

let mapleader = "\<Space>"

"

set noswapfile

set virtualedit=onemore
set selection=exclusive

"command line autocompletion
set wildmode=longest,list
set wildmenu

set tabstop=4
set shiftwidth=4
set autoindent
"set whichwrap+=h,l
set mouse=a
"
set backspace=indent,eol,start

"format options
"disable automatic comment continuation
"set formatoptions-=cro

function DCG_linebreakToggle()
	if &linebreak
		set nolinebreak
	else
		set nolist
		set wrap
		set linebreak
	endif
endfunction
"
"list disables line break
"set nolist
"wrap
"nnoremap <A-w> :set list! \|
"\ :set list?<CR>
"set wrap linebreak
nnoremap <A-w> :set wrap!<CR>
nnoremap <A-l> :call DCG_linebreakToggle
"linebreak tokens, default
"set breakat&vim

"set wrap linebreak nolist


"disable comment automatic continuation
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
