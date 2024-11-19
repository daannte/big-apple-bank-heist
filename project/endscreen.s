  subroutine
load_endscreen:
  lda #$f0                ; loading 240 into CHARSET to reset character set for titlescreen 
  sta CHARSET             ; the above can be found on page 267

  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

  ldx #10
  ldy #7
  clc
  jsr PLOT

  lda #'Y
  jsr CHROUT
  lda #'O
  jsr CHROUT
  lda #'U
  jsr CHROUT
  lda #' 
  jsr CHROUT
  lda #'W
  jsr CHROUT
  lda #'I
  jsr CHROUT
  lda #'N
  jsr CHROUT
  lda #'!
  jsr CHROUT

  ldx #12
  ldy #6
  clc
  jsr PLOT

  lda #'S
  jsr CHROUT
  lda #'C
  jsr CHROUT
  lda #'O
  jsr CHROUT
  lda #'R
  jsr CHROUT
  lda #'E
  jsr CHROUT
  lda #':
  jsr CHROUT
  lda #' 
  jsr CHROUT

.load_endscreen_loop:
  jsr GETIN
  cmp #00
  beq .load_endscreen_loop
  rts