# Assignment 2 Compression Results

| Program           | Method              | Size (in bytes) | Compression Ratio |
| :----------------:| :------------------:|:---------------:|:-----------------:|
| 2_titlescreen.prg | Original            | 775             | 1                 |
| exo.prg           | Exomizer            | 671             | 1.15              |
| rle.prg           | Run Length Encoding | 407             | 1.90              |
| zx02.prg          | Zx02                | 313             | 2.47              |
| decomp2.prg       | GPT                 | 316             | 2.45              |


## ChatGPT Prompts for Part 2

Prompt 1: 
I want to achieve 2 things.
Create a python program that compresses byte data using python, implementing lzss. The input is formatted as : #$20, #$20, ....
Then you will provide me with a 6502 assembly program for the VIC20 that decompresses the output of the previous task. The program will load the decrypted byte, and use CHROUT, a kernel function at $ffd2 to output the byte data one by one on the screen.

Output:
Python Compression Program (LZSS)
The LZSS compression algorithm works by finding repeated sequences in data and replacing them with pointers to previous locations of the same sequence. Here’s a simplified Python version:
def lzss_compress(data):
    compressed = []
    i = 0
    window_size = 256
    lookahead_buffer_size = 15

    while i < len(data):
        match_length = 0
        match_distance = 0

        # Search in the sliding window
        for j in range(max(0, i - window_size), i):
            length = 0
            while length < lookahead_buffer_size and i + length < len(data) and data[j + length] == data[i + length]:
                length += 1
            if length > match_length:
                match_length = length
                match_distance = i - j

        if match_length >= 2:
            # Encode as (distance, length)
            compressed.append((match_distance, match_length))
            i += match_length
        else:
            # Encode as literal byte
            compressed.append(data[i])
            i += 1

    return compressed

# Example usage
# Input in format #$20, #$20, etc.
input_data = [0x20, 0x20, 0x20, 0x21, 0x20, 0x22, 0x22, 0x22, 0x22, 0x23]
compressed_data = lzss_compress(input_data)
print("Compressed Data:", compressed_data)


6502 Assembly Decompression Program for VIC-20
Now, I’ll prepare a decompression program for the VIC-20 in 6502 assembly. This program will load compressed data, handle the LZSS decompression, and output each byte using the CHROUT kernel function located at $FFD2.

The assembly program will assume that each compressed tuple in the format (distance, length) is stored consecutively, and literals are stored as raw bytes.

        ORG $1000          ; Starting address

START   LDX #$00           ; X register will point to the current compressed data location
LOOP    LDA DATA,X         ; Load byte from DATA
        CMP #$80           ; Check if it's a literal or a pointer
        BCC LITERAL        ; If less than $80, treat as literal byte

        ; Pointer Handling (distance, length)
        AND #$7F           ; Mask out the high bit to get the length
        STA LENGTH         ; Store length for the loop
        INX
        LDA DATA,X         ; Get the distance
        STA DISTANCE

        ; Copy bytes from the distance
COPY    LDY #$00
BACKREF LDA DATA,X
        JSR $FFD2          ; Output the byte with CHROUT
        INY
        CPY LENGTH
        BNE BACKREF
        JMP NEXT

LITERAL LDA DATA,X         ; Load the literal byte
        JSR $FFD2          ; Output the byte
NEXT    INX                ; Move to the next compressed data
        CPX DATA_END       ; Check if we are at the end of DATA
        BNE LOOP           ; Repeat the loop if not finished

        RTS                ; Return from subroutine

DATA    .BYTE $20, $20, $80, $02, $20 ; Compressed example data here
DATA_END .BYTE $00                    ; End of data marker


Assessment:
Code in fact did not run
X , Y register wasn't being used to increment properly
Needed to store output value to some buffer so edited code accordingly


Prompt 2:
The problem with the assembly code is that when it finds a literal, it just prints the literal and moves, on - it doesn't print the literal however many times the back length value is

Response:
You're absolutely correct; in the current assembly code, literals are handled as single characters without taking any potential repeat counts into account. For sequences where a literal byte should be repeated multiple times (similar to a run-length encoding), we need to adjust the assembly decompression logic to support this behavior.

        ORG $1000               ; Start at memory address $1000

START   LDX #$00                ; Initialize X register to point to compressed data
LOOP    LDA DATA,X              ; Load the next byte from DATA
        CMP #$80                ; Check if it's a literal or a back-reference
        BCC LITERAL             ; If less than $80, treat as a literal

        ; Back-reference handling (pointer)
        AND #$7F                ; Mask out the high bit to get the length
        STA LENGTH              ; Store the length for copying
        INX                     ; Advance to the distance byte
        LDA DATA,X              ; Load the distance byte
        STA DISTANCE            ; Store the distance

        ; Copying the bytes from the distance back
        LDY #$00                ; Y will serve as a counter for copying
BACKREF LDA DATA,X              ; Load byte at the back-reference
        JSR $FFD2               ; Output each byte using CHROUT
        INY                     ; Increment Y
        CPY LENGTH              ; Check if we’ve copied the specified length
        BNE BACKREF
        JMP NEXT

LITERAL LDA DATA,X              ; Literal case, output the byte directly
        STA TEMP_LITERAL        ; Store the literal value
        INX                     ; Move to next byte
        LDA DATA,X              ; Load the repeat count for the literal
        STA LENGTH              ; Store the repeat count

        LDY #$00
LITERAL_LOOP
        LDA TEMP_LITERAL        ; Load the literal value
        JSR $FFD2               ; Output each byte using CHROUT
        INY
        CPY LENGTH
        BNE LITERAL_LOOP

