; Program: TEST.ASM
; A Program to display the letter X on the screen
 
.model small
.stack 256
 
.code
 
start:

dw sum ?
mov ax, dh ; 13
mov bx, 0
mov cx, 0
:loop
add bx, 2
add cx, bx
dec ax
jnz loop
mov sum, cx 

;mov dl, 'T'
;mov ah, 2h
;int 21h
 
; All programs use the following 3 lines to terminate
 
mov ax, 4c00h
int 21h

end start
