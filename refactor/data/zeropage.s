; -------- VARIABLES (Zero Page) --------
    seg.u ZP
    org $00

TEMP1                   ds.b  1     ; Temporary variable for screen offset calculation
TEMP2                   ds.b  1     ; Temporary variable for screen offset calculation

X_POS                   ds.b  1     ; vertical axis, because why not
Y_POS                   ds.b  1     ; horizontal axis, because why not
TEMP_X_POS              ds.b  1     ; Temporary X position before collision detection
TEMP_Y_POS              ds.b  1     ; Temporary Y position before collision detection
COLLISION               ds.b  1     ; Store collision Bool (0 - No col, 1 - Wall, 2 - Exit, 3 - Item)
PLAYER_LIVES            ds.b  1     ; Store player lives 

CURRENT                 ds.b  1     ; Current animation frame
INPUT_COMMAND           ds.b  1     ; Stores Keyboard Input
CURRENT_LEVEL           ds.b  1     ; Current level index
LEVEL_LOW_BYTE          ds.b  1     ; Low byte of level data offset
LEVEL_HIGH_BYTE         ds.b  1     ; High byte of level data offset
BITWISE                 ds.b  1     ; Bitmask for level decompression

EXIT_X                  ds.b  1     ; x = vertical axis, because why not
EXIT_Y                  ds.b  1     ; y = horizontal axis, because why not

; TIMER RELATED
CURR_JIFFY_H            ds.b  1     ; JIFFY HIGH temporary storage 
CURR_JIFFY_M            ds.b  1     ; JIFFY MID temporary storage 
CURR_JIFFY_L            ds.b  1     ; JIFFY LOW temporary storage 
LOOP_INTERVAL           ds.b  1     ; JIFFY LOOP INTERVAL STORAGE
TARG_JIFFY_L            ds.b  1     ; JIFFY LOW Target value storage
TARG_JIFFY_M            ds.b  1     ; JIFFY MID Target value storage
TARG_JIFFY_H            ds.b  1     ; JIFFY HIGH Target value storage
TIMER_LOOP_COUNT        ds.b  1     ; Number of game loops before timer decrements
ASCII_OFFSET            ds.b  1     ; Offset for ASCII characters (default or custom)
TIMER_VALUE             ds.b  1     ; Timer value
TIME_OUT_FLAG           ds.b  1     ; Flag to set time out

; Animations
ANIMATION_FRAME         ds.b  1     ; Current animation frame
ANIMATION_DIRECTION     ds.b  1     ; Current Facing ANIMATION_DIRECTION
ANINATION_LOOP_COUNT    ds.b  1     ; Animation Loop Counter
MOVING                  ds.b  1     ; 0 = moving, 1 = not moving

CAN_JUMP                ds.b  1     ; 0 = can't jump, 1 = can jump
GRAVITY_COOLDOWN        ds.b  1     ; Cooldown for gravity
SCORE1                  ds.b  1     ; Keeps track of the last 2 digits of the score  (xx00-xx99)
SCORE2                  ds.b  1     ; Keeps track of the first 2 digits of the score (00xx-99xx)
BCD_TO_PRINT            ds.b  1     ; BCD to print

; zx02 variables
offset_hi             ds.b  1   ; Offset high byte
ZX0_src               ds.w  1   ; Source address
ZX0_dst               ds.w  1   ; Destination address
bitr                  ds.b  1   ; Bitmask for decompression
pntr                  ds.w  1   ; Pointer to last offset
    seg