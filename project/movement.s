  subroutine
check_collision:
  lda X_POS
  cmp #10
  bcc .baseaddr
  lda X_POS
  cmp #10
  bne .midaddr
  lda Y_POS
  cmp #11
  bcc .baseaddr

.midaddr
  lda X_POS
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
  adc TEMP2
  adc TEMP1
  
  sta TEMP1
  lda Y_POS
  clc
  adc TEMP1
  sec
  sbc #70 ; for some reason, the magic number is 70
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
  adc TEMP2
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
  jsr move_down
  sta CAN_JUMP
  rts