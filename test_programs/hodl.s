	processor 6502

; KERNAL [sic] addresses
CHROUT  = $FFD2
SCREEN  = $900F
PLOT    = $FFF0

JIFFY   = $A2
keyW    = $03
lastJiffy = $04


    org $1001

; Basic stub
    dc.w nextstmt
    dc.w 10
    dc.b $9e, [clr]d, 0
nextstmt
    dc.w 0



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

main
    jsr readCurrentKey
    jsr handleKeyW
    jmp main

readCurrentKey
    lda $C5
    cmp #$12
    beq setW
    lda #$00
    sta keyW
    rts

setW
    lda #$01
    sta keyW
    rts

handleKeyW
    lda keyW
    beq exitW
    lda #65
    jsr CHROUT
exitW
    rts

setbg
    and SCREEN
    sta SCREEN
    rts