  subroutine
increment_clock:
  lda JIFFY1              ; load current jiffy
  cmp LASTJIFFY           ; compare to last jiffy
  beq .end_timer           ; if jiffy elapsed, update timer
  sta LASTJIFFY           ; store current jiffy
  lda GRAVITY_COOLDOWN
  beq .inc_jiffy_seconds
  dec GRAVITY_COOLDOWN

.inc_jiffy_seconds
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

.dec_level_timer:
  lda TIMER_VALUE
  beq .times_up
  and #15
  cmp #0
  bne .dec_ones
  lda TIMER_VALUE
  sec
  sbc #6
  sta TIMER_VALUE

.dec_ones:
  dec TIMER_VALUE
  jsr print_bcd
  
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