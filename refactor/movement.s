; movement.s
; Movement related subroutines
; States saved on ZP memory is used to manipulate movement
;   for modularity

    subroutine

; Subroutine : Handle Movement
; Description : Loads INPUT_COMMAND(ZP), moves character sprite
handle_movement:
    lda INPUT_COMMAND
    cmp #87                     ; "W"
    beq move_up
    cmp #83                     ; "S"
    beq move_down
    cmp #65                     ; "A"
    beq move_left
    cmp #68                     ; "D"
    beq move_right 
    rts

; Subroutine : Move Up
; Description : 
move_up:
