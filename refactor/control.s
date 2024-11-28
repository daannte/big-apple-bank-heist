; control.s
; Input handling subroutines
    
    
; subroutine : Handle Input
; Description : calls GETIN, reads input and stores input in INPUT_COMMAND (ZP)
;               *** May change to joystick or $00C5 checks instead ***
    subroutine
handle_input:
    lda $00C5
    cmp #$09                      ; "W"
    beq .set_move_up
    cmp #$29                     ; "S"
    beq .set_move_down
    cmp #$11                     ; "A"
    beq .set_move_left
    cmp #$12                     ; "D"
    beq .set_move_right
    cmp #$20                     ; "<SPACE>"
    beq .set_action_space           
    rts

.set_move_up:
    lda #87
    sta INPUT_COMMAND
    rts

.set_move_down:
    lda #83
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