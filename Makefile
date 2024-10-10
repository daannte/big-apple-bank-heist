ifneq (,$(wildcard ./.env))
	include .env
	export
endif

ifeq ($(OS),Windows_NT)
	OS_TYPE := WIN32
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
			OS_TYPE := LINUX
	endif
	ifeq ($(UNAME_S),Darwin)
			OS_TYPE := OSX
	endif
endif

main: compile upload run

1:
	dasm 1_music.s -oout.prg -lout.lst

2:
	dasm 2_titlescreen.s -oout.prg -lout.lst

3:
	dasm 3_wasd.s -oout.prg -lout.lst

4:
	dasm 4_collisions.s -oout.prg -lout.lst

5:
	dasm 5_sfx.s -oout.prg -lout.lst

6:
	dasm 6_screenposition.s -oout.prg -lout.lst

7:
	dasm 7_idle_animation.s -oout.prg -lout.lst

8:
	dasm 8_map.s -oout.prg -lout.lst

9:
	dasm 9_cheat.s -oout.prg -lout.lst

10:
	dasm 10_move_animation.s -oout.prg -lout.lst

compile:
	dasm $(INFILE) -o$(OUTFILE) -lout.lst

upload:
	scp "./$(OUTFILE)" "$(REMOTE):~/www/$(OUTFILE)"

run:
ifeq ($(OS_TYPE), WIN32)
	powershell -Command "Start-Process https://cspages.ucalgary.ca/~aycock/599.82/vic20/?file=https://cspages.ucalgary.ca/~$(USER)/$(OUTFILE)"
endif
ifeq ($(OS_TYPE), OSX)
	open "https://cspages.ucalgary.ca/~aycock/599.82/vic20/?file=https://cspages.ucalgary.ca/~$(USER)/$(OUTFILE)"
endif
ifeq ($(OS_TYPE), LINUX)
	open "https://cspages.ucalgary.ca/~aycock/599.82/vic20/?file=https://cspages.ucalgary.ca/~$(USER)/$(OUTFILE)"
endif
