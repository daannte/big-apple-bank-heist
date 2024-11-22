; render.s
; Rendering Objects Subroutines
    subroutine

; Subroutine : Render Game
; Description : Render game objects
render_game:
    rts

; Subroutine : Draw player
; Description : Draws Player Character
draw_player:
    ldx X_POS
    ldy Y_POS
    clc
    jsr PLOT
    lda CURRENT
    jsr CHROUT
    rts 

; Subroutine : Load Level
; Description : Level Data is included during compile as level<n>
;               Each level pointer is ds.w, to cover for 16+ levels
load_level:
    jsr clear_scr
.load_level_address
    lda CURRENT_LEVEL           ; Load level index
    asl
    tay

    lda level_pointers,Y
    sta LEVEL_LOW_BYTE
    lda level_pointers+1,Y
    sta LEVEL_HIGH_BYTE
  
    lda #1                      ; Set X to White (Walls and PC)
    sta $0286

; Reposition Cursor Position here,
; Display HUD (lives and timer) moved to separate subroutine
    ldx #1
    ldy #22
    jsr PLOT

    ldy #0
.top_row:
  lda #WALL
  jsr CHROUT
  iny
  cpy #22
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
  cpy #21
  bne .bottom_row
  lda #10
  sta $1FF9

; Subroutine : Draw HUD
; Description : Displays timer, Player lives, and score
draw_hud:
    jsr draw_score
    jsr draw_lives
    jsr draw_timer

; Subroutine : Draw Score
; Description : Display Score
draw_score:
    ; Implement score drawing logic
    rts

; Subroutine : Draw lives
; Description : Display Player Lives
draw_lives:
    ; Implement lives drawing logic
    rts

; Subroutine : Draw Timer
; Description : Displays Timer
draw_timer:
    ; Implement timer drawing logic
    rts