  subroutine
initialize_variables:
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

  lda #1
  sta DIED