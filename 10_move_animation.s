  processor 6502

; KERNAL [sic] address
CHROUT  = $FFD2
PLOT    = $FFF0
SCREEN  = $900f
INPUT   = $00C5

JIFFY1  = $00A2     ; n * 256^2
JIFFY2  = $00A1     ; n * 256^1
JIFFY3  = $00A0     ; n * 256^0

CURRENT = $1DFB     ; current animation frame
LASTJIFFY = $1DFC   ; stores last known jiffy
TIMER1  = $1DFF     ; n * 256^0
TIMER2  = $1DFE     ; n * 256^1
TIMER3  = $1DFD     ; n * 256^2

TIMERESET1  = #5
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

; MOVEMENT addresses
MOVING  = $1DF8
X_POS   = $1DF9
Y_POS   = $1DFA

  org $1001   ; BASIC start address

; BASIC stub
  dc.w nextstmt       ; next BASIC statement
  dc.w 10             ; line number
  dc.b $9e, "4109", 0 ; Start of assembly program
nextstmt                ; next BASIC statement
  dc.w 0              ; end of BASIC program

  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

setup:
  lda #TIMERESET1       ; 60 * 256^0 = 60 jiffies
  sta TIMER1            ; store the timer value in address TIMER1

  lda #TIMERESET2       ; 0 * 256^1 = 0 jiffies
  sta TIMER2            ; store the timer value in address TIMER2

  lda #TIMERESET3       ; 0 * 256^2 = 0 jiffies
  sta TIMER3            ; store the timer value in address TIMER3

  lda #$ff              ; loading 255 into $9005 makes the vic look at $1c00 for characters instead
  sta $9005             ; the above can be found on pages 84

  lda #0
  sta MOVING

  lda #0
  sta X_POS
  lda #0
  sta Y_POS

  ldx #0
  ldy #0
  clc
  jsr PLOT
  lda #ROBBER_R
  sta CURRENT
  jsr CHROUT
  clc
  jsr PLOT

read_input:
  lda MOVING
  beq loop
  lda INPUT
  cmp #9
  beq w_key
  cmp #17
  beq a_key
  cmp #18
  beq d_key
  cmp #41
  beq s_key
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

loop:
  jsr increment_timer
  jmp read_input

; -------- SUBROUTINES --------

move_up:
  lda X_POS
  beq end_move_up

  lda #ROBBER_VR_2
  jsr CHROUT

  dec X_POS
  ldy Y_POS
  ldx X_POS
  clc
  jsr PLOT

  lda #ROBBER_VR_1
  sta CURRENT
  jsr CHROUT

  clc
  jsr PLOT
  lda #0
  sta MOVING
  lda #TIMERESET1
  sta TIMER1

end_move_up:
  rts
; -------------------
move_down:
  lda X_POS
  cmp #22
  beq end_move_down

  lda #ROBBER_VL_1
  jsr CHROUT

  inc X_POS
  ldy Y_POS
  ldx X_POS
  clc
  jsr PLOT

  lda #ROBBER_VL_2
  sta CURRENT
  jsr CHROUT

  clc
  jsr PLOT
  lda #0
  sta MOVING
  lda #TIMERESET1
  sta TIMER1

end_move_down:
  rts
; -------------------
move_right:
  lda Y_POS
  cmp #21
  beq end_move_right

  lda #ROBBER_R_1
  jsr CHROUT

  inc Y_POS
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT

  lda #ROBBER_R_2
  sta CURRENT
  jsr CHROUT

  clc
  jsr PLOT
  lda #0
  sta MOVING
  lda #TIMERESET1
  sta TIMER1

end_move_right:
  rts
; -------------------
move_left:
  lda Y_POS
  beq end_move_left

  lda #ROBBER_L_2
  jsr CHROUT

  dec Y_POS
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT

  lda #ROBBER_L_1
  sta CURRENT
  jsr CHROUT

  clc
  jsr PLOT
  lda #0
  sta MOVING
  lda #TIMERESET1
  sta TIMER1

end_move_left:
  rts

; increment_timer
    ; decrements the timer
