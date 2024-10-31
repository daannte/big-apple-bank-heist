       processor 6502

CHROUT = $ffd2
SCREEN = $900f
PLOT   = $FFF0

        org $1001

        ; BASIC stub
        dc.w nextstmt       ; next BASIC statement
        dc.w 10             ; line number
        dc.b $9e, "4109", 0 ; Start of assembly program
nextstmt
        dc.w 0

; BEGIN PROGRAM HERE
CLR     LDA #147
        JSR CHROUT

BG      LDA #$0F                ; Reset the 4 background bits
        AND SCREEN
        STA SCREEN              ; Store new colour into the screen colour address
        LDA #$F8
        AND SCREEN
        STA SCREEN
        LDX #1
        STX $0286


START   LDX #$00                ; Initialize X register to point to compressed data
LOOP    LDA DATA,X              ; Load the next byte (literal)
        STA TEMP_LITERAL        ; Store the literal in TEMP_LITERAL
        INX                     ; Move to the length byte
        LDA DATA,X              ; Load the length (number of repetitions)
        STA LENGTH              ; Store the length

        LDY #$00
LITERAL_LOOP
        LDA TEMP_LITERAL        ; Load the literal value
        JSR $FFD2               ; Output each byte using CHROUT
        INY
        CPY LENGTH              ; Check if we've reached the repeat count
        BNE LITERAL_LOOP

NEXT    INX                     ; Move to the next literal in compressed data
        CPX DATA_END            ; Check if we are at the end of DATA
        BNE LOOP                ; Loop until finished

        LDA #$00
        STA TEMP_LITERAL

HOLD    JMP HOLD

LENGTH: 
        .byte 0
DISTANCE: 
        .byte 0
TEMP_LITERAL 
        .BYTE $00          ; Temporary storage for literal value


.DATABANK: .byte

DATA: 
        .byte $20, $30, $54, $01, $48, $01, $45, $01, $20, $01, $42, $01, $49, $01, $47, $01, $20, $01
        .byte $41, $01, $50, $02, $4C, $01, $45, $01, $20, $20, $42, $01, $41, $01, $4E, $01, $4B, $01
        .byte $20, $02, $48, $01, $45, $01, $49, $01, $53, $01, $54, $01, $20, $36, $44, $01, $41, $01
        .byte $4E, $01, $54, $01, $45, $01, $20, $02, $4B, $01, $49, $01, $52, $01, $53, $01, $4D, $01
        .byte $41, $01, $4E, $01, $20, $07, $44, $01, $41, $01, $4E, $01, $49, $01, $45, $01, $4C, $01
        .byte $20, $02, $53, $01, $41, $01, $42, $01, $4F, $01, $55, $01, $52, $01, $4F, $01, $56, $01
        .byte $20, $06, $52, $01, $41, $01, $4D, $01, $49, $01, $52, $01, $4F, $01, $20, $02, $50, $01
        .byte $49, $01, $51, $01, $55, $01, $45, $01, $52, $01, $20, $0B, $4A, $01, $49, $01, $4E, $01
        .byte $20, $02, $53, $01, $4F, $01, $4E, $01, $47, $01
        .byte $20, $25, $32, $01, $30, $01, $32, $01, $34, $01, $20, $3F, $6E, $01, $6D, $01, $20, $13
        .byte $6E, $01, $24, $02, $6D, $01, $20, $11, $A6, $06, $20, $10, $B6, $01, $20, $01, $B5, $01
        .byte $B6, $01, $20, $01, $B5, $01, $20, $10, $B6, $01, $20, $01, $B5, $01, $B6, $01, $20, $01
        .byte $B5, $01, $20, $10, $B6, $01, $20, $01, $B5, $01, $B6, $01, $20, $01, $B5, $01, $20, $10
        .byte $B8, $06

DATA_END:
        .byte #$00
