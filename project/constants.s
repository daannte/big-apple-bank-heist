; CONSTANT values
TIMERESET1  = #3
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
TRAP        = #75
EXITDOOR    = #76

ASCII_0     = #77
ASCII_1     = #78
ASCII_2     = #79
ASCII_3     = #80
ASCII_4     = #81
ASCII_5     = #82
ASCII_6     = #83
ASCII_7     = #84
ASCII_8     = #85
ASCII_9     = #86

EMPTY_SPACE_CHAR  = #87
HEART_CHAR        = #88
TIMER_MAX_VALUE   = %01100000 ; binary-coded decimal. left nibble is tens, right nibble is ones

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
