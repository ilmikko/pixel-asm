.model large
.stack 512
.code

;; Our maximum drawing bounds.
;; Just in case something changes.
maxx = 20480
maxy = 12800
;; Center x and y
cenx = maxx / 2
ceny = maxy / 2
;; Maximum value for es:[bx], used for calculating bounds
maxesbx = 320*200

;; Color variable
color db 15

;; x and y variables
x dw 0
y dw 0

;; Our (frame) offset from the center x and y
offsetx dw 0
offsety dw 0

;; Current time (or frame)
time dw 0

;; ---------------MACROS-----------------
set_display macro
	mov ah, 0 	; display mode function
	mov al, 13h 	; video, 320x200 graphics, 256 colors, 1 page
	int 10h

	; Set es to point to 0a000h, start of video memory
	mov bx, 0a000h
	mov es, bx
endm

unset_display macro
	mov ah, 0	; display mode function
	mov al, 3h	; text mode
	int 10h
endm

;; Wait for a keypress, pause
wait_keypress macro
	xor ax, ax
	;mov ah, 0h
	;int 16h
	mov ax, 0100h
	int 21h
endm

;; Wait milliseconds: cx and dx as timers
waits macro
	xor ax, ax
	mov cx, 0h
	mov dx, 0f00h
	mov ah, 86h
	int 15h
endm

;; Check if key was pressed and end if so
chkeyend macro
	xor ax, ax
	mov ah, 1
	int 16h
	jnz exit
endm

clear_screen macro
	mov ax, 0 ; color, 0 = black
	push es
	mov cx, 8000 ; pixel count?
	rep stosw
	pop es
endm

;; draw one pixel :3
draw_pixel:
	add cx, cenx
	sub cx, offsetx
	sar cx, 6

	add dx, ceny
	sub dx, offsety
	sar dx, 6

	; Check if in range
	cmp cx, 320
	jg runforyourlife
	test cx, cx
	js runforyourlife

	cmp dx, 200
	jg runforyourlife
	test dx, dx
	js runforyourlife

	;; Calculate the index
	mov ax, dx
	mov bx, 320
	mul bx
	add ax, cx

	;; Draw the pixel
	mov bx, ax
	mov ah, color
	mov es:[bx], ah

	runforyourlife:
ret

