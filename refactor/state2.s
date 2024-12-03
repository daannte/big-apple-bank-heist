; state2.s
; Sets game state, manages values of game state variables
; Timer value, 

; Subroutine : handle_game_state
; Description : 
;   1. Load MOVING (ZP)
;   2. Collision Test
;       2a. Valid           - Change XPOS/YPOS accordingly
;       2b. Invalid (Wall)  - CONTINUE; proceed game loop
;       2c. Valid ( Exit )  - Sets level complete flag
;   3. IF VALID : update ANIMATION_FRAME
;      IF INVALID : end
handle_game_state:
    lda FRAME_STATE
    cmp #1                  ; If animation state, skip
    beq .start_anim
    
    lda FRAME_STATE
    cmp #2
    beq .finish_anim

    jsr temp_coord
    jsr check_collisions
    bne .no_move

.start_anim:
    jsr temp_coord
    jsr check_collisions
    bne .no_move
.finish_anim:
    jsr handle_frames
    jsr update_frames
    jmp .game_state_end
.no_move:
    jsr reset_coord
.game_state_end:
    jsr dec_timer_loop
    rts

; Subroutine : handle_frames
; Description : 
;   * All movement consists of 2 frames, one animation frame and one destination frame
;   ** FRAME_STATE - #1 animation frame, #2 destination frame
;   ** If ANIMATION FRAME:
;       render needs to use CURRENT POSITION to display first half
;       Then $POS to display second half
;   ** If DESTINATION FRAME:
;       render needs to use $POS to display half
;   Use FRAME_STATE (ZP) to distinguish FRAME
handle_frames:
    ; Check if currently in process of moving
    lda FRAME_STATE
    cmp #1              ; Animation Frame
    beq .anim_frame
    
    lda FRAME_STATE
    cmp #2              ; Destination Frame
    beq .dest_frame

    lda MOVING
    beq .idle_frame

.dest_frame:
    lda MOVING
    cmp #1
    beq .dest_right_frame
    
    lda MOVING
    cmp #2
    beq .dest_left_frame
    
    lda MOVING
    cmp #3
    beq .dest_up_frame

    lda MOVING
    cmp #4
    beq .dest_down_frame

.dest_right_frame:
    lda #1              ; Right Dest
    sta ANIMATION_FRAME
    jmp .end_frames
.dest_left_frame:
    lda #2              ; Left Dest
    sta ANIMATION_FRAME
    jmp .end_frames
.dest_up_frame:
    lda DIRECTION
    cmp #0
    beq .dest_right_frame
    jmp .dest_left_frame
.dest_down_frame:
    lda DIRECTION
    cmp #0
    beq .dest_right_frame
    jmp .dest_left_frame
.idle_frame:
    lda IDLE_LOOP_COUNT
    beq .idle_next
    dec IDLE_LOOP_COUNT
    jmp .end_frames
.idle_next:
    lda ANIMATION_FRAME
    cmp #3              ; Face Right
    bcc .idle_switch
    lda ANIMATION_FRAME
    sbc #2
    sta ANIMATION_FRAME
    jmp .idle_end
.idle_switch:
    lda ANIMATION_FRAME
    adc #2
    sta ANIMATION_FRAME    
.idle_end:
    lda #ANIMATION_DELAY
    sta IDLE_LOOP_COUNT
    jmp .end_frames
.anim_frame:
    lda MOVING
    cmp #1
    beq .anim_right_frame

    lda MOVING
    cmp #2
    beq .anim_left_frame

    lda MOVING
    cmp #3
    beq .anim_up_frame

    lda MOVING
    cmp #4
    beq .anim_down_frame

.anim_right_frame:
    lda #5
    sta ANIMATION_FRAME
    jmp .end_frames
.anim_left_frame:
    lda #6
    sta ANIMATION_FRAME
    jmp .end_frames
.anim_up_frame:
    lda DIRECTION
    beq .anim_up_right
    lda #8
    sta ANIMATION_FRAME
    jmp .end_frames
.anim_up_right:
    lda #7
    sta ANIMATION_FRAME
    jmp .end_frames
.anim_down_frame:
    lda DIRECTION
    beq .anim_down_right
    lda #10
    sta ANIMATION_FRAME
    jmp .end_frames
.anim_down_right:
    lda #9
    sta ANIMATION_FRAME
    jmp .end_frames
.end_frames:    
    rts

; Subroutine : Update frames
; Description : Uses ANIMATION_FRAME val to designate CURRENT
; Basically a indexing table for CURRENT VALUE.
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
    beq .right_anim
    lda ANIMATION_FRAME
    cmp #6
    beq .left_anim
    lda ANIMATION_FRAME
    cmp #7
    beq .right_jmp
    lda ANIMATION_FRAME
    cmp #8
    beq .left_jmp
    lda ANIMATION_FRAME
    cmp #9
    beq .right_fall
    lda ANIMATION_FRAME
    cmp #10
    beq .left_fall
