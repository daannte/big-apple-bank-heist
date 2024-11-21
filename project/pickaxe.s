subroutine

swing_pickaxe:
  lda HORIZONTAL
  cmp #00
  beq check_left
  cmp #01
  beq check_right
  rts

check_left:
  lda MOVING
  cmp #01
  bne .end_swing
  jmp facing_left

check_right:
  lda MOVING
  cmp #01
  bne .end_swing
  jmp facing_right

.end_swing:
  rts

facing_left:
  lda Y_POS
  cmp #1
  beq .end_move
  dec Y_POS
  jsr check_collision
  cmp #1
  beq mineable_left
  lda #0
  sta MINEABLE
  inc Y_POS
  rts

mineable_left:
  lda #1
  sta MINEABLE

  lda #1
  sta MOVING
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  lda #EMPTY_SPACE_CHAR
  jsr CHROUT
  inc Y_POS
  
  jmp facing_left
  rts

facing_right:
  lda Y_POS
  cmp #20
  beq .end_move
  inc Y_POS
  jsr check_collision
  cmp #1
  beq mineable_right
  lda #0
  sta MINEABLE
  dec Y_POS
  rts

mineable_right:
  lda #1
  sta MINEABLE

  lda #1
  sta MOVING
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  lda #EMPTY_SPACE_CHAR
  jsr CHROUT
  dec Y_POS

  jmp facing_right
  rts

.end_move:
 ; lda #0
 ; sta MINEABLE
  rts

