; render.s
; Rendering Objects Subroutines
    subroutine

; Subroutine : Render Game
; Description : Render game objects
render_game:
    rts

; Subroutine : Draw player
; Description : Draws Player Character
draw_player:
    ldx X_POS
    ldy Y_POS
    clc
    jsr PLOT
    lda CURRENT
    jsr CHROUT
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
    lda #10
    sta $1FF9

.load_player:
    ldy #51
    lda (LEVEL_LOW_BYTE),y
    tax
    stx X_POS
    dey
    lda (LEVEL_LOW_BYTE),y
    tay
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
    rts

; Subroutine : Draw Timer
; Description : Displays Timer
draw_timer:
    ; Implement timer drawing logic
    rts