NEXT    INX                     ; Move to the next byte in compressed data
        CPX DATA_END            ; Check if we are at the end of DATA
        BNE LOOP                ; Loop until finished

        RTS                     ; Return from subroutine

TEMP_LITERAL .BYTE $00          ; Temporary storage for literal value
DATA    .BYTE $20, $20, $B7, $01, $54, ... ; Compressed data from Python
DATA_END .BYTE $00              ; Marker to indicate the end of the data


Assessment
Literally spent the next 40+ prompts after correctig code to most of my understanding
to salvage code given by ChatGPT - Until window method proved to be difficult

Prompt (3) + a
To make things a lot better to understand, set the distance to be an offset from the beginning, not from the current index, assuming our data doesn't go over the window

Response:
Good idea! Setting the distance as an absolute offset from the start of OUTPUT_BUFFER rather than relative to the current position will simplify the logic significantly. This means that DISTANCE will directly represent an index in OUTPUT_BUFFER, so we don’t need to calculate a relative offset each time.

Updated Approach
Distance as Absolute Offset: The distance in the compressed data is now treated as an absolute index in OUTPUT_BUFFER.
Window Limit Assumption: We assume the data does not exceed the window size, so we don’t need to worry about overwriting earlier parts of the output buffer.
Revised Assembly Code with Absolute Distance Offset
This version will use DISTANCE directly as an index in OUTPUT_BUFFER:

        ORG $1000               ; Start at memory address $1000

START   LDX #$00                ; Initialize X register to point to compressed data
        LDY #$00                ; Initialize Y register as a pointer in OUTPUT_BUFFER

LOOP    LDA DATA,X              ; Load the next byte from DATA
        CMP #$80                ; Check if it's a literal or a back-reference/length byte
        BCC LITERAL             ; If less than $80, treat as a literal

        ; Back-reference handling (pointer)
        AND #$7F                ; Mask out the high bit to get the length
        STA LENGTH              ; Store the length for copying
        INX                     ; Advance to the distance byte
        LDA DATA,X              ; Load the distance byte (absolute index in OUTPUT_BUFFER)
        STA DISTANCE            ; Store the absolute position for back-reference

        LDY #$00                ; Initialize Y for the length loop
BACKREF LDA OUTPUT_BUFFER,DISTANCE  ; Load byte from OUTPUT_BUFFER at absolute DISTANCE
        JSR $FFD2               ; Output each byte using CHROUT
        STA OUTPUT_BUFFER,Y     ; Save it to OUTPUT_BUFFER for future reference
        INX                     ; Move X to the next position in the back-reference
        INY                     ; Move Y to the next position in OUTPUT_BUFFER
        CPY LENGTH              ; Check if we’ve reached the length
        BNE BACKREF
        JMP NEXT

LITERAL LDA DATA,X              ; Literal case: output the byte directly
        JSR $FFD2               ; Output the literal immediately
        STA OUTPUT_BUFFER,Y     ; Store it in OUTPUT_BUFFER for future back-references
NEXT    INX                     ; Move to the next byte in compressed data
        CPX DATA_END            ; Check if we are at the end of DATA
        BNE LOOP                ; Loop until finished

        RTS                     ; Return from subroutine

LENGTH       .BYTE $00          ; Storage for repeat length
DISTANCE     .BYTE $00          ; Storage for absolute position in OUTPUT_BUFFER
OUTPUT_BUFFER .RES 256          ; Buffer to hold decompressed output
DATA         .BYTE $20, $AF, $01, $54, $48, ... ; Compressed data from Python (literal, back-references, etc.)
DATA_END     .BYTE $00          ; Marker to indicate the end of the data


Assessment
Incorrect Incrementing of variables, res directive doesn't work - had to use bytes instead.
Refactored the code so it worked only half the time.

Prompt (4) + a (fixing process)
you reinitialize Y to be 00 right before the backref label. After it finishes, when it encounters the next literal, it will use that Y value to to store the new literal - which overwrites things

Response
Same code

Assessment
Losing hope but understand this algorithm more

Prompt (5) + a
since there are distances that are 00, refactor code so there is a separate terminating codition

Response
To handle DISTANCE = 0 correctly, we can add a separate terminating condition for the compressed data. A common approach is to add a special byte at the end of the compressed data to signal the end of decompression (e.g., $FF). This way, a DISTANCE of 0 doesn’t cause issues, and we don’t need to rely on specific data values to signify the end.

Here's the approach:

End-of-Data Marker: Use a unique byte (like $FF) as a terminating condition at the end of DATA.
Modified Code: Update the decompression loop to check for this end-of-data marker.
Updated Assembly Code with a Separate Terminating Condition
In this version, $FF is added as the end-of-data marker in the DATA definition. The loop will check for $FF to terminate the decompression.

** Suggested I use $FF instead **
Terrible Choice - Decided it was better to start distance at 1, not 0

Prompt (6) + a
refactor the python code so that the distance is distance + 1, so it can avoid 00 check

Response
o handle DISTANCE = 0 correctly, we can add a separate terminating condition for the compressed data. A common approach is to add a special byte at the end of the compressed data to signal the end of decompression (e.g., $FF). This way, a DISTANCE of 0 doesn’t cause issues, and we don’t need to rely on specific data values to signify the end.

Here's the approach:

End-of-Data Marker: Use a unique byte (like $FF) as a terminating condition at the end of DATA.
Modified Code: Update the decompression loop to check for this end-of-data marker.
Updated Assembly Code with a Separate Terminating Condition
In this version, $FF is added as the end-of-data marker in the DATA definition. The loop will check for $FF to terminate the decompression.

Assessment
GPT provided python code, which just broke completely
refactored code so that it scrapped windows and backrefs, to only use length and characters.


** Completed **
Managed to bring prg file size to 314 bytes
