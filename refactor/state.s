; state.s
; Sets game state, manages values of game state variables
; Timer value, 

    subroutine
; Subroutine : handle_game_state
; Description : Sets necessary values for frame counting
handle_game_state:
 ;   jsr player_move_animation
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
    lda MOVING
    beq .not_moving
    ;lda ANIMATION_LOOP_COUNT
    cmp #4

.not_moving:
    lda #0
    sta ANIMATION_FRAME



