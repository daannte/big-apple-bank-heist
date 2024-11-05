CHROUT  = $FFD2
PLOT    = $FFF0
SCREEN  = $900f
INPUT   = $00C5
GETIN   = $FFE4
CHARSET = $9005

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

WALL        = #74
EXITDOOR        = #75

; MOVEMENT addresses
HORIZONTAL = $1DF6; 0 = left, 1 = right
VERTICAL = $1DF7; 0 = up, 1 = down
MOVING  = $1DF8
X_POS   = $1DF9
Y_POS   = $1DFA

PLAYER_LIVES = $00   ; Store player lives 

; ZX02 VARS
ZP        = $80
offset_hi = ZP+0
ZX0_src   = ZP+1
ZX0_dst   = ZP+3
bitr      = ZP+5
pntr      = ZP+6
out_addr = $1e00

BITWISE = $1DF6

; BASIC stub
  processor 6502
  org $1001
    dc.w nextstmt       
    dc.w 10             
    dc.b $9e, [bg]d, 0 
nextstmt               
    dc.w 0              

out_addr = $1e00

  incdir "project"

comp_data:
  incbin "titlescreen.zx02"


level1_data:
  incbin "level1.data"

bg:
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

titlescreen:
  jsr draw_titlescreen

title_input_loop:
  jsr GETIN
  cmp #00               ; Keep looping until we get a value
  beq title_input_loop

textcolor:
  ldx #1              ; Set X to white
  stx $0286           ; Store X into current color code address

start:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

  lda #2
  sta PLAYER_LIVES      ; 2 is interpreted as 3 lives because of how BNE works

setup:
  lda #$ff              ; loading 255 into $9005 makes the vic look at $1c00 for characters instead
  sta $9005             ; the above can be found on pages 84

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
  cmp #0
  beq titlescreen
  jmp init

loop:
  jsr increment_timer
  jmp read_input

; -------- SUBROUTINES --------

load_level:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it
  ldx #0
  ldy #0
  jsr PLOT

top_row:
  lda #WALL
  jsr CHROUT
  iny
  cpy #23
  bne top_row
  ldy #0

load_character:
  lda #1
  sta BITWISE
  jmp loop_byte

inc_char:
  iny
  tya
  cmp #20
  bne inc_bitwise
  lda #WALL
  jsr CHROUT
  jsr CHROUT
  ldy #0

inc_bitwise:
  lda BITWISE
  cmp #128
  beq end_loop_byte
  asl BITWISE
loop_byte:
  lda level1_data,x
  and BITWISE
  beq empty_space
  lda #WALL
  jsr CHROUT
  jmp inc_char

empty_space:
  lda #32
  jsr CHROUT
  jmp inc_char

end_loop_byte:
  inx
  txa
  cmp #50
  bne load_character
  ldy #0

bottom_row:
  lda #WALL
  jsr CHROUT
  iny
  cpy #21
  bne bottom_row

load_player:
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

load_exit:
  ldx #53
  lda level1_data,x
  tax
  ldy #52
  lda level1_data,y
  tay
  clc
  jsr PLOT
  lda #EXITDOOR
  jsr CHROUT

set_position:
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  rts

; --------------------------------

move_up:
  lda X_POS
  beq end_move_up

  lda #0
  sta VERTICAL

  lda HORIZONTAL
  beq move_up1
  lda #ROBBER_VL_2
  jmp move_up2

move_up1:
  lda #ROBBER_VR_2

move_up2:
  jsr CHROUT

  dec X_POS
  ldy Y_POS
  ldx X_POS
  clc
  jsr PLOT

  lda HORIZONTAL
  beq move_up3
  lda #ROBBER_VL_1
  jmp move_up4

move_up3:
  lda #ROBBER_VR_1

move_up4:
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

  lda #1
  sta VERTICAL

  lda HORIZONTAL
  beq move_down1
  lda #ROBBER_VL_1
  jmp move_down2

move_down1:
  lda #ROBBER_VR_1

move_down2:
  jsr CHROUT

  inc X_POS
  ldy Y_POS
  ldx X_POS
  clc
  jsr PLOT

  lda HORIZONTAL
  beq move_down3
  lda #ROBBER_VL_2
  jmp move_down4

move_down3:
  lda #ROBBER_VR_2

move_down4:
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

  lda #1
  sta HORIZONTAL

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

  lda #0
  sta HORIZONTAL

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

; -------------------

handle_lives:
  lda PLAYER_LIVES
  bne dec_lives

  lda #$f0                ; loading 240 into CHARSET to reset character set for titlescreen 
  sta CHARSET             ; the above can be found on page 267

  lda #0
  rts

dec_lives:
  dec PLAYER_LIVES
  lda #1

end_handle_lives:
  rts

; -------------------

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
  lda VERTICAL
  cmp #255
  beq skip_animate
  ldx X_POS
  ldy Y_POS
  lda CURRENT
  cmp #ROBBER_R_2
  beq animate_r
  cmp #ROBBER_L_1
  beq animate_l
  lda VERTICAL
  beq animate_u
  jmp animate_d

skip_animate:
  lda #0
  sta VERTICAL
  rts

animate_r:
  dey
  clc
  jsr PLOT
  lda #32
  jsr CHROUT
  lda #ROBBER_R
  jsr CHROUT
  jmp end_animate

animate_l:
  iny
  clc
  jsr PLOT
  lda #32
  jsr CHROUT
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  lda #ROBBER_L
  jsr CHROUT
  jmp end_animate

animate_u:
  inx
  clc
  jsr PLOT
  lda #32
  jsr CHROUT
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  lda HORIZONTAL
  beq animate_ul
  lda #ROBBER_R
  jmp animate_u1

animate_ul:
  lda #ROBBER_L

animate_u1:
  jsr CHROUT
  jmp end_animate

animate_d:
  dex
  clc
  jsr PLOT
  lda #32
  jsr CHROUT
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  lda HORIZONTAL
  beq animate_dl
  lda #ROBBER_R
  jmp animate_d1

animate_dl:
  lda #ROBBER_L

animate_d1:
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

wall:
  dc.b %10101010
  dc.b %01010101
  dc.b %10101010
  dc.b %01010101
  dc.b %10101010
  dc.b %01010101
  dc.b %10101010
  dc.b %01010101

exitdoor:
  dc.b %11111111
  dc.b %11111111
  dc.b %11000011
  dc.b %11000011
  dc.b %11000011
  dc.b %11000011
  dc.b %11000011
  dc.b %11000011

  include "zx02.s"
  include "titlescreen.s"