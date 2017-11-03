.model medium
.stack 32
.code

;; Our maximum drawing bounds.
;; Just in case something changes.
maxx = 20480
maxy = 12800
;; Center x and y
cenx = maxx / 2
ceny = maxy / 2
;;;; Maximum value for es:[bx], used for calculating bounds
;;maxesbx = 320*200

;; Color variable
color db 15

;; x and y variables
x dw 0
y dw 0

;; Our (frame) offset from the center x and y
offsetx dw 0
offsety dw 0

;; Frame velocity
velocityx dw 152
velocityy dw 152

;; Current time (or frame), used for calculating colors and shapes
time dw 0

;; Set to 0 if we want to clear the screen
;; Anded with COLOR in drawtime
clear db 11111111b

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
	mov dx, 02ff0h
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

moveframe macro
	;;;; X
	mov ax, offsetx
	add ax, velocityx
	mov offsetx, ax

	;; if abs ax more than bounds then negate velocity and go back to bounds
	mov bx, 10240 ;;; 320<<5
	mov cx, radius
	shl cx, 6
	sub bx, cx
	call absax
	sub bx, ax
	jns noflipxyet
		mov ax, velocityx
		not ax
		inc ax
		mov velocityx, ax

		mov ax, offsetx
		jns nsoffsetx
			add ax, bx
			mov offsetx, ax
		jmp noflipxyet
		nsoffsetx:
			sub ax, bx
			mov offsetx, ax
	noflipxyet:

	;;;; Y
	mov ax, offsety
	add ax, velocityy
	mov offsety, ax

	;; if abs ax more than bounds then negate velocity and return back
	mov bx, 6400 ;;; 200<<5
	mov cx, radius
	shl cx, 6
	sub bx, cx
	call absax
	sub bx, ax
	jns noflipyyet
		mov ax, velocityy
		not ax
		inc ax
		mov velocityy, ax

		mov ax, offsety
		jns nsoffsety
			add ax, bx
			mov offsety, ax
		jmp noflipyyet
		nsoffsety:
			sub ax, bx
			mov offsety, ax
	noflipyyet:
endm

;;clear_screen macro
;;
;;	;; For some reason, we need this offset (32 bits) to keep vertical sync but not really
;;	mov bx, 09FE0h
;;	mov es, bx
;;
;;	mov ax, 0 ; color, 0 = black
;;	mov cx, 32000 ; word count ((320*200)/2)
;;	rep stosw
;;
;;	mov bx, 0a000h
;;	mov es, bx
;;endm

;; draw one pixel :3
draw_pixel:
	add cx, cenx
	sub cx, offsetx
	sar cx, 6

	add dx, ceny
	sub dx, offsety
	sar dx, 6

	; Check if in range, otherwise do not draw
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
	and ah, clear
	mov es:[bx], ah

	runforyourlife:
ret

;; The first quadrant of precalculated sine values, stored in 255 words, just for you!
;; I was initially thinking of increasing the precision by storing 512 words, but this is good enough for now
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

;; Old sin approx functions, beware

;; Parameter: cx = r
;; Returns: dx = y
;;sin_A:
;;	sub cx, 111111b
;;	call cos_A
;;ret

;; I tried calculating the sine function on the fly, but this doesn't draw a circle, rather an awkward rounded square
;; Parameter: cx = r
;; Returns: dx = y
;;cos_A:
;;	;; This cosine function is a modified version
;;	;; of the one presented here: http://www.coranac.com/2009/07/sines/
;;	;; ARM assembly version, with modified instructions
;;	;; because we're using 16-bit numbers instead of 32-bit ones,
;;	;; and because TASM syntax is quite different from ARM syntax.
;;
;;	mov ax, cx
;;	;; mov r0, r0, lsl #(30-13)
;;	;; 17/2 -> 8, 9?
;;	shl ax, 9
;;	;; rsbmi r0, r0, #1<<31
;;	;; using 16-bit numbers, so #1<<15
;;	;; Change every 1,3 to be negative
;;	jns notneg
;;		;;mov bx, 1
;;		;;shl bx, 15 ;; (16-1, set highest-order bits)
;;		;; OR mov bx, 1000000000000000b
;;		mov bx, 1111111100000000b
;;		sub bx, ax
;;		mov ax, bx
;;	notneg:
;;
;;
;;	;; Change every 2,3 around
;;	mov dx, cx
;;	shl dx, 8
;;	add dx, 0011111111111111b
;;	jns notnegB
;;		mov bx, 1111111111111111b
;;		;;mov ax, 0
;;		sub bx, ax
;;		mov ax, bx
;;	notnegB:
;;
;;
;;	;; mov r0, r0, asr #(30-13)
;;	;; 17/2 -> 8, 9?
;;	sar ax, 8
;;
;;	;; mul r1, r0, r0
;;	mov cx, ax ; store original ax
;;	mov bx, ax
;;	mul bx
;;	mov bx, ax ; move ax^2 to bx
;;	mov ax, cx ; get back original ax
;;
;;	;; mov r1, r1, asr #11
;;	;; 6, always!
;;	sar bx, 6
;;	;; rsb r1, r1, #3<<15
;;	;; 15/2 -> 7
;;	mov cx, 1
;;	add cx, bx
;;	mov bx, cx
;;	;; mul r0, r1, r0
;;	mul bx
;;
;;	;; Add some offset to the final curve (overflow is our friend)
;;	add ax, 0111111111111111b
;;
;;	;; mov r0, r0, asr #17
;;	;; 17/2 -> 9
;;	;; Arithmetic shift makes things nice and small
;;	sar ax, 9
;;
;;	mov dx, ax
;;ret

