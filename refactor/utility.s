; utility.s
; Reused subroutines to perform set up, clear, and etc.

    subroutine

; Subroutine : Initialize Clock
; Description : Initialize Game Variables and System Variables
initialize_clock:
    ; Loop Speed Init (FPS)
    lda #LOOP_RATE_10
    sta LOOP_INTERVAL
    rts

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
    jsr read_jiffy          ; Read, save values in ZP
    jsr add_jiffy           ; Save target values in ZP
.wait
    jsr read_jiffy          ; Read again to compare
    jsr compare_jiffy       ; Compare values to target
    bcs .continue_loop      ; Check carry in subroutine 'compare_jiffy.is_reached'
    jmp .wait
.continue_loop
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

; Subroutine : Add Jiffy
; Description : Add LOOP_INTERVAL (Control Var) to CURR_JIFFY_$. 
;               LOOP_INTERVAL can be changed at constants.s to play with timing of game
add_jiffy:
    lda CURR_JIFFY_L
    clc
    adc LOOP_INTERVAL       ; Add LOOP_INTERVAL to $A2 val
    sta TARG_JIFFY_L

    lda CURR_JIFFY_M
    adc #0                  ; Add carry
    sta TARG_JIFFY_M

    lda CURR_JIFFY_H
    adc #0                  ; Add carry
    sta TARG_JIFFY_H
    rts

; Subroutine : Compare Jiffy
; Description : Compare CURR_JIFFY_$ with TARG_JIFFY_$
;               Returns carry flag if CURR_JIFFY_$ > TARG_JIFFY_$
compare_jiffy:
    ; Compare High Byte First
    lda CURR_JIFFY_H
    cmp TARG_JIFFY_H
    bcc .not_reached        ; If CURR_H < TARG_H, branch
    bne .is_reached         ; If CURR_H > TARG_H, reached

    ; If CURR_H == TARG_H
    lda CURR_JIFFY_M        
    cmp TARG_JIFFY_M        ; If CURR_M > TARG_M 
    bcc .not_reached        ; If CURR_M < TARG_M

    ; If CURR_M == TARG_M
    lda CURR_JIFFY_L        ; If CURR_L > TARG_L
    cmp TARG_JIFFY_L        ; If CURR_L < TARG_L
    bcc .not_reached

.is_reached:
    sec                     ; Reached, set carry flag
    rts

.not_reached
    clc                     ; Not reached, clear carry
    rts

; Subroutine : Add Score
; Description : Increments the score
subroutine
add_score:
  lda TIMER_VALUE
  and #$0f
  sta TEMP1
  lda TIMER_VALUE
  and #$f0
  lsr
  sta TEMP2
  lsr
  lsr
  clc
  adc TEMP2
  clc 
  adc TEMP1
  clc
  adc SCORE1
  
  cmp #99
  bcc .increment_tens
  sec
  sbc #100
  inc SCORE2

.increment_tens:
  sta SCORE1
  rts

  subroutine
print_bcd:
  lda BCD_TO_PRINT
  lsr
  lsr
  lsr
  lsr
  clc
  adc ASCII_OFFSET
  jsr CHROUT

  lda BCD_TO_PRINT
  and #15
  clc
  adc ASCII_OFFSET
  jsr CHROUT
  
  rts