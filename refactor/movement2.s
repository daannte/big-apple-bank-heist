; movement.s
; Movement related subroutines
; ** ONLY sets flags for it to be changed later in state.s

; Subroutine : Handle Movement
; Description : Sets flags indicating type of movement
handle_movement:
    lda FRAME_STATE
    cmp #2              ; If destination frame hasn't been rendered yet
    beq .skip_input
    jsr read_input
.skip_input:
    rts

; Subroutine : Read Input
; Description : Loads INPUT_COMMAND and branch accordingly
read_input:
    ; Read Input
    lda INPUT_COMMAND
    cmp #87                     ; "W"
    beq .move_up
    cmp #83                     ; "S"
    beq .move_down
    cmp #65                     ; "A"
    beq .move_left
    cmp #68                     ; "D"
    beq .move_right 
    lda #0
    sta MOVING 
    jmp .exit_complete
.move_up:
    lda #3
    sta MOVING
    jmp .exit_read
.move_down:
    lda #4
    sta MOVING
    jmp .exit_read
.move_left:
    lda #2                     ; Direction - Left
    sta MOVING
    lda #1
    sta DIRECTION
    jmp .exit_read
.move_right:
    lda #1                     ; Direction - Right
    sta MOVING
    lda #0
    sta DIRECTION
    jmp .exit_read
.exit_read:
    lda #1                      ; Initiates the movement sequence 
    sta FRAME_STATE
.exit_complete:
    rts