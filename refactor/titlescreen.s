  subroutine

draw_titlescreen:
  lda #$f0                ; loading 240 into CHARSET to reset character set for titlescreen 
  sta CHARSET             ; the above can be found on page 267
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

.bg_and_border:
  ldx #0              ; Set X to black
  lda SCREEN          ; Load screen colour
  and #$08            ; Reset both bg and border bits
  sta SCREEN          ; Update screen

.title:
  ldx #1              ; Set X to white
  stx $0286           ; Store X into current color code address

.decomp:
  jsr full_decomp

play_music:
  lda #0
  sta $00C6
  jsr musicinit
  jmp .end

title_input_loop:
  ; jsr GETIN             ; JIN - input check done in music
  ; cmp #00               ; Keep looping until we get a value
  beq title_input_loop

.end:
  rts

