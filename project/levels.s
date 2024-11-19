  subroutine
load_level:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

.load_level_address:
  ; Load level index
  lda CURRENT_LEVEL
  asl
  tay

  lda level_pointers,y
  sta LEVEL_LOW_BYTE
  lda level_pointers+1,y
  sta LEVEL_HIGH_BYTE

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

.load_timer
  ldy #54
  lda (LEVEL_LOW_BYTE),y
  sta TIMER_VALUE

.load_traps:
  lda #55                   
  sta TRAP_INDEX

.load_next_trap:
  ldy TRAP_INDEX

  lda (LEVEL_LOW_BYTE),y    ; Load trap X position
  beq .load_guards          ; If X position is 0, end of traps
  pha                       ; Store X position in stack for later 

  iny
  lda (LEVEL_LOW_BYTE),y    ; Load trap Y position
  tax                       ; Store Y position in X register

  pla                       ; Pull X from stack
  tay                       ; Store X position in Y register

  clc
  jsr PLOT
  lda #TRAP
  jsr CHROUT

  ; Increment twice because traps take 2 bytes
  inc TRAP_INDEX
  inc TRAP_INDEX

  jmp .load_next_trap

.load_guards:
  iny
  sty GUARD_INDEX

.load_next_guard:
  ldy GUARD_INDEX

  lda (LEVEL_LOW_BYTE),y    ; Load trap X position
  beq .show_timer           ; If X position is 0, end of traps
  pha                       ; Store X position in stack for later 

  ldx NUM_OF_GUARDS         ; Get the current guard
  sta GUARDS_X_POS,x        ; Store the guard's X position

  iny
  lda (LEVEL_LOW_BYTE),y    ; Load trap Y position
  sta GUARDS_Y_POS,x        ; Store the guard's Y position
  tax                       ; Store Y position in X register

  pla                       ; Pull X from stack
  tay                       ; Store X position in Y register

  clc
  jsr PLOT
  lda #GUARD
  jsr CHROUT

  ; Increment twice because guards take 2 bytes
  inc GUARD_INDEX
  inc GUARD_INDEX

  inc NUM_OF_GUARDS

  jmp .load_next_guard

.show_timer:
  ldx #0
  ldy #20
  clc
  jsr PLOT
  jsr print_bcd

.set_position:
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  rts
