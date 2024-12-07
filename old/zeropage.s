; -------- VARIABLES (Zero Page) --------
  seg.u ZP
  org $00
PLAYER_LIVES          ds.b  1   ; $00 Store player lives 
JIFFIES_SINCE_SECOND  ds.b  1   ; $01 Store jiffies since last second
EXIT_X                ds.b  1   ; $02 x = vertical axis, because why not
EXIT_Y                ds.b  1   ; $03 y = horizontal axis, because why not
TEMP1                 ds.b  1   ; $04 temporary variable for screen offset calculation
TEMP2                 ds.b  1   ; $05 temporary variable for screen offset calculation
HORIZONTAL            ds.b  1   ; $06 0 = left, 1 = right
VERTICAL              ds.b  1   ; $07 0 = up, 1 = down
MOVING                ds.b  1   ; $08 0 = moving, 1 = not moving
X_POS                 ds.b  1   ; $09 vertical axis, because why not
Y_POS                 ds.b  1   ; $0A horizontal axis, because why not
CURRENT               ds.b  1   ; $0B current animation frame
LASTJIFFY             ds.b  1   ; $0C stores last known jiffy
TIMER1                ds.b  1   ; $0D n * 256^0
TIMER2                ds.b  1   ; $0E n * 256^1
TIMER3                ds.b  1   ; $0F n * 256^2
BITWISE               ds.b  1   ; $10 Bitmask for level decompression
CAN_JUMP              ds.b  1   ; $11 0 = can't jump, 1 = can jump
TIMER_VALUE           ds.b  1   ; $12 Timer value
GRAVITY_COOLDOWN      ds.b  1   ; $13 Cooldown for gravity
CURRENT_LEVEL         ds.b  1   ; $14 Current level number
LEVEL_LOW_BYTE        ds.b  1   ; $15 Low byte of level data offset
LEVEL_HIGH_BYTE       ds.b  1   ; $16 High byte of level data offset
TRAP_INDEX            ds.b  1   ; $17 Keeps track of the trap index 
SCORE1                ds.b  1   ; $18 Keeps track of the last 2 digits of the score  (xx00-xx99)
SCORE2                ds.b  1   ; $19 Keeps track of the first 2 digits of the score (00xx-99xx)
ASCII_OFFSET          ds.b  1   ; $1A Offset for ASCII characters (default or custom)

; zx02 variables
offset_hi             ds.b  1   ; Offset high byte
ZX0_src               ds.w  1   ; Source address
ZX0_dst               ds.w  1   ; Destination address
bitr                  ds.b  1   ; Bitmask for decompression
pntr                  ds.w  1   ; Pointer to last offset
  seg
