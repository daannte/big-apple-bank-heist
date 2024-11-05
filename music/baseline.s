	processor 6502

; KERNAL [sic] addresses
CHROUT  = $FFD2
SCREEN  = $900F
PLOT    = $FFF0
JIFFY   = $A2

; SOUND addresses
VOLUME  = $900E
SPKLOW  = $900A
SPKMID  = $900B
SPKHIH  = $900C
SPKWHT  = $900D

    org $1001

; Basic stub
    dc.w nextstmt
    dc.w 10
    dc.b $9e, [clr]d, 0
nextstmt
    dc.w 0

tObj1:
    .BYTE #'M, #'U, #'S, #'I, #'C, #' , #0

measure:
    .BYTE 8
riff1:                  ; Main melody
    .BYTE #207, #0,   #0,   #209, #212, #0,   #209, #0
riff2:                  ; 5th Harmony
    .BYTE #219, #0,   #0,   #221, #223, #0,   #221, #0
riff3:                  ; Baseline
    .BYTE #183, #179, #175, #179, #167, #163, #175, 183 


; Program Start
clr
    lda #147
    jsr CHROUT
bg
    lda #$0F
    jsr setbg
    lda #$F8
    jsr setbg
    ldx #1
    stx $0286

    ldx #0
drawT
    lda tObj1,X
    jsr CHROUT
    inx
    cmp #0
    bne drawT

musicinit
    ldy #0
.musicloop
    lda #15
    sta VOLUME              ; Set volume to 15
    lda riff1,Y
    sta SPKMID
    lda riff2,Y
    sta SPKHIH
    lda riff3,Y
    sta SPKLOW
    jsr restNote
    iny
    cpy measure
    bne .musicloop
    jmp musicinit


restNote
    ldx #14                 ; 8th Note on 130 bpm
.restNoteLoop
    lda JIFFY
.restNoteTimer
    cmp JIFFY
    beq .restNoteTimer
    dex
    bne .restNoteLoop
    lda #0
    sta VOLUME
    rts

setbg
    and SCREEN
    sta SCREEN
    rts
