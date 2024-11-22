; -------- VARIABLES (Zero Page) --------
    seg.u ZP
    org $00

CURRENT                 ds.b  1     ; Current animation frame
INPUT_COMMAND           ds.b  1     ; Stores Keyboard Input

    seg