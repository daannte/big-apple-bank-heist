  processor 6502

  incdir "project"
  include "constants.s"
  include "zeropage.s"
  org $1001
  include "stub.s"
  
comp_data
  incbin "titlescreen.zx02"

level_pointers
  dc.w level_1
  dc.w level_2
  dc.w level_3

level_1
  incbin "levels/level1.data"
level_2
  incbin "levels/level2.data"
level_3
  incbin "levels/level3.data"

start:
  lda #$80
  sta $028A           ; Key repeats - needed for XVIC emulator
  lda #$0F            ; Border Black
  jsr setbg
  lda #$F8            ; BG Black 
  jsr setbg
  ldx #1
  stx $0286
  lda #147            ; Load clear screen command
  jsr CHROUT          ; Print it

titlescreen:
  jsr draw_titlescreen

game:
  lda #0
  sta CURRENT_LEVEL   ; Set the current_level to the first
  sta SCORE1
  sta SCORE2

  lda #2
  sta PLAYER_LIVES    ; 2 is interpreted as 3 lives because of how BNE works

  lda JIFFY1
  sta LASTJIFFY

init:
  lda #CUSTOM_ASCII_0
  sta ASCII_OFFSET
  lda #$ff              ; loading 255 into $9005 makes the vic look at $1c00 for characters instead
  sta CHARSET             ; the above can be found on pages 84
  lda #0
  sta MOVING
  sta JIFFIES_SINCE_SECOND

  lda #GRAVITY_MAX_COOLDOWN
  sta GRAVITY_COOLDOWN

  lda #255
  sta VERTICAL

  lda #1
  sta HORIZONTAL
  
  lda #TIMERESET1       ; 60 * 256^0 = 60 jiffies
  sta TIMER1            ; store the timer value in address TIMER1

  lda #TIMERESET2       ; 0 * 256^1 = 0 jiffies
  sta TIMER2            ; store the timer value in address TIMER2

  lda #TIMERESET3       ; 0 * 256^2 = 0 jiffies
  sta TIMER3            ; store the timer value in address TIMER3

  jsr load_level
  jsr main_loop
  cmp #0
  beq start
  jmp init

main_loop:
  jsr move_guards
read_input:
  lda MOVING
  beq loop
  jsr gravity
  lda MOVING
  beq loop
  
  jsr GETIN
  cmp #87
  beq w_key
  cmp #65
  beq a_key
  cmp #68
  beq d_key
  cmp #83
  beq s_key
  cmp #32
  beq space_key
  jmp loop

w_key:
  lda CAN_JUMP
  beq loop
  lda #0
  sta CAN_JUMP
  jsr move_up
  lda #GRAVITY_JUMP_COOLDOWN
  sta GRAVITY_COOLDOWN
  jmp loop

a_key:
  jsr move_left
  jmp loop

d_key:
  jsr move_right
  jmp loop

s_key:
  jsr move_down
  jmp loop

space_key:
  jsr handle_lives
  rts

setbg:
  and SCREEN 
  sta SCREEN
  rts

loop:
  lda X_POS
  cmp EXIT_X
  bne not_exited
  lda Y_POS
  cmp EXIT_Y
  bne not_exited
  jmp increment_level

not_exited:
  jsr increment_clock
  cmp #0
  bne space_key
  jmp main_loop

increment_level:
  jsr add_score
  inc CURRENT_LEVEL   ; Increment CURRENT_LEVEL
  lda CURRENT_LEVEL
  cmp #MAX_LEVELS     ; If max level reached, render next level, else die
  beq game_win
  lda #ASCII_0
  sta ASCII_OFFSET
  lda #$f0
  sta CHARSET
  lda #147
  jsr CHROUT
  jsr print_score
  jmp init

game_win:
  jsr load_endscreen
  lda #0
  sta PLAYER_LIVES
  jmp space_key


; -------- SUBROUTINES --------

  include "clock.s"
  include "endscreen.s"
  include "levels.s"
  include "lives.s"
  include "movement.s"
  include "guards.s"
  include "titlescreen.s"
  include "zx02.s"
  include "music.s"

; -------------------

  org $1c00
  include "charset.s"

  org $1d00
  include "musicdata.s"

