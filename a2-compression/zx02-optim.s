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
offset  = ZP+0
ZX0_src = ZP+2
ZX0_dst = ZP+4
bitr    = ZP+6
pntr    = ZP+7


zx0_ini_block:
  lda #$00                ; load offset
  sta $00                 ; offset = 0
  sta $01                 ; offset = 0
  lda #$0D                ; load compiled data, lower byte
  sta $02
  lda #$10                ; load compiled data, uopper byte
  sta $03
  lda #$00                ; set destination location lower byte
  sta $04
  lda #$1E                ; set destination location upper byte
  sta $05         
  lda #$80                ; bitr = $80
  sta $06
  lda #$ff                ; pntr = $ff              
  sta $07

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
  lda (ZX0_src),y
  inc ZX0_src
  bne cop0_dst
  inc ZX0_src+1

cop0_dst:   
  sta (ZX0_dst),y
  inc ZX0_dst
  bne cop0_offset
  inc ZX0_dst+1

cop0_offset:
  dex
  bne cop0

  asl bitr
  bcs dzx0s_new_offset

; Copy from last offset (repeat N bytes from last offset)
;    Elias(length)
  jsr get_elias
dzx0s_copy:
  lda ZX0_dst
  sbc offset  ; C=0 from get_elias
  sta pntr
  lda ZX0_dst+1
  sbc offset+1
  sta pntr+1

cop1:
  lda (pntr),y
  inc pntr
  bne cop1_dst
  inc pntr+1

cop1_dst:
  sta (ZX0_dst),y
  inc ZX0_dst
  bne cop1_decode
  inc ZX0_dst+1

cop1_decode:
  dex
  bne cop1

  asl bitr
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
  sta offset+1

  ; Get low part of offset, a literal 7 bits
  lda (ZX0_src),y
  inc ZX0_src
  bne dzx0s_divide
  inc ZX0_src+1

dzx0s_divide:
  ; Divide by 2
  ror
  sta offset

  ; And get the copy length.
  ; Start elias reading with the bit already in carry:
  ldx #1
  jsr elias_skip1

  inx
  bcc dzx0s_copy

; Read an elias-gamma interlaced code.
; ------------------------------------
elias_get:     ; Read next data bit to result
  asl bitr
  rol
  tax

get_elias:
  ; Get one bit
  asl bitr
  bne elias_skip1

  ; Read new bit from stream
  lda (ZX0_src),y
  inc ZX0_src
  bne elias_bitr
  inc ZX0_src+1

elias_bitr:
  rol
  sta bitr

elias_skip1:
  txa
  bcs elias_get
  ; Got ending bit, stop reading

loop:
  jmp loop

