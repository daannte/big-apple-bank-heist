EXOMIZER_COMPRESS=./exomizer
ZX02_COMPRESS=./zx02
DASM=~aycock/599.82/bin/dasm
ALL=zx02.prg exo.prg rle.prg compress2.prg

all: $(ALL)

%.prg:
	$(DASM) $< -o$@ -l$(<:.s=.lst)

zx02.prg: zx02.s titlescreen.zx02
exo.prg: exo.s exodecrunch.s titlescreen.exo
rle.prg: rle.s
compress2.prg: compress2.s

clean:
	rm *.prg *.lst
