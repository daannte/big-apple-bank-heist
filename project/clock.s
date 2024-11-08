  subroutine
toAscii:
  lda timer_value
  sbc #9
  bcc .skipFirst
  lda timer_value
  ldx #0
  jmp .tenDigit
.skipFirst
  lda #EMPTY_SPACE_CHAR
  jsr CHROUT
  lda timer_value
  adc #76
  jsr CHROUT
  rts
.tenDigit
  sec
  sbc #10
  bcc .oneDigit
.tenDiv
  inx
  sbc #10
  bcc .tenOutput
  jmp .tenDiv
.tenOutput
  tay                 ; Store remainder to Y-reg, value is r-10
  txa
  adc #76             ; ASCII 0 - 9 (#48 - #57)
  jsr CHROUT
.oneDigit
  tya
  adc #86             ; (48(acii offset) + 10 (initial subtrahend))
  jsr CHROUT
  rts

  subroutine
increment_clock:
  lda JIFFY1              ; load current jiffy
  cmp LASTJIFFY           ; compare to last jiffy
  beq .end_timer           ; if jiffy elapsed, update timer
  sta LASTJIFFY           ; store current jiffy
  inc JIFFIES_SINCE_SECOND
  lda JIFFIES_SINCE_SECOND
  cmp #60
  bne .continue_timer
  lda #0
  sta JIFFIES_SINCE_SECOND
  tax
  ldy #20
  clc
  jsr PLOT
  lda timer_value
  beq .times_up
  dec timer_value
  jsr toAscii
  ldx X_POS
  ldy Y_POS
  clc
  jsr PLOT
  jmp .continue_timer

.times_up:
  lda #0
  sta PLAYER_LIVES
  lda #1
  rts

.continue_timer:
  lda MOVING
  bne .end_timer
  lda TIMER1
  bne .increment_timer1    ; if timer 1 is not 0, increment timer 1
  lda TIMER2
  bne .increment_timer1    ; if timer 2 is not 0, increment timer 2
  lda TIMER3
  bne .increment_timer1    ; if timer 3 is not 0, increment timer 3
  
  lda #1
  sta MOVING
  jsr animate

  jmp .end_timer
    
.increment_timer1:
  lda TIMER1              ; check if timer 1 is 0
  beq .increment_timer2    ; if so, increment timer 2
  dec TIMER1              ; otherwise, decrement timer 1
  jmp .end_timer

.increment_timer2:
  lda #255                ; reset timer 1
  sta TIMER1              ; store into timer 1 register
  lda TIMER2              ; check if timer 2 is 0
  beq .increment_timer3    ; if so, increment timer 3
  dec TIMER2              ; otherwise, decrement timer 2
  jmp .end_timer

.increment_timer3:
  lda #255                ; reset timer 2
  sta TIMER2              ; store into timer 2 register
  lda TIMER3              ; check if timer 3 is 0
  beq .end_timer          ; if so, loop timer
  dec TIMER3              ; otherwise, decrement timer 3  

.end_timer:
  lda #0
  rts                 ; return from subroutine

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