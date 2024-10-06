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

draw:
  lda #$ff              ; loading 255 into $9005 makes the vic look at $1c00 for characters instead
  sta $9005             ; the above can be found on pages 84

  ; Custom player

  lda #64
  jsr CHROUT

  ; Custom pickaxe

  lda #65
  jsr CHROUT


loop:
  jmp loop

end:
  rts

  org $1c00

  dc.b $18
  dc.b $24
  dc.b $24
  dc.b $18
  dc.b $7e
  dc.b $18
  dc.b $24
  dc.b $24

  dc.b $70
  dc.b $8e
  dc.b $62
  dc.b $12
  dc.b $29
  dc.b $55
  dc.b $a5
  dc.b $c2