;; The first quadrant of precalculated sine values, stored in 255 words, just for you!
init_table macro
	mov bx, 0bee0h ;; our address
	mov ds:[bx], 0
	inc bx
	inc bx
	mov ds:[bx], 50
	inc bx
	inc bx
	mov ds:[bx], 101
	inc bx
	inc bx
	mov ds:[bx], 151
	inc bx
	inc bx
	mov ds:[bx], 201
	inc bx
	inc bx
	mov ds:[bx], 251
	inc bx
	inc bx
	mov ds:[bx], 302
	inc bx
	inc bx
	mov ds:[bx], 352
	inc bx
	inc bx
	mov ds:[bx], 402
	inc bx
	inc bx
	mov ds:[bx], 452
	inc bx
	inc bx
	mov ds:[bx], 502
	inc bx
	inc bx
	mov ds:[bx], 553
	inc bx
	inc bx
	mov ds:[bx], 603
	inc bx
	inc bx
	mov ds:[bx], 653
	inc bx
	inc bx
	mov ds:[bx], 703
	inc bx
	inc bx
	mov ds:[bx], 753
	inc bx
	inc bx
	mov ds:[bx], 803
	inc bx
	inc bx
	mov ds:[bx], 853
	inc bx
	inc bx
	mov ds:[bx], 903
	inc bx
	inc bx
	mov ds:[bx], 953
	inc bx
	inc bx
	mov ds:[bx], 1003
	inc bx
	inc bx
	mov ds:[bx], 1053
	inc bx
	inc bx
	mov ds:[bx], 1102
	inc bx
	inc bx
	mov ds:[bx], 1152
	inc bx
	inc bx
	mov ds:[bx], 1202
	inc bx
	inc bx
	mov ds:[bx], 1252
	inc bx
	inc bx
	mov ds:[bx], 1301
	inc bx
	inc bx
	mov ds:[bx], 1351
	inc bx
	inc bx
	mov ds:[bx], 1401
	inc bx
	inc bx
	mov ds:[bx], 1450
	inc bx
	inc bx
	mov ds:[bx], 1499
	inc bx
	inc bx
	mov ds:[bx], 1549
	inc bx
	inc bx
	mov ds:[bx], 1598
	inc bx
	inc bx
	mov ds:[bx], 1647
	inc bx
	inc bx
	mov ds:[bx], 1697
	inc bx
	inc bx
	mov ds:[bx], 1746
	inc bx
	inc bx
	mov ds:[bx], 1795
	inc bx
	inc bx
	mov ds:[bx], 1844
	inc bx
	inc bx
	mov ds:[bx], 1893
	inc bx
	inc bx
	mov ds:[bx], 1942
	inc bx
	inc bx
	mov ds:[bx], 1990
	inc bx
	inc bx
	mov ds:[bx], 2039
	inc bx
	inc bx
	mov ds:[bx], 2088
	inc bx
	inc bx
	mov ds:[bx], 2136
	inc bx
	inc bx
	mov ds:[bx], 2185
	inc bx
	inc bx
	mov ds:[bx], 2233
	inc bx
	inc bx
	mov ds:[bx], 2282
	inc bx
	inc bx
	mov ds:[bx], 2330
	inc bx
	inc bx
	mov ds:[bx], 2378
	inc bx
	inc bx
	mov ds:[bx], 2426
	inc bx
	inc bx
	mov ds:[bx], 2474
	inc bx
	inc bx
	mov ds:[bx], 2522
	inc bx
	inc bx
	mov ds:[bx], 2570
	inc bx
	inc bx
	mov ds:[bx], 2617
	inc bx
	inc bx
	mov ds:[bx], 2665
	inc bx
	inc bx
	mov ds:[bx], 2712
	inc bx
	inc bx
	mov ds:[bx], 2760
	inc bx
	inc bx
	mov ds:[bx], 2807
	inc bx
	inc bx
	mov ds:[bx], 2854
	inc bx
	inc bx
	mov ds:[bx], 2901
	inc bx
	inc bx
	mov ds:[bx], 2948
	inc bx
	inc bx
	mov ds:[bx], 2995
	inc bx
	inc bx
	mov ds:[bx], 3042
	inc bx
	inc bx
	mov ds:[bx], 3088
	inc bx
	inc bx
	mov ds:[bx], 3135
	inc bx
	inc bx
	mov ds:[bx], 3181
	inc bx
	inc bx
	mov ds:[bx], 3228
	inc bx
	inc bx
	mov ds:[bx], 3274
	inc bx
	inc bx
	mov ds:[bx], 3320
	inc bx
	inc bx
	mov ds:[bx], 3366
	inc bx
	inc bx
	mov ds:[bx], 3411
	inc bx
	inc bx
	mov ds:[bx], 3457
	inc bx
	inc bx
	mov ds:[bx], 3503
	inc bx
	inc bx
	mov ds:[bx], 3548
	inc bx
	inc bx
	mov ds:[bx], 3593
	inc bx
	inc bx
	mov ds:[bx], 3638
	inc bx
	inc bx
	mov ds:[bx], 3683
	inc bx
	inc bx
	mov ds:[bx], 3728
	inc bx
	inc bx
	mov ds:[bx], 3773
	inc bx
	inc bx
	mov ds:[bx], 3817
	inc bx
	inc bx
	mov ds:[bx], 3862
	inc bx
	inc bx
	mov ds:[bx], 3906
	inc bx
	inc bx
	mov ds:[bx], 3950
	inc bx
	inc bx
	mov ds:[bx], 3994
	inc bx
	inc bx
	mov ds:[bx], 4038
	inc bx
	inc bx
	mov ds:[bx], 4081
	inc bx
	inc bx
	mov ds:[bx], 4125
	inc bx
	inc bx
	mov ds:[bx], 4168
	inc bx
	inc bx
	mov ds:[bx], 4212
	inc bx
	inc bx
	mov ds:[bx], 4255
	inc bx
	inc bx
	mov ds:[bx], 4297
	inc bx
	inc bx
	mov ds:[bx], 4340
	inc bx
	inc bx
	mov ds:[bx], 4383
	inc bx
	inc bx
	mov ds:[bx], 4425
	inc bx
	inc bx
	mov ds:[bx], 4467
	inc bx
	inc bx
	mov ds:[bx], 4509
	inc bx
	inc bx
	mov ds:[bx], 4551
	inc bx
	inc bx
	mov ds:[bx], 4593
	inc bx
	inc bx
	mov ds:[bx], 4634
	inc bx
	inc bx
	mov ds:[bx], 4676
	inc bx
	inc bx
	mov ds:[bx], 4717
	inc bx
	inc bx
	mov ds:[bx], 4758
	inc bx
	inc bx
	mov ds:[bx], 4799
	inc bx
	inc bx
	mov ds:[bx], 4840
	inc bx
	inc bx
	mov ds:[bx], 4880
	inc bx
	inc bx
	mov ds:[bx], 4920
	inc bx
	inc bx
	mov ds:[bx], 4960
	inc bx
	inc bx
	mov ds:[bx], 5000
	inc bx
	inc bx
	mov ds:[bx], 5040
	inc bx
	inc bx
	mov ds:[bx], 5080
	inc bx
	inc bx
	mov ds:[bx], 5119
	inc bx
	inc bx
	mov ds:[bx], 5158
	inc bx
	inc bx
	mov ds:[bx], 5197
	inc bx
	inc bx
	mov ds:[bx], 5236
	inc bx
	inc bx
	mov ds:[bx], 5274
	inc bx
	inc bx
	mov ds:[bx], 5313
	inc bx
	inc bx
	mov ds:[bx], 5351
	inc bx
	inc bx
	mov ds:[bx], 5389
	inc bx
	inc bx
	mov ds:[bx], 5427
	inc bx
	inc bx
	mov ds:[bx], 5464
	inc bx
	inc bx
	mov ds:[bx], 5501
	inc bx
	inc bx
	mov ds:[bx], 5539
	inc bx
	inc bx
	mov ds:[bx], 5575
	inc bx
	inc bx
	mov ds:[bx], 5612
	inc bx
	inc bx
	mov ds:[bx], 5649
	inc bx
	inc bx
	mov ds:[bx], 5685
	inc bx
	inc bx
	mov ds:[bx], 5721
	inc bx
	inc bx
	mov ds:[bx], 5757
	inc bx
	inc bx
	mov ds:[bx], 5793
	inc bx
	inc bx
	mov ds:[bx], 5828
	inc bx
	inc bx
	mov ds:[bx], 5863
	inc bx
	inc bx
	mov ds:[bx], 5898
	inc bx
	inc bx
	mov ds:[bx], 5933
	inc bx
	inc bx
	mov ds:[bx], 5968
	inc bx
	inc bx
	mov ds:[bx], 6002
	inc bx
	inc bx
	mov ds:[bx], 6036
	inc bx
	inc bx
	mov ds:[bx], 6070
	inc bx
	inc bx
	mov ds:[bx], 6104
	inc bx
	inc bx
	mov ds:[bx], 6137
	inc bx
	inc bx
	mov ds:[bx], 6170
	inc bx
	inc bx
	mov ds:[bx], 6203
	inc bx
	inc bx
	mov ds:[bx], 6236
	inc bx
	inc bx
	mov ds:[bx], 6268
	inc bx
	inc bx
	mov ds:[bx], 6300
	inc bx
	inc bx
	mov ds:[bx], 6333
	inc bx
	inc bx
	mov ds:[bx], 6364
	inc bx
	inc bx
	mov ds:[bx], 6396
	inc bx
	inc bx
	mov ds:[bx], 6427
	inc bx
	inc bx
	mov ds:[bx], 6458
	inc bx
	inc bx
	mov ds:[bx], 6489
	inc bx
	inc bx
	mov ds:[bx], 6519
	inc bx
	inc bx
	mov ds:[bx], 6550
	inc bx
	inc bx
	mov ds:[bx], 6580
	inc bx
	inc bx
	mov ds:[bx], 6610
	inc bx
	inc bx
	mov ds:[bx], 6639
	inc bx
	inc bx
	mov ds:[bx], 6669
	inc bx
	inc bx
	mov ds:[bx], 6698
	inc bx
	inc bx
	mov ds:[bx], 6726
	inc bx
	inc bx
	mov ds:[bx], 6755
	inc bx
	inc bx
	mov ds:[bx], 6783
	inc bx
	inc bx
	mov ds:[bx], 6811
	inc bx
	inc bx
	mov ds:[bx], 6839
	inc bx
	inc bx
	mov ds:[bx], 6867
	inc bx
	inc bx
	mov ds:[bx], 6894
	inc bx
	inc bx
	mov ds:[bx], 6921
	inc bx
	inc bx
	mov ds:[bx], 6948
	inc bx
	inc bx
	mov ds:[bx], 6974
	inc bx
	inc bx
	mov ds:[bx], 7001
	inc bx
	inc bx
	mov ds:[bx], 7027
	inc bx
	inc bx
	mov ds:[bx], 7052
	inc bx
	inc bx
	mov ds:[bx], 7078
	inc bx
	inc bx
	mov ds:[bx], 7103
	inc bx
	inc bx
	mov ds:[bx], 7128
	inc bx
	inc bx
	mov ds:[bx], 7152
	inc bx
	inc bx
	mov ds:[bx], 7177
	inc bx
	inc bx
	mov ds:[bx], 7201
	inc bx
	inc bx
	mov ds:[bx], 7225
	inc bx
	inc bx
	mov ds:[bx], 7248
	inc bx
	inc bx
	mov ds:[bx], 7272
	inc bx
	inc bx
	mov ds:[bx], 7295
	inc bx
	inc bx
	mov ds:[bx], 7317
	inc bx
	inc bx
	mov ds:[bx], 7340
	inc bx
	inc bx
	mov ds:[bx], 7362
	inc bx
	inc bx
	mov ds:[bx], 7384
	inc bx
	inc bx
	mov ds:[bx], 7405
	inc bx
	inc bx
	mov ds:[bx], 7427
	inc bx
	inc bx
	mov ds:[bx], 7448
	inc bx
	inc bx
	mov ds:[bx], 7469
	inc bx
	inc bx
	mov ds:[bx], 7489
	inc bx
	inc bx
	mov ds:[bx], 7509
	inc bx
	inc bx
	mov ds:[bx], 7529
	inc bx
	inc bx
	mov ds:[bx], 7549
	inc bx
	inc bx
	mov ds:[bx], 7568
	inc bx
	inc bx
	mov ds:[bx], 7588
	inc bx
	inc bx
	mov ds:[bx], 7606
	inc bx
	inc bx
	mov ds:[bx], 7625
	inc bx
	inc bx
	mov ds:[bx], 7643
	inc bx
	inc bx
	mov ds:[bx], 7661
	inc bx
	inc bx
	mov ds:[bx], 7679
	inc bx
	inc bx
	mov ds:[bx], 7696
	inc bx
	inc bx
	mov ds:[bx], 7713
	inc bx
	inc bx
	mov ds:[bx], 7730
	inc bx
	inc bx
	mov ds:[bx], 7746
	inc bx
	inc bx
	mov ds:[bx], 7763
	inc bx
	inc bx
	mov ds:[bx], 7779
	inc bx
	inc bx
	mov ds:[bx], 7794
	inc bx
	inc bx
	mov ds:[bx], 7809
	inc bx
	inc bx
	mov ds:[bx], 7825
	inc bx
	inc bx
	mov ds:[bx], 7839
	inc bx
	inc bx
	mov ds:[bx], 7854
	inc bx
	inc bx
	mov ds:[bx], 7868
	inc bx
	inc bx
	mov ds:[bx], 7882
	inc bx
	inc bx
	mov ds:[bx], 7895
	inc bx
	inc bx
	mov ds:[bx], 7909
	inc bx
	inc bx
	mov ds:[bx], 7921
	inc bx
	inc bx
	mov ds:[bx], 7934
	inc bx
	inc bx
	mov ds:[bx], 7946
	inc bx
	inc bx
	mov ds:[bx], 7959
	inc bx
	inc bx
	mov ds:[bx], 7970
	inc bx
	inc bx
	mov ds:[bx], 7982
	inc bx
	inc bx
	mov ds:[bx], 7993
	inc bx
	inc bx
	mov ds:[bx], 8004
	inc bx
	inc bx
	mov ds:[bx], 8014
	inc bx
	inc bx
	mov ds:[bx], 8025
	inc bx
	inc bx
	mov ds:[bx], 8035
	inc bx
	inc bx
	mov ds:[bx], 8044
	inc bx
	inc bx
	mov ds:[bx], 8054
	inc bx
	inc bx
	mov ds:[bx], 8063
	inc bx
	inc bx
	mov ds:[bx], 8071
	inc bx
	inc bx
	mov ds:[bx], 8080
	inc bx
	inc bx
	mov ds:[bx], 8088
	inc bx
	inc bx
	mov ds:[bx], 8096
	inc bx
	inc bx
	mov ds:[bx], 8103
	inc bx
	inc bx
	mov ds:[bx], 8111
	inc bx
	inc bx
	mov ds:[bx], 8117
	inc bx
	inc bx
	mov ds:[bx], 8124
	inc bx
	inc bx
	mov ds:[bx], 8130
	inc bx
	inc bx
	mov ds:[bx], 8136
	inc bx
	inc bx
	mov ds:[bx], 8142
	inc bx
	inc bx
	mov ds:[bx], 8147
	inc bx
	inc bx
	mov ds:[bx], 8153
	inc bx
	inc bx
	mov ds:[bx], 8157
	inc bx
	inc bx
	mov ds:[bx], 8162
	inc bx
	inc bx
	mov ds:[bx], 8166
	inc bx
	inc bx
	mov ds:[bx], 8170
	inc bx
	inc bx
	mov ds:[bx], 8173
	inc bx
	inc bx
	mov ds:[bx], 8177
	inc bx
	inc bx
	mov ds:[bx], 8180
	inc bx
	inc bx
	mov ds:[bx], 8182
	inc bx
	inc bx
	mov ds:[bx], 8184
	inc bx
	inc bx
	mov ds:[bx], 8186
	inc bx
	inc bx
	mov ds:[bx], 8188
	inc bx
	inc bx
	mov ds:[bx], 8190
	inc bx
	inc bx
	mov ds:[bx], 8191
	inc bx
	inc bx
	mov ds:[bx], 8191
	inc bx
	inc bx
	mov ds:[bx], 8192
	inc bx
	inc bx
