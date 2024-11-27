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
    jsr init_set

    ; Level Init
    lda #0
    sta CURRENT_LEVEL

    ; Player Lives Init
    lda #2
    sta PLAYER_LIVES

init:
    jsr load_level
    jsr initialize_clock           ; THIS INITIALIZES CLOCK

game:
    ;jsr handle_input
    ;jsr handle_movement
    jsr handle_game_state
    jsr render_game
    jsr handle_timing
    jmp game
loop:
    jmp loop

; -------- SUBROUTINES ---------

; -------- OTHER FILES ---------

    include "debug.s"               ; debugging subroutines
    include "utility.s"
    include "control.s"
    include "movement.s"
    include "render.s"
    include "state.s"

; ---- Memory Specific Data ----

    org $1c00
    include "charset.s"