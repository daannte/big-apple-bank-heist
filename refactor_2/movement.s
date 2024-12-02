  subroutine
handle_input:
  lda MOVING
  beq .end_handle_input
  jsr gravity
  lda MOVING
  beq .end_handle_input
  
  jsr GETIN
  cmp #87
  beq .w_key
  cmp #65
  beq .a_key
  cmp #68
  beq .d_key
  cmp #83
  beq .s_key
  cmp #32
  beq .space_key
  jmp .end_handle_input

.w_key:
  lda CAN_JUMP
  beq .end_handle_input
  lda #0
  sta CAN_JUMP
  jsr move_up
  lda #GRAVITY_JUMP_COOLDOWN
  sta GRAVITY_COOLDOWN
  jmp .end_handle_input

.a_key:
  jsr move_left
  jmp .end_handle_input

.d_key:
  jsr move_right
  jmp .end_handle_input

.s_key:
  jsr move_down
  jmp .end_handle_input

.space_key:
  lda #0
  sta DIED

.end_handle_input:
  rts
; -------------------
  subroutine
check_collision:
  lda X_POS
  cmp #11
  bcc .baseaddr
  lda X_POS
  cmp #11
  bne .midaddr
  lda Y_POS
  cmp #11
  bcc .baseaddr

.midaddr
  lda X_POS
  sec
  sbc #10
  asl
  asl
  asl
  asl
  sta TEMP1

  lda X_POS
  asl
  sta TEMP2

  asl
  clc
  adc TEMP2
  clc
  adc TEMP1
  
  sta TEMP1
  lda Y_POS
  clc
  adc TEMP1
  sec
  sbc #90 ; for some reason, the magic number is 70
  tax
  lda SCR2,x
  jmp .check_occupied

.baseaddr
  lda X_POS
  asl
  asl
  asl
  asl
  sta TEMP1
  lda X_POS
  asl
  sta TEMP2
  asl
  clc
  adc TEMP2
  clc
  adc TEMP1
  sta TEMP1
  lda Y_POS
  adc TEMP1
  tax
  lda SCR,x

.check_occupied:
  cmp #10 ; WALL
  beq .occupied_wall
  cmp #11 ; EXITDOOR
  beq .occupied_exit
  lda #0
  rts
  
.occupied_wall:
  lda #1
  rts

.occupied_exit:
  lda #2
  rts

; --------------------------------
  subroutine
move_up:
  lda X_POS
  cmp #2
  beq .end_move_up
  dec X_POS
  jsr check_collision
  inc X_POS
  cmp #1
  beq .end_move_up

  lda #0
  sta VERTICAL

  lda HORIZONTAL
  beq .move_up1
  lda #ROBBER_VL_2
  jmp .move_up2

.move_up1:
  lda #ROBBER_VR_2

.move_up2:
  jsr CHROUT

  dec X_POS
  ldy Y_POS
  ldx X_POS
  clc
  jsr PLOT

  lda HORIZONTAL
  beq .move_up3
  lda #ROBBER_VL_1
  jmp .move_up4

.move_up3:
  lda #ROBBER_VR_1

.move_up4:
  sta CURRENT
  jsr CHROUT

  clc
  jsr PLOT
  lda #0
  sta MOVING
  lda #TIMERESET1
  sta TIMER1

.end_move_up:
  rts

; -------------------
  subroutine
move_down:
  lda X_POS
  cmp #21
  beq .end_move_down_fail
  inc X_POS
  jsr check_collision
  dec X_POS
  cmp #1
  beq .end_move_down_fail

  lda #1
  sta VERTICAL

  lda HORIZONTAL
  beq .move_down1
  lda #ROBBER_VL_1
  jmp .move_down2

.move_down1:
  lda #ROBBER_VR_1

.move_down2:
  jsr CHROUT

  inc X_POS
  ldy Y_POS
  ldx X_POS
  clc
  jsr PLOT

  lda HORIZONTAL
  beq .move_down3
  lda #ROBBER_VL_2
  jmp .move_down4

.move_down3:
  lda #ROBBER_VR_2

.move_down4:
  sta CURRENT
  jsr CHROUT

  clc
  jsr PLOT
  lda #0
  sta MOVING
  lda #TIMERESET1
  sta TIMER1

.end_move_down_success:
  lda #0
  rts

.end_move_down_fail:
  lda #1
  rts

; -------------------
  subroutine
move_right:
  lda Y_POS
  cmp #20
  beq .end_move_right
  inc Y_POS
  jsr check_collision
  dec Y_POS
  cmp #1
  beq .end_move_right

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

.end_move_right:
  rts
; -------------------
  subroutine
move_left:
  lda Y_POS
  cmp #1
  beq .end_move_left
  dec Y_POS
  jsr check_collision
  inc Y_POS
  cmp #1
  beq .end_move_left

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

.end_move_left:
  rts
; -------------------
  subroutine
gravity:
  lda MOVING
  beq .check_on_ground
  lda GRAVITY_COOLDOWN
  bne .check_on_ground
  lda #GRAVITY_MAX_COOLDOWN
  sta GRAVITY_COOLDOWN
  jsr move_down
  sta CAN_JUMP
  rts

.check_on_ground:
  inc X_POS
  jsr check_collision
  sta CAN_JUMP
  dec X_POS
  rts
  
; -------------------

  subroutine
animate:
  lda VERTICAL
  cmp #255
  beq .skip_animate
  ldx X_POS
  ldy Y_POS
  lda CURRENT
  cmp #ROBBER_R_2
  beq .animate_r
  cmp #ROBBER_L_1
  beq .animate_l
  lda VERTICAL
  beq .animate_u
  jmp .animate_d

.skip_animate:
  lda #0
  sta VERTICAL
  rts

.animate_r:
  dey
  clc
  jsr PLOT
  lda #EMPTY_SPACE_CHAR
  jsr CHROUT
  lda #ROBBER_R
  jsr CHROUT
  jmp .end_animate

.animate_l:
  iny
  clc
  jsr PLOT
  lda #EMPTY_SPACE_CHAR
  jsr CHROUT
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  lda #ROBBER_L
  jsr CHROUT
  jmp .end_animate

.animate_u:
  inx
  clc
  jsr PLOT
  lda #EMPTY_SPACE_CHAR
  jsr CHROUT
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  lda HORIZONTAL
  beq .animate_ul
  lda #ROBBER_R
  jmp .animate_u1

.animate_ul:
  lda #ROBBER_L

.animate_u1:
  jsr CHROUT
  jmp .end_animate

.animate_d:
  dex
  clc
  jsr PLOT
  lda #EMPTY_SPACE_CHAR
  jsr CHROUT
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  lda HORIZONTAL
  beq .animate_dl
  lda #ROBBER_R
  jmp .animate_d1

.animate_dl:
  lda #ROBBER_L

.animate_d1:
  jsr CHROUT

.end_animate:
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  rts
