    processor 6502

    incdir "refactor"
    incdir "data"
    incdir "levels"
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
    jsr initialize_clock           ; THIS INITIALIZES CLOCK

init:
    jsr load_level
    
game:
    jsr handle_input
    jsr handle_movement
    jsr handle_game_state
    jsr render_game
    jsr handle_timing
    jmp game
loop:
    ;jsr load_endscreen
    ;jmp start
    jmp loop

; -------- OTHER FILES ---------

    include "debug.s"               ; debugging subroutines
    include "utility.s"
    include "control.s"
    include "movement.s"
    include "state.s"
    include "render.s"
    ;include "titlescreen.s"
    ;include "music.s"
    include "zx02.s"

; ---- Memory Specific Data ----

    org $1c00
    include "charset.s"