;; Real sin / cos functions, interpreting the pre-stored values

;; Parameter: cl = r
;; Returns: ax = y
cos:
	add cx, 11111111b
	call sin
ret

;; Parameter: cl = r
;; Returns: ax = y
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
ret

iter dw 0
radius dw 512
sides dw 0

;; Parameters: cx
calcx:
		; calc x for a screen x
		call sin

		;; Arithmetic shift because of radius multiply
		sar ax, 7
		mov cx, radius
		mul radius

		mov x, ax
ret

;; Parameters: cx
calcy:
		call cos

		;; Arithmetic shift because of radius multiply
		sar ax, 7
		mov cx, radius
		mul radius

		mov y, ax
ret

;; Absolute ax
absax:
	test ax, ax
	jns endabsax
		not ax
		inc ax
	endabsax:
ret

;; Line variables start x and y, end x and y
sx dw 0
sy dw 0
ex dw 0
ey dw 0

;; A little bit of magic in code never hurt anyone
magic dw 0
linlen dw 22
linec dw 100

magicline:
	mov ax, linec
	mov linlen, ax
	mov magic, ax 	;; TODO: rename

	magicloop:
		mov cx, sx
		mov ax, ex
		sub ax, sx

		;; MUST BE a number that magic>>ax = 1
		;; (divide with magic to fit the scale)
		;;sar ax, 5
		mov bx, linlen
		xor dx, dx
		test ax, ax
		jns notsigneda
			not ax
			inc ax
			div bx
			not ax
		jmp signedenda
		notsigneda:
			div bx
		signedenda:

		mov bx, magic
		mul bx
		add cx, ax
		mov x, cx

		mov cx, sy
		mov ax, ey
		sub ax, sy

		;; MUST BE a number that magic>>ax = 1
		;; (divide with magic to fit the scale)
		;;sar ax, 5
		mov bx, linlen
		xor dx, dx
		test ax, ax
		jns notsignedb
			not ax
			inc ax
			div bx
			not ax
		jmp signedendb
		notsignedb:
			div bx
		signedendb:

		mov bx, magic
		mul bx
		add cx, ax
		mov y, cx

		mov cx, x
		mov dx, y
		call draw_pixel		

		mov ax, magic
		dec ax
		mov magic, ax
	jnz magicloop
ret

rot dw 0

pointoncir:
	;;mov ax, 1
	;;shl ax, 9

	;;;; Div ax by sides
	;;xor dx, dx
	;;mov bx, sides
	;;div bx
	;;xor ah, ah
	;;mov bx, iter
	;;mul bx

	mov ax, 1024
	mov bx, sides
	xor dx, dx
	div bx
	mov bx, iter
	mul bx
	add ax, rot
	mov cx, ax
	call calcx

	;;mov ax, 1
	;;shl ax, 9

	;;;; Div ax by sides
	;;xor dx, dx
	;;mov bx, sides
	;;div bx
	;;xor ah, ah
	;;mov bx, iter
	;;mul bx

	mov ax, 1024
	mov bx, sides
	xor dx, dx
	div bx
	mov bx, iter
	mul bx
	add ax, rot
	mov cx, ax
	call calcy
ret

;; Draw a shape, based on the variables 'sides', 'radius', 'rot'
drawshape:
	mov bx, sides
	mov iter, bx

	; Calc first sx sy (always the same)
	call pointoncir
	mov cx, x
	mov sx, cx
	mov dx, y
	mov sy, dx

	iterloop:
		mov ax, iter
		dec ax
		mov iter, ax

		; Calc ex ey
		call pointoncir
		mov ax, x
		mov ex, ax
		mov ax, y
		mov ey, ax

		call magicline

		; e is now the new s
		mov ax, ex
		mov sx, ax
		mov ax, ey
		mov sy, ax

		mov ax, iter
		test ax, ax
	jnz iterloop
