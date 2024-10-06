    processor 6502

; KERNAL [sic] address
CHROUT  = $FFD2

; SPEAKER addresses
VOL     = $900E   ; volume
SPKR1   = $900A   ; low frequency
SPKR2   = $900B   ; mid frequency
SPKR3   = $900C  ; high frequency
SPKR4   = $900D   ; noise

; JIFFY CLOCK addresses (resets every 24 hours)
JIFFY3  = $00A0     ; n * 256^0
JIFFY2  = $00A1     ; n * 256^1
JIFFY1  = $00A2     ; n * 256^2

; MUSIC TIMER addresses (jiffy with manual reset)
LASTJIFFY = $1DFC   ; stores last known jiffy
TIMER1  = $1DFF     ; n * 256^0
TIMER2  = $1DFE     ; n * 256^1
TIMER3  = $1DFD     ; n * 256^2

PICKTIME1  = #10
PICKTIME2  = #0
PICKTIME3  = #0

; INPUT address
KEYBOARD = $00C5

KEY_R = #10

    org $0801   ; BASIC start address

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
    lda #5         ; load volume as 5
    sta VOL         ; store into volume register (AKA set volume)

    lda #0
    sta TIMER1
    sta TIMER2
    sta TIMER3

    ; Prints "PRESS R TO PLAY PICKAXE SOUND"
    lda #'P
    jsr CHROUT
    lda #'R
    jsr CHROUT
    lda #'E
    jsr CHROUT
    lda #'S
    jsr CHROUT
    lda #'S
    jsr CHROUT
    lda #32
    jsr CHROUT
    lda #'R
    jsr CHROUT
    lda #32
    jsr CHROUT
    lda #'T
    jsr CHROUT
    lda #'O
    jsr CHROUT
    lda #32
    jsr CHROUT
    lda #'P
    jsr CHROUT
    lda #'L
    jsr CHROUT
    lda #'A
    jsr CHROUT
    lda #'Y
    jsr CHROUT
    lda #32
    jsr CHROUT
    lda #'P
    jsr CHROUT
    lda #'I
    jsr CHROUT
    lda #'C
    jsr CHROUT
    lda #'K
    jsr CHROUT
    lda #'A
    jsr CHROUT
    lda #'X
    jsr CHROUT
    lda #'E
    jsr CHROUT
    lda #32
    jsr CHROUT
    lda #'S
    jsr CHROUT
    lda #'O
    jsr CHROUT
    lda #'U
    jsr CHROUT
    lda #'N
    jsr CHROUT
    lda #'D
    jsr CHROUT

gameloop:
    lda KEYBOARD        ; load keyboard input
    cmp #KEY_R          ; compare to R key
    bne game_timer        ; if R key is pressed, play sound

play_pickaxe:
    lda TIMER1
    bne game_timer
    lda TIMER2
    bne game_timer
    lda TIMER3
    bne game_timer

    lda #PICKTIME1
    sta TIMER1
    lda #PICKTIME2
    sta TIMER2
    lda #PICKTIME3
    sta TIMER3

    lda #A1
    sta SPKR4

game_timer:
    jsr increment_timer
    jmp gameloop

stop_sound:
    lda #0
    sta SPKR4
    rts

end:
    rts             ; return from subroutine

    ; increment_timer
    ; decrements the timers and loops them
    ; allows for approx. 16 seconds of looped data, such as music
increment_timer:
    lda JIFFY1              ; load current jiffy
    cmp LASTJIFFY           ; compare to last jiffy
    beq end_timer           ; if jiffy elapsed, update timer
    sta LASTJIFFY           ; store current jiffy
    lda TIMER1
    bne increment_timer1    ; if timer 1 is not 0, increment timer 1
    lda TIMER2
    bne increment_timer1    ; if timer 2 is not 0, increment timer 2
    lda TIMER3
    bne increment_timer1    ; if timer 3 is not 0, increment timer 3
    lda #0
    sta SPKR1               ; stop sound
    sta SPKR2
    sta SPKR3
    sta SPKR4
    jmp end_timer
    
increment_timer1:
    lda TIMER1              ; check if timer 1 is 0
    beq increment_timer2    ; if so, increment timer 2
    dec TIMER1              ; otherwise, decrement timer 1
    rts

increment_timer2:
    lda #255                ; reset timer 1
    sta TIMER1              ; store into timer 1 register
    lda TIMER2              ; check if timer 2 is 0
    beq increment_timer3    ; if so, increment timer 3
    dec TIMER2              ; otherwise, decrement timer 2
    rts

increment_timer3:
    lda #255                ; reset timer 2
    sta TIMER2              ; store into timer 2 register
    lda TIMER3              ; check if timer 3 is 0
    beq end_timer          ; if so, loop timer
    dec TIMER3              ; otherwise, decrement timer 3

end_timer:
    rts