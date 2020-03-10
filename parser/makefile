CFLAGS = -DEBUG -g

parser: y.tab.c lex.yy.c
	gcc -DEBUD -g y.tab.c lex.yy.c -o parser

y.tab.c:
	$(YACC) -v -t -d parser.y

lex.yy.c:
	$(LEX) scanner.l

clean:
	$(RM) *.o parser y.tab.h y.tab.c lex.yy.c y.output
