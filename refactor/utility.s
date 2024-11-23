; utility.s
; Reused subroutines to perform set up, clear, and etc.

    subroutine

; Subroutine : Clear Screen
; Description : Clears screen and sets border/background to black
clear_scr:
    lda #$80            ; #$80 for Key Repeats, needed for XVIC emulator
    sta $028A           ; Key repeats - needed for XVIC emulator
    lda #$0F            ; Border Black
    jsr .setbg
    lda #$F8            ; BG Black 
    jsr .setbg
    ldx #1
    stx $0286
    lda #147            ; Load clear screen command
    jsr CHROUT          ; Print it
    rts
.setbg:
    and SCREEN 
    sta SCREEN
    rts

; Subroutine : Load Charset
; Description : Load #$FF in $9005 (Charset), to load custom characters
load_chars:
    lda #$ff            ; 255 -> $1c00
    sta CHARSET
    rts

; ---- Jiffy Related ----

; Subroutine : Handle Timing
; Description : Dictates game loop speed
handle_timing:
    rts


; Subroutine : Read Jiffy
; Description : Reads Jiffy value and saves in CURR_JIFFY_$ ZP-variables
read_jiffy:
    lda JIFFY_LOW
    sta CURR_JIFFY_L
    lda JIFFY_MID
    sta CURR_JIFFY_M
    lda JIFFY_HIGH
    sta CURR_JIFFY_H
    rts
