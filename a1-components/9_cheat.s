        processor 6502

; KERNAL [sic[ addresses
CHROUT  = $ffd2
GETIN   = $ffe4
SCREEN  = $900f

KEY_C   = #67
KEY_O   = #79
KEY_W   = #87
KEY_L   = #76
KEY_E   = #69
KEY_V   = #86

CINDEX  = $1098
CKEY    = $1099

; Expected Cheat Code


  org $1001

  ; Basic Stub
  dc.w nextstmt
  dc.w 10
  dc.b $9e, "4109", 0
nextstmt
  dc.w 0

SEQUENCE: .BYTE KEY_C, KEY_O, KEY_W, KEY_L, KEY_E, KEY_V, KEY_E, KEY_L

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

init
  lda #0
  sta CINDEX

  ; Cheat Code, once activated, toggles flag on arbitrary memory address to indicate
  ; that cheat has been activated
  ; Long nested branches.. wonder if they're any good for later

loop
  ; check when cindex is exactly 8, before jsr GETKEY
  ldx CINDEX
  cpx #8
  beq activate

  jsr GETIN
  sta CKEY
  cmp #$00
  beq loop

  ldx CINDEX
  cpx #8
  beq activate

  lda SEQUENCE,X
  cmp CKEY
  bne init

  inc CINDEX
  jmp loop


; Cow level baby

activate
  lda #'C
  jsr CHROUT
  lda #'O
  jsr CHROUT
  lda #'W
  jsr CHROUT
  lda #'L
  jsr CHROUT
  lda #'E
  jsr CHROUT
  lda #'V
  jsr CHROUT
  lda #'E
  jsr CHROUT
  lda #'L
  jsr CHROUT
  jmp activate

