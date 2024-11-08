; -------- VARIABLES (Zero Page) --------
  seg.u ZP
  org $00
PLAYER_LIVES          ds.b  1   ; Store player lives 
JIFFIES_SINCE_SECOND  ds.b  1   ; Store jiffies since last second
CAN_JUMP              ds.b  1   ; 1 if player can jump, 0 if not
EXIT_X                ds.b  1   ; x = vertical axis, because why not
EXIT_Y                ds.b  1   ; y = horizontal axis, because why not
TEMP1                 ds.b  1   ; temporary variable for screen offset calculation
TEMP2                 ds.b  1   ; temporary variable for screen offset calculation
HORIZONTAL            ds.b  1   ; 0 = left, 1 = right
VERTICAL              ds.b  1   ; 0 = up, 1 = down
MOVING                ds.b  1   ; 0 = moving, 1 = not moving
X_POS                 ds.b  1   ; vertical axis, because why not
Y_POS                 ds.b  1   ; horizontal axis, because why not
CURRENT               ds.b  1   ; current animation frame
LASTJIFFY             ds.b  1   ; stores last known jiffy
TIMER1                ds.b  1   ; n * 256^0
TIMER2                ds.b  1   ; n * 256^1
TIMER3                ds.b  1   ; n * 256^2
BITWISE               ds.b  1   ; Bitmask for level decompression

; zx02 variables
offset_hi             ds.b  1   ; Offset high byte
ZX0_src               ds.w  1   ; Source address
ZX0_dst               ds.w  1   ; Destination address
bitr                  ds.b  1   ; Bitmask for decompression
pntr                  ds.w  1   ; Pointer to last offset
  seg