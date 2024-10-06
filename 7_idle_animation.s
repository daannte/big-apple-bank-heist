    processor 6502

; KERNAL [sic] address
CHROUT  = $FFD2
SCREEN  = $900f

JIFFY3  = $00A0     ; n * 256^0
JIFFY2  = $00A1     ; n * 256^1
JIFFY1  = $00A2     ; n * 256^2

CURRENT = $1DFA     ; current animation frame
SWITCH = $1DFB     ; switch for idle animation
LASTJIFFY = $1DFC   ; stores last known jiffy
TIMER1  = $1DFF     ; n * 256^0
TIMER2  = $1DFE     ; n * 256^1
TIMER3  = $1DFD     ; n * 256^2

TIMERESET1  = #60
TIMERESET2  = #0
TIMERESET3  = #0

    org $1001   ; BASIC start address

; BASIC stub
    dc.w nextstmt       ; next BASIC statement
    dc.w 10             ; line number
    dc.b $9e, "4109", 0 ; Start of assembly program
nextstmt                ; next BASIC statement
    dc.w 0              ; end of BASIC program


clr:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

setup:
  lda #TIMERESET1        ; 60 * 256^0 = 60 jiffies
  sta TIMER1            ; store the timer value in address TIMER1

  lda #TIMERESET2        ; 0 * 256^1 = 0 jiffies
  sta TIMER2            ; store the timer value in address TIMER2

  lda #TIMERESET3        ; 0 * 256^2 = 0 jiffies
  sta TIMER3            ; store the timer value in address TIMER3

  lda #1
  sta CURRENT

  lda #0
  sta SWITCH

  lda #$ff              ; loading 255 into $9005 makes the vic look at $1c00 for characters instead
  sta $9005             ; the above can be found on pages 84

draw:
  lda SWITCH
  beq check_current
  jmp loop

check_current:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it
  lda CURRENT
  bne idle_1
  jmp idle_2

idle_1:
  lda #1
  sta SWITCH
  lda #0
  sta CURRENT
  lda #64
  jsr CHROUT
  jmp loop

idle_2:
  lda #1
  sta SWITCH
  lda #1
  sta CURRENT
  lda #65
  jsr CHROUT

loop:
  jsr increment_timer
  jmp draw

; -------- SUBROUTINES --------

; increment_timer
    ; decrements the timers and loops them
    ; allows for approx. 16 seconds of looped data, such as music
increment_timer:
  lda JIFFY1              ; load current jiffy
  cmp LASTJIFFY           ; compare to last jiffy
  bne increment_timer1    ; if jiffy elapsed, update timer
  jmp check_timer         ; otherwise, return
    
increment_timer1:
  sta LASTJIFFY           ; store current jiffy
  beq increment_timer2    ; if so, increment timer 2
  dec TIMER1              ; otherwise, decrement timer 1
  jmp check_timer         ; return from subroutine

increment_timer2:
    lda #255                ; reset timer 1
    sta TIMER1              ; store into timer 1 register
    lda TIMER2              ; check if timer 2 is 0
    beq increment_timer3    ; if so, increment timer 3
    dec TIMER2              ; otherwise, decrement timer 2
    jmp check_timer         ; return from subroutine

increment_timer3:
    lda #255                ; reset timer 2
    sta TIMER2              ; store into timer 2 register
    lda TIMER3              ; check if timer 3 is 0
    beq loop_timer          ; if so, loop timer
    dec TIMER3              ; otherwise, decrement timer 3
    jmp check_timer         ; return from subroutine

loop_timer:
    lda #255                ; reset timer 3
    sta TIMER3              ; store into timer 3 register

check_timer:
    sta LASTJIFFY           ; store current jiffy
    lda TIMER1              ; check if timer 1 is 0
    bne end_timer           ; if so, increment timer 1
    lda TIMER2              ; check if timer 2 is 0
    bne end_timer           ; if so, increment timer 2
    lda TIMER3              ; check if timer 3 is 0
    bne end_timer           ; if so, increment timer 3

    lda #0
    sta SWITCH

    lda #TIMERESET1     ; 168 * 256^0 = 168 jiffies
    sta TIMER1          ; store the timer value in address TIMER1

    lda #TIMERESET2     ; 0 * 256^1 = 0 jiffies
    sta TIMER2          ; store the timer value in address TIMER2

    lda #TIMERESET3     ; 0 * 256^2 = 0 jiffies
    sta TIMER3          ; store the timer value in address TIMER3

end_timer:
    rts                 ; return from subroutine

  org $1c00

idle_1_char:
  dc.b %01111000
  dc.b %10011110
  dc.b %10110101
  dc.b %10011110
  dc.b %01110000
  dc.b %11111000
  dc.b %11111000
  dc.b %01010000

idle_2_char
  dc.b %00000000
  dc.b %01111000
  dc.b %10011110
  dc.b %10110101
  dc.b %10011110
  dc.b %11111000
  dc.b %11111000
  dc.b %01010000

pickaxe_char:
  dc.b $70
  dc.b $8e
  dc.b $62
  dc.b $12
  dc.b $29
  dc.b $55
  dc.b $a5
  dc.b $c2
