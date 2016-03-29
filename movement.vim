"power movement

"for scrolling
let power = 10
let maxPower = 50
let minPower = 4
let dPower = 2

"for just moving
"let power2 = 4
"let maxPower2 = 8
"let minPower2 = 2
"let dPower2 = 1

function PowerMovement()
	call Map_nv('I', g:power."k".g:power."<C-y>")
	call Map_nv('K', g:power."j".g:power."<C-e>")
	call Map_nv('<C-i>', g:power."k")
	call Map_nv('<C-k>', g:power."j")
	call Map_nv('<A-i>', g:power."<C-y>")
	call Map_nv('<A-k>', g:power."<C-e>")
endfunction

nnoremap + :let power = min([maxPower, power + dPower]) \|
\ :call PowerMovement() \|
\ :echo "power up: ".power<CR>

nnoremap - :let power = max([minPower, power - dPower]) \|
\ :call PowerMovement() \|
\ :echo "power down: ".power<CR>

call PowerMovement()

"basic movement	
noremap i k
noremap k j
noremap j h
"
call Map_nv('J', 'b')
call Map_nv('L', 'el')
"
"
call Map_nv('<C-J>', '0')
call Map_esc('<C-J>', '0')
call Map_nv('<C-L>', '$l')
call Map_esc('<C-L>', '$l')









