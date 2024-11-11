  subroutine
load_level:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it
  ldx #0
  ldy #0
  jsr PLOT

  ; Clear the level address before doing anything
  lda #0
  sta LEVEL_LOW_BYTE
  sta LEVEL_HIGH_BYTE

  lda CURRENT_LEVEL       ; Load the level we are at
  beq .load_level_address ; skip multiply if level is 0
  sta LEVEL_LOW_BYTE      ; Use the low byte as the counter

 ; Calculate the level address 
.multiply:
  clc                     ; Clear carry to prepare for addition
  lda LEVEL_HIGH_BYTE     ; Load the high byte
  adc #LEVEL_SIZE         ; Add the level size
  sta LEVEL_HIGH_BYTE     ; store the updated value into the high byte

  dec LEVEL_LOW_BYTE      ; Decrement the multiply counter
  bne .multiply           ; If not zero, keep multiplying

.load_level_address:
  clc
  lda #<level_data        ; Load base address low byte
  adc LEVEL_HIGH_BYTE     ; Add offset
  sta LEVEL_LOW_BYTE      ; Low byte becomes indirect index addressing 
  lda #>level_data        ; Load base address high byte
  adc #0                  ; Add carry if any
  sta LEVEL_HIGH_BYTE     ; Store in back in high byte 

  lda PLAYER_LIVES
  tay
  iny

  lda #2                  ; Set X to red
  sta $0286               ; Store X into current color code address
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
  inx
  cpx #20
  bne .inc_bitwise
  lda #WALL
  jsr CHROUT
  jsr CHROUT
  ldx #0

.inc_bitwise:
  lda BITWISE
  cmp #128
  beq .end_loop_byte
  asl BITWISE
.loop_byte:
  lda (LEVEL_LOW_BYTE),y
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
  iny
  cpy #50
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
  ldy #51
  lda (LEVEL_LOW_BYTE),y
  tax
  stx X_POS
  dey
  lda (LEVEL_LOW_BYTE),y
  tay
  sty Y_POS
  clc
  jsr PLOT
  lda #ROBBER_R
  jsr CHROUT

.load_exit:
  ldy #53
  lda (LEVEL_LOW_BYTE),y
  tax
  stx EXIT_X
  dey
  lda (LEVEL_LOW_BYTE),y
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
