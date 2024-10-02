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


  clc                 ; Clear carry
  ldx #9              ; Set X 
  ldy #4              ; Set Y
  jsr PLOT            ; Move cursor to (X, Y)
                      ; Print "Dante Kirsman"
  lda #68             ; "D"
  jsr CHROUT          ; Print "D"
  lda #65             ; "A"
  jsr CHROUT          ; Print "A"
  lda #78             ; "N"
  jsr CHROUT          ; Print "N"
  lda #84             ; "T"
  jsr CHROUT          ; Print "T"
  lda #69             ; "E"
  jsr CHROUT          ; Print "E"
  lda #160            ; Space
  jsr CHROUT          ; Print Space
  lda #75             ; "K"
  jsr CHROUT          ; Print "K"
  lda #73             ; "I"
  jsr CHROUT          ; Print "I"
  lda #82             ; "R"
  jsr CHROUT          ; Print "R"
  lda #83             ; "S"
  jsr CHROUT          ; Print "S"
  lda #77             ; "M"
  jsr CHROUT          ; Pkint "M"
  lda #65             ; "A"
  jsr CHROUT          ; Print "A"
  lda #78             ; "N"
  jsr CHROUT          ; Print "N"

  clc                 ; Clear carry
  ldx #11              ; Set X 
  ldy #3              ; Set Y
  jsr PLOT            ; Move cursor to (X, Y)
                      ; Print "Daniel Sabourov"
  lda #68             ; "D"
  jsr CHROUT          ; Print "D"
  lda #65             ; "A"
  jsr CHROUT          ; Print "A"
  lda #78             ; "N"
  jsr CHROUT          ; Print "N"
  lda #73             ; "I"
  jsr CHROUT          ; Print "I"
  lda #69             ; "E"
  jsr CHROUT          ; Print "E"
  lda #76             ; "L"
  jsr CHROUT          ; Print "L"
  lda #160            ; Space
  jsr CHROUT          ; Print Space
  lda #83             ; "S"
  jsr CHROUT          ; Print "S"
  lda #65             ; "A"
  jsr CHROUT          ; Print "A"
  lda #66             ; "B"
  jsr CHROUT          ; Print "B"
  lda #79             ; "O"
  jsr CHROUT          ; Print "O"
  lda #85             ; "U"
  jsr CHROUT          ; Print "U"
  lda #82             ; "R"
  jsr CHROUT          ; Print "R"
  lda #79             ; "O"
  jsr CHROUT          ; Print "O"
  lda #86             ; "V"
  jsr CHROUT          ; Print "V"

  clc                 ; Clear carry
  ldx #13             ; Set X 
  ldy #4              ; Set Y
  jsr PLOT            ; Move cursor to (X, Y)
                      ; Print "Ramiro Piquer"
  lda #82             ; "R"
  jsr CHROUT          ; Print "R"
  lda #65             ; "A"
  jsr CHROUT          ; Print "A"
  lda #77             ; "M"
  jsr CHROUT          ; Print "M"
  lda #73             ; "I"
  jsr CHROUT          ; Print "I"
  lda #82             ; "R"
  jsr CHROUT          ; Print "R"
  lda #79             ; "O"
  jsr CHROUT          ; Print "O"
  lda #160            ; Space
  jsr CHROUT          ; Print Space
  lda #80             ; "P"
  jsr CHROUT          ; Print "P"
  lda #73             ; "I"
  jsr CHROUT          ; Print "I"
  lda #81             ; "Q"
  jsr CHROUT          ; Print "Q"
  lda #85             ; "U"
  jsr CHROUT          ; Print "U"
  lda #69             ; "E"
  jsr CHROUT          ; Print "E"
  lda #82             ; "R"
  jsr CHROUT          ; Print "R"

  clc                 ; Clear carry
  ldx #15             ; Set X 
  ldy #6              ; Set Y
  jsr PLOT            ; Move cursor to (X, Y)
                      ; Print "Jin Song"
  lda #74             ; "J"
  jsr CHROUT          ; Print "J"
  lda #73             ; "I"
  jsr CHROUT          ; Print "I"
  lda #78             ; "N"
  jsr CHROUT          ; Print "N"
  lda #160            ; Space
  jsr CHROUT          ; Print Space
  lda #83             ; "S"
  jsr CHROUT          ; Print "S"
  lda #79             ; "O"
  jsr CHROUT          ; Print "O"
  lda #78             ; "N"
  jsr CHROUT          ; Print "N"
  lda #71             ; "G"
  jsr CHROUT          ; Print "G"

loop:
  jmp loop

end:
  rts
