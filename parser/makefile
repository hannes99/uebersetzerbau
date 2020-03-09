parser: y.tab.c lex.yy.c
	gcc y.tab.c lex.yy.c -o parser

y.tab.c:
	$(YACC) -v -d parser.y

lex.yy.c:
	$(LEX) scanner.l

clean:
	$(RM) *.o parser y.tab.h y.tab.c lex.yy.c y.output
