; utility.s
; Reused subroutines to perform set up, clear, and etc.

    subroutine

setbg:
    and SCREEN 
    sta SCREEN
    rts

; Subroutine : Clear Screen
; Description : Clears screen and sets border/background to black
clear_scr:
    lda #$80            ; #$80 for Key Repeats, needed for XVIC emulator
    sta $028A           ; Key repeats - needed for XVIC emulator
    lda #$0F            ; Border Black
    jsr setbg
    lda #$F8            ; BG Black 
    jsr setbg
    ldx #1
    stx $0286
    lda #147            ; Load clear screen command
    jsr CHROUT          ; Print it
    rts

; Subroutine : Load Charset
; Description : Load #$FF in $9005 (Charset), to load custom characters
load_chars:
    lda #$ff            ; 255 -> $1c00
    sta CHARSET
    rts
