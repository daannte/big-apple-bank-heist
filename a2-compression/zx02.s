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

CHROUT = $FFD2
SCREEN = $900F

; BASIC stub
  processor 6502
  org $1001
    dc.w nextstmt       
    dc.w 10             
    dc.b $9e, [start]d, 0 
nextstmt               
    dc.w 0              

out_addr = $1e00

comp_data
  incbin "titlescreen.zx02"


ZP        = $80
offset_hi = ZP+0
ZX0_src   = ZP+1
ZX0_dst   = ZP+3
bitr      = ZP+5
pntr      = ZP+6

            ; Initial values for offset_hi, source, destination, bitr and pntr
zx0_ini_block
  .byte $00, <comp_data, >comp_data, <out_addr, >out_addr, $80, $ff

start:
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

;--------------------------------------------------
; Decompress ZX0 data (6502 optimized format)

full_decomp:
  ; Get initialization block
  ldy #7

copy_init:
  ldx zx0_ini_block-1,y
  stx offset_hi-1,y
  dey
  bne copy_init

; Decode literal: Ccopy next N bytes from compressed file
;    Elias(length)  byte[1]  byte[2]  ...  byte[N]
decode_literal:
  inx
  jsr get_elias

cop0:          
  lda (ZX0_src),y
  inc ZX0_src
  bne cop0_dst
  inc ZX0_src+1

cop0_dst:
  sta (ZX0_dst),y
  inc ZX0_dst
  bne cop0_bitr
  inc ZX0_dst+1

cop0_bitr:
  dex
  bne cop0

  asl bitr
  bcs dzx0s_new_offset

; Copy from last offset (repeat N bytes from last offset)
;    Elias(length)
  inx
  jsr get_elias
dzx0s_copy:
  lda ZX0_dst+1
  sbc offset_hi  ; C=0 from get_elias
  sta pntr+1

cop1:
  ldy ZX0_dst
  lda (pntr),y
  ldy #0
  sta (ZX0_dst),y
  inc ZX0_dst
  bne cop1_dst
  inc ZX0_dst+1
  inc pntr+1

cop1_dst:             
  dex
  bne cop1

  asl bitr
  bcc decode_literal

; Copy from new offset (repeat N bytes from new offset)
;    Elias(MSB(offset))  LSB(offset)  Elias(length-1)
dzx0s_new_offset:
  ; Read elias code for high part of offset
  inx
  jsr get_elias
  beq loop  ; Read a 0, signals the end
  ; Decrease and divide by 2
  dex
  txa
  lsr 
  sta offset_hi

  ; Get low part of offset, a literal 7 bits
  lda (ZX0_src),y
  inc ZX0_src
  bne dzx0s_divide
  inc ZX0_src+1

dzx0s_divide:
  ; Divide by 2
  ror 
  eor #$ff
  sta pntr

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
  bne get_elias_bitr
  inc ZX0_src+1
get_elias_bitr:             ;sec   ; not needed, C=1 guaranteed from last bit
  rol 
  sta bitr

elias_skip1:
  txa
  bcs elias_get
  ; Got ending bit, stop reading

loop:
  rts
