    processor 6502

    incdir "refactor"
    incdir "refactor/data"
    incdir "refactor/levels"
    include "constants.s"
    include "zeropage.s"

    org $1001
    include "stub.s"

level_pointers:
    dc.w level_1
level_1
    incbin "level1.data"

comp_data
    incbin "titlescreen.zx02"

start:
    jsr clear_scr                  ; Clear Screen and set BG color
    jsr load_chars                 ; Load Custom Charset
    jsr init_set

    ; Level Init
    lda #0
    sta CURRENT_LEVEL

    lda #ROBBER_R
    sta CURRENT

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
    jsr load_endscreen
    jmp start

; -------- SUBROUTINES ---------

; -------- OTHER FILES ---------

    include "debug.s"               ; debugging subroutines
    include "utility.s"
    include "control.s"
    include "movement.s"
    include "state.s"
    include "render.s"
<<<<<<< HEAD
    include "state.s"
    include "titlescreen.s"
=======
>>>>>>> 2fe4694 (Add subroutine tag to all subroutines, delete redundant file in refactor directory)
    include "zx02.s"

; ---- Memory Specific Data ----

    org $1c00
    include "charset.s"