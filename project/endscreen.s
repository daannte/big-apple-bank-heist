  subroutine
load_endscreen:
  lda #ASCII_0
  sta ASCII_OFFSET
  
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

  jsr print_score

.end_load_endscreen:
  rts
; -------------------
  subroutine
print_score:
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

.convert_to_bcd:
  lda SCORE2    ; Already in BCD since only using 0-9
  sta TIMER_VALUE
  jsr print_bcd ; Print the BCD

  lda #0
  sta TEMP1
  lda SCORE1
.loop:
  cmp #10
  bcc .print_ones
  inc TEMP1
  sec
  sbc #10
  jmp .loop

.print_ones:
  sta TEMP2
  lda TEMP1
  asl
  asl
  asl
  asl
  clc
  adc TEMP2
  sta TIMER_VALUE
  jsr print_bcd

.load_endscreen_loop:
  jsr GETIN
  cmp #00
  beq .load_endscreen_loop

.end_print_score:
  rts
; -------------------
  subroutine
add_score:
  lda TIMER_VALUE
  and #$0f
  sta TEMP1
  lda TIMER_VALUE
  and #$f0
  lsr
  sta TEMP2
  lsr
  lsr
  clc
  adc TEMP2
  clc 
  adc TEMP1
  clc
  adc SCORE1
  
  cmp #99
  bcc .increment_tens
  sec
  sbc #100
  inc SCORE2

.increment_tens:
  sta SCORE1
  rts