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

ASCII_0     = #76
ASCII_1     = #77
ASCII_2     = #78
ASCII_3     = #79
ASCII_4     = #80
ASCII_5     = #81
ASCII_6     = #82
ASCII_7     = #83
ASCII_8     = #84
ASCII_9     = #85

EMPTY_SPACE_CHAR  = #86
HEART_CHAR        = #87
TIMER_MAX_VALUE   = %00100101 ; binary-coded decimal. left nibble is tens, right nibble is ones

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