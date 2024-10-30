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

  incbin "titlescreen.exo"
exo_data_end

start:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

bg:
  ldx #0                ; Set X to black
  lda SCREEN            ; Load the screen colour address
  and	#$0F              ; Reset the 4 background bits
  stx $1001             ; Store X into the user basic area memory
  ora $1001             ; Combine new background color with the screen
  sta SCREEN            ; Store new colour into the screen colour address


border:
  ldx #0                ; Set X to black
  lda SCREEN            ; Load the screen colour address
  and	#$F8              ; Reset the 3 border bits
  stx $1001             ; Store X into the user basic area memory
  ora $1001             ; Combine new border colour with the screen 
  sta SCREEN            ; Store new colour into the screen colour address

title:
  ldx #1                ; Set X to white
  stx $0286             ; Store X into current color code address

decrunch:
  jsr exod_decrunch     ; Jump to the exomizer decompression code
  jmp loop              ; Jump to loop once finished decompressing

; We need this function
; I stole it from the main.s in the exomizer repo
exod_get_crunched_byte:
  lda _byte_lo
  bne _byte_skip_hi
  dec _byte_hi
_byte_skip_hi:
  dec _byte_lo
_byte_lo = * + 1
_byte_hi = * + 2
  lda exo_data_end
  rts

loop:
  jmp loop              ; Loop forever

  include "exodecrunch.s"
