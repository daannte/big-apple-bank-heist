; KERNAL MEMORY LOCATIONS
CHROUT  = $FFD2
SCREEN  = $900f
GETIN   = $FFE4
CHARSET = $9005

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

ROBBER_VL_1 = #70
ROBBER_VL_2 = #71
ROBBER_VR_1 = #72
ROBBER_VR_2 = #73

WALL        = #74
EXITDOOR    = #75

CUSTOM_ASCII_0     = #76
CUSTOM_ASCII_1     = #77
CUSTOM_ASCII_2     = #78
CUSTOM_ASCII_3     = #79
CUSTOM_ASCII_4     = #80
CUSTOM_ASCII_5     = #81
CUSTOM_ASCII_6     = #82
CUSTOM_ASCII_7     = #83
CUSTOM_ASCII_8     = #84
CUSTOM_ASCII_9     = #85

EMPTY_SPACE_CHAR  = #86
HEART_CHAR        = #87
TRAP              = #88

CHAR_END          = #89                ; For debugging purposes

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

