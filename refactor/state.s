; state.s
; Sets game state, manages values of game state variables
; Timer value, 

    subroutine
; Subroutine : handle_game_state
; Description : Sets necessary values for frame counting
handle_game_state:
    jsr handle_frames
    jsr update_frames
    jsr dec_timer_loop
    rts

; Subroutine : Decrement Timer Loop
; Description : Decrement TIMER_VALUE every #TIMER_LOOP_COUNT loops over game
dec_timer_loop:
    lda TIMER_LOOP_COUNT                ; Load Loop Count
    cmp #0
    beq .timer_dec                      ; If 0, reset value and decrement TIMER_VALUE
    dec TIMER_LOOP_COUNT                ; If not 0, dec loop count
    jmp .timer_inter_exit               ; Exit sub
.timer_dec:
    lda #TIMER_DELAY
    sta TIMER_LOOP_COUNT
    lda TIMER_VALUE
    beq .times_up
    and #15
    cmp #0
    bne .tens
    lda TIMER_VALUE
    sec
    sbc #7
    sta TIMER_VALUE
    jmp .timer_inter_exit
.tens:
    dec TIMER_VALUE
    jmp .timer_inter_exit
.times_up:
    lda #1
    sta TIME_OUT_FLAG
.timer_inter_exit:
    rts

; Subroutine : handle_frames
; Description : Stores frame ID
handle_frames:
    ; First Check if MOVING
    ; If moving, game takes 2 loops to complete movement
    ; If not moving, game takes 2 loops to complete idle movement
    lda MOVING
    beq .idle_start         ; NOT MOVING
    
    ; MOVING HERE - Check if in the middle of move, or new input
    ; 1 - Key has been pressed this game loop, start movement processor
    ; 2 - Is in the middle of the loop
    lda MOVING
    cmp #1
    beq .move_start

    ; In process of moving ( MOVING is #2 ) - needs to finish movement
    lda ANIMATION_FRAME
    cmp #5                      ; Since last frame was #5 or #6 (TRAN_R, TRAN_L)
    beq .right_complete

    ; Finish left movement
    lda #FACE_L
    sta ANIMATION_FRAME
    lda #0                      ; Reset MOVING to 0
    sta MOVING
    jmp .frames_exit

    ; Finish right movement
.right_complete:
    lda #FACE_R
    sta ANIMATION_FRAME
    lda #0                      ; Reset MOVING to 0
    sta MOVING
    jmp .frames_exit
    
.move_start:
    ; Key was only recently pressed
    ; Start the movement sequence
    ; Needs to render 2 frames: CURRENT, and CURRENT2 for intermediate frame
    lda ANIMATION_FRAME
    cmp #1                      ; Check if movement is left or right (if eq #1, RIGHT)
    beq .right_anim

    ; Left movement animation here
    lda #2                      
    sta MOVING                  ; Saves #2 to MOVING to indicate next loop needs to render transition frames
    lda #TRAN_L                 ; #6 - Refer to constants.s file for exact value
    sta ANIMATION_FRAME         ; Indicates that `draw_player` has to draw the 2 frames related to transition
    jmp .frames_exit

    ; Right movement animation here
.right_anim
    lda #2
    sta MOVING                  ; Saves #2 to MOVING to indicate next loop needs to render transition frames
    lda #TRAN_R                 ; #5 - Refer to constants.s file for value meaning
    sta ANIMATION_FRAME         ; Indicates that `draw_player` has to draw the 2 frames related to trasition
    jmp .frames_exit

.idle_start:
    ; Skips a game loop to simulate idle movement: will change CURRENT frame every $ANIMATION_LOOP_COUNT Times
    lda ANIMATION_LOOP_COUNT
    beq .next_frame
    dec ANIMATION_LOOP_COUNT
    jmp .frames_exit

.next_frame:
    ; Reset Animation Delay
    lda #ANIMATION_DELAY
    sta ANIMATION_LOOP_COUNT
    
    lda MOVING              ; If MOVING == 0, branch idle animations
    beq .idle_frames

.idle_frames:
    lda ANIMATION_FRAME
    cmp #3
    bcc .idle_switch        ; If on idle frame, (>2) and not moving, Switch to normal frame
    lda ANIMATION_FRAME
    sec
    sbc #2
    sta ANIMATION_FRAME
    jmp .frames_exit
.idle_switch:
    lda ANIMATION_FRAME
    clc
    adc #2
    sta ANIMATION_FRAME
.frames_exit:
    rts

; Subroutine : Update frames
; Description : Uses ANIMATION_FRAME val to designate CURRENT
; Basically a indexing table for CURRENT VALUE.
; Want to optimize but too big
update_frames:
    lda ANIMATION_FRAME
    cmp #1
    beq .face_right
    lda ANIMATION_FRAME
    cmp #2
    beq .face_left
    lda ANIMATION_FRAME
    cmp #3
    beq .right_idle
    lda ANIMATION_FRAME
    cmp #4
    beq .left_idle
    lda ANIMATION_FRAME
    cmp #5
    beq .right_move
    lda ANIMATION_FRAME
    cmp #6
    beq .left_move

.face_right
    lda #ROBBER_R
    sta CURRENT
    jmp .update_end
.face_left
    lda #ROBBER_L
    sta CURRENT
    jmp .update_end
.right_idle
    lda #ROBBER_R_IDLE
    sta CURRENT
    jmp .update_end
.left_idle 
    lda #ROBBER_L_IDLE
    sta CURRENT
    jmp .update_end
.right_move
    lda #ROBBER_R_1
    sta CURRENT2
    lda #ROBBER_R
    sta CURRENT
    jmp .update_end
.left_move
    lda #ROBBER_L_1
    sta CURRENT2
    lda #ROBBER_L
    sta CURRENT
.update_end
    rts