# Assignment 2 Compression Results

| Program           | Method              | Size (in bytes) | Compression Ratio |
| :----------------:| :------------------:|:---------------:|:-----------------:|
| 2_titlescreen.prg | Original            | 775             | 1                 |
| exo.prg           | Exomizer            | 671             | 1.15              |
| rle.prg           | Run Length Encoding | 407             | 1.90              |
| zx02.prg          | Zx02                | 313             | 2.47              |
| compress2.prg     | GPT                 | 277             | 2.80              |


## ChatGPT Prompts for Part 2

Prompt 1: 
    “I'm programming using 6502 on the VIC20. I have a program that draws a title screen for a game I'm working on. I want to compress the code.” 
    // Insert Source Code Here
Response :
    Fails miserably to run :

    /************** CHATGPT RESPONSE ***************/
              CHROUT = $ffd2
              SCREEN = $900f
              PLOT   = $FFF0
              org $1001

              ; BASIC stub
                  dc.w nextstmt       ; next BASIC statement
                  dc.w 10             ; line number
                  dc.b $9e, "4109", 0 ; Start of assembly program
              nextstmt
                  dc.w 0              ; end of BASIC program

              clr:
                lda #147              ; Load clear screen command
                jsr CHROUT            ; Print it

              set_color:
                lda SCREEN
                and #$F0              ; Clear color bits
                ora COLOR             ; Combine with desired color
                sta SCREEN
                rts

              print_string:
                ldy #0                ; Set index to 0
              .print_loop
                lda (TEXT), y         ; Load character from text
                beq .done             ; Stop if zero byte (end of string)
                jsr CHROUT            ; Print character
                iny                   ; Move to next character
                bne .print_loop       ; Repeat
              .done:
                rts

              move_cursor:
                jsr PLOT              ; Move cursor to position (X, Y)
                rts

              main:
                jsr clr               ; Clear screen

                lda #$00
                sta COLOR
                jsr set_color         ; Set background to black

                lda #$0F
                sta COLOR
                jsr set_color         ; Set border to black

                ; Print Titles
                ldx #2
                ldy #4
                lda #<title1
                sta TEXT
                lda #>title1
                sta TEXT+1
                jsr move_cursor
                jsr print_string

                ldx #4
                ldy #5
                lda #<title2
                sta TEXT
                lda #>title2
                sta TEXT+1
                jsr move_cursor
                jsr print_string

                ldx #7
                ldy #4
                lda #<author1
                sta TEXT
                lda #>author1
                sta TEXT+1
                jsr move_cursor
                jsr print_string

                ; Repeat for other titles/authors...

              loop:
                jmp loop              ; Infinite loop

              end:
                rts

              ; Data for strings
              title1:
                dc.b "The Big Apple", 0
              title2:
                dc.b "Bank Heist", 0
              author1:
                dc.b "Dante Kirsman", 0
              ; Add other strings similarly...

	/***************** Adjustments *******************/
            * GPT response didn't declare COLOR to a memory Address
            * moved setcolor subroutine to bottom of file
            * fixed setcolor opcode so it could actually work

              lda #$0F
              sta COLOR
              jsr set_color         ; Set background to black

              lda #$F8
              sta COLOR
              jsr set_color         ; Set border to black
              .
              .
              .
              set_color:
                ldx #0                ; Set Y to black
                lda SCREEN            ; Load the scren colour address
                and COLOR             ; Reset 4 background bits based on COLOR loc
                stx $1001             ; Store X into user basic area memory
                ora $1001             ; Combine with desired color
                sta SCREEN
                rts

  

Prompt 2:
    “what does it mean by gptcompress.s (67): error: Value in 'lda (TEXT),y' must be <$100.”
    Response:

