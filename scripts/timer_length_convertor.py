"""
This script converts a timer length in milliseconds to 6502 assembly code which counts
in Jiffies (1/60th seconds).
"""

from sys import argv
from math import ceil

def main():
    if len(argv) != 2:
        print(f"Usage: {argv[0]} <time in milliseconds>")
        return

    time = int(argv[1])
    if time < 0:
        print("Time must be a positive integer")
        return

    jiffies = ceil((time * 60) / 1000)

    # convert time to base 256
    time_bytes = []

    for i in range(2,-1,-1):
        power = 256 ** i
        time_bytes.append(jiffies // power)
        jiffies = jiffies % power

    # print assembly code
    print(f"""
    ; Timer length:\t  {argv[1]} milliseconds
    ; Time in jiffies:\t  {ceil((int(argv[1]) * 60) / 1000)}
    ; Confirmation:\t  ({time_bytes[2]} * 256^0)
    ; \t\t\t+ ({time_bytes[1]} * 256^1)
    ; \t\t\t+ ({time_bytes[0]} * 256^2)
    ; \t\t\t= {time_bytes[2]} + {time_bytes[1] * 256} + {time_bytes[0] * (256 ** 2)} = {ceil((int(argv[1]) * 60) / 1000)}

    TIMERESET1\t= #{time_bytes[2]}
    TIMERESET2\t= #{time_bytes[1]}
    TIMERESET3\t= #{time_bytes[0]}

    lda #TIMERESET1\t; {time_bytes[2]} * 256^0 = {time_bytes[2]} jiffies
    sta TIMER1\t\t; store the timer value in address TIMER1

    lda #TIMERESET2\t; {time_bytes[1]} * 256^1 = {time_bytes[1] * 256} jiffies
    sta TIMER2\t\t; store the timer value in address TIMER2

    lda #TIMERESET3\t; {time_bytes[0]} * 256^2 = {time_bytes[0] * (256 ** 2)} jiffies
    sta TIMER3\t\t; store the timer value in address TIMER3
    """)

if __name__ == "__main__":
    main()