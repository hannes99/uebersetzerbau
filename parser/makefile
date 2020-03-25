parser: y.tab.c lex.yy.c
	gcc y.tab.c lex.yy.c -o parser

y.tab.c:
	$(YACC) -d parser.y

lex.yy.c:
	$(LEX) scanner.l

clean:
	rm -rf *.o parser y.tab.h y.tab.c lex.yy.c y.output
