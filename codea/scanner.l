%{
#include <string.h>
#include "names.h"
#include "oxout.h"
#include "y.tab.h"

char *lexeme() {
    char *tmp;
    tmp = (char *)malloc(yyleng+1);
    strcpy(tmp, yytext);
    return tmp;
}

%}
%%

"if"    return IF;
"end"   return END;
"return"    return RETURN;
"then"  return THEN;
"else"  return ELSE;
"loop"  return LOOP;
"break" return BREAK;
"cont"  return CONT;
"var"   return VAR;
"not"   return NOT;
"and"   return AND;
"("     return '(';
")"     return ')';
","     return ',';
";"     return ';';
":"     return ':';
"*"     return '*';
"-"     return '-';
"+"     return '+';
"#"     return '#';
"<="    return LEQ;
":="    return ASSIGN;

([a-zA-Z]|"_")[a-zA-Z0-9|"_"]* return ID; @{ @ID.name@ = lexeme(); @ID.line@ = yylineno; @}

[0-9]+          return NUM; @{ @NUM.value@ = atoll(yytext); @}
0x[0-9a-fA-F]+  return NUM; @{ @NUM.value@ = strtoll(yytext+2, 0, 16); @}

[\n]    {yylineno++;}

"//".* ;

[ \t] ;

. {fprintf(stderr, "Lexical error at line: %d: %s\n", yylineno, yytext); exit(1);}

%%
int yywrap(void){return 1;}
