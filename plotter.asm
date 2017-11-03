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

wait_keypress macro
	xor ax, ax
	;mov ah, 0h
	;int 16h
	mov ax, 0100h
	int 21h
endm

draw_pixel macro
	; draw one pixel :3
	mov cx, x
	mov dx, y

	add cx, cenw
	add dx, cenh

	; Check if in range
	cmp cx, maxw
	jg runforyourlife
	test cx, cx
	js runforyourlife
	
	cmp dx, maxh
	jg runforyourlife
	test dx, dx
	js runforyourlife

	mov ax, dx

	mov bx, maxw
	mul bx
	add ax, cx

	mov bx, ax

	mov ah, color
	mov es:[bx], ah

	runforyourlife:
endm

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

funktio macro
	mov ax, x
	;mul ax
	mov y, ax
endm

incx macro
	mov cx, x
	add cx, 1
	mov x, cx
endm

maxw = 320
maxh = 200
cenw = maxw / 2
cenh = maxh / 2
color db 15
maxesbx = maxw*maxh

x dw -cenw
y dw 0

start:
set_display

; Set es to point to 0a000h, start of video memory
mov bx, 0a000h
mov es, bx

dploop:
	funktio
	
	draw_pixel

	waits
	
	chkeyend

	incx
jmp dploop

; wait for the keypress
wait_keypress

exit:
unset_display

; terminate
mov ax, 4c00h
int 21h

end start
