  processor 6502

CHROUT = $ffd2
SCREEN = $900f
PLOT   = $FFF0
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

title:
  ldx #1              ; Set X to white
  stx $0286           ; Store X into current color code address

  ; Screen HEIGHT (X) is 0 - 21
  ; Screen WIDTH (Y) is 0 - 22
  ; idk why its like this

  clc                 ; Clear carry
  ldx #2              ; Set X 
  ldy #4              ; Set Y
  jsr PLOT            ; Move cursor to (X, Y)
                      ; Print "The Big Apple"
  lda #84             ; "T"
  jsr CHROUT          ; Print "T"
  lda #72             ; "H"
  jsr CHROUT          ; Print "H"
  lda #69             ; "E"
  jsr CHROUT          ; Print "E"
  lda #160            ; Space
  jsr CHROUT          ; Print Space
  lda #66             ; "B"
  jsr CHROUT          ; Print "B"
  lda #73             ; "I"
  jsr CHROUT          ; Print "I"
  lda #71             ; "G"
  jsr CHROUT          ; Print "G"
  lda #160            ; Space
  jsr CHROUT          ; Print Space
  lda #65             ; "A"
  jsr CHROUT          ; Print "A"
  lda #80             ; "P"
  jsr CHROUT          ; Print "P"
  lda #80             ; "P"
  jsr CHROUT          ; Print "P"
  lda #76             ; "L"
  jsr CHROUT          ; Print "L"
  lda #69             ; "E"
  jsr CHROUT          ; Print "E"

  clc                 ; Clear carry
  ldx #4              ; Set X 
  ldy #5              ; Set Y
  jsr PLOT            ; Move cursor to (X, Y)
                      ; Print "Bank Heist"
  lda #66             ; "B"
  jsr CHROUT          ; Print "B"
  lda #65             ; "A"
  jsr CHROUT          ; Print "A"
  lda #78             ; "N"
  jsr CHROUT          ; Print "N"
  lda #75             ; "K"
  jsr CHROUT          ; Print "K"
  lda #160            ; Space
  jsr CHROUT          ; Print Space
  lda #72             ; "H"
  jsr CHROUT          ; Print "H"
  lda #69             ; "E"
  jsr CHROUT          ; Print "E"
  lda #73             ; "I"
  jsr CHROUT          ; Print "I"
  lda #83             ; "S"
  jsr CHROUT          ; Print "S"
  lda #84             ; "T"
  jsr CHROUT          ; Print "T"

loop:
  jmp loop

end:
  rts
