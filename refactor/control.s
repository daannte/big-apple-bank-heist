; control.s
; Input handling subroutines
    
    subroutine

; subroutine : Handle Input
; Description : calls GETIN, reads input and stores input in INPUT_COMMAND (ZP)
handle_input:
    jsr GETIN
    cmp #87                     ; "W"
    beq .set_move_up
    cmp #83                     ; "S"
    beq .set_move_down
    cmp #65                     ; "A"
    beq .set_move_left
    cmp #68                     ; "D"
    beq .set_move_right
    cmp #32                     ; "<SPACE>"
    beq .set_action_space           
    rts

.set_move_up:
    lda #87
    sta INPUT_COMMAND
    rts

.set_move_down:
    lda #32
    sta INPUT_COMMAND
    rts

.set_move_left:
    lda #65
    sta INPUT_COMMAND
    rts

.set_move_right:
    lda #68
    sta INPUT_COMMAND
    rts

.set_action_space
    lda #32
    sta INPUT_COMMAND
    rts