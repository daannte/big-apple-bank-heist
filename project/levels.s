  subroutine
load_level:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it
  ldx #0
  ldy #0
  jsr PLOT

  lda PLAYER_LIVES
  tay
  iny

  lda #2              ; Set X to red
  sta $0286           ; Store X into current color code address
.show_lives:
  lda #HEART_CHAR
  jsr CHROUT
  dey
  bne .show_lives

  lda #1              ; Set X to white
  sta $0286         

  lda #22
  sbc PLAYER_LIVES
  tax

.repeat:
  lda #EMPTY_SPACE_CHAR
  jsr CHROUT
  dex
  bne .repeat

.top_row:
  lda #WALL
  jsr CHROUT
  iny
  cpy #23
  bne .top_row
  ldy #0

.load_character:
  lda #1
  sta BITWISE
  jmp .loop_byte

.inc_char:
  iny
  tya
  cmp #20
  bne .inc_bitwise
  lda #WALL
  jsr CHROUT
  jsr CHROUT
  ldy #0

.inc_bitwise:
  lda BITWISE
  cmp #128
  beq .end_loop_byte
  asl BITWISE
.loop_byte:
  lda level1_data,x
  and BITWISE
  beq .empty_space
  lda #WALL
  jsr CHROUT
  jmp .inc_char

.empty_space:
  lda #EMPTY_SPACE_CHAR
  jsr CHROUT
  jmp .inc_char

.end_loop_byte:
  inx
  txa
  cmp #50
  bne .load_character
  ldy #0

.bottom_row:
  lda #WALL
  jsr CHROUT
  iny
  cpy #20
  bne .bottom_row
  lda #10
  sta $1FF9

.load_player:
  ldx #51
  lda level1_data,x
  tax
  stx X_POS
  ldy #50
  lda level1_data,y
  tay
  sty Y_POS
  clc
  jsr PLOT
  lda #ROBBER_R
  jsr CHROUT

.load_exit:
  ldx #53
  lda level1_data,x
  tax
  stx EXIT_X
  ldy #52
  lda level1_data,y
  tay
  sty EXIT_Y
  clc
  jsr PLOT
  lda #EXITDOOR
  jsr CHROUT

.show_timer:
  ldx #0
  ldy #20
  clc
  jsr PLOT
  jsr toAscii

.set_position:
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  rts