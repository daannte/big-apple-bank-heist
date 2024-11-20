; CONSTANT values
TIMERESET1  = #2
TIMERESET2  = #0
TIMERESET3  = #0

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

;;;TRAP     =

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

GRAVITY_MAX_COOLDOWN = #10 ; in jiffies
GRAVITY_JUMP_COOLDOWN = #30  ; in jiffies

LEVEL_SIZE = #55
MAX_LEVELS = #3


; MEMORY locations
CHROUT  = $FFD2
PLOT    = $FFF0
SCREEN  = $900f
INPUT   = $00C5
GETIN   = $FFE4
CHARSET = $9005

SCR     = $1E00
SCR2    = $1EFA

JIFFY1  = $00A2     ; n * 256^2
JIFFY2  = $00A1     ; n * 256^1
JIFFY3  = $00A0     ; n * 256^0

VOLUME      = $900E
SPKLOW      = $900A
SPKMID      = $900B
SPKHIH      = $900C
SPKWHT      = $900D
