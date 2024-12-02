  processor 6502

  incdir  "refactor_2"
  include "constants.s"
  include "zeropage.s"
  org $1001
  include "stub.s"
  
comp_data
  incbin "titlescreen.zx02"

level_pointers
  dc.w level_1
  dc.w level_2
  dc.w level_3

level_1
  incbin "levels/level1.data"
level_2
  incbin "levels/level2.data"
level_3
  incbin "levels/level3.data"

start:
  jsr handle_setup

titlescreen:
  jsr draw_titlescreen

init:
  jsr initialize_variables
  jsr load_level
  jsr main_loop
  cmp #0      ; if 0, player lost. If 1, continue game.
  beq start
  jmp init

main_loop:
  jsr handle_input
  lda DIED
  beq .died

  lda X_POS
  cmp EXIT_X
  bne .not_exited
  lda Y_POS
  cmp EXIT_Y
  bne .not_exited
  
  jsr increment_level
  rts

.not_exited:
  jsr increment_clock
  cmp #0
  bne .died
  jmp main_loop

.died:
  jsr handle_lives
  rts

; -------- SUBROUTINES --------

  include "setup.s"
  include "clock.s"
  include "levels.s"
  include "lives.s"
  include "movement.s"
  include "screens.s"
  include "zx02.s"
  include "music.s"

; -------------------

  org $1c00
  include "charset.s"

  org $1d00
  include "musicdata.s"

