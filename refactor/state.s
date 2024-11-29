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
    lda ANIMATION_LOOP_COUNT
    beq .next_frame
    dec ANIMATION_LOOP_COUNT
    jmp .frames_exit
.next_frame:
    lda #ANIMATION_DELAY
    sta ANIMATION_LOOP_COUNT
    
    lda MOVING              ; If MOVING == 0, branch idle animations
    beq .idle_frames
    
    ; For Movement Frames
    lda ANIMATION_DIRECTION 
    beq .right_frame
    bne .left_frame

    ; Right animation
.right_frame:
    lda #TRAN_R
    sta ANIMATION_FRAME    
    jmp .frames_exit

.left_frame:
    lda #TRAN_L
    sta ANIMATION_FRAME
    jmp .frames_exit

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
    lda #ROBBER_R_2
    sta CURRENT
.left_move
    lda #ROBBER_L_1
    sta CURRENT2
    lda #ROBBER_L_2
    sta CURRENT
.update_end
    rts