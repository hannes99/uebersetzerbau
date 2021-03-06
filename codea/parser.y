%{
#include "names.h"
#include "tree.h"
#include "asm.h"
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

extern void cg_statement(NODEPTR_TYPE root);

%}

%token END RETURN IF THEN ELSE LOOP BREAK CONT VAR NOT AND
%token '(' ')' ',' ';' ':' ASSIGN '*' '-' '+' LEQ '#'
%token NUM ID
%start program


@attributes {char *name; int line;} ID
@attributes {long long value;} NUM
@attributes {nnode names, labels; char *name_up; int line; struct Tree *tree; } stmt
@attributes {nnode names, labels; } mbelse mbstmts
@attributes {nnode names; struct Tree *tree; } lexpr expr plusterm mbpterm multterm mbmterm andterm mbaterm term mblop
@attributes {nnode names; } mbpars mbexprs

@traversal symusage
@traversal @lefttoright @postorder codegen
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
                @codegen cg_statement(@stmt.tree@);
            @}
        | /* EMPTY */
        ;

stmt    : RETURN expr
            @{
                @i @stmt.tree@ = new_node(@expr.tree@, NULL, TREE_RETURN);
                @i @stmt.name_up@ = "";
                @i @stmt.line@ = -1;
                @i @expr.names@ = @stmt.names@;
            @}
        | IF expr THEN mbstmts mbelse END
            @{
                @i @stmt.tree@ = NULL;
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
                @i @stmt.tree@ = NULL;
                @i @stmt.name_up@ = "";
                @i @stmt.line@ = -1;
                @i @mbstmts.labels@ = add_new_name(&@stmt.labels@, @stmt.names@, @ID.name@, @ID.line@);
                @i @mbstmts.names@ = @stmt.names@;
            @}
        | BREAK ID
            @{
                @i @stmt.tree@ = NULL;
                @symusage must_exist(@stmt.labels@, @ID.name@, @ID.line@);
                @i @stmt.name_up@ = "";
                @i @stmt.line@ = -1;
            @}
        | CONT ID
            @{
                @i @stmt.tree@ = NULL;
                @symusage must_exist(@stmt.labels@, @ID.name@, @ID.line@);
                @i @stmt.name_up@ = "";
                @i @stmt.line@ = -1;
            @}
        | VAR ID ASSIGN expr
            @{
                @i @stmt.tree@ = new_vardeclar_node(@ID.name@, @expr.tree@);
                @i @stmt.name_up@ = @ID.name@;
                @i @stmt.line@ = @ID.line@;
                @i @expr.names@ = @stmt.names@;
            @}
        | lexpr ASSIGN expr
            @{
                @i @stmt.tree@ = new_varassign_node(@lexpr.tree@, @expr.tree@);
                @i @stmt.name_up@ = "";
                @i @stmt.line@ = -1;
                @i @lexpr.names@ = @stmt.names@;
                @i @expr.names@ = @stmt.names@;
            @}
        | expr
            @{
                @i @stmt.tree@ = @expr.tree@;
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
                @i @lexpr.tree@ = new_varusage_node(@ID.name@);
                @symusage must_exist(@lexpr.names@, @ID.name@, @ID.line@);
            @}
        | '*' term
            @{
                @i @lexpr.tree@ = new_node(@term.tree@, NULL, TREE_MEM);
                @i @term.names@ = @lexpr.names@;
            @}
        ;

mblop	: term		@{  
                        @i @mblop.tree@ = @term.tree@; 
                        @i @term.names@ = @mblop.names@;
                    @}
      	| NOT mblop	@{ 
                        @i @mblop.tree@ = new_node(@mblop.1.tree@, NULL, TREE_NOT); 
                        @i @mblop.1.names@ = @mblop.names@; 
                    @}
	    | '-' mblop	@{ 
                        @i @mblop.tree@ = new_node(@mblop.1.tree@, NULL, TREE_NEG);
                        @i @mblop.1.names@ = @mblop.names@; 
                    @}
	    | '*' mblop	@{ 
                        @i @mblop.tree@ = new_node(@mblop.1.tree@, NULL, TREE_MEM);
                        @i @mblop.1.names@ = @mblop.names@;
                    @}
	    ;

expr    : mblop     @{
                        @i @expr.tree@ = @mblop.tree@; 
                        @i @mblop.names@ = @expr.names@;
                    @}
        | plusterm  @{ 
                        @i @expr.tree@ = @plusterm.tree@;
                        @i @plusterm.names@ = @expr.names@;
                    @}
        | multterm  @{ 
                        @i @expr.tree@ = @multterm.tree@;
                        @i @multterm.names@ = @expr.names@;
                    @}
        | andterm   @{
                        @i @expr.tree@ = @andterm.tree@; 
                        @i @andterm.names@ = @expr.names@;
                    @}
        | term LEQ term
            @{
                @i @expr.tree@ = new_node(@term.tree@, @term.1.tree@, TREE_LEQ);
                @i @term.names@ = @expr.names@;
                @i @term.1.names@ = @expr.names@;
            @}
        | term '#' term
            @{
                @i @expr.tree@ = new_node(@term.tree@, @term.1.tree@, TREE_NEQ);
                @i @term.names@ = @expr.names@;
                @i @term.1.names@ = @expr.names@;
            @}
        ;

plusterm: term '+' mbpterm
            @{
                @i @plusterm.tree@ = new_node(@term.tree@, @mbpterm.tree@, TREE_ADD);
                @i @term.names@ =  @plusterm.names@;
                @i @mbpterm.names@ = @plusterm.names@;
            @}
        ;

mbpterm : plusterm  @{ 
                        @i @mbpterm.tree@ = @plusterm.tree@;
                        @i @plusterm.names@ = @mbpterm.names@;
                    @}
        | term      @{
                        @i @mbpterm.tree@ = @term.tree@; 
                        @i @term.names@ = @mbpterm.names@;
                    @}
        ;

multterm: term '*' mbmterm
            @{
                @i @multterm.tree@ = new_node(@term.tree@, @mbmterm.tree@, TREE_MULT);
                @i @term.names@ = @multterm.names@;
                @i @mbmterm.names@ = @multterm.names@;
            @}
        ;

mbmterm	: multterm  @{ 
                        @i @mbmterm.tree@ = @multterm.tree@;
                        @i @multterm.names@ = @mbmterm.names@;
                    @}
        | term      @{  
                        @i @mbmterm.tree@ = @term.tree@;
                        @i @term.names@ = @mbmterm.names@;
                    @}
        ;

andterm : term AND mbaterm
            @{
                @i @andterm.tree@ = new_node(@term.tree@, @mbaterm.tree@, TREE_AND);
                @i @term.names@ = @andterm.names@;
                @i @mbaterm.names@ = @andterm.names@;
            @}
        ;

mbaterm	: andterm   @{
                        @i @mbaterm.tree@ = @andterm.tree@;
                        @i @andterm.names@ = @mbaterm.names@;
                    @}
        | term      @{  
                        @i @mbaterm.tree@ = @term.tree@;
                        @i @term.names@ = @mbaterm.names@;
                    @}
        ;

term    : '(' expr ')'          @{ @i @term.tree@ = @expr.tree@; @i @expr.names@ = @term.names@; @}
        | NUM                   @{ @i @term.tree@ = new_const_node(@NUM.value@); @}
        | ID                    @{ @i @term.tree@ = new_varusage_node(@ID.name@); @symusage must_exist(@term.names@, @ID.name@, @ID.line@);	@}
        | ID '(' mbexprs ')'
            @{
                @i @term.tree@ = NULL;
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
