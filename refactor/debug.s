; debug.s
; Subroutines to test features
    subroutine
; Subroutine : Test Sprites
; Description : Loads sprites from charset to test sprites
test_sprites:
    ldx #64
.test_sprites_loop:
    txa
    jsr CHROUT
    inx
    cpx #CHAR_END
    bne .test_sprites_loop
    rts


; Subroutine : Test Level Loader
; Description : Draw Level Borders
test_level:
    jsr load_level