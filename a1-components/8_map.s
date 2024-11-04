    processor 6502

CHROUT = $FFD2
PLOT   = $FFF0
SCREEN = $900f
SETCOLOR = $0286
    org $1001

    dc.w nextstmt
    dc.w 10
    dc.b $9e, "4109", 0
nextstmt:
    dc.w 0

bg:
  ldx #0              ; Set X to black
  lda SCREEN          ; Load the screen colour address
  and #$0F            ; Reset the 4 background bits
  stx $1001           ; Store X into the user basic area memory
  ora $1001           ; Combine new background color with the screen
  sta SCREEN          ; Store new colour into the screen colour address

border:
  ldx #0              ; Set X to black
  lda SCREEN          ; Load the screen colour address
  and #$F8            ; Reset the 3 border bits
  stx $1001           ; Store X into the user basic area memory
  ora $1001           ; Combine new border colour with the screen 
  sta SCREEN          ; Store new colour into the screen colour address

clr:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

start:
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    lda #5
    sta SETCOLOR

    clc
    ldx #0
    ldy #0
    jsr PLOT
    lda #'$
    jsr CHROUT

    clc
    ldx #0
    ldy #21
    jsr PLOT
    lda #'$
    jsr CHROUT

    lda #1
    sta SETCOLOR
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------   

    ldx #0
    ldy #1
    clc
    jsr PLOT

    ldx #20
topWall:
    lda #166
    jsr CHROUT
    dex
    bne topWall
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #21
    ldy #0
wallLeft:
    clc
    jsr PLOT

    lda #166
    jsr CHROUT
    dex

    bne wallLeft
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #19
    ldy #21
wallRight:
    clc
    jsr PLOT

    lda #166
    jsr CHROUT
    dex

    bne wallRight
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #2
    ldy #18
    clc
    jsr PLOT

    ldy #20
firstZone:
    lda #166
    jsr CHROUT
    dey
    bne firstZone
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #10
    ldy #3
    clc
    jsr PLOT

    ldy #18
middleAreaLedge:
    lda #166
    jsr CHROUT
    dey
    bne middleAreaLedge
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #11
    ldy #5
    clc
    jsr PLOT

    ldy #16
middleArea:
    lda #166
    jsr CHROUT
    dey
    bne middleArea
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #17
    ldy #8
middleWall:
    clc
    jsr PLOT

    lda #166
    jsr CHROUT

    dex

    bne middleWall
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ;this is for the opening
    clc
    ldx #5
    ldy #8
    jsr PLOT
    lda #$20
    jsr CHROUT

    ;this is for the random brick in the middle
    clc
    ldx #19
    ldy #8
    jsr PLOT
    lda #166
    jsr CHROUT
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #20
    ldy #1
    clc
    jsr PLOT

    ldy #14
floorOne:
    lda #166
    jsr CHROUT
    dey
    bne floorOne
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #21
    ldy #1
    clc
    jsr PLOT

    ldy #16
floor:
    lda #166
    jsr CHROUT
    dey
    bne floor
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ldx #22
    ldy #1
    clc
    jsr PLOT

    ldy #20
bottomWall:
    lda #166
    jsr CHROUT
    dey
    bne bottomWall
;-----------------;-----------------;-----------------;-----------------;-----------------;-----------------

    ;change colour
    lda #4
    sta SETCOLOR

    ;entrance door
    clc
    ldx #2
    ldy #1
    jsr PLOT
    lda #181
    jsr CHROUT

    ;exit door
    clc
    ldx #21
    ldy #21
    jsr PLOT
    lda #164
    jsr CHROUT

    ;change colour
    lda #5
    sta SETCOLOR

    clc
    ldx #22
    ldy #0
    jsr PLOT
    lda #'$
    jsr CHROUT

loop:
  jmp loop

end:
  rts