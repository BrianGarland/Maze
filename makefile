NAME=3d Maze
BIN_LIB=MAZE
DBGVIEW=*SOURCE
TGTRLS=V7R1M0
SHELL=/QOpenSys/usr/bin/qsh

#----------

all: $(BIN_LIB).lib mazefm.dspf maze.rpgle
	@echo "Built all"

#----------

%.dspf:
	system "CPYFRMSTMF FROMSTMF('QSOURCE/$*.dspf') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QSOURCE.file/$*.mbr') MBROPT(*REPLACE)"
	system "CRTDSPF FILE($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/QSOURCE) SRCMBR($*) RSTDSP(*YES) TEXT('$(NAME)') REPLACE(*YES)"

%.rpgle:
	liblist -a $(BIN_LIB);\
	system "CRTBNDRPG PGM($(BIN_LIB)/$*) SRCSTMF('QSOURCE/$*.rpgle') TEXT('$(NAME)') REPLACE(*YES) DBGVIEW($(DBGVIEW)) TGTRLS($(TGTRLS))"

%.lib:
	-system -qi "CRTLIB LIB($(BIN_LIB)) TEXT('$(NAME)')"
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/QSOURCE) MBR($*) RCDLEN(112)"

clean:
	system "CLRLIB LIB($(BIN_LIB))"

erase:
	-system -qi "DLTLIB LIB($(BIN_LIB))"	
