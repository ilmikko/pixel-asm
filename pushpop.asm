; Program: pushpop.asm

.MODEL small
.STACK 256

;---- Insert INCLUDE "filename" directives here

;---- Insert EQU and = equates here



;---- If an appropriate error occurs and the program should halt, store an appropriate
; error code in exCode and execute a JMP Exit instruction. To do this from a 
; submodule, declare the Exit label in an EXTRN directive.


;---- Declare other variables with DB, DW, etc, here

;---- Specify an EXTRN variables here


.CODE

;---- Specify an EXTRN procedure here

Start:

mov ax,177EH 		;initialize DS to address 
mov ds,ax 			;of data segment
mov es,ax 			; make es=ds

;---- Insert program subroutines calls, etc. here

push ax 			;save ax
push bx 			;save bx
mov ax,-1 			;move immediate data into registers
mov bx,-2
mov cx,0
mov dx,0

push ax
push bx
pop cx
pop dx

pop bx
pop ax

Exit:
mov ax, 4c00h
int 21h 			;call DOS. Terminate program
END Start			;End program
