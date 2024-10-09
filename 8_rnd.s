        processor 6502

; KERNAL [sic[ addresses
CHROUT  = $ffd2
SCREEN  = $900f

  org $1001

; Basic Stub
  dc.w nextstmt
  dc.w 10
  dc.b $9e, "4109", 0
nextstmt
  dc.w 0

; Program Start
clr
  lda #147
  jsr CHROUT

bg
  ldx #0
  lda SCREEN
  and #$0f
  stx $1001
  ora $1001
  sta SCREEN


