; https://github.com/dmsc/zx02/blob/main/6502/zx02-optim.asm
; De-compressor for ZX02 files
; ----------------------------
;
; Decompress ZX02 data (6502 optimized format), optimized for speed and size
;  132 bytes code, 54.9 cycles/byte in test file.
;
; Compress with:
;    zx02 input.bin output.zx0
;
; (c) 2022 DMSC
; Code under MIT license, see LICENSE file.

; Updated the code so it works with DASM

; BASIC stub
  processor 6502
  org $1001
    dc.w nextstmt       
    dc.w 10             
    dc.b $9e, "4109", 0 
nextstmt               
    dc.w 0              

  incbin "titlescreen.zx02"

ZP      = $00          
OFFSET  = ZP+0
ZX0_SRC = ZP+2
ZX0_DST = ZP+4
BITR    = ZP+6
PNTR    = ZP+7


zx0_ini_block:
  lda #$00                ; load offset
  sta OFFSET              ; offset = 0
  sta OFFSET+1            ; offset = 0

  ; Load the compiled data location (It's 100D according to memory editor in the emulator)
  lda #$0D                ; lower byte
  sta ZX0_SRC
  lda #$10                ; upper byte
  sta ZX0_SRC+1

  ; Set the data destination location (1E00 is the screen memory)
  lda #$00                ; lower byte
  sta ZX0_DST
  lda #$1E                ; upper byte
  sta ZX0_DST+1
  
  ; Set BITR
  lda #$80                ; BITR = $80
  sta BITR

;--------------------------------------------------
; Decompress ZX0 data (6502 optimized format)

full_decomp:
  ; Get initialization block
  ldy #0

; Decode literal: Ccopy next N bytes from compressed file
;    Elias(length)  byte[1]  byte[2]  ...  byte[N]
decode_literal:
  jsr get_elias

cop0:
  lda (ZX0_SRC),y
  inc ZX0_SRC
  bne cop0_dst
  inc ZX0_SRC+1

cop0_dst:   
  sta (ZX0_DST),y
  inc ZX0_DST
  bne cop0_offset
  inc ZX0_DST+1

cop0_offset:
  dex
  bne cop0

  asl BITR
  bcs dzx0s_new_offset

; Copy from last offset (repeat N bytes from last offset)
;    Elias(length)
  jsr get_elias
dzx0s_copy:
  lda ZX0_DST
  sbc OFFSET  ; C=0 from get_elias
  sta PNTR
  lda ZX0_DST+1
  sbc OFFSET+1
  sta PNTR+1

cop1:
  lda (PNTR),y
  inc PNTR
  bne cop1_dst
  inc PNTR+1

cop1_dst:
  sta (ZX0_DST),y
  inc ZX0_DST
  bne cop1_decode
  inc ZX0_DST+1

cop1_decode:
  dex
  bne cop1

  asl BITR
  bcc decode_literal

; Copy from new offset (repeat N bytes from new offset)
;    Elias(MSB(offset))  LSB(offset)  Elias(length-1)
dzx0s_new_offset:
  ; Read elias code for high part of offset
  jsr get_elias
  beq loop ; Read a 0, signals the end
  ; Decrease and divide by 2
  dex
  txa
  lsr
  sta OFFSET+1

  ; Get low part of offset, a literal 7 bits
  lda (ZX0_SRC),y
  inc ZX0_SRC
  bne dzx0s_divide
  inc ZX0_SRC+1

dzx0s_divide:
  ; Divide by 2
  ror
  sta OFFSET

  ; And get the copy length.
  ; Start elias reading with the bit already in carry:
  ldx #1
  jsr elias_skip1

  inx
  bcc dzx0s_copy

; Read an elias-gamma interlaced code.
; ------------------------------------
elias_get:     ; Read next data bit to result
  asl BITR
  rol
  tax

get_elias:
  ; Get one bit
  asl BITR
  bne elias_skip1

  ; Read new bit from stream
  lda (ZX0_SRC),y
  inc ZX0_SRC
  bne elias_bitr
  inc ZX0_SRC+1

elias_bitr:
  rol
  sta BITR

elias_skip1:
  txa
  bcs elias_get
  ; Got ending bit, stop reading

loop:
  jmp loop

