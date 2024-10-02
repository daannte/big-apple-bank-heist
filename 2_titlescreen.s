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

bg:
  ldx #0              ; Set X to black
  lda SCREEN          ; Load the screen colour address
  and	#$0F            ; Reset the 4 background bits
  stx $1001           ; Store X into the user basic area memory
  ora $1001           ; Combine new background color with the screen
  sta SCREEN          ; Store new colour into the screen colour address


border:
  ldx #0              ; Set X to black
  lda SCREEN          ; Load the screen colour address
  and	#$F8            ; Reset the 3 border bits
  stx $1001           ; Store X into the user basic area memory
  ora $1001           ; Combine new border colour with the screen 
  sta SCREEN          ; Store new colour into the screen colour address

end:
  rts
