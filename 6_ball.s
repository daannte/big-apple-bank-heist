	processor 6502

; KERNAL [sic] addresses
CHROUT  = $ffd2
CHRIN   = $ffcf
SCNKEY  = $ff9f
GETIN   = $ffe4

SCREEN = $900f


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
  jmp readkey


  ; still figuring out how to simulate movement by drawing erasing and redrawing
drawBallw
  lda #81
  sta $1e00 + 5 + 5 * 22 ; Refer to page 271 on the Bible
  jmp readkey

drawBalla
  lda #81
  sta $1e00 + 10 + 10 * 22 
  jmp readkey

drawBalls
  lda #81
  sta $1e00 + 13 + 13 * 22 
  jmp readkey

drawBalld
  lda #81
  sta $1e00 + 1 + 15 * 22
  jmp readkey

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
  jsr drawBallw
  jmp readkey
a_key
  jsr drawBalla
  jmp readkey
s_key
  jsr drawBalls 
  jmp readkey
d_key
  jsr drawBalld
  jmp readkey

end
  rts
