  subroutine
move_guards:
  lda #0                ; Load 0 into A
  sta GUARD_INDEX       ; Store 0 into the GUARD_INDEX to get ready to update the guards

.dir_to_move:
  ldx GUARD_INDEX       ; Load the current guard we are updating
  cpx NUM_OF_GUARDS     ; If we looped through all the guards, then branch to end
  beq .end              ; branch to end

  lda GUARDS_DIR,x
  bne .move_right
  jmp .move_left


.move_right:
  lda GUARDS_X_POS,x 
  cmp #20
  beq .end_move
  ;inc GUARDS_Y_POS,x 
  ;jsr check_collision
  ;dec GUARDS_Y_POS,x 
  ;cmp #1
  ;beq .end_move_right
  lda #0
  sta GUARDS_DIR,x

  inc GUARDS_X_POS,x 
  ldy GUARDS_X_POS,x
  lda GUARDS_Y_POS,x
  tax
  clc
  jsr PLOT
  lda #GUARD
  jsr CHROUT

  jmp .end_move

.move_left:
  lda GUARDS_X_POS,x 
  cmp #1
  beq .end_move
  ;inc GUARDS_Y_POS,x 
  ;jsr check_collision
  ;dec GUARDS_Y_POS,x 
  ;cmp #1
  ;beq .end_move_right
  lda #1
  sta GUARDS_DIR,x

  dec GUARDS_X_POS,x 
  ldy GUARDS_X_POS,x
  lda GUARDS_Y_POS,x
  tax
  clc
  jsr PLOT
  lda #GUARD
  jsr CHROUT

.end_move:
  inc GUARD_INDEX       ; Increment the guard we are updating
  jmp .dir_to_move      ; Update the next guard

.end:
  rts