endm

;; Old sin approx functions

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

;; Parameter: cl = r
;; Returns: dx = y
cos:
	add cx, 11111111b
	call sin
ret

;; Parameter: cl = r
;; Returns: dx = y
sin:
	; Use a table to approximate sine
	; 256 values currently

	;; register dx is encoding the flip state of the sine function.
	;; unset bits
	xor dx, dx

	;; Calc x axis flip
	mov ax, cx
	sar ax, 2
	and ax, 11111111b
	sub ax, 10000000b ;; ditto as above
	js notpos1
		;; set bit for positive
		or dx, 1
	notpos1:

	;; Calc y axis flip (immediate)
	mov ax, cx
	sar ax, 1
	and ax, 11111111b
	sub ax, 10000000b ;; subtract 1 more, because zero is not signed
	js notpos0
		;; immediate flip
		not cx
	notpos0:

	xor ch, ch 	;; ignore ch
	shl cx, 1 	;; multiply cx by 2 (byte -> word)
	mov bx, 0bee0h	;; our address
	add bx, cx	;; add cx offset
	mov ax, ds:[bx]	;; get the corresponding sine value

	;; flip if bit 0 set
	test dx, 1
	jz noxflip
		not ax
	noxflip:

	mov dx, ax
ret

iter dw 0

