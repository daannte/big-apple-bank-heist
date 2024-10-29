CHROUT = $FFD2
SCREEN = $900F

; BASIC stub
  processor 6502
  org $1001
    dc.w nextstmt       
    dc.w 10             
    dc.b $9e, "4109", 0 
nextstmt               
    dc.w 0              

OFFSET = $00
COMPRESSED_CHAR = $01
DATA_SECTION = $02  

; Start of program
clr:
  lda #147                ; Load clear screen command
  jsr CHROUT              ; Print it

bg:
  ldx #0                  ; Set X to black
  lda SCREEN              ; Load the screen colour address
  and #$0F                ; Reset the 4 background bits
  stx $1001               ; Store X into the user basic area memory
  ora $1001               ; Combine new background color with the screen
  sta SCREEN              ; Store new colour into the screen colour address

border:
  ldx #0                  ; Set X to black
  lda SCREEN              ; Load the screen colour address
  and #$F8                ; Reset the 3 border bits
  stx $1001               ; Store X into the user basic area memory
  ora $1001               ; Combine new border colour with the screen 
  sta SCREEN              ; Store new colour into the screen colour address

title:
  ldx #1                  ; Set x to white
  stx $0286               ; Store x into current color code address

decompress:
  lda #0                  ; Reset a
  tay                     ; Set y to 0              
  sta OFFSET              ; Set offset to 0
  sta DATA_SECTION        ; Set DATA_SECTION to 0

next_char:
  ldx OFFSET              ; Grab the offset 
  lda DATA_SECTION        ; Check which section we are decompressing
  beq load_title_data 
  lda rle_bank_data,x     ; Load the current character to decompress for bank
  jmp process_char

load_title_data:
  lda rle_title_data,x    ; Load the current character to decompress for title

process_char:
  sta COMPRESSED_CHAR     ; Store the char for later use
  beq check_data_section  ; If character is zero, check data section

  inx                     ; Move to the next RLE data byte
  stx OFFSET              ; Set the new offset for later
  lda DATA_SECTION        ; Check which section we are decompressing
  beq load_title_length    
  lda rle_bank_data,x     ; Load the run length value for bank
  jmp store_run_length

load_title_length:
  lda rle_title_data,x    ; load the run length value for title

store_run_length:
  tax                     ; Store the run length in X

decompress_char:
  lda COMPRESSED_CHAR     ; Load the character
  jsr CHROUT              ; Print to screen
  dex                     ; Decrement run length
  bne decompress_char     ; Repeat until run length is zero

  inc OFFSET              ; Increment offset since we finished the run length
  jmp next_char           ; Go to the next character

check_data_section:
  lda DATA_SECTION
  beq switch_to_bank      ; If we are in the title section, switch to bank data
  jmp end                 ; Otherwise, we are done

switch_to_bank:
  lda #1
  sta DATA_SECTION        ; Set DATA_SECTION to 1 for rle_bank_data
  lda #0
  sta OFFSET              ; Reset OFFSET to 0 for new data section
  jmp next_char           ; Start decompressing rle_bank_data

end:
  jmp end                 ; Infinite loop

; RLE Data Storage
; THE BIG APPLE
; BANK HEIST
rle_title_data:
  .byte #$20, #$16
  .byte #$20, #$16
  .byte #$20, #$04, #$54, #$01, #$48, #$01, #$45, #$01, #$20, #$01, #$42, #$01, #$49, #$01, #$47, #$01, #$20, #$01, #$41, #$01, #$50, #$02, #$4C, #$01, #$45, #$01, #$20, #$05
  .byte #$20, #$16
  .byte #$20, #$05, #$42, #$01, #$41, #$01, #$4e, #$01, #$4b, #$01, #$20, #$02, #$48, #$01, #$45, #$01, #$49, #$01, #$53, #$01, #$54, #$01, #$20, #$05    
  .byte #$20, #$16
  .byte #$20, #$16
  .byte #$20, #$05, #$44, #$01, #$41, #$01, #$4e, #$01, #$54, #$01, #$45, #$01, #$20, #$02, #$4b, #$01, #$49, #$01, #$52, #$01, #$53, #$01, #$4d, #$01, #$41, #$01, #$4e, #$01, #$20, #$03
  .byte #$20, #$04, #$44, #$01, #$41, #$01, #$4e, #$01, #$49, #$01, #$45, #$01, #$4c, #$01, #$20, #$02, #$53, #$01, #$41, #$01, #$42, #$01, #$4f, #$01, #$55, #$01, #$52, #$01, #$4f, #$01, #$56, #$01, #$20, #$02
  .byte #$20, #$04, #$52, #$01, #$41, #$01, #$4d, #$01, #$49, #$01, #$52, #$01, #$4f, #$01, #$20, #$02, #$50, #$01, #$49, #$01, #$51, #$01, #$55, #$01, #$45, #$01, #$52, #$01, #$20, #$04
  .byte #$20, #$07, #$4a, #$01, #$49, #$01, #$4e, #$01, #$20, #$02, #$53, #$01, #$4f, #$01, #$4e, #$01, #$47, #$01, #$20, #$06
  .byte #$20, #$16
  .byte #$20, #$09, #$32, #$01, #$30, #$01, #$32, #$01, #$34, #$01, #$20, #$09
  .byte #$20, #$16
  .byte #$20, #$16
  ; End marker for title data
  .byte #$00

rle_bank_data:
  ; Bank Art
  .byte #$20, #$0A, #$6E, #$01, #$6D, #$01, #$20, #$0A
  .byte #$20, #$09, #$6E, #$01, #$24, #$02, #$6D, #$01, #$20, #$09
  .byte #$20, #$08, #$A6, #$06, #$20, #$08
  .byte #$20, #$08, #$B6, #$01, #$20, #$01, #$B5, #$01, #$B6, #$01, #$20, #$01, #$B5, #$01, #$20, #$08
  .byte #$20, #$08, #$B6, #$01, #$20, #$01, #$B5, #$01, #$B6, #$01, #$20, #$01, #$B5, #$01, #$20, #$08
  .byte #$20, #$08, #$B6, #$01, #$20, #$01, #$B5, #$01, #$B6, #$01, #$20, #$01, #$B5, #$01, #$20, #$08
  .byte #$20, #$08, #$B8, #$06, #$20, #$08
  ; End marker for bank data
  .byte #$00
