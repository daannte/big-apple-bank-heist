    processor 6502

; KERNAL [sic] address
CHROUT  = $FFD2

; SPEAKER addresses
VOL     = $900E     ; volume
SPKR1   = $900A     ; low frequency
SPKR2   = $900B     ; mid frequency
SPKR3   = $900C     ; high frequency
SPKR4   = $900D     ; noise

; JIFFY CLOCK addresses (resets every 24 hours)
JIFFY3  = $00A0     ; n * 256^0
JIFFY2  = $00A1     ; n * 256^1
JIFFY1  = $00A2     ; n * 256^2

; MUSIC TIMER addresses (jiffy with manual reset)
LASTJIFFY = $1DFC   ; stores last known jiffy
TIMER1  = $1DFF     ; n * 256^0
TIMER2  = $1DFE     ; n * 256^1
TIMER3  = $1DFD     ; n * 256^2

TIMERESET1  = #168  ; 168 * 256^0 = 168 jiffies
TIMERESET2  = #0    ; 0 * 256^1 = 0 jiffies
TIMERESET3  = #0    ; 0 * 256^2 = 0 jiffies

PLAYNOTE1 = #168
STOPNOTE1 = #162

PLAYNOTE2 = #84
STOPNOTE2 = #78

PLAYNOTE3 = #74
STOPNOTE3 = #68

; -------- NOTES --------
A1      = #183
A2      = #219
A3      = #237

As1     = #187
As2     = #221
As3     = #238

B1      = #191
B2      = #223
B3      = #239

C1      = #135
C2      = #195
C3      = #225
C4      = #240

Cs1     = #143
Cs2     = #199
Cs3     = #227
Cs4     = #241

D1      = #147
D2      = #201
D3      = #228

Ds1     = #151
Ds2     = #203
Ds3     = #229

E1      = #159
E2      = #207
E3      = #231

F1      = #163
F2      = #209
F3      = #232

Fs1     = #167
Fs2     = #212
Fs3     = #233

G1      = #175
G2      = #215
G3      = #235

Gs1     = #179
Gs2     = #217
Gs3     = #236

    org $1001   ; BASIC start address

; BASIC stub
    dc.w nextstmt       ; next BASIC statement
    dc.w 10             ; line number
    dc.b $9e, "4109", 0 ; Start of assembly program
nextstmt                ; next BASIC statement
    dc.w 0              ; end of BASIC program

; -------- PROGRAM --------
    ; Setup
    lda #5          ; load volume as 10
    sta VOL         ; store into volume register (AKA set volume)

    lda JIFFY1      ; load 0 for jiffy
    sta LASTJIFFY   ; store last known jiffy

    lda #TIMERESET1 ; load timer 1 as 255
    sta TIMER1      ; store into timer 1 register

    lda #TIMERESET2 ; load timer 1 as 255
    sta TIMER2      ; store into timer 2 register

    lda #TIMERESET3 ; load timer 3 as 31
    sta TIMER3      ; store into timer 3 register

    lda #F1         ; load register as F
    sta SPKR2       ; store into high frequency register

    ; print out "The Shape Stalks"
    lda #'T
    jsr CHROUT
    lda #'H
    jsr CHROUT
    lda #'E
    jsr CHROUT
    lda #32
    jsr CHROUT
    lda #'S
    jsr CHROUT
    lda #'H
    jsr CHROUT
    lda #'A
    jsr CHROUT
    lda #'P
    jsr CHROUT
    lda #'E
    jsr CHROUT
    lda #32
    jsr CHROUT
    lda #'S
    jsr CHROUT
    lda #'T
    jsr CHROUT
    lda #'A
    jsr CHROUT
    lda #'L
    jsr CHROUT
    lda #'K
    jsr CHROUT
    lda #'S
    jsr CHROUT

    ; Main loop
gameloop:           ; play a note on loop
    lda TIMER1
    cmp #PLAYNOTE1
    beq volume_on
    cmp #PLAYNOTE2
    beq volume_on
    cmp #PLAYNOTE3
    beq volume_on

    cmp #STOPNOTE1
    beq volume_off
    cmp #STOPNOTE2
    beq volume_off
    cmp #STOPNOTE3
    beq volume_off
    lda #0
    beq next_loop
    
volume_off:
    lda #0
    sta VOL
    beq next_loop

volume_on:
    lda #5
    sta VOL


next_loop:
    jsr increment_timer ; increment the timer
    jmp gameloop        ; loop

end:                    ; end of program
    rts                 ; return from subroutine

; -------- END PROGRAM --------


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

    lda #TIMERESET1     ; 168 * 256^0 = 168 jiffies
    sta TIMER1          ; store the timer value in address TIMER1

    lda #TIMERESET2     ; 0 * 256^1 = 0 jiffies
    sta TIMER2          ; store the timer value in address TIMER2

    lda #TIMERESET3     ; 0 * 256^2 = 0 jiffies
    sta TIMER3          ; store the timer value in address TIMER3

end_timer:
    rts                 ; return from subroutine

; END increment_timer