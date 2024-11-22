    processor 6502

    incdir "refactor"
    incdir "data"
    include "constants.s"
    include "zeropage.s"

    org $1001
    include "stub.s"

start:
    jsr clearSCR                    ; Clear Screen and set BG color
    jsr loadChars                   ; Load Custom Charset

game:
    jsr handle_input
    jsr update_game_state

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

; ---- Memory Specific Data ----

    org $1c00
    include "charset.s"