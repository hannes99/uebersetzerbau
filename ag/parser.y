%{
#include "names.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "oxout.h"

int yylex();
nnode names_root = {};
nnode labels_root = {};
extern int yylineno;
int yyerror(char *e) {
    fprintf(stderr, "Parser error at line: %d: %s\n", yylineno, e);
    exit(2);
}

%}

%token END RETURN IF THEN ELSE LOOP BREAK CONT VAR NOT AND
%token '(' ')' ',' ';' ':' ASSIGN '*' '-' '+' LEQ '#'
%token NUM ID
%start program

@attributes {char *name; int line;} ID
@attributes {long value;} NUM
@attributes {nnode names, labels; char *name_up; int line;} stmt
@attributes {nnode names, labels;} mbstmts mbelse
@attributes {nnode names;} mbpars lexpr expr plusterm mbpterm multterm mbmterm andterm mbaterm term mbexprs

@traversal symusage

%%

program : funcdef ';' program
        | /* EMPTY */
        ;

funcdef : ID '(' mbpars ')' mbstmts END
            @{
                @i @mbstmts.names@ = @mbpars.names@;
                @i @mbstmts.labels@ = labels_root;
            @}
        ;

mbpars	: ID ',' mbpars @{ @i @mbpars.names@ = add_new_name(&@mbpars.1.names@, labels_root,@ID.name@, @ID.line@); @}
        | ID            @{ @i @mbpars.names@ = add_new_name(&names_root, labels_root, @ID.name@, @ID.line@); @}
        | /* EMPTY */   @{ @i @mbpars.names@ = names_root; @}
        ;

mbstmts	: stmt ';' mbstmts
            @{
                @i @stmt.names@ = @mbstmts.names@;
                @i @stmt.labels@ = @mbstmts.labels@;
                @i @mbstmts.1.names@ = add_new_name(&@mbstmts.names@, @mbstmts.labels@, @stmt.name_up@, @stmt.line@);
                @i @mbstmts.1.labels@ = @mbstmts.labels@;
            @}
        | /* EMPTY */
        ;

stmt    : RETURN expr
            @{
                @i @stmt.name_up@ = "";
                @i @stmt.line@ = -1;
                @i @expr.names@ = @stmt.names@;
            @}
        | IF expr THEN mbstmts mbelse END
            @{
                @i @stmt.name_up@ = "";
                @i @stmt.line@ = -1;
                @i @expr.names@ = @stmt.names@;
                @i @mbstmts.labels@ = @stmt.labels@;
                @i @mbstmts.names@ = @stmt.names@;
                @i @mbelse.labels@ = @stmt.labels@;
                @i @mbelse.names@ = @stmt.names@;
            @}
        | ID ':' LOOP mbstmts END
            @{
                @i @stmt.name_up@ = "";
                @i @stmt.line@ = -1;
                @i @mbstmts.labels@ = add_new_name(&@stmt.labels@, @stmt.names@, @ID.name@, @ID.line@);
                @i @mbstmts.names@ = @stmt.names@;
            @}
        | BREAK ID
            @{
                @symusage must_exist(@stmt.labels@, @ID.name@, @ID.line@);
                @i @stmt.name_up@ = "";
                @i @stmt.line@ = -1;
            @}
        | CONT ID
            @{
                @symusage must_exist(@stmt.labels@, @ID.name@, @ID.line@);
                @i @stmt.name_up@ = "";
                @i @stmt.line@ = -1;
            @}
        | VAR ID ASSIGN expr
            @{
                @i @stmt.name_up@ = @ID.name@;
                @i @stmt.line@ = @ID.line@;
                @i @expr.names@ = @stmt.names@;
            @}
        | lexpr ASSIGN expr
            @{
                @i @stmt.name_up@ = "";
                @i @stmt.line@ = -1;
                @i @lexpr.names@ = @stmt.names@;
                @i @expr.names@ = @stmt.names@;
            @}
        | expr
            @{
                @i @stmt.name_up@ = "";
                @i @stmt.line@ = -1;
                @i @expr.names@ = @stmt.names@;
            @}
        ;

mbelse  : ELSE mbstmts
            @{
                @i @mbstmts.labels@ = @mbelse.labels@;
                @i @mbstmts.names@ = @mbelse.names@;
            @}
        | /* EMPTY */
        ;

lexpr   : ID
            @{
                @symusage must_exist(@lexpr.names@, @ID.name@, @ID.line@);
            @}
        | '*' term
            @{
                @i @term.names@ = @lexpr.names@;
            @}
        ;

expr    : term      @{ @i @term.names@ = @expr.names@; @}
        | NOT term  @{ @i @term.names@ = @expr.names@; @}
        | '-' term  @{ @i @term.names@ = @expr.names@; @}
        | '*' term  @{ @i @term.names@ = @expr.names@; @}
        | plusterm  @{ @i @plusterm.names@ = @expr.names@; @}
        | multterm  @{ @i @multterm.names@ = @expr.names@; @}
        | andterm   @{ @i @andterm.names@ = @expr.names@; @}
        | term LEQ term
            @{
                @i @term.names@ = @expr.names@;
                @i @term.1.names@ = @expr.names@;
            @}
        | term '#' term
            @{
                @i @term.names@ = @expr.names@;
                @i @term.1.names@ = @expr.names@;
            @}
        ;

plusterm: term '+' mbpterm
            @{
                @i @term.names@ =  @plusterm.names@;
                @i @mbpterm.names@ = @plusterm.names@;
            @}
        ;

mbpterm : plusterm  @{ @i @plusterm.names@ = @mbpterm.names@; @}
        | term      @{ @i @term.names@ = @mbpterm.names@; @}
        ;

multterm: term '*' mbmterm
            @{
                @i @term.names@ = @multterm.names@;
                @i @mbmterm.names@ = @multterm.names@;
            @}
        ;

mbmterm	: multterm  @{ @i @multterm.names@ = @mbmterm.names@; @}
        | term      @{ @i @term.names@ = @mbmterm.names@; @}
        ;

andterm : term AND mbaterm
            @{
                @i @term.names@ = @andterm.names@;
                @i @mbaterm.names@ = @andterm.names@;
            @}
        ;

mbaterm	: andterm   @{ @i @andterm.names@ = @mbaterm.names@; @}
        | term      @{ @i @term.names@ = @mbaterm.names@; @}
        ;

term    : '(' expr ')'          @{ @i @expr.names@ = @term.names@; @};
        | NUM
        | ID                    @{ @symusage must_exist(@term.names@, @ID.name@, @ID.line@);	@}
        | ID '(' mbexprs ')'
            @{
                @i @mbexprs.names@ = @term.names@;
            @}
        ;

mbexprs	: expr ',' mbexprs
            @{
                @i @expr.names@ = @mbexprs.0.names@;
                @i @mbexprs.1.names@ = @mbexprs.0.names@;
            @}
        | expr  @{ @i @expr.names@ = @mbexprs.names@; @}
        | /* EMPTY */
        ;

%%

int main(void) {
 yyparse();
 return 0;
}
