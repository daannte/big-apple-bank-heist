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

main: compile #upload run

compile:
	dasm project/main.s -omain.prg -lmain.lst

#upload:
#	scp "./$(OUTFILE)" "$(REMOTE):~/www/$(OUTFILE)"

#run:
#ifeq ($(OS_TYPE), WIN32)
#	powershell -Command "Start-Process https://cspages.ucalgary.ca/~aycock/599.82/vic20/?file=https://cspages.ucalgary.ca/~$(USER)/$(OUTFILE)"
#endif
#ifeq ($(OS_TYPE), OSX)
#	open "https://cspages.ucalgary.ca/~aycock/599.82/vic20/?file=https://cspages.ucalgary.ca/~$(USER)/$(OUTFILE)"
#endif
#ifeq ($(OS_TYPE), LINUX)
#	open "https://cspages.ucalgary.ca/~aycock/599.82/vic20/?file=https://cspages.ucalgary.ca/~$(USER)/$(OUTFILE)"
#endif
