; Program: TEST.ASM
; A Program to display the letter X on the screen
 
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
 
start:

call input

mov bl, al
call newline

mov dl, bl
call print

call exit
end start
