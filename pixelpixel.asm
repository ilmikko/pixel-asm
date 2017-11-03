; Pixel.asm
; By ilmikko

.model small
.stack 256

.code

set_display macro
mov ah, 0 	; display mode function
mov al, 13h 	; video, 320x200 graphics, 256 colors, 1 page
int 10h
endm

unset_display macro
mov ah, 0	; display mode function
mov al, 3h	; text mode
int 10h
endm

draw_pixel macro
; TODO: Draw to specific coordinates
mov ah, 0Ch 	; put pixel
int 10h
endm

wait_keypress macro
mov ah, 0
int 16h
endm

exit macro
; TODO: exit with codes
mov ax, 4c00h
int 21h
endm

; this will drive me insane
sin macro

endm

start:

maxx EQU 320
maxy EQU 200
sides EQU 22

set_display ; set our display to 320x200

; cx = x (0-maxx)
; cy = y (0-maxy)
; al = color

mov ax, @data
mov ax, 0
mov bx, @data
mov bx, 10

mov cx, 2 	; col ('x')
mov dx, 0 	; row ('y')
mov al, 0	; color

wait_keypress

; initialize color
mov ax, 15 	; white
mov di, 0 	; data index 0
mov ds, ax

; start drawing
; currently only one frame
inframeloop:
	; sin
	sin

	; get color
	mov di, 0
	mov ax, ds

	draw_pixel

	; save color
	mov di, 0
	mov ds, ax

	dec bx
jnz inframeloop

wait_keypress ; wait for a keypress

unset_display ; unset what we have set

exit
end start
