.model small
.stack 256
.code

maxx = 320
maxy = 200
cenx = maxx / 2
ceny = maxy / 2
color db 15
maxesbx = maxx*maxy

iter dw -cenx
boundx dw 4
boundy dw 4
centerx dw 0
centery dw 0
x dw 0
y dw 0

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

wait_keypress macro
	xor ax, ax
	;mov ah, 0h
	;int 16h
	mov ax, 0100h
	int 21h
endm

draw_pixel:
	; draw one pixel :3
	mov cx, x
	mov dx, y

	add cx, cenx
	add dx, ceny

	sub cx, centerx
	sub dx, centery

	; Check if in range
	cmp cx, maxx
	jg runforyourlife
	test cx, cx
	js runforyourlife
	
	cmp dx, maxy
	jg runforyourlife
	test dx, dx
	js runforyourlife

	mov ax, dx

	mov bx, maxx
	mul bx
	add ax, cx

	mov bx, ax

	mov ah, color
	mov es:[bx], ah

	runforyourlife:
ret

waits macro
	xor ax, ax
	mov cx, 0
	mov dx, 0f00h
	mov ah, 86h
	int 15h
endm

chkeyend macro
	xor ax, ax
	mov ah, 1
	int 16h
	jnz exit
endm

;; Parameter: cx = r
;; Returns: dx = y
sin_A:
	sub cx, 111111b
	call cos_A
ret

;; Parameter: cx = r
;; Returns: dx = y
cos_A:
	;; This cosine function is a modified version
	;; of the one presented here: http://www.coranac.com/2009/07/sines/
	;; ARM assembly version, with modified instructions
	;; because we're using 16-bit numbers instead of 32-bit ones,
	;; and because TASM syntax is quite different from ARM syntax.

	mov ax, cx
	;; mov r0, r0, lsl #(30-13)
	;; 17/2 -> 8, 9?
	shl ax, 9
	;; rsbmi r0, r0, #1<<31
	;; using 16-bit numbers, so #1<<15
	;; Change every 1,3 to be negative
	jns notneg
		;;mov bx, 1
		;;shl bx, 15 ;; (16-1, set highest-order bits)
		;; OR mov bx, 1000000000000000b
		mov bx, 1111111100000000b
		sub bx, ax
		mov ax, bx
	notneg:


	;; Change every 2,3 around
	mov dx, cx
	shl dx, 8
	add dx, 0011111111111111b
	jns notnegB
		mov bx, 1111111111111111b
		;;mov ax, 0
		sub bx, ax
		mov ax, bx
	notnegB:


	;; mov r0, r0, asr #(30-13)
	;; 17/2 -> 8, 9?
	sar ax, 8

	;; mul r1, r0, r0
	mov cx, ax ; store original ax
	mov bx, ax
	mul bx
	mov bx, ax ; move ax^2 to bx
	mov ax, cx ; get back original ax

	;; mov r1, r1, asr #11
	;; 6, always!
	sar bx, 6
	;; rsb r1, r1, #3<<15
	;; 15/2 -> 7
	mov cx, 1
	add cx, bx
	mov bx, cx
	;; mul r0, r1, r0
	mul bx

	;; Add some offset to the final curve (overflow is our friend)
	add ax, 0111111111111111b

	;; mov r0, r0, asr #17
	;; 17/2 -> 9
	;; Arithmetic shift makes things nice and small
	sar ax, 9

	mov dx, ax
ret

start:
set_display

; Set es to point to 0a000h, start of video memory
mov bx, 0a000h
mov es, bx

drawi dw 0

dploop:
	; calc x for a screen x
	mov ax, centerx
	add ax, iter
	mov x, ax
	
	; First graph, cos, green
	mov color, 2

	mov cx, x
	call cos_A
	mov y, dx

	call draw_pixel

	; Second graph, sin, red
	mov color, 4

	mov cx, x
	call sin_A
	mov y, dx

	call draw_pixel

	; Drawing a circle the hard way:
	; For iter, calc the corresponding x and y
	; using our newly-found sine and cosine functions
	mov cx, iter
	call sin_A
	mov x, dx

	mov cx, iter
	call cos_A
	mov y, dx

	mov color, 15
	call draw_pixel

	waits
	
	chkeyend

	;; Increase iter (x)
	mov cx, iter
	add cx, 1
	mov iter, cx
jmp dploop

; wait for the keypress
wait_keypress

exit:
unset_display

; terminate
mov ax, 4c00h
int 21h

end start
