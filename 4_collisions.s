	processor 6502

; KERNAL [sic] addresses
CHROUT  = $ffd2
GETIN   = $ffe4
SCR     = $1e00
SCREEN  = $900f
PLOT   = $FFF0
SETCOLOR = $0286
CHAR_CODE	= $1DE7

; Address for coordinates
X_POS   = $1DDA
Y_POS   = $1DDB
TEMP1   = $1DDC
TEMP2   = $1DDD
POS     = $1DDE
PREV_X_POS    = $1DE2
PREV_Y_POS    = $1DE3
PREVIOUS_POS    = $1DE5

  org $1001

; Basic stub
  dc.w nextstmt
	dc.w 10
	dc.b $9e, "4109", 0
nextstmt
  dc.w 0

; Program Start
clr
  lda #147
  jsr CHROUT

bg:
  ldx #0              ; Set X to black
  lda SCREEN          ; Load the screen colour address
  and #$0F            ; Reset the 4 background bits
  stx $1001           ; Store X into the user basic area memory
  ora $1001           ; Combine new background color with the screen
  sta SCREEN          ; Store new colour into the screen colour address

border:
  ldx #0              ; Set X to black
  lda SCREEN          ; Load the screen colour address
  and #$F8            ; Reset the 3 border bits
  stx $1001           ; Store X into the user basic area memory
  ora $1001           ; Combine new border colour with the screen 
  sta SCREEN          ; Store new colour into the screen colour address

init:
	lda #19
	sta X_POS
	sta PREV_X_POS
	lda #17
	sta Y_POS
	sta PREV_Y_POS

	;collider colour
	lda #3
    sta SETCOLOR

	;diamonds
	clc
	ldx #4
	ldy #19
	jsr PLOT
	lda #122
	jsr CHROUT

	clc
	ldx #5
	ldy #19
	jsr PLOT
	lda #122
	jsr CHROUT

	clc
	ldx #6
	ldy #19
	jsr PLOT
	lda #122
	jsr CHROUT

	clc
	ldx #7
	ldy #19
	jsr PLOT
	lda #122
	jsr CHROUT

	;arrow
	clc
	ldx #7
	ldy #19
	jsr PLOT
	lda #122
	jsr CHROUT

	;mapWalls
	lda #1
    sta SETCOLOR

	;wall stuff
    ldx #0
    ldy #1
    clc
    jsr PLOT
    ldx #20
topWall:
    lda #166
    jsr CHROUT
    dex
    bne topWall
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #21
    ldy #0
wallLeft:
    clc
    jsr PLOT

    lda #166
    jsr CHROUT
    dex

    bne wallLeft
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #21
    ldy #21
wallRight:
    clc
    jsr PLOT

    lda #166
    jsr CHROUT
    dex

    bne wallRight
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #11
    ldy #5
    clc
    jsr PLOT

    ldy #16
middleArea:
    lda #166
    jsr CHROUT
    dey
    bne middleArea
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #22
    ldy #1
    clc
    jsr PLOT

    ldy #20
bottomWall:
    lda #166
    jsr CHROUT
    dey
    bne bottomWall
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

	;change colour
	lda #2
	sta SETCOLOR

	;this draws the initial player
	clc
	ldx #17
	ldy #19
	jsr PLOT
	lda #115
	jsr CHROUT

	clc
	ldx #17
	ldy #10
	jsr PLOT
	lda #95
	jsr CHROUT

	jmp readkey

