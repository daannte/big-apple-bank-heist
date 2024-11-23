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
    cmp #32                     ; "<SPACE>"
    beq move_action             
    rts

; Subroutine : Move Up
; Description : 
move_up:

; Subroutine : Move Down
; Description : 
move_down:

; Subroutine : Move Left
; Description : 
move_left:

; Subroutine : Move Right
; Description : 
move_right:

; Subroutine : Action
; Description : Item usage: Loads from CURRENT_ITEM(ZP) and calls item use subroutine
;               *PICKAXE : Detect collision ahead and remove block and replace with <SPACE>
move_action:


; Subroutine : Animations
; Description : Animations
