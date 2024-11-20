	processor 6502

; KERNAL [sic] addresses
CHROUT  = $FFD2
SCREEN  = $900F
PLOT    = $FFF0

JIFFY   = $A2

    org $1001

; Basic stub
    dc.w nextstmt
    dc.w 10
    dc.b $9e, [clr]d, 0
nextstmt
    dc.w 0

tObj1:
    .BYTE #'T, #'I, #'M, #'E, #'R, #' , #0
tObj2:
    .BYTE #'N, #'I, #'C, #'E, #0
tMaxV:
    .BYTE #75           ; Nice

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

; Loop Structure of program
; 0. Start Clock
; 1. Load Main BG - level data
; 2. Load Character/Mob/Item data
; 3. Take input
; 4. Modify data based on input
; Repeat

drawT
    ; For testing purposes, load static background
    ldx #0
    ldy #3
    jsr PLOT
.pObjT
    lda tObj1,X
    jsr CHROUT
    inx
    cmp #0
    bne .pObjT

tickT
    ; Timer starts here
    jsr jiffySec
    lda tMaxV               ; Max Timer Value
    ldx #0
    ldy #9
    clc
    jsr PLOT
    jsr print_bcd
    jmp tickT

; Subroutines

setbg
    and SCREEN
    sta SCREEN
    rts

jiffySec
    lda JIFFY               ; Load Jiffy Clock Val
    sta $02                 ; Store temporarily
.jiffyWait
    lda JIFFY
    sec
    sbc $02
    cmp #60
    bcc .jiffyWait
    dec tMaxV   
    rts

print_bcd
    lda tMaxV
    ldx #0
.tenDigit
    sec
    sbc #10
    bcc .oneDigit
.tenDiv
    inx
    sbc #10
    bcc .tenOutput
    jmp .tenDiv
.tenOutput
    tay                 ; Store remainder to Y-reg, value is r-10
    txa
    adc #48             ; ASCII 0 - 9 (#48 - #57)
    jsr CHROUT
.oneDigit
    tya
    adc #58             ; (48(acii offset) + 10 (initial subtrahend))
    jsr CHROUT
    rts
