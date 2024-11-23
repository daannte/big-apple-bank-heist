    processor 6502

    incdir "refactor"
    incdir "data"
    include "constants.s"
    include "zeropage.s"

    org $1001
    include "stub.s"

level_pointers:
    dc.w level_1

level_1
    incbin "levels/level1.data"


start:
    jsr clear_scr                  ; Clear Screen and set BG color
    jsr load_chars                 ; Load Custom Charset

init:
    lda #0
    sta CURRENT_LEVEL
    lda #2
    sta PLAYER_LIVES

game:
    jsr test_level
    ;jsr handle_input
    ;jsr update_game_state
    ;jsr render_game
    ;jsr handle_timing

loop:
    jmp loop

; -------- SUBROUTINES ---------

; Subroutine : Update Game State
; Description : Update game states, such as 
;               Gravity, Movement, Collisions, Pickups, Actions, etc.
update_game_state:
    jsr handle_movement

; -------- OTHER FILES ---------

    include "debug.s"               ; debugging subroutines
    include "utility.s"
    include "control.s"
    include "movement.s"
    include "render.s"

; ---- Memory Specific Data ----

    org $1c00
    include "charset.s"