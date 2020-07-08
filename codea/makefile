CFLAGS = -DEBUG -g

all: clean codea

codea: y.tab.c y.tab.h lex.yy.c tree.o codegen.o asm.o names.o
	$(CC) -o codea y.tab.h y.tab.c lex.yy.c *.o -lfl

oxout.y oxout.l: parser.y scanner.l
	ox -h parser.y scanner.l

y.tab.c y.tab.h: oxout.y
	yacc -d oxout.y

lex.yy.c: oxout.l y.tab.h# allocation.o
	lex oxout.l

tree.o: tree.c tree.h
asm.o: asm.c asm.h
#allocation.o: allocation.c allocation.h
#panic.o: panic.c panic.h
names.o: names.c names.h

codegen.brg: cg.bfe
	bfe cg.bfe > codegen.brg
codegen.c: codegen.brg
	iburg codegen.brg > codegen.c
codegen.o: codegen.c

clean:
	rm -f *.o codea y.tab.h y.tab.c lex.yy.c oxout.l oxout.y *.brg codegen.c

