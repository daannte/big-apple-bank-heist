  processor 6502

CHROUT = $ffd2
SCREEN = $900f
  org $1001


; BASIC stub
    dc.w nextstmt       ; next BASIC statement
    dc.w 10             ; line number
    dc.b $9e, "4109", 0 ; Start of assembly program
nextstmt                ; next BASIC statement
    dc.w 0              ; end of BASIC program

clr:
  lda #$93              ; Load clear screen command
  jsr CHROUT            ; Print it

border:
  ldx #0              ; Set X do black
  lda SCREEN          ; Load the screen colour address
  and	#$F0            ; Reset the 2 border bits
  stx $1001           ; Store X into the user basic area memory
  ora $1001           ; Combine black with the screen (Set black border)
  sta SCREEN          ; Store new colour into the screen colour address

end:
  rts