ret

;; Define our shapes
shape_rotato:
	;; A rotating triangle with a square inside
	mov radius, 30
	mov sides, 4
	mov bx, time
	not bx
	mov rot, bx
	call drawshape

	mov ah, color
	inc ah
	mov color, ah

	mov radius, 50
	mov sides, 3
	mov bx, time
	shl bx, 2
	mov rot, bx
	call drawshape

	mov ah, color
	dec ah
	mov color, ah
ret

shape_square:
	mov radius, 30
	mov sides, 4
	mov bx, time
	shl bx, 1
	mov rot, bx
	call drawshape
ret

shape_triangle:
	mov radius, 40
	mov sides, 3
	mov bx, time
	mov rot, bx
	call drawshape
ret

shape_circle:
	mov radius, 40
	mov sides, 3
	mov bx, time
    shl bx, 2
    not bx
	mov rot, bx
	call drawshape

	mov radius, 40
	mov sides, 3
    shl bx, 2
	mov bx, time
	mov rot, bx
	call drawshape
ret

shape_pentagon:
	mov radius, 40
	mov sides, 5
	mov bx, time
	shl bx, 3
	mov rot, bx
	call drawshape
ret

shape_zelda: 
	push linec

	mov linec, 20
	mov radius, 12
	mov sides, 3
	mov bx, time
	add bx, 100000000b
	mov rot, bx
	call drawshape

	mov ah, color
	inc ah
	mov color, ah

	mov linec, 40
	mov radius, 25
	mov sides, 3
	mov bx, time
	add bx, 10000000b
	mov rot, bx
	call drawshape

	mov ah, color
	inc ah
	mov color, ah

	mov linec, 80
	mov radius, 50
	mov sides, 3
	mov bx, time
	mov rot, bx
	call drawshape

	mov ah, color
	sub ah, 2
	mov color, ah

	pop linec
ret

shape_keo:
	mov radius, 50
	mov sides, 2
	mov bx, time
	mov rot, bx
	call drawshape

	mov bx, time
	add bx, 11111111b
	mov rot, bx
	call drawshape

	mov bx, time
	mov rot, bx
	mov sides, 4
	call drawshape
ret

shape_end:
	mov radius, 32
	mov sides, 4
	mov bx, time
	shl bx, 3
	not bx
	mov rot, bx
	call drawshape

	mov radius, 32
	mov sides, 4
	mov bx, time
	add bx, 1111b
	shl bx, 3
	not bx
	mov rot, bx
	call drawshape

	mov radius, 50
	mov sides, 64
	mov bx, time
	mov rot, bx
	push linec
	mov linec, 5
	call drawshape
	pop linec
ret

shape db 0

;; Choose which shape to draw
frame:
	cmp shape, 1
	jne shape2
		call shape_square
		ret
	shape2:
	cmp shape, 2
	jne shape3
		call shape_triangle
		ret
	shape3:
	cmp shape, 3
	jne shape4
		call shape_pentagon
		ret
	shape4:
	cmp shape, 4
	jne shape5
		call shape_circle
		ret
	shape5:
	cmp shape, 5
	jne shape6
		call shape_keo
		ret
	shape6:
	cmp shape, 6
	jne shape7
		call shape_zelda
		ret
	shape7:
	cmp shape, 7
	jne shape0
		call shape_rotato
		ret
	shape0:
	jmp shape_end
ret

prevframe dw 0

start:
        set_display

        init_table

        dploop:
            ;; Idea: Instead of clearing the screen whole, just draw the last frame with blackness on our next frame.
            moveframe

            ;; Check if color needs to be changed
            test time, 111111b
            jnz nocol
                ;; Change color
                ;; we want to avoid color 0 because it's black
                mov ah, color
                and ah, 111b
                inc ah
                mov color, ah
            nocol:

            ;; Check if shape needs to be changed
            test time, 11111111b
            jnz noshape
                ;; Change shape
                mov ah, shape
                and ah, 111b
                inc ah
                mov shape, ah
            noshape:

            ;; Draw the shapes
            call frame

            ;;waits ;; wait for milliseconds before next frame (faster, but no vsync)

            ;; Busyloop with system time, fps 18.2
            busyloop:
                mov ah, 0
                int 1ah	;; Get system time to dx
                cmp dx, prevframe
            je busyloop
            mov prevframe, dx
            
            chkeyend

            ;; Draw the frame again with blackness, effectively clearing the screen
            mov clear, 0
            call frame
            mov clear, 11111111b

            ;; Increase time
            mov cx, time
            inc cx
            mov time, cx
        jmp dploop

        ; wait for keypress to terminate the program
        wait_keypress

        ;; Exit code
        exit:
        unset_display

        ; terminate
        mov ax, 4c00h
        int 21h
end start
