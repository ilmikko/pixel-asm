.model small
.stack 256
 
.code

print:
pop ax
mov ah, 2h
int 21h
ret

input:
mov ah, 1h
int 21h
push ax
ret

start:
mov ax,10

inputloop:
call input
dec ax
jnz inputloop

call print

mov ax, 4c00h
int 21h
