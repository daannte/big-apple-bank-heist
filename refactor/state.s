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
    dec TIMER_LOOP_COUNT
    jmp .timer_inter_exit               ; Exit sub


.timer_done:
    lda TIMER_VALUE
    and #0x0F                          ; Mask out high nibble
    cmp #0
    beq .dec_tens
    dec TIMER_VALUE
    jmp .add_delay

.dec_tens:
    lda TIMER_VALUE
    sec
    sbc #7
    sta TIMER_VALUE
    
.add_delay:
    lda #TIMER_DELAY
    sta TIMER_LOOP_COUNT
.timer_inter_exit:
    rts