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

funcdef : ID '(' pars ')' stmts END
        ;

pars    : ID ',' pars	
        | mbpar	
        ;

mbpar   : ID    
        | /* EMPTY */   
        ;

stmts   : stmt ';' stmts 
        | /* EMPTY */   
        ;

stmt    : RETURN expr
        | IF expr THEN stmts mbelse END
        | ID ':' LOOP stmts END
        | BREAK ID
        | CONT ID
        | VAR ID ASSIGN expr
        | lexpr ASSIGN expr
        | expr
        ;

mbelse  : ELSE stmts 
        | /* EMPTY */   
        ;

lexpr   : ID    
        | '*' term  
        ;

expr    : unary term  
        | term binary term 
        ;

unary	: NOT
      	| '-'
	| '*'
	;

binary	: '+'
       	| '*'
       	| AND
       	| LEQ
       	| '#'
	;

term    : '(' expr ')'  
	| NUM   
        | ID	 
        | ID '(' exprs ')'    
        ;

exprs	: expr ',' exprs
	| expr
	| /* EMPTY */
	;

%%

int main(void) {
 yyparse();
 return 0;
}
