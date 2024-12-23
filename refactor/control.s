; control.s
; Input handling subroutines
    
    
; subroutine : Handle Input
; Description : calls GETIN, reads input and stores input in INPUT_COMMAND (ZP)
;               *** May change to joystick or $00C5 checks instead ***
    subroutine
handle_input:
    ; If movement is in process (animation is supposed to be rendered)
    ; Ignore input for this Loop
    lda $00C5
    sta INPUT_COMMAND
    cmp #$09                    ; "W"
    beq .set_move_up
    cmp #$11                    ; "A"
    beq .set_move_left
    cmp #$12                    ; "D"
    beq .set_move_right
    cmp #$15                    ; "L"
    beq .set_cheat              
    lda #0
    sta INPUT_COMMAND                          
    jmp .set_exit

.set_move_up:
    lda #87
    sta INPUT_COMMAND
    jmp .set_exit

.set_move_left:
    lda #65
    sta INPUT_COMMAND
    jmp .set_exit

.set_move_right:
    lda #68
    sta INPUT_COMMAND
    jmp .set_exit

.set_cheat:
    lda #1
    sta LEVEL_UP

.set_exit
    rts