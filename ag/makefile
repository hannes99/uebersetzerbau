ag: y.tab.c y.tab.h lex.yy.c
	gcc -o ag y.tab.h y.tab.c lex.yy.c *.o -lfl

oxout.y oxout.l: parser.y scanner.l
	ox -h parser.y scanner.l

y.tab.c y.tab.h: oxout.y
	yacc -d oxout.y

lex.yy.c: oxout.l y.tab.h names.o
	lex oxout.l

names.o: names.c names.h

clean:
	$(RM) *.o ag y.tab.h y.tab.c lex.yy.c oxout.*
