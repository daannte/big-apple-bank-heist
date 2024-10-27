; BASIC stub
  processor 6502
  org $1001
    dc.w nextstmt       
    dc.w 10             
    dc.b $9e, "4109", 0 
nextstmt               
    dc.w 0              


  incbin "titlescreen.exo"
exo_data_end

exomizer_decomp:
  jsr exod_decrunch

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
  jmp loop

  include "exodecrunch.s"
