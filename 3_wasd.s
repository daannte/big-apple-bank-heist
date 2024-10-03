    processor 6502

CHROUT = $ffd2
SCREEN = $900f
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

input:
  lda 197
  cmp #9
  beq w_key
  cmp #17
  beq a_key
  cmp #18
  beq d_key
  cmp #41
  beq s_key
  jmp input

w_key:
  ldx #2              ; Set X to red
  jmp border          ; Change border for visual

a_key:
  ldx #6              ; Set X to blue
  jmp border          ; Change border for visual

d_key:
  ldx #4              ; Set X to purple
  jmp border          ; Change border for visual

s_key:
  ldx #5              ; Set X to green
  jmp border          ; Change border for visual

border:
  lda SCREEN          ; Load the screen colour address
  and	#$F8            ; Reset the 3 border bits
  stx $1001           ; Store X into the user basic area memory
  ora $1001           ; Combine new border colour with the screen 
  sta SCREEN          ; Store new colour into the screen colour address
  jmp input

end:
    rts             ; return from subroutine
