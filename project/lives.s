  subroutine
handle_lives:
  lda PLAYER_LIVES
  bne .dec_lives

  lda #$f0                ; loading 240 into CHARSET to reset character set for titlescreen 
  sta CHARSET             ; the above can be found on page 267

  lda #0
  rts

.dec_lives:
  dec PLAYER_LIVES
  lda #1

.end_handle_lives:
  rts