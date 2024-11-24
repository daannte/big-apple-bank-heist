; KERNAL MEMORY LOCATIONS
CHROUT      = $FFD2
SCREEN      = $900f
GETIN       = $FFE4
CHARSET     = $9005
PLOT        = $FFF0
JIFFY_LOW   = $00A2
JIFFY_MID   = $00A1
JIFFY_HIGH  = $00A0

; OTHER MEMORY LOCATIONS

; CONSTANT VALUES - SPRITES
; Custom characters are defined in charset.s / $1c00
; VALUES ASSIGNED BELOW MUST RESPECT ORDER OF DATA IN "CHARSET.S"!!
ROBBER_R    = #64
ROBBER_R_1  = #65
ROBBER_R_2  = #66

ROBBER_L    = #67
ROBBER_L_1  = #68
ROBBER_L_2  = #69

ROBBER_VR_1 = #70
ROBBER_VR_2 = #71
ROBBER_VL_1 = #72
ROBBER_VL_2 = #73

ROBBER_R_IDLE = #74
ROBBER_L_IDLE = #75

WALL        = #76
EXITDOOR    = #77
PICKAXE     = #78

CUSTOM_ASCII_0     = #79
CUSTOM_ASCII_1     = #80
CUSTOM_ASCII_2     = #81
CUSTOM_ASCII_3     = #82
CUSTOM_ASCII_4     = #83
CUSTOM_ASCII_5     = #84
CUSTOM_ASCII_6     = #85
CUSTOM_ASCII_7     = #86
CUSTOM_ASCII_8     = #87
CUSTOM_ASCII_9     = #88

EMPTY_SPACE_CHAR  = #89
HEART_CHAR        = #90
TRAP              = #91

CHAR_END          = #92                ; For debugging purposes

; ASCII VALUES
ASCII_0           = #48
ASCII_1           = #49
ASCII_2           = #50
ASCII_3           = #51
ASCII_4           = #52
ASCII_5           = #53
ASCII_6           = #54
ASCII_7           = #55
ASCII_8           = #56
ASCII_9           = #57

; TIMER VALUES
LOOP_RATE_60      = #1                  ; 60Hz
LOOP_RATE_30      = #2                  ; 30Hz
LOOP_RATE_15      = #4                  ; 15Hz
LOOP_RATE_10      = #6                  ; 10Hz