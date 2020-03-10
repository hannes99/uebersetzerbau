%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "y.tab.h"
    int yylex();
    extern int yylineno;
    int yyerror(char *e) {
        printf("Parser error at line: %d: %s\n", yylineno, e);
        exit(2);
    }
%}
%token END RETURN IF THEN ELSE LOOP BREAK CONT VAR NOT AND
%token '(' ')' ',' ';' ':' ASSIGN '*' '-' '+' LEQ '#'
%token NUM ID
%start program

%%

program : funcdef ';' program
	| /* EMPTY */
        ;

funcdef : ID '(' mbpars ')' mbstmts END
        ;

mbpars	: ID ',' mbpars
	| ID
	| /* EMPTY */
	;

mbstmts	: stmt ';' mbstmts
       	| /* EMPTY */
	;

stmt    : RETURN expr
        | IF expr THEN mbstmts mbelse END
        | ID ':' LOOP mbstmts END
        | BREAK ID
        | CONT ID
        | VAR ID ASSIGN expr
        | lexpr ASSIGN expr
        | expr
        ;

mbelse  : ELSE mbstmts
        | /* EMPTY */   
        ;

lexpr   : ID
        | '*' term
        ;

expr    : term
	| NOT term
	| '-' term
	| '*' term
        | plusterm
        | multterm
        | andterm
        | term LEQ term 
        | term '#' term 
        ;

plusterm: term '+' mbpterm
	;

mbpterm : plusterm
	| term
	;

multterm: term '*' mbmterm
	;

mbmterm	: multterm
	| term
	;

andterm : term AND mbaterm
	;

mbaterm	: andterm
	| term
	;

term    : '(' expr ')'  
	| NUM   
        | ID	 
        | ID '(' mbexprs ')'    
        ;

mbexprs	: expr ',' mbexprs
	| expr
	| /* EMPTY */
	;

%%

int main(void) {
 yyparse();
 return 0;
}
