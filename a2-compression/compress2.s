  processor 6502

CHROUT = $ffd2
SCREEN = $900f
PLOT   = $FFF0
COLOR  = $1DDA

  org $1001

; BASIC stub
    dc.w nextstmt       ; next BASIC statement
    dc.w 10             ; line number
    dc.b $9e, "4109", 0 ; Start of assembly program
nextstmt
    dc.w 0              ; end of BASIC program

; Program Start
clr:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

main:
  lda #$0F
  jsr set_color         ; Set background to black
  lda #$F8
  jsr set_color         ; Set border to black

  ldx #1                ; Set X to white
  stx $0286             ; Current Color code address

  ; Print Titles
  lda #0
  sta counter
print_titles:
  ldx counter
  lda title_y,x
  tay
  lda title_x,x
  tax
  jsr PLOT
  ldx counter
  lda title_x_lo,x
  sta $02
  lda title_x_hi,x
  sta $03
  jsr printstring

  inc counter
  lda counter
  cmp #14
  bne print_titles

loop:
  jmp loop

; Counter
counter: .byte 0

; Counter and Data Storage
title_x_lo: .byte <title1, <title2, <title3, <title4, <title5, <title6, <title7, <title8, <title9, <title10, <title11, <title11, <title11, <title14
title_x_hi: .byte >title1, >title2, >title3, >title4, >title5, >title6, >title7, >title8, >title9, >title10, >title11, >title11, >title11, >title14
title_x:    .byte #2, #4, #7, #8, #9, #10, #12, #15, #16, #17, #18, #19, #20, #21 ; X coordinates
title_y:    .byte #4, #5, #4, #3, #3, #6, #8, #9, #8, #7, #7, #7, #7, #7  ; Y coordinates

title1: dc.b "THE BIG APPLE", 0
title2: dc.b "BANK  HEIST", 0
title3: dc.b "DANTE  KIRSMAN", 0
title4: dc.b "DANIEL  SABOUROV", 0
title5: dc.b "RAMIRO  PIQUER", 0
title6: dc.b "JIN  SONG", 0
title7: dc.b "2024", 0
title8: .BYTE #110, #109, #0
title9: .BYTE #110, #36, #36, #109, #0
title10: .BYTE #166, #166, #166, #166, #166, #166, #0
title11: .BYTE #182, #32, #181, #182, #32, #181, #0
title14: .BYTE #184, #184, #184, #184, #184, #184, #0

printstring:
  ldy #0                ; Set index to 0
.printloop
  lda ($02),Y
  beq .done             ; Stop if zero byte (end of string)
  jsr CHROUT            ; Print character
  iny                   ; Move to next character
  jmp .printloop
.done:
  rts

set_color:
  sta COLOR
  lda SCREEN
  and COLOR
  sta SCREEN
  rts