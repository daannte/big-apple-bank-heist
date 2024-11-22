; render.s
; Rendering Objects Subroutines
    subroutine

; Subroutine : Render Game
; Description : Render game objects
render_game:
    rts

; Subroutine : Draw player
; Description : Draws Player Character
draw_player:
    ldx X_POS
    ldy Y_POS
    clc
    jsr PLOT
    lda CURRENT
    jsr CHROUT
    rts 
