	processor 6502

; KERNAL [sic] addresses
CHROUT  = $ffd2
CHRIN   = $ffcf
SCNKEY  = $ff9f
GETIN   = $ffe4
SCR     = $1e00
SCREEN  = $900f

; Address for coordinates
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

bg
  ldx #0
  lda SCREEN
  and #$0f
  stx $1001
  ora $1001
  sta SCREEN

init
  lda #5
  sta X_POS
  lda #5
  sta Y_POS
  jmp readkey

  ; Calculate Memory Location Address to draw Character.
  ; Screen memory location is $1e00 + X position * 22 + Y position
  ; To multiply by 22, Left shift 4 times ( *16 ), and add lsb 2 times ( *4 ) 
  ; and add lsb 1 time ( *2 )
  ; (16X + 4X + 2X)

  ; POS = $1dde - check memory map to see offset value change

calculatePOS
  lda X_POS             ; Load X_POS in accumulator
  asl                   ; left shift
  asl                   ; left shift
  asl                   ; left shift
  asl                   ; left shift
  sta TEMP1             ; multiply by 16 (shift 4 times) and store temporarily in X register

  lda X_POS             ; Load (again) X_POS in accumulator
  asl                   ; left shift
  sta TEMP2             ; Store left shifted (*2) value in TEMP2 address
  asl                   ; Let shift
  clc                   ; Clear carry for addition
  adc TEMP2             ; Add (*2) to (*4)
  clc                   ; Clear carry
  adc TEMP1             ; Add (*16) 
  
  sta TEMP1             ; 22X
  lda Y_POS             ; Load Y val to accumulator
  clc                   ; clear carry 
  adc TEMP1             ; Y val + 22x
  sta POS               ; save result in POS address
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
  lda Y_POS
  cmp #23
  beq readkey
  inc Y_POS
  jsr calculatePOS
  jmp readkey

a_key
  lda X_POS
  cmp #0
  beq readkey
  dec X_POS
  jsr calculatePOS
  jmp readkey

s_key
  lda Y_POS
  cmp #0
  beq readkey
  dec Y_POS
  jsr calculatePOS
  jmp readkey

d_key
  lda X_POS
  cmp #22
  beq readkey
  inc X_POS
  jsr calculatePOS
  jmp readkey

end
  rts