calcx:
		; calc x for a screen x
		mov cx, iter
		add cx, time

		call sin

		mov x, ax
ret

calcy:
		mov cx, iter
		add cx, time

		call cos

		mov y, ax
ret

sx dw 0
sy dw 0
ex dw 0
ey dw 0

magic dw 0

magicline:
		mov color, 3

		mov magic, 128
		magicloop:
			mov cx, sx
			mov dx, sy

			mov ax, ex
			sar ax, 7
			mov bx, magic
			mul bx
			add cx, ax

			mov ax, ey
			sar ax, 7
			mov bx, magic
			mul bx
			add dx, ax

			call draw_pixel		

			mov ax, magic
			dec ax
			mov magic, ax
		jnz magicloop
ret

lines:
		mov sx, 0
		mov sy, 0

		call calcx
		call calcy

		mov cx, x
		mov dx, y
		mov ex, cx
		mov ey, dx

		call magicline

		;;mov color, 4
		;;mov cx, iter
		;;mov ax, iter
		;;
		;;sar ax, 6
		;;mov bx, time
		;;mul bx
		;;mov x, cx
		;;mov y, ax

		;;call draw_pixel
ret

start:
set_display

init_table

dploop:
	mov iter, 5

	clear_screen

	frameloop:
		mov cx, iter
		dec cx
		mov iter, cx

		;; Line
		call lines

		;; Circle
 
		;;call calcx
		;;call calcy

		;;mov color, 15
		;;call draw_pixel

		mov cx, iter
		test cx, cx
	jnz frameloop

	waits ;; wait for milliseconds before next frame
	
	chkeyend

	;; Increase time
	mov cx, time
	inc cx
	mov time, cx
jmp dploop

; wait for the keypress
wait_keypress

exit:
unset_display

; terminate
mov ax, 4c00h
int 21h

end start
