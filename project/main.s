  processor 6502

CHROUT  = $FFD2
PLOT    = $FFF0
SCREEN  = $900f
INPUT   = $00C5
GETIN   = $FFE4
CHARSET = $9005

SCR     = $1E00
SCR2    = $1EE6

JIFFY1  = $00A2     ; n * 256^2
JIFFY2  = $00A1     ; n * 256^1
JIFFY3  = $00A0     ; n * 256^0

TIMERESET1  = #3
TIMERESET2  = #0
TIMERESET3  = #0

; CHARACTER codes
ROBBER_R    = #64
ROBBER_R_1  = #65
ROBBER_R_2  = #66

ROBBER_L    = #67
ROBBER_L_1  = #68
ROBBER_L_2  = #69

ROBBER_VL_1 = #70
ROBBER_VL_2 = #71
ROBBER_VR_1 = #72
ROBBER_VR_2 = #73

WALL        = #74
EXITDOOR    = #75

ASCII_0     = #76
ASCII_1     = #77
ASCII_2     = #78
ASCII_3     = #79
ASCII_4     = #80
ASCII_5     = #81
ASCII_6     = #82
ASCII_7     = #83
ASCII_8     = #84
ASCII_9     = #85

EMPTY_SPACE_CHAR  = #86
HEART_CHAR        = #87
TIMER_MAX_VALUE   = #15

  include "zeropage.s"

  org $1001
  incdir "project"
  include "stub.s"
  
comp_data
  incbin "titlescreen.zx02"

level1_data
  incbin "level1.data"

timer_value:
    .BYTE #69         ; Nice

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
  sta timer_value

  lda JIFFY1
  sta LASTJIFFY

  lda #0
  sta JIFFIES_SINCE_SECOND

setup:
  lda #$ff              ; loading 255 into $9005 makes the vic look at $1c00 for characters instead
  sta CHARSET             ; the above can be found on pages 84

init:
  lda #0
  sta MOVING

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
  jsr move_up
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