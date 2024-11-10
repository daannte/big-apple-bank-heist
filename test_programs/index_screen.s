	processor 6502

; KERNAL [sic] addresses
CHROUT  = $ffd2
CHRIN   = $ffcf
SCNKEY  = $ff9f
GETIN   = $ffe4
SCR     = $1e00
SCR2    = $1EFA
SCREEN  = $900f

; Address for coordinates
WHICH_ADDR = $1DD8
X_POS   = $1DDA
Y_POS   = $1DDB
TEMP1   = $1DDC
TEMP2   = $1DDD
POS     = $1DDE

START_X = #5
START_Y = #5

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
  ; PRESS WASD TO MOVE
  ; WRITES WITHOUT
  ; USING PLOT
  lda #'P
  jsr CHROUT
  lda #'R
  jsr CHROUT
  lda #'E
  jsr CHROUT
  lda #'S
  jsr CHROUT
  lda #'S
  jsr CHROUT
  lda #32
  jsr CHROUT
  lda #'W
  jsr CHROUT
  lda #'A
  jsr CHROUT
  lda #'S
  jsr CHROUT
  lda #'D
  jsr CHROUT
  lda #32
  jsr CHROUT
  lda #'T
  jsr CHROUT
  lda #'O
  jsr CHROUT
  lda #32
  jsr CHROUT
  lda #'M
  jsr CHROUT
  lda #'O
  jsr CHROUT
  lda #'V
  jsr CHROUT
  lda #'E
  jsr CHROUT
  lda #13
  jsr CHROUT
  lda #'W
  jsr CHROUT
  lda #'R
  jsr CHROUT
  lda #'I
  jsr CHROUT
  lda #'T
  jsr CHROUT
  lda #'E
  jsr CHROUT
  lda #'S
  jsr CHROUT
  lda #32
  jsr CHROUT
  lda #'W
  jsr CHROUT
  lda #'I
  jsr CHROUT
  lda #'T
  jsr CHROUT
  lda #'H
  jsr CHROUT
  lda #'O
  jsr CHROUT
  lda #'U
  jsr CHROUT
  lda #'T
  jsr CHROUT
  lda #13
  jsr CHROUT
  lda #'U
  jsr CHROUT
  lda #'S
  jsr CHROUT
  lda #'I
  jsr CHROUT
  lda #'N
  jsr CHROUT
  lda #'G
  jsr CHROUT
  lda #32
  jsr CHROUT
  lda #'P
  jsr CHROUT
  lda #'L
  jsr CHROUT
  lda #'O
  jsr CHROUT
  lda #'T
  jsr CHROUT

bg
  ldx #0
  lda SCREEN
  and #$0f
  stx $1001
  ora $1001
  sta SCREEN

init
  ldx #5
  stx X_POS
  ldy #5
  sty Y_POS
  jmp readkey

  ; Calculate Memory Location Address to draw Character.
  ; Screen memory location is $1e00 + Y position * 22 + X position
  ; To multiply by 22, Left shift 4 times ( *16 ), and add lsb 2 times ( *4 ) 
  ; and add lsb 1 time ( *2 )
  ; (16Y + 4Y + 2Y)

calculatePOS
  lda #147
  jsr CHROUT
  lda X_POS
  cmp #11
  bcc baseaddr
  lda X_POS
  cmp #11
  bne midaddr
  lda Y_POS
  cmp #11
  bcc baseaddr

midaddr
  lda #2
  sta WHICH_ADDR
  lda X_POS
  sec
  sbc #10
  asl
  asl
  asl
  asl
  sta TEMP1

  lda X_POS
  asl
  sta TEMP2

  asl
  clc
  adc TEMP2
  clc
  adc TEMP1
  
  sta TEMP1
  lda Y_POS
  sec
  sbc #90 ; for some reason, the magic number is 69

  clc
  adc TEMP1
  sta POS  
  ldx POS
  lda #65
  sta SCR2,x
  rts

baseaddr
  lda #1
  sta WHICH_ADDR
  lda X_POS
  asl
  asl
  asl
  asl
  sta TEMP1
  lda X_POS
  asl
  sta TEMP2
  asl
  clc
  adc TEMP2
  clc
  adc TEMP1
  sta TEMP1
  lda Y_POS
  clc
  adc TEMP1
  sta POS  
  ldx POS
  lda #65
  sta SCR,x
  rts
  
  

  ; Main Loop - Read key, recalculate position on screen
readkey
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


w_key
  lda X_POS
  beq readkey
  dec X_POS
  jsr calculatePOS
  jmp readkey

a_key
  lda Y_POS
  beq readkey
  dec Y_POS
  jsr calculatePOS
  jmp readkey

s_key
  lda X_POS
  cmp #22
  beq readkey
  inc X_POS
  jsr calculatePOS
  jmp readkey

d_key
  lda Y_POS
  cmp #21
  beq readkey
  inc Y_POS
  jsr calculatePOS
  jmp readkey

end
  rts
