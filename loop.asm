; Program: TEST.ASM
; A Program to display the letter X on the screen
 
.model small
.stack 256
 
.code
 
start:

sum dw ?
mov ax, 12
mov bx, 0
mov cx, 0

loopaloopa:
add bx, 2
add cx, bx
dec ax
jnz loopaloopa
mov sum, cx

;mov dl, 'T'
;mov ah, 2h
;int 21h
 
; All programs use the following 3 lines to terminate
 
mov ax, 4c00h
int 21h

end start
