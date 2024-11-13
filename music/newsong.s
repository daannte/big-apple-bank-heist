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
    .BYTE #32
riff1:                  ; Main melody
    .BYTE #217,#215,#209,#225,#209,#225,#209,#225
    .BYTE #221,#217,#215,#227,#215,#227,#215,#227
    .BYTE #225,#221,#217,#221,#217,#221,#225,#225
    .BYTE #221,#217,#215,#225,#221,#225,#221,#221
riff3:                  ; Baseline
    .BYTE #217,#0,#225,#0,#217,#0,#225,#0
    .BYTE #221,#0,#227,#0,#221,#0,#227,#0
    .BYTE #217,#0,#225,#0,#217,#0,#225,#0
    .BYTE #221,#0,#227,#0,#221,#0,#227,#0

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
    ;lda riff2,Y
    ;sta SPKHIH
    lda riff3,Y
    sta SPKLOW
    jsr restNote
    jsr pause
    iny
    cpy measure
    bne .musicloop
    jmp musicinit


restNote
    ldx #11                 ; 8th Note on 130 bpm
.restNoteLoop
    lda JIFFY1
.restNoteTimer
    cmp JIFFY1
    beq .restNoteTimer
    dex
    bne .restNoteLoop
    lda #0
    sta VOLUME
    rts

pause
    ldx #2
.pauseLoop
    lda JIFFY1
.pauseTimer
    cmp JIFFY1
    beq .pauseTimer
    dex
    bne .pauseLoop
    rts

setbg
    and SCREEN
    sta SCREEN
    rts