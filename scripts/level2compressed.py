#!/usr/bin/env python3

import sys
import os

'''
On the VIC-20, the screen resolution is 22x23 characters.
The top row is reserved for the score/time, and each of the borders is guaranteed to be a wall.
This means that the play area is 20x20 characters.
The data in each level is stored as a 20x20 grid of characters. Static walls are represented by '#', the player is represented by 'P', and the exit is represented by 'E'.

Compression will be handled in the following manner:
  - A 50 byte blob will represent the positions of the walls in the level, where each bit determines if a wall is present in that area.
  - After the 50 byte blob, the player and exit positions will be stored as two bytes each, where the first byte is the x position and the second byte is the y position.
  - After the player and exit positions, the remaining bytes will be used to store the positions of special objects such as traps and guards.
  - The end of the compressed data will be marked by a 0 byte.
'''

CHAR_PLAYER = 'P'
CHAR_EXIT = 'E'
CHAR_WALL = '#'
CHAR_EMPTY = ' '

def compress(data: list[list[str]]):
  if len(data) != 20:
    print('Invalid number of rows. The level data must be exactly 20 rows.')
    sys.exit(1)
  if len(data[0]) != 20:
    print('Invalid number of columns. The level data must be exactly 20 columns.')
    sys.exit(1)

  compressed_data = []

  current_byte = 0
  current_bit = 0

  player_x = -1
  player_y = -1

  exit_x = -1
  exit_y = -1

  for row_idx in range(20):
    row = data[row_idx]
    for char_idx in range(20):
      char = row[char_idx]
      if char not in [CHAR_PLAYER, CHAR_EXIT, CHAR_WALL, CHAR_EMPTY]:
        print(f'Invalid character {char} found at {row_idx},{char_idx}. Only the following characters are allowed: #, P, E, and space.')
        sys.exit(1)
      
      if char == '#':
        current_byte |= (1 << current_bit)
      else:
        current_byte &= (255 - (1 << current_bit))

        if char == CHAR_PLAYER:
          if player_x != -1 or player_y != -1:
            print('Multiple player characters found. Only one player character is allowed.')
            sys.exit(1)
          player_x = char_idx + 1
          player_y = row_idx + 1

        elif char == CHAR_EXIT:
          if exit_x != -1 or exit_y != -1:
            print('Multiple exit characters found. Only one exit character is allowed.')
            sys.exit(1)
          exit_x = char_idx + 1
          exit_y = row_idx + 1
        
        elif char != CHAR_EMPTY:
          print(f'Invalid character {char} found at {row_idx},{char_idx}. Only the following characters are allowed: #, P, E, and space.')
          sys.exit(1)

      current_bit += 1

      if current_bit == 8:
        compressed_data.append(current_byte)
        current_byte = 0
        current_bit = 0
  
  # validate that there are 50 bytes in the compressed data, and that the player and exit positions have been found
  if len(compressed_data) != 50:
    print('Invalid number of bytes in the compressed data. There should be exactly 50 bytes.')
    sys.exit(1)

  if player_x == -1 or player_y == -1:
    print('Player position not found. The player position must be specified.')
    sys.exit(1)

  if exit_x == -1 or exit_y == -1:
    print('Exit position not found. The exit position must be specified.')
    sys.exit(1)

  compressed_data.append(player_x)
  compressed_data.append(player_y)
  
  compressed_data.append(exit_x)
  compressed_data.append(exit_y)
  
  compressed_data.append(0)  # end of compressed data marker
  
  return compressed_data

def decompress(compressed_data: list[int]):
  if len(compressed_data) < 54:
    print('Invalid number of bytes in the compressed data. There should be at least 54 bytes.')
    sys.exit(1)

  if compressed_data[-1] != 0:
    print('End of compressed data marker not found. The compressed data must end with a 0 byte.')
    sys.exit(1)

  player_x = compressed_data[-5]
  player_y = compressed_data[-4]

  exit_x = compressed_data[-3]
  exit_y = compressed_data[-2]

  if player_x < 0 or player_x > 20 or player_y < 0 or player_y > 20:
    print('Invalid player position. The player position must be within the bounds of the level.')
    sys.exit(1)

  if exit_x < 0 or exit_x > 20 or exit_y < 0 or exit_y > 20:
    print('Invalid exit position. The exit position must be within the bounds of the level.')
    sys.exit(1)

  data = []
  row = []
  char_idx = 0

  for i in range(50):
    byte = compressed_data[i]
    for j in range(8):
      if byte & (1 << j):
        row.append('#')
      else:
        row.append(' ')
      
      char_idx += 1
      if char_idx == 20:
        data.append(row.copy())
        row = []
        char_idx = 0
      
  data[player_y - 1][player_x - 1] = 'P'
  data[exit_y - 1][exit_x - 1] = 'E'

  return data

def main():
  data = []
  if len(sys.argv) == 2:
    data = sys.stdin.readlines()
    if not data:
      print('No data provided. Please provide level data to compress.')
      sys.exit(1)

    for i in range(len(data)):
      data[i] = data[i].strip("\n")
    [list(i) for i in data]
  elif len(sys.argv) == 3:
    with open(sys.argv[1], 'r') as f:
      data = f.readlines()
      for i in range(len(data)):
        data[i] = data[i].strip("\n")
      [list(i) for i in data]
  else:
    print('Usage: level2compressed.py <outfile> [infile (as parameter or stdin)]')
    sys.exit(1)
  
  # if the data is empty, exit
  if not data:
    print('No data provided. Please provide level data to compress.')
    sys.exit(1)

  compressed_data = compress(data)

  [print('{0:08b}'.format(i)) for i in compressed_data]

  decompressed_data = decompress(compressed_data)
  [print(i) for i in decompressed_data]

  outfile = sys.argv[1]

  # check if file already exists
  if os.path.exists(outfile):
    print(f'File {outfile} already exists. Please specify a different file.')
    sys.exit(1)

  with open(outfile, 'wb') as f:
    f.write(bytes(compressed_data))

  print(f'Level data written to {outfile}.')

if __name__ == '__main__':
  main()