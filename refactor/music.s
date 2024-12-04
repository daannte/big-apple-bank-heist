    subroutine
musicinit
    ldy #0
.musicloop
    jsr GETIN
    bne .exit
    lda #15
    sta VOLUME              ; Set volume to 15
    lda riff1,Y
    sta SPKMID
    lda riff3,Y
    sta SPKLOW
    jsr restNote
    jsr pause
    iny
    cpy measure
    bne .musicloop
    jmp musicinit
.exit

restNote
    ldx #11                 ; 8th Note on 130 bpm
.restNoteLoop
    lda JIFFY_LOW
.restNoteTimer
    cmp JIFFY_LOW
    beq .restNoteTimer
    dex
    bne .restNoteLoop
    lda #0
    sta VOLUME
    rts

pause
    ldx #2
.pauseLoop
    lda JIFFY_LOW
.pauseTimer
    cmp JIFFY_LOW
    beq .pauseTimer
    dex
    bne .pauseLoop
    rts