;had to hardcode because not sure how to get the character code from the memory address
;will update when I find out
checkCollision:
	jsr calculatePOS
	lda POS
	sta CHAR_CODE

	cmp #$F7
    beq pathBlocked

	cmp #$F8
    beq pathBlocked

	cmp #$F9
    beq pathBlocked

	cmp #$FA
    beq pathBlocked

	cmp #$FB
    beq pathBlocked

	cmp #$FC
    beq pathBlocked

	cmp #$FD
    beq pathBlocked

	cmp #$FE
    beq pathBlocked

	cmp #$FF
    beq pathBlocked

	cmp #$01
    beq pathBlocked

	cmp #$02
    beq pathBlocked

	cmp #$03
    beq pathBlocked

	cmp #$04
    beq pathBlocked	

	cmp #$05
    beq pathBlocked

	cmp #$06
    beq pathBlocked

	jmp charIsEmpty ; Proceed with movement

pathBlocked:
	;colour
	lda #2
    sta SETCOLOR

	lda PREVIOUS_POS
	sta POS

	lda PREV_Y_POS
	sta Y_POS

	lda PREV_X_POS
	sta X_POS

	lda #0
	rts

charIsEmpty:
	lda #2
    sta SETCOLOR

	clc
	ldx #17
	ldy #10
	jsr PLOT
	lda #95
	jsr CHROUT

	;this draws the new character
    ldx Y_POS
    ldy X_POS
    clc
    jsr PLOT
	lda #115
	jsr CHROUT

	;this deletes the old character and replaces it with a blank
    ldx PREV_Y_POS
    ldy PREV_X_POS
	clc
    jsr PLOT
	lda #$20
    jsr CHROUT

	lda Y_POS
	sta PREV_Y_POS

	lda X_POS
	sta PREV_X_POS

	lda #0

	rts

; Calculate Memory Location Address to draw Character.
; Screen memory location is $1e00 + Y position * 22 + X position
; To multiply by 22, Left shift 4 times ( *16 ), and add lsb 2 times ( *4 ) 
; and add lsb 1 time ( *2 )
; (16Y + 4Y + 2Y)

; POS = $1dde - check memory map to see offset value change
calculatePOS
	lda POS					;storing the previous position in PREVIOUS_POS
	sta PREVIOUS_POS 

	lda Y_POS             ; Load Y_POS in accumulator
	asl                   ; left shift
	asl                   ; left shift
	asl                   ; left shift
	asl                   ; left shift
	sta TEMP1             ; multiply by 16 (shift 4 times) and store temporarily in X register

	lda Y_POS             ; Load (again) Y_POS in accumulator
	asl                   ; left shift
	sta TEMP2             ; Store left shifted (*2) value in TEMP2 address
	asl                   ; Let shift
	clc                   ; Clear carry for addition
	adc TEMP2             ; Add (*2) to (*4)
	clc                   ; Clear carry
	adc TEMP1             ; Add (*16) 

	sta TEMP1             ; 22X
	lda X_POS             ; Load X val to accumulator
	clc                   ; clear carry 
	adc TEMP1             ; X val + 22Y
	sta POS               ; save result in POS address
	lda #0

	rts

; Main Loop - Read key, recalculate position on screen
readkey:
	; Loading from 197, or current key pressed doesn't handle multiple keys - I think
	; situation - moving left, and while holding left, press pickaxe.
	; or moving left then quickly switching to right while left is still pressed - doesn't register
	jsr GETIN     ; Read from keyboard buffer
	cmp #0        ; if no key from buffer, go back to read
	beq readkey

	cmp #87       ; W key
	beq w_key
	cmp #65       ; A key
	beq a_key
	cmp #83       ; S key
	beq s_key
	cmp #68       ; D key
	beq d_key
  	jmp readkey

w_key:
	lda Y_POS
	cmp #1
	beq readkey
	dec Y_POS
	jsr checkCollision
	jmp readkey

s_key:
  	lda Y_POS
	cmp #21
	beq readkey
	inc Y_POS
	jsr checkCollision
	jmp readkey

a_key:
	lda X_POS
	cmp #1
	beq readkey
	dec X_POS
	jsr checkCollision
	jmp readkey

d_key:
	lda X_POS
	cmp #20
	beq readkey
	inc X_POS
	jsr checkCollision
	jmp readkey

end:
	rts