Response:
    Made adjustments accordingly to attempt to print (Below response)
    The error Value in 'lda (TEXT),y' must be <$100 arises because the lda (TEXT), y syntax in 6502 assembly only supports zero-page addressing. This means the address stored in TEXT must be in the range $00-$FF. Since your string pointers (TEXT in this case) are likely above $FF, this direct indirect addressing mode isn’t allowed.
    To fix this, you can use a different approach to load the string addresses using a pair of bytes stored in zero page, often called a "pointer" in 6502 assembly. Here’s how to adjust the code:
    Use Zero-Page Pointers for Indirect Addressing: Define TEXTL and TEXTH in the zero page to hold the low and high bytes of the TEXT address.
    Modify print_string to Load the Address into These Pointers: This approach enables indirect access without the zero-page limitation.    
    
    
    /************** CHATGPT RESPONSE ***************/

                  .
                  .
                  .
              TEXTL = $fb       ; Low byte of TEXT address (zero page)
              TEXTH = $fc       ; High byte of TEXT address (zero page)
                  .
                  .
                  .
              print_string:
                ldy #0                ; Set index to 0
              .print_loop
                lda (TEXTL), y        ; Load character from zero-page pointer
                beq .done             ; Stop if zero byte (end of string)
                jsr CHROUT            ; Print character
                iny                   ; Move to next character
                bne .print_loop       ; Repeat
              .done:
                rts
                  .
                  .
                  .
              ; Print Titles
                ldx #2
                ldy #4
                lda #<title1
                sta TEXTL             ; Load low byte of title1
                lda #>title1
                sta TEXTH             ; Load high byte of title1
                jsr move_cursor
                jsr print_string

	  /***************** Adjustments *******************/
      * Moved PLOT to printstring subroutine to reduce memory consumption
      * didn't declare separate zero page address names
      * added Y offset value to calculate byte sequence location

              printstring:
                jsr PLOT
                ldy #0                ; Set index to 0
              .printloop
                lda ($02),Y
                beq .done             ; Stop if zero byte (end of string)
                jsr CHROUT            ; Print character
                iny                   ; Move to next character
                jmp .printloop
              .done:
                rts
      * Based on the response, adjusted entire code to use printstring subroutine.
      * Result : ** Reused title10 using a loop due to 3 lines being exact duplicates

                processor 6502

              CHROUT = $ffd2
              SCREEN = $900f
              PLOT   = $FFF0
              COLOR  = $1DDA

                org $1001

              ; BASIC stub
                  dc.w nextstmt       ; next BASIC statement
                  dc.w 10             ; line number
                  dc.b $9e, "4109", 0 ; Start of assembly program
              nextstmt
                  dc.w 0              ; end of BASIC program

              ; Program Start
              clr:
                lda #147              ; Load clear screen command
                jsr CHROUT            ; Print it

              main:
                lda #$0F
                sta COLOR
                jsr set_color         ; Set background to black

                lda #$F8
                sta COLOR
                jsr set_color         ; Set border to black

                ldx #1                ; Set X to white
                stx $0286             ; Current Color code address

                ; Print Titles
                ; THE BIG APPLE
                ldx #2
                ldy #4
                lda #<title1          ; Respect endianness!!
                sta $02
                lda #>title1
                sta $03
                jsr printstring

                ; BANK HEIST
                ldx #4
                ldy #5
                lda #<title2
                sta $02
                lda #>title2
                sta $03
                jsr printstring

                ; Dante
                ldx #7
                ldy #4
                lda #<title3
                sta $02
                lda #>title3
                sta $03
                jsr printstring

                ; Daniel
                ldx #8
                ldy #3
                lda #<title4
                sta $02
                lda #>title4
                sta $03
                jsr printstring

                ; Ramiro
                ldx #9
                ldy #3
                lda #<title5
                sta $02
                lda #>title5
                sta $03
                jsr printstring

                ; JIN
                ldx #10
                ldy #6
                lda #<title6
                sta $02
                lda #>title6
                sta $03
                jsr printstring

                ; 2024
                ldx #12
                ldy #8
                lda #<title7
                sta $02
                lda #>title7
                sta $03
                jsr printstring

                ; ROOF - TOP
                ldx #15
                ldy #9
                lda #<title8
                sta $02
                lda #>title8
                sta $03
                jsr printstring
                
                ; ROOF - MID
                ldx #16
                ldy #8
                lda #<title9
                sta $02
                lda #>title9
                sta $03
                jsr printstring

                ; ROOF - BOTTOM
                ldx #17
                ldy #7
                lda #<title10
                sta $02
                lda #>title10
                sta $03
                jsr printstring

                ; WALLS
                lda #3
                sta counterl
                lda #18
                sta counterx
              walls:
                ldx counterx
                ldy #7
                lda #<title11
                sta $02
                lda #>title11
                sta $03
                jsr printstring

                dec counterl
                inc counterx
                lda counterl
                bne walls

                ; FLOOR
                lda #6
                sta counterl
                lda #7
                sta counterx
              floor:
                ldx #21
                ldy counterx
                lda #<title12
                sta $02
                lda #>title12
                sta $03
                jsr printstring

                dec counterl
                inc counterx
                lda counterl
                bne floor

              loop:
                jmp loop

              ; Counter
              counterl: .byte 0
              counterx: .byte 0

              title1: dc.b "THE BIG APPLE", 0
              title2: dc.b "BANK  HEIST", 0
              title3: dc.b "DANTE  KIRSMAN", 0
              title4: dc.b "DANIEL  SABOUROV", 0
              title5: dc.b "RAMIRO  PIQUER", 0
              title6: dc.b "JIN  SONG", 0
              title7: dc.b "2024", 0
              title8: .BYTE #110, #109, #0
              title9: .BYTE #110, #36, #36, #109, #0
              title10: .BYTE #166, #166, #166, #166, #166, #166, #0
              title11: .BYTE #182, #32, #181, #182, #32, #181, #0
              title12: .BYTE #184, #0


              set_color:
                ldx #0                ; Set Y to black
                lda SCREEN            ; Load the scren colour address
                and COLOR             ; Reset 4 background bits based on COLOR loc
                stx $1001             ; Store X into user basic area memory
                ora $1001             ; Combine with desired color
                sta SCREEN
                rts

              printstring:
                jsr PLOT
                ldy #0                ; Set index to 0
              .printloop
                lda ($02),Y
                beq .done             ; Stop if zero byte (end of string)
                jsr CHROUT            ; Print character
                iny                   ; Move to next character
                jmp .printloop
              .done:
                rts



