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
    lda #10         ; load volume as 15 (max)
    sta VOL         ; store into volume register (AKA set volume)

    ldx #100          ; load x register as 0

    ldy #Fs1        ; load x register as F#1
    sty SPKR3       ; store into high frequency register

    ldy #0    

gameloop:           ; play a note on loop
    jmp gameloop

end:
    rts             ; return from subroutine