increment_timer:
  lda MOVING
  bne end_timer
  lda JIFFY1              ; load current jiffy
  cmp LASTJIFFY           ; compare to last jiffy
  beq end_timer           ; if jiffy elapsed, update timer
  sta LASTJIFFY           ; store current jiffy
  lda TIMER1
  bne increment_timer1    ; if timer 1 is not 0, increment timer 1
  lda TIMER2
  bne increment_timer1    ; if timer 2 is not 0, increment timer 2
  lda TIMER3
  bne increment_timer1    ; if timer 3 is not 0, increment timer 3
  
  lda #1
  sta MOVING
  jsr animate

  jmp end_timer
    
increment_timer1:
  lda TIMER1              ; check if timer 1 is 0
  beq increment_timer2    ; if so, increment timer 2
  dec TIMER1              ; otherwise, decrement timer 1
  rts

increment_timer2:
  lda #255                ; reset timer 1
  sta TIMER1              ; store into timer 1 register
  lda TIMER2              ; check if timer 2 is 0
  beq increment_timer3    ; if so, increment timer 3
  dec TIMER2              ; otherwise, decrement timer 2
  rts

increment_timer3:
  lda #255                ; reset timer 2
  sta TIMER2              ; store into timer 2 register
  lda TIMER3              ; check if timer 3 is 0
  beq end_timer          ; if so, loop timer
  dec TIMER3              ; otherwise, decrement timer 3  

end_timer:
  rts                 ; return from subroutine


animate:
  lda #147
  jsr CHROUT
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  lda CURRENT
  cmp #ROBBER_R_2
  beq animate_r
  cmp #ROBBER_L_1
  beq animate_l
  cmp #ROBBER_VR_1
  beq animate_l
  cmp #ROBBER_VL_2
  beq animate_r
  rts

animate_r:
  lda #ROBBER_R
  jsr CHROUT
  jmp end_animate

animate_l:
  lda #ROBBER_L
  jsr CHROUT
  jmp end_animate

end_animate:
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  rts


  org $1c00

robber_r:
  dc.b %01111000
  dc.b %10011110
  dc.b %10110101
  dc.b %10011110
  dc.b %01110000
  dc.b %11111000
  dc.b %11111000
  dc.b %01010000

robber_r_1:
  dc.b %00000111
  dc.b %00001001
  dc.b %00001011
  dc.b %00001001
  dc.b %00000111
  dc.b %00001111
  dc.b %00001111
  dc.b %00000101

robber_r_2:
  dc.b %10000000
  dc.b %11100000
  dc.b %01010000
  dc.b %11100000
  dc.b %00000000
  dc.b %10000000
  dc.b %10000000
  dc.b %00000000

robber_l:
  dc.b %00011110
  dc.b %01111001
  dc.b %10101101
  dc.b %01111001
  dc.b %00001110
  dc.b %00011111
  dc.b %00011111
  dc.b %00001010

robber_l_1:
  dc.b %00000001
  dc.b %00000111
  dc.b %00001010
  dc.b %00000111
  dc.b %00000000
  dc.b %00000001
  dc.b %00000001
  dc.b %00000000

robber_l_2:
  dc.b %11100000
  dc.b %10010000
  dc.b %11010000
  dc.b %10010000
  dc.b %11100000
  dc.b %11110000
  dc.b %11110000
  dc.b %10100000

robber_vr_1:
  dc.b %00000000
  dc.b %00000000
  dc.b %00000000
  dc.b %00000000
  dc.b %01111000
  dc.b %10011110
  dc.b %10110101
  dc.b %10011110

robber_vr_2:
  dc.b %01110000
  dc.b %11111000
  dc.b %11111000
  dc.b %01010000
  dc.b %00000000
  dc.b %00000000
  dc.b %00000000
  dc.b %00000000

robber_vl_1:
  dc.b %00000000
  dc.b %00000000
  dc.b %00000000
  dc.b %00000000
  dc.b %00011110
  dc.b %01111001
  dc.b %10101101
  dc.b %01111001
  
robber_vl_2:
  dc.b %00001110
  dc.b %00011111
  dc.b %00011111
  dc.b %00001010
  dc.b %00000000
  dc.b %00000000
  dc.b %00000000
  dc.b %00000000