Prompt 3:
    “im programming in 6502 assembly and i want to compress this code
  processor 6502"
  // Insert Renewed code Here

Response:
    * Looked very promising
      To compress and optimize your 6502 assembly code, you can focus on reducing redundancy, reusing code, and simplifying repeated operations. Here are some strategies:
      Centralize Repeated Operations: Functions that are used multiple times like setting the screen color and printing strings can be abstracted into subroutines. This not only saves space but also makes your code cleaner.
      Optimize Data Structures: For titles and similar data, using a single subroutine to handle the positioning and displaying can significantly reduce code size.
      Loop Unrolling and Merging: Merge similar loops or operations that follow a pattern, particularly for your title display sections.
      Use Index Registers More Efficiently: X and Y registers can be used more strategically to minimize the need for loading and storing the same values repeatedly.
      Macro Usage: Although not always available in all assemblers for the 6502, using macros to encapsulate repetitive code can be very helpful if your toolchain supports it.
      Let's apply these principles to your existing code. Here’s a revised version:

  
  /************** CHATGPT RESPONSE ***************/

                processor 6502

              CHROUT = $ffd2
              SCREEN = $900f
              PLOT   = $FFF0
              COLOR  = $1DDA

                org $1001

              ; BASIC stub
                  dc.w nextstmt       ; next BASIC statement
                  dc.w 10             ; line number
                  dc.b $9e, "4109", 0 ; Start of assembly program
              nextstmt
                  dc.w 0              ; end of BASIC program

              ; Program Start
              clr:
                lda #147              ; Load clear screen command
                jsr CHROUT            ; Print it

              main:
                lda #$0F
                sta COLOR
                jsr set_color         ; Set background to black

                lda #$F8
                sta COLOR
                jsr set_color         ; Set border to black

                ldx #1                ; Set X to white
                stx $0286             ; Current Color code address

              ; Print Titles - Compressed Loop for Title Display
                ldx #0
              print_titles:
                lda title_x_lo,x      ; Low byte of title address
                sta $02
                lda title_x_hi,x      ; High byte of title address
                sta $03
                lda title_pos,x       ; Position data packed as yyxx
                tax
                tay
                jsr printstring
                inx
                inx
                inx
                cpx #27               ; Total bytes for 9 titles (3 bytes each)
                bne print_titles

              loop:
                jmp loop

              ; Counter and Data Storage
              title_x_lo: .byte <title1, <title2, <title3, <title4, <title5, <title6, <title7, <title8, <title9
              title_x_hi: .byte >title1, >title2, >title3, >title4, >title5, >title6, >title7, >title8, >title9
              title_pos:  .byte 24, 45, 74, 83, 93, 106, 128, 159, 168 ; Packed as YX

              ; Title strings
              title1: .byte "THE BIG APPLE", 0
              title2: .byte "BANK HEIST", 0
              ; Add other titles as needed

              set_color:
                ldx #0                ; Set Y to black
                lda SCREEN            ; Load the screen color address
                and COLOR             ; Reset 4 background bits based on COLOR loc
                stx $1001             ; Store X into user basic area memory
                ora $1001             ; Combine with desired color
                sta SCREEN
                rts

              printstring:
                jsr PLOT
                ldy #0                ; Set index to 0
              .printloop
                lda ($02),Y
                beq .done             ; Stop if zero byte (end of string)
                jsr CHROUT            ; Print character
                iny                   ; Move to next character
                jmp .printloop
              .done:
                rts

    /***************** Adjustments *******************/
      * packing the position values together didn't look correct at all - didn't even bother to run it
      * declared x and y positions separately as bytes

      title_x:    .byte #2, #4, #7, #8, #9, #10, #12, #15, #16, #17, #18, #19, #20, #21 ; X coordinates
      title_y:    .byte #4, #5, #4, #3, #3, #6, #8, #9, #8, #7, #7, #7, #7, #7  ; Y coordinates

      * counter compare `cmp #27` -> `cmp #14` to match nmber of lines
      * Removed jsr PLOT call from printstring because it was messing up X values for some reason
      * added counterx declaration

            print_titles:
              ldx counter
              lda title_y,x
              tay
              lda title_x,x
              tax
              jsr PLOT
              ldx counter
              lda title_x_lo,x
              sta $02
              lda title_x_hi,x
              sta $03
              jsr printstring

            printstring:
              ldy #0                ; Set index to 0
            .printloop
              lda ($02),Y
              beq .done             ; Stop if zero byte (end of string)
              jsr CHROUT            ; Print character
              iny                   ; Move to next character
              jmp .printloop
            .done:
              rts

        * Reduced a lot of redundancies
      
        ** Went through the code to investigate unnecessary code -
        ** realized screen and border colors were all black so didn't need to or bits with screen together
        ** Managed to reduce couple of bytes.
        
            set_color:
              and SCREEN
              sta SCREEN
              rts 
