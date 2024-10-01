    processor 6502

; KERNAL [sic] address
CHROUT  = $ffd2
A       = $030c
X       = $030d
Y       = $030e

; SPEAKER addresses
VOL     = $900e   ; volume
SPKR1   = $900a   ; low frequency
SPKR2   = $900b   ; mid frequency
SPKR3   = $900c  ; high frequency
SPKR4   = $900d   ; noise

; MUSIC TIMER addresses
TIMER1  = $1DFD  ; 256^1
TIMER2  = $1DFE   ; 256^2
TIMER3  = $1DFF   ; 256^3

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

    lda #255        ; load timer 1 as 255
    sta TIMER1      ; store into timer 1 register

    lda #255        ; load timer 1 as 255
    sta TIMER2      ; store into timer 2 register

    lda #2          ; load timer 3 as 31
    sta TIMER3      ; store into timer 3 register

    lda #Fs1        ; load x register as F#1
    sta SPKR3       ; store into high frequency register

gameloop:           ; play a note on loop
    lda TIMER3      ; check if timer 3 is 0
    beq volume_on   ; if so, turn volume on
    sbc #1         ; check if timer 3 is 16
    beq volume_off  ; if so, turn volume off
    jmp next_loop   ; otherwise, continue loop

volume_off:
    lda #0          ; set volume to 0
    sta VOL         ; store into volume register
    jmp next_loop   ; continue loop

volume_on:          ; play note
    lda #5          ; set volume to 5
    sta VOL         ; store into volume register

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
    lda TIMER1              ; check if timer 1 is 0
    beq increment_timer2    ; if so, increment timer 2
    dec TIMER1              ; otherwise, decrement timer 1
    rts                     ; return from subroutine

increment_timer2:
    lda #255                ; reset timer 1
    sta TIMER1              ; store into timer 1 register
    lda TIMER2              ; check if timer 2 is 0
    beq increment_timer3    ; if so, increment timer 3
    dec TIMER2              ; otherwise, decrement timer 2
    rts                     ; return from subroutine

increment_timer3:
    lda #255                ; reset timer 2
    sta TIMER2              ; store into timer 2 register
    lda TIMER3              ; check if timer 3 is 0
    beq loop_timer          ; if so, loop timer
    dec TIMER3              ; otherwise, decrement timer 3
    rts                     ; return from subroutine

loop_timer:
    lda #2                 ; reset timer 3
    sta TIMER3              ; store into timer 3 register
    rts                     ; return from subroutine

; END increment_timer