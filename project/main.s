  processor 6502

  incdir "project"
  include "constants.s"
  include "zeropage.s"
  org $1001
  include "stub.s"
  
comp_data
  incbin "titlescreen.zx02"

level1_data
  incbin "levels/level2.data"

start:
  ldx #0              ; Set X to black
  lda SCREEN          ; Load the screen colour address
  and	#$0F            ; Reset the 4 background bits
  stx $1001           ; Store X into the user basic area memory
  ora $1001           ; Combine new background color with the screen
  sta SCREEN          ; Store new colour into the screen colour address

border:
  ldx #0              ; Set X to black
  lda SCREEN          ; Load the screen colour address
  and	#$F8            ; Reset the 3 border bits
  stx $1001           ; Store X into the user basic area memory
  ora $1001           ; Combine new border colour with the screen 
  sta SCREEN          ; Store new colour into the screen colour address

textcolor:
  ldx #1              ; Set X to white
  stx $0286           ; Store X into current color code address

titlescreen:
  jsr draw_titlescreen

game:
  lda #147            ; Load clear screen command
  jsr CHROUT          ; Print it

  lda #2
  sta PLAYER_LIVES    ; 2 is interpreted as 3 lives because of how BNE works

  lda #TIMER_MAX_VALUE
  sta TIMER_VALUE

  lda JIFFY1
  sta LASTJIFFY

setup:
  lda #$ff              ; loading 255 into $9005 makes the vic look at $1c00 for characters instead
  sta CHARSET             ; the above can be found on pages 84

init:
  lda #0
  sta MOVING

  lda #0
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

loop:
  lda X_POS
  cmp EXIT_X
  bne not_exited
  lda Y_POS
  cmp EXIT_Y
  bne not_exited
  lda #0
  sta PLAYER_LIVES
  jmp space_key

not_exited:
  jsr increment_clock
  cmp #0
  bne space_key
  jmp read_input

; -------- SUBROUTINES --------

  include "clock.s"
  include "levels.s"
  include "lives.s"
  include "movement.s"
  include "titlescreen.s"
  include "zx02.s"

; -------------------

  org $1c00
  include "charset.s"