.face_right:
    lda #ROBBER_R
    sta CURRENT
    jmp .update_end
.face_left:
    lda #ROBBER_L
    sta CURRENT
    jmp .update_end
.right_idle:
    lda #ROBBER_R_IDLE
    sta CURRENT
    jmp .update_end
.left_idle: 
    lda #ROBBER_L_IDLE
    sta CURRENT
    jmp .update_end
.right_anim:
    lda #ROBBER_R_1
    sta CURRENT2
    lda #ROBBER_R_2
    sta CURRENT
    jmp .update_end
.left_anim:
    lda #ROBBER_L_2
    sta CURRENT2
    lda #ROBBER_L_1
    sta CURRENT
    jmp .update_end
.right_jmp:
    lda #ROBBER_VR_2
    sta CURRENT2
    lda #ROBBER_VR_1
    sta CURRENT
    jmp .update_end
.left_jmp:
    lda #ROBBER_VL_2
    sta CURRENT2
    lda #ROBBER_VL_1
    sta CURRENT
    jmp .update_end
.right_fall:
    lda #ROBBER_VR_1
    sta CURRENT2
    lda #ROBBER_VR_2
    sta CURRENT
    jmp .update_end
.left_fall:
    lda #ROBBER_VL_1
    sta CURRENT2
    lda #ROBBER_VL_2
    sta CURRENT
    jmp .update_end
.update_end
    rts

; Subroutine : Temporary Coordinates
; Description : Updates Temporary Coordinates based on Direction
;   Stores Temporary Coordinates to TEMP_$_POS
;   RETURN VALUE IN REGISTER : NONE
temp_coord:
    lda X_POS
    sta TEMP_X_POS
    lda Y_POS
    sta TEMP_Y_POS

    lda MOVING
    cmp #1
    beq .right_move

    lda MOVING 
    cmp #2
    beq .left_move

    lda MOVING
    cmp #3
    beq .up_move

    lda MOVING
    cmp #4
    beq .down_move
    jmp .end_update_coord
.right_move:
    inc TEMP_Y_POS
    jmp .end_update_coord
.left_move:
    dec TEMP_Y_POS
    jmp .end_update_coord
.up_move:
    dec TEMP_X_POS
    jmp .end_update_coord
.down_move:
    inc TEMP_X_POS
    jmp .end_update_coord
.end_update_coord:
    rts

; Subroutine : Reset Coordinates
; Description : Since $_POS is changed after rendering, and TEMP_$_POS
;   is used for rendering, reset TEMP_$_POS if movement is not viable
reset_coord:
    lda X_POS
    sta TEMP_X_POS
    lda Y_POS
    sta TEMP_Y_POS

; Subroutine : Check Collisions
; Description : 
;   TEMP_$_POS is incremented/decremented accordingly based on given input key
;   Potential Player Coordinates are tested if it is a valid movement ( no collisions)
;   RETURN VALUE IN REGISTER : (A)
;   If valid, returns #0 in Accumulator
;   If wall, returns #1 in Accumulator
;   If exit, returns #2 in Accumulator
check_collisions:
    lda TEMP_X_POS
    cmp #11
    bcc .baseaddr
    lda TEMP_X_POS
    cmp #11
    bne .midaddr
    lda TEMP_Y_POS
    cmp #11
    bcc .baseaddr
.midaddr
    lda TEMP_X_POS
    sec
    sbc #10
    asl
    asl
    asl
    asl
    sta TEMP1

    lda TEMP_X_POS
    asl
    sta TEMP2

    asl
    clc
    adc TEMP2
    clc
    adc TEMP1

    sta TEMP1
    lda TEMP_Y_POS
    clc
    adc TEMP1
    sec
    sbc #90                 ; Magic number, apparently
    tax
    lda SCR2,X
    jmp .check_occupied
.baseaddr
    lda TEMP_X_POS
    asl
    asl
    asl
    asl
    sta TEMP1
    lda TEMP_X_POS
    asl
    sta TEMP2
    asl
    clc
    adc TEMP2
    clc
    adc TEMP1
    sta TEMP1
    lda TEMP_Y_POS
    adc TEMP1
    tax
    lda SCR,x
.check_occupied
    cmp #12                 ; WALL
    beq .occupied_wall
    cmp #13                 ; EXIT
    beq .occupied_exit
    lda #0                  ; No collision
    rts
.occupied_wall
    lda #1
    rts
.occupied_exit
    lda #2
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

