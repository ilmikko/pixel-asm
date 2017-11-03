.model small
.stack 256
 
.code

exit:
mov ax, 4c00h
int 21h
ret

print:
mov ah, 2h
int 21h
ret

input:
mov ah, 1h
int 21h
ret

newline:
mov dl, 13D
call print

mov dl, 10D
call print
ret

overflow:
inc dx
ret
 
start:

mov dx,0
mov bx,0
mov cx,99

loopa:
add bx,cx
dec cx
jo overflow
jnz loopa

call print

mov dx, bx
call print

call exit
end start
