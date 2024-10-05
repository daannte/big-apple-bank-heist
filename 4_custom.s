    processor 6502

; KERNAL [sic] address
CHROUT  = $FFD2
SCREEN  = $900f

    org $1001   ; BASIC start address

; BASIC stub
    dc.w nextstmt       ; next BASIC statement
    dc.w 10             ; line number
    dc.b $9e, "4109", 0 ; Start of assembly program
nextstmt                ; next BASIC statement
    dc.w 0              ; end of BASIC program


clr:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

bg:
  ldx #8                ; Black background			
  stx SCREEN            ; Make background black

  ; Set the characters to replace on the screen
  ; Page 271 in book

  ldx #0		            ; @
  stx 7690		
  ldx #33               ; !
  stx 7691

draw:
  lda #$ff              ; loading 255 into $9005 makes the vic look at $1c00 for characters instead
  sta $9005             ; the above can be found on pages 84

  ldx #$18
  stx $1c00
  ldx #$24
  stx $1c01
  ldx #$24
  stx $1c02
  ldx #$18
  stx $1c03
  ldx #$7e
  stx $1c04
  ldx #$18
  stx $1c05
  ldx #$24
  stx $1c06
  ldx #$24
  stx $1c07

  ldx #$70
  stx $1d08
  ldx #$8e
  stx $1d09
  ldx #$62
  stx $1d0a
  ldx #$12
  stx $1d0b
  ldx #$29
  stx $1d0c
  ldx #$55
  stx $1d0d
  ldx #$a5
  stx $1d0e
  ldx #$c2
  stx $1d0f

end:
  rts
