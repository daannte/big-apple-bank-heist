; -------- VARIABLES (Zero Page) --------
    seg.u ZP
    org $00

X_POS                   ds.b  1     ; vertical axis, because why not
Y_POS                   ds.b  1     ; horizontal axis, because why not
PLAYER_LIVES            ds.b  1     ; Store player lives 
CURRENT                 ds.b  1     ; Current animation frame
INPUT_COMMAND           ds.b  1     ; Stores Keyboard Input
CURRENT_LEVEL           ds.b  1     ; Current level index
LEVEL_LOW_BYTE          ds.b  1     ; Low byte of level data offset
LEVEL_HIGH_BYTE         ds.b  1     ; High byte of level data offset
BITWISE                 ds.b  1     ; Bitmask for level decompression
EXIT_X                  ds.b  1     ; x = vertical axis, because why not
EXIT_Y                  ds.b  1     ; y = horizontal axis, because why not
CURR_JIFFY_H            ds.b  1     ; JIFFY HIGH temporary storage 
CURR_JIFFY_M            ds.b  1     ; JIFFY MID temporary storage 
CURR_JIFFY_L            ds.b  1     ; JIFFY LOW temporary storage 
LOOP_INTERVAL           ds.b  1     ; JIFFY LOOP INTERVAL STORAGE
TARG_JIFFY_L            ds.b  1     ; JIFFY LOW Target value storage
TARG_JIFFY_M            ds.b  1     ; JIFFY MID Target value storage
TARG_JIFFY_H            ds.b  1     ; JIFFY HIGH Target value storage

    seg