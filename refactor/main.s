    processor 6502

    incdir "refactor"
    incdir "refactor/data"
    incdir "refactor/levels"
    include "constants.s"
    include "zeropage.s"

    org $1001
    include "stub.s"

level_pointers:
    dc.w level_1, level_2, level_3
    
level_1
    incbin "level1.data"
level_2
    incbin "level2.data"
level_3
    incbin "level3.data"

comp_data
    incbin "titlescreen.zx02"

start:
    jsr clear_scr                  ; Clear Screen and set BG color
    jsr initialize_clock           ; THIS INITIALIZES CLOCK

title:
    jsr draw_titlescreen
    lda #0                         ; Level Init
    sta CURRENT_LEVEL
    lda #2                      ; Player Lives Init
    sta PLAYER_LIVES
init:
    jsr reset_score
    jsr load_chars                 ; Load Custom Charset
init2:
    jsr init_set
    jsr load_level
game:
    lda LEVEL_UP
    bne .level_up
    lda TIME_OUT_FLAG
    bne .lose_life
    jsr handle_input
    jsr handle_movement
    jsr handle_game_state
    jsr render_game
    jsr handle_timing
    jmp game

.level_up:
    jsr add_score
    inc CURRENT_LEVEL
    lda CURRENT_LEVEL
    cmp #MAX_LEVELS
    beq .score_scene
    jmp init2

.lose_life:
    lda PLAYER_LIVES
    beq .game_over
    dec PLAYER_LIVES
    jmp init2

.score_scene:
    jsr load_endscreen

.game_over:
    jmp start

; -------- OTHER FILES ---------

    ;include "debug.s"               ; debugging subroutines
    include "utility.s"
    include "control.s"
    include "movement.s"
    include "state.s"
    include "render.s"
    include "titlescreen.s"
    include "music.s"
    include "zx02.s"

; ---- Memory Specific Data ----

    org $1c00
    include "charset.s"

    org $1d00
    include "musicdata.s"