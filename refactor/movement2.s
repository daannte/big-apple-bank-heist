; movement.s
; Movement related subroutines
; ** ONLY sets flags for it to be changed later in state.s

; Subroutine : Handle Movement
; Description : Sets flags indicating type of movement
handle_movement:
    lda FRAME_STATE
    bne .skip_input
    jsr read_input

    inc TEMP_X_POS
    jsr check_collisions
    bne .enable_jump

    ; No collision - in air
    jsr dec_gravity_loop
    bne .fall 
    jmp .skip_input

.fall:
    lda #4
    sta MOVING
    lda #FALL_GRAVITY_DELAY
    sta GRAVITY_LOOP
    jmp .skip_input

    ; Standing on platform (collision downwards)
.reset_gravity_loop:
    lda FRAME_STATE
    bne .skip_input
    jsr reset_grav
.enable_jump:
    lda #1
    sta CAN_JUMP
.skip_input:
    rts

; Subroutine : Read Input
; Description : Loads INPUT_COMMAND and branch accordingly
read_input:
    lda INPUT_COMMAND
    cmp #87                     ; "W"
    beq .move_up
    cmp #65                     ; "A"
    beq .move_left
    cmp #68                     ; "D"
    beq .move_right
    lda #0
    sta MOVING
    jmp .exit_complete
.move_up:
    lda CAN_JUMP
    beq .cant_jump
    lda #0
    sta CAN_JUMP
    lda #3
    sta MOVING
    lda #JUMP_GRAVITY_DELAY
    sta GRAVITY_LOOP
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
    jmp .exit_complete
.cant_jump:
    lda #0
    sta MOVING
.exit_complete:
    rts