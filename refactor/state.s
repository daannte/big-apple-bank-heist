; state.s
; Sets game state, manages values of game state variables
; Timer value, 

    subroutine

; Subroutine : handle_game_state
; Description : Sets necessary values for frame counting
handle_game_state:
    jsr dec_timer_loop
    rts

; Subroutine : Decrement Timer Loop
dec_timer_loop:
    lda TIMER_LOOP_COUNT                ; Load Loop Count
    cmp #0
    beq .timer_done                     ; If 0, reset value and decrement TIMER_VALUE
    dec TIMER_LOOP_COUNT                ; If not 0, dec loop count
    jmp .timer_inter_exit               ; Exit sub
.timer_done:
    dec TIMER_VALUE
    lda #TIMER_DELAY
    sta TIMER_LOOP_COUNT
.timer_inter_exit:
    rts