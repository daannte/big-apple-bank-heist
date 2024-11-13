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