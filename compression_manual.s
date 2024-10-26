    processor 6502
    
CHROUT = $ffd2
PLOT   = $FFF0
OFFSET = $1DFF
SCREEN = $900f

    org $1001

; BASIC stub
    dc.w nextstmt       ; next BASIC statement
    dc.w 10             ; line number
    dc.b $9e, "4109", 0 ; Start of assembly program
nextstmt                ; next BASIC statement
    dc.w 0       

; Start of program
clr:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

bg:
  ldx #0              ; Set X to black
  lda SCREEN          ; Load the screen colour address
  and	#$0F            ; Reset the 4 background bits
  stx $1001           ; Store X into the user basic area memory
  ora $1001           ; Combine new background color with the screen
  sta SCREEN          ; Store new colour into the screen colour address


border:
  ldx #0              ; Set X to black
  lda SCREEN          ; Load the screen colour address
  and	#$F8            ; Reset the 3 border bits
  stx $1001           ; Store X into the user basic area memory
  ora $1001           ; Combine new border colour with the screen 
  sta SCREEN          ; Store new colour into the screen colour address

title:
    ldx #1              ; Set X to white
    stx $0286           ; Store X into current color code address

    LDA #$00                ; Reset A
    STA OFFSET

DECOMPRESS:
    LDX OFFSET
    LDA RLE_DATA,X         ; Load the current RLE data byte (character)
    BEQ END                 ; If it's zero, we've reached the end

    ; Load the next byte (run length)
    TAY
    INX                     ; Move to the next RLE data byte
    INC OFFSET              ; Increment the offset
    LDA RLE_DATA,X         ; Load the run length
    BEQ END                 ; If run length is zero, exit

    ; Repeat character based on run length
    TAX
    TYA

REPEAT_CHAR:
    JSR CHROUT             ; Output the character
    DEX                     ; Decrement run length counter
    CPX #$00                ; Check if run length is zero
    BNE REPEAT_CHAR         ; If not, repeat the character

    INC OFFSET              ; Increment the offset
    JMP DECOMPRESS          ; Repeat the decompression process

END:
    jmp END

; RLE Data Storage
; THE BIG APPLE
; BANK HEIST
RLE_DATA:
    .byte #$20, #$16
    .byte #$20, #$16
    .byte #$20, #$16
    .byte #$20, #$05, #$54, #$01, #$48, #$01, #$45, #$01, #$20, #$01, #$42, #$01, #$49, #$01, #$47, #$01, #$20, #$01, #$41, #$01, #$50, #$02, #$4C, #$01, #$45, #$01, #$20, #$04
    .byte #$20, #$16
    .byte #$20, #$06, #$42, #$01, #$41, #$01, #$4e, #$01, #$4b, #$01, #$20, #$02, #$48, #$01, #$45, #$01, #$49, #$01, #$53, #$01, #$54, #$01, #$20, #$04    
    .byte #$20, #$16
    .byte #$20, #$16
    .byte #$20, #$06, #$44, #$01, #$41, #$01, #$4e, #$01, #$54, #$01, #$45, #$01, #$20, #$02, #$4b, #$01, #$49, #$01, #$52, #$01, #$53, #$01, #$4d, #$01, #$41, #$01, #$4e, #$01, #$20, #$03
    .byte #$20, #$04, #$44, #$01, #$41, #$01, #$4e, #$01, #$49, #$01, #$45, #$01, #$4c, #$01, #$20, #$02, #$53, #$01, #$41, #$01, #$42, #$01, #$4f, #$01, #$55, #$01, #$52, #$01, #$4f, #$01, #$56, #$01, #$20, #$02
    .byte #$20, #$04, #$52, #$01, #$41, #$01, #$4d, #$01, #$49, #$01, #$52, #$01, #$4f, #$01, #$20, #$02, #$50, #$01, #$49, #$01, #$51, #$01, #$55, #$01, #$45, #$01, #$52, #$01, #$20, #$04
    .byte #$20, #$07, #$4a, #$01, #$49, #$01, #$4e, #$01, #$20, #$02, #$53, #$01, #$4f, #$01, #$4e, #$01, #$47, #$01, #$20, #$07
    .byte #$20, #$16
    .byte #$20, #$08, #$32, #$01, #$30, #$01, #$32, #$01, #$34, #$01, #$20, #$09
    .byte #$20, #$16
    .byte #$20, #$0A, #$6E, #$01, #$6D, #$01, #$20, #$0A
    ; THE REST OF THE BANK ASCII ART GOES BELOW HERE
    
    .byte #$00  ; End marker for data