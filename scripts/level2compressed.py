#!/usr/bin/env python3

import sys
import os

"""
On the VIC-20, the screen resolution is 22x23 characters.
The top row is reserved for the score/time, and each of the borders is guaranteed to be a wall.
This means that the play area is 20x20 characters.
The data in each level is stored as a 20x20 grid of characters. Static walls are represented by '#', traps by 'T', the player is represented by 'P', and the exit is represented by 'E'.

Compression will be handled in the following manner:
  - A 50 byte blob will represent the positions of the walls in the level, where each bit determines if a wall is present in that area.
  - After the 50 byte blob, the player and exit positions will be stored as two bytes each, where the first byte is the x position and the second byte is the y position.
  - After the player and exit positions, a single byte will be used to store the timer value for the level.
  - The remaining bytes will be used to store the positions of special objects such as traps and guards.
  - The end of the compressed data will be marked by a 0 byte.
"""

CHAR_PLAYER = "P"
CHAR_EXIT = "E"
CHAR_WALL = "#"
CHAR_EMPTY = " "
CHAR_TRAP = "T"

CHARACTERS = [CHAR_PLAYER, CHAR_EXIT, CHAR_WALL, CHAR_EMPTY, CHAR_TRAP]


def compress(data: list[list[str]], timer: int):
    if len(data) != 20:
        raise Exception("Invalid number of rows. The level data must be exactly 20 rows.")
    if len(data[0]) != 20:
        raise Exception("Invalid number of columns. The level data must be exactly 20 columns.")

    compressed_data = []

    current_byte = 0
    current_bit = 0

    player_x = -1
    player_y = -1

    exit_x = -1
    exit_y = -1
    traps = []

    for row_idx in range(20):
        row = data[row_idx]
        for char_idx in range(20):
            char = row[char_idx]
            if char not in CHARACTERS:
                raise Exception(f"Invalid character {char} found at {row_idx},{char_idx}. Only the following characters are allowed: #, P, E, T, and space.")

            if char == "#":
                current_byte |= 1 << current_bit
            else:
                current_byte &= 255 - (1 << current_bit)

                if char == CHAR_PLAYER:
                    if player_x != -1 or player_y != -1:
                        raise Exception("Multiple player characters found. Only one player character is allowed.")
                    player_x = char_idx + 1
                    player_y = row_idx + 2

                elif char == CHAR_EXIT:
                    if exit_x != -1 or exit_y != -1:
                        raise Exception("Multiple exit characters found. Only one exit character is allowed.")
                    exit_x = char_idx + 1
                    exit_y = row_idx + 2

                elif char == CHAR_TRAP:
                    traps.append((char_idx + 1, row_idx + 2))

                elif char != CHAR_EMPTY:
                    raise Exception(f"Invalid character {char} found at {row_idx},{char_idx}. Only the following characters are allowed: #, P, E, T and space.")

            current_bit += 1

            if current_bit == 8:
                compressed_data.append(current_byte)
                current_byte = 0
                current_bit = 0

    # validate that there are 50 bytes in the compressed data, and that the player and exit positions have been found
    if len(compressed_data) != 50:
        raise Exception("Invalid number of bytes in the compressed data. There should be exactly 50 bytes.")

    if player_x == -1 or player_y == -1:
        raise Exception("Player position not found. The player position must be specified.")

    if exit_x == -1 or exit_y == -1:
        raise Exception("Exit position not found. The exit position must be specified.")

    compressed_data.append(player_x)
    compressed_data.append(player_y)

    compressed_data.append(exit_x)
    compressed_data.append(exit_y)

    # Add timer value
    if (timer < 1) or (timer > 99):
        raise Exception("Invalid timer value. The timer value must be between 1 and 99.")
    
    timer_encoded = 0
    timer_encoded |= (timer % 10) & 0b1111
    timer_encoded |= ((timer // 10) << 4) & 0b11110000

    print(f"Timer: {timer} -> {timer_encoded} ({timer_encoded:08b})")

    compressed_data.append(timer_encoded)

    for trap_x, trap_y in traps:
        compressed_data.append(trap_x)
        compressed_data.append(trap_y)

    compressed_data.append(0)  # end of compressed data marker

    return compressed_data


def decompress(compressed_data: list[int]):
    if len(compressed_data) < 54:
        raise Exception("Invalid number of bytes in the compressed data. There should be at least 54 bytes.")

    if compressed_data[-1] != 0:
        raise Exception("End of compressed data marker not found. The compressed data must end with a 0 byte.")

    # Retrieve player and exit positions
    player_x = compressed_data[50]
    player_y = compressed_data[51]
    exit_x = compressed_data[52]
    exit_y = compressed_data[53]

    # Check validity of player and exit positions
    if not (1 <= player_x <= 20 and 2 <= player_y <= 21):
        raise Exception("Invalid player position. The player position must be within the bounds of the level.")

    if not (1 <= exit_x <= 20 and 2 <= exit_y <= 21):
        raise Exception("Invalid exit position. The exit position must be within the bounds of the level.")

    # Initialize the empty level grid
    data = []
    row = []
    char_idx = 0

    # Fill the grid with wall data from the first 50 bytes
    for i in range(50):
        byte = compressed_data[i]
        for j in range(8):
            if byte & (1 << j):
                row.append("#")
            else:
                row.append(" ")

            char_idx += 1
            if char_idx == 20:
                data.append(row.copy())
                row = []
                char_idx = 0

    # Place player and exit in the grid
    data[player_y - 2][player_x - 1] = "P"
    data[exit_y - 2][exit_x - 1] = "E"

    # Decompress timer
    timer_encoded = compressed_data[54]
    timer = (timer_encoded & 0b1111) + ((timer_encoded & 0b11110000) >> 4) * 10

    # Decompress trap positions from remaining bytes
    trap_idx = 55
    while trap_idx < len(compressed_data) - 1:
        trap_x = compressed_data[trap_idx]
        trap_y = compressed_data[trap_idx + 1]

        # Ensure valid trap coordinates within bounds
        if not (1 <= trap_x <= 20 and 2 <= trap_y <= 21):
            raise Exception(f"Invalid trap position ({trap_x}, {trap_y}). Must be within level bounds.")

        data[trap_y - 2][trap_x - 1] = "T"
        trap_idx += 2

    print(f"Timer: {timer} ({timer_encoded:08b})")

    return data, timer


def main():
    data = []
    if len(sys.argv) == 3:
        data = sys.stdin.readlines()
        if not data:
            raise Exception("No data provided. Please provide level data to compress.")

        for i in range(len(data)):
            data[i] = data[i].strip("\n")
        [list(i) for i in data]
    elif len(sys.argv) == 4:
        with open(sys.argv[3], "r") as f:
            data = f.readlines()
            for i in range(len(data)):
                data[i] = data[i].strip("\n")
            [list(i) for i in data]
    else:
        raise Exception("Usage: level2compressed.py <level_timer> <outfile> [infile (as parameter or stdin)]")

    # if the data is empty, exit
    if not data:
        raise Exception("No data provided. Please provide level data to compress.")

    compressed_data = compress(data, int(sys.argv[1]))

    [print("{0:08b}".format(i)) for i in compressed_data]

    decompressed_data = decompress(compressed_data)
    [print(i) for i in decompressed_data[0]]

    outfile = sys.argv[2]

    # check if file already exists
    if os.path.exists(outfile):
        raise Exception(f"File {outfile} already exists. Please specify a different file.")
        

    with open(outfile, "wb") as f:
        f.write(bytes(compressed_data))

    print(f"Level data written to {outfile}.")


if __name__ == "__main__":
    main()
