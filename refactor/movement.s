; movement.s
; Movement related subroutines
; States saved on ZP memory is used to manipulate movement
;   for modularity

    
; Subroutine : Handle Movement
; Description : Loads INPUT_COMMAND(ZP), moves character sprite
    subroutine
handle_movement:
    jsr read_input
    jsr check_collisions
    jsr move_character
    rts

; Subroutine : Read Input
; Description : Loads INPUT_COMMAND and compares with keymap and branche
    subroutine
read_input:
    ; Store X and Y temporarily for collision detection
    lda X_POS
    sta TEMP_X_POS             
    lda Y_POS
    sta TEMP_Y_POS

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
    cmp #32                     ; "<SPACE>"
    beq .move_action             
    rts

; Subroutine : Move Up
; Description : 
.move_up:
    dec TEMP_X_POS
    rts

; Subroutine : Move Down
; Description : 
.move_down:
    inc TEMP_X_POS
    rts

; Subroutine : Move Left
; Description : 
.move_left:
    dec TEMP_Y_POS
    rts

; Subroutine : Move Right
; Description : 
.move_right:
    inc TEMP_Y_POS
    rts

; Subroutine : Action
; Description : Item usage: Loads from CURRENT_ITEM(ZP) and calls item use subroutine
;               *PICKAXE : Detect collision ahead and remove block and replace with <SPACE>
.move_action:
    rts

; Subroutine : Check Collisions
; Description : Compares TEMP_$_POS with screen data to detect collision
    subroutine
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
    cmp #10                 ; WALL
    beq .occupied_wall
    cmp #11                 ; EXIT
    beq .occupied_exit
    lda #0                  ; No collision
    rts

.occupied_wall
    lda #1
    rts

.occupied_exit
    lda #2
    rts

; Subroutine : Move Character
; Description : Moves character position
; FUTURE : 
    subroutine
move_character:
    cmp #1
    beq .collision_wall
    ldx X_POS
    ldy Y_POS
    clc
    jsr PLOT
    lda #EMPTY_SPACE_CHAR
    jsr CHROUT
    lda TEMP_X_POS
    sta X_POS
    lda TEMP_Y_POS
    sta Y_POS

.collision_wall
    lda #0
    sta INPUT_COMMAND
    rts

; Subroutine : Gravity (WIP)
; Description : Gravity

; Subroutine : Animations
; Description : Animations
