; render.s
; Rendering Objects Subroutines
    subroutine

; Subroutine : Render Game
; Description : Render game objects
render_game:
    lda FRAME_STATE
    cmp #1
    beq .draw_anim

    lda FRAME_STATE
    cmp #2
    beq .draw_dest

.draw_dest:
    jsr draw_dest_frame
    jmp .next
.draw_anim:
    jsr draw_animation
    jmp .next
.next:
    jsr draw_timer
    rts

; Subroutine : Draw Animation Frame
; Description : Draws Player Character
draw_animation:
    ldx X_POS
    ldy Y_POS
    clc
    jsr PLOT
    lda CURRENT2                       
    jsr CHROUT

    ldx TEMP_X_POS
    ldy TEMP_Y_POS
    clc
    jsr PLOT
    lda CURRENT
    jsr CHROUT

    lda #2
    sta FRAME_STATE
    rts 

; Subroutine : Draw Destination Frame
; Description : Subroutine called when drawing destination frame
draw_dest_frame:
    ldx X_POS
    ldy Y_POS
    clc
    jsr PLOT
    lda #EMPTY_SPACE_CHAR
    jsr CHROUT

    ldx TEMP_X_POS
    ldy TEMP_Y_POS
    clc
    jsr PLOT
    lda CURRENT                       
    jsr CHROUT

    ; Save coordinates after successful render
    lda TEMP_X_POS
    sta X_POS
    lda TEMP_Y_POS
    sta Y_POS
    
    lda #0
    sta FRAME_STATE
    rts 


; Subroutine : Load Level
; Description : Level Data is included during compile as level<n>
;               Each level pointer is ds.w, to cover for 16+ levels
;               Load level is only called once before new iterations of game loop
;               Timer is intentionally removed from this subroutine to make control of it more accessible
load_level:
    lda #147              ; Load clear screen command
    jsr CHROUT            ; Print it
.load_level_address:
    ; Load level index
    lda CURRENT_LEVEL
    asl
    tay

    lda level_pointers,y
    sta LEVEL_LOW_BYTE
    lda level_pointers+1,y
    sta LEVEL_HIGH_BYTE

    lda PLAYER_LIVES
    tay
    iny

    lda #2                  ; Set X to red
    sta $0286               ; Store X into current color code address
.show_lives:
    lda #HEART_CHAR
    jsr CHROUT
    dey
    bne .show_lives

    lda #1              ; Set X to white
    sta $0286         

    lda #22
    sbc PLAYER_LIVES
    tax
.repeat:
    lda #EMPTY_SPACE_CHAR
    jsr CHROUT
    dex
    bne .repeat
.top_row:
    lda #WALL
    jsr CHROUT
    iny
    cpy #23
    bne .top_row
    ldy #0
.load_character:
    lda #1
    sta BITWISE
    jmp .loop_byte
.inc_char:
    inx
    cpx #20
    bne .inc_bitwise
    lda #WALL
    jsr CHROUT
    jsr CHROUT
    ldx #0
.inc_bitwise:
    lda BITWISE
    cmp #128
    beq .end_loop_byte
    asl BITWISE
.loop_byte:
    lda (LEVEL_LOW_BYTE),y
    and BITWISE
    beq .empty_space
    lda #WALL
    jsr CHROUT
    jmp .inc_char
.empty_space:
    lda #EMPTY_SPACE_CHAR
    jsr CHROUT
    jmp .inc_char
.end_loop_byte:
    iny
    cpy #50
    bne .load_character
    
    ldy #0
.bottom_row:
    lda #WALL
    jsr CHROUT
    iny
    cpy #20
    bne .bottom_row
    lda #12
    sta $1FF9
.load_player:
    ldy #51
    lda (LEVEL_LOW_BYTE),y
    tax
    stx TEMP_X_POS
    stx X_POS
    dey
    lda (LEVEL_LOW_BYTE),y
    tay
    sty TEMP_Y_POS
    sty Y_POS
    clc
    jsr PLOT
    lda #ROBBER_R
    jsr CHROUT
.load_exit:
    ldy #53
    lda (LEVEL_LOW_BYTE),y
    tax
    stx EXIT_X
    dey
    lda (LEVEL_LOW_BYTE),y
    tay
    sty EXIT_Y
    clc
    jsr PLOT
    lda #EXITDOOR
    jsr CHROUT
.load_timer_value:
    ldy #54
    lda (LEVEL_LOW_BYTE),y
    sta TIMER_VALUE

.load_traps:
  lda #55                   
  sta TRAP_INDEX

.load_next_trap:
  ldy TRAP_INDEX

  lda (LEVEL_LOW_BYTE),y    ; Load trap X position
  beq .end_traps            ; If X position is 0, end of traps
  pha                       ; Store X position in stack for later 

  iny
  lda (LEVEL_LOW_BYTE),y    ; Load trap Y position
  tax                       ; Store Y position in X register

  pla                       ; Pull X from stack
  tay                       ; Store X position in Y register

  clc
  jsr PLOT
  lda #TRAP
  jsr CHROUT

  ; Increment twice because traps take 2 bytes
  inc TRAP_INDEX
  inc TRAP_INDEX

  jmp .load_next_trap

.end_traps
  rts

; Subroutine : Draw Timer
; Description : Displays Timer
draw_timer:
    ldx #0
    ldy #20
    clc
    jsr PLOT
    lda TIMER_VALUE
    lsr
    lsr
    lsr
    lsr
    clc
    adc ASCII_OFFSET
    jsr CHROUT

    lda TIMER_VALUE
    and #$0f
    clc
    adc ASCII_OFFSET
    jsr CHROUT
    rts

; Subroutine : Draw Score
; Description : Displays Score
    subroutine
print_score:
  ldx #12
  ldy #6
  clc
  jsr PLOT

  lda #'S
  jsr CHROUT
  lda #'C
  jsr CHROUT
  lda #'O
  jsr CHROUT
  lda #'R
  jsr CHROUT
  lda #'E
  jsr CHROUT
  lda #':
  jsr CHROUT
  lda #' 
  jsr CHROUT

.convert_to_bcd:
  lda SCORE2    ; Already in BCD since only using 0-9
  sta BCD_TO_PRINT
  jsr print_bcd ; Print the BCD

  lda #0
  sta TEMP1
  lda SCORE1
.loop:
  cmp #10
  bcc .print_ones
  inc TEMP1
  sec
  sbc #10
  jmp .loop

.print_ones:
  sta TEMP2
  lda TEMP1
  asl
  asl
  asl
  asl
  clc
  adc TEMP2
  sta BCD_TO_PRINT
  jsr print_bcd

.load_endscreen_loop:
  lda #0
  sta $00C6
  jsr GETIN
  cmp #00
  beq .load_endscreen_loop

.end_print_score:
  rts

; Subroutine : Load End Screen
; Description : Renders End Screen
  subroutine
load_endscreen:
  lda #ASCII_0
  sta ASCII_OFFSET
  
  lda #$f0                ; loading 240 into CHARSET to reset character set for titlescreen 
  sta CHARSET             ; the above can be found on page 267

  lda #147              ; Load clear screen command
  jsr CHROUT            ; Print it

  ldx #10
  ldy #7
  clc
  jsr PLOT

  lda #'Y
  jsr CHROUT
  lda #'O
  jsr CHROUT
  lda #'U
  jsr CHROUT
  lda #' 
  jsr CHROUT
  lda #'W
  jsr CHROUT
  lda #'I
  jsr CHROUT
  lda #'N
  jsr CHROUT
  lda #'!
  jsr CHROUT

  jsr print_score

.end_load_endscreen:
  rts

