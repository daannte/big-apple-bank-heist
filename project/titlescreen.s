draw_titlescreen:
  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

bg_and_border:
  ldx #0              ; Set X to black
  lda SCREEN          ; Load screen colour
  and #$08            ; Reset both bg and border bits
  stx $1001           ; Store black value
  ora $1001           ; Combine colours
  sta SCREEN          ; Update screen

;  lda #0              ; Set X to black
;  lda SCREEN          ; Load the screen colour address
;  and	#$0F            ; Reset the 4 background bits
;  stx $1001           ; Store X into the user basic area memory
;  ora $1001           ; Combine new background color with the screen
;  sta SCREEN          ; Store new colour into the screen colour address
;
;border:
;  ldx #0              ; Set X to black
;  lda SCREEN          ; Load the screen colour address
;  and	#$F8            ; Reset the 3 border bits
;  stx $1001           ; Store X into the user basic area memory
;  ora $1001           ; Combine new border colour with the screen 
;  sta SCREEN          ; Store new colour into the screen colour address

title:
  ldx #1              ; Set X to white
  stx $0286           ; Store X into current color code address

decomp:
  jsr full_decomp

end:
  rts

