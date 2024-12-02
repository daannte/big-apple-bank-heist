  subroutine
handle_setup:
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

  lda #0
  sta CURRENT_LEVEL   ; Set the current_level to the first
  sta SCORE1
  sta SCORE2

  lda #2
  sta PLAYER_LIVES    ; 2 is interpreted as 3 lives because of how BNE works

  lda JIFFY1
  sta LASTJIFFY
  
  rts

setbg:
  and SCREEN 
  sta SCREEN
  rts