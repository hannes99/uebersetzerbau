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
%token ID NUM
%start program

%%

program : /* EMPTY */   {;}
        | funcdef ';'   {;}
        ;

funcdef : ID '(' pars ')' stmts END {;}
        ;

pars    : ID ',' mbpars  {;}
        | mbpars         {;}
        ;

mbpars  : ID    {;}
        | /* EMPTY */   {;}
        ;

stmts   : stmt ';'  {;}
        | /* empty */   {;}
        ;

stmt    : '(' ')'
        | IF expr THEN stmts mbelse END
        | ID ':' LOOP stmts END
        | BREAK ID
        | CONT ID
        | VAR ID ASSIGN expr
        | lexpr ASSIGN expr
        | expr
        ;

mbelse  : ELSE stmts {;}
        | /* EMPTY */   {;}
        ;

lexpr   : ID    {;}
        | '*' term  {;}
        ;

expr    : NOT term  {;}
        | '-' term  {;}
        | '*' term  {;}
        | term '+' term {;}
        | term '*' term {;}
        | term AND term {;}
        | term LEQ term {;}
        | term '#' term {;}
        ;

term    : '(' expr ')'  {;}
        | NUM   {;}
        | ID    {;}
        | ID '(' expr ',' mbexpr ')'    {;}
        ;

mbexpr  : expr  {;}
        | /* EMPTY */   {;}
        ;
%%

int main(void) {
 yyparse();
 return 0;
}
