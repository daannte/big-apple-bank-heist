CHROUT = $ffd2
PLOT   = $FFF0
OFFSET = $1DFF
SCREEN = $900f


; BASIC stub
  processor 6502
  org $1001
    dc.w nextstmt       
    dc.w 10             
    dc.b $9e, "4109", 0 
nextstmt               
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
  ldx #1              ; set x to white
  stx $0286           ; store x into current color code address

  lda #$00            ; reset a
  sta OFFSET

decompress:
  ldx OFFSET
  lda rle_data,x         ; load the current rle data byte (character)
  beq end                ; if it's zero, we've reached the end

  ; load the next byte (run length)
  tay
  inx                    ; move to the next rle data byte
  inc OFFSET             ; increment the offset
  lda rle_data,x         ; load the run length
  beq end                ; if run length is zero, exit

  ; repeat character based on run length
  tax
  tya

repeat_char:
  jsr CHROUT             ; Output the character
  dex                    ; Decrement run length counter
  cpx #$00               ; Check if run length is zero
  bne repeat_char        ; If not, repeat the character

  inc OFFSET             ; Increment the offset
  jmp decompress         ; Repeat the decompression process

end:
  jmp end

; RLE Data Storage
; THE BIG APPLE
; BANK HEIST
rle_data:
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

  ; Bank Art
  .byte #$20, #$0A, #$6E, #$01, #$6D, #$01, #$20, #$0A
  .byte #$20, #$09, #$6E, #$01, #$24, #$02, #$6D, #$01, #$20, #$09
  .byte #$20, #$08, #$A6, #$06, #$20, #$08
  .byte #$20, #$08, #$B6, #$01, #$20, #$01, #$B5, #$01, #$B6, #$01, #$20, #$01, #$B5, #$01, #$20, #$08
  .byte #$20, #$08, #$B6, #$01, #$20, #$01, #$B5, #$01, #$B6, #$01, #$20, #$01, #$B5, #$01, #$20, #$08
  .byte #$20, #$08, #$B6, #$01, #$20, #$01, #$B5, #$01, #$B6, #$01, #$20, #$01, #$B5, #$01, #$20, #$08
  .byte #$20, #$08, #$B8, #$06, #$20, #$08

  ; End marker for data
  .byte #$00
