%{
#include "y.tab.h"
%}
%%

"if"    {return IF;}
"end"   {return END;}
"return"    {return RETURN;}
"then"  {return THEN;}
"else"  {return ELSE;}
"loop"  {return LOOP;}
"break" {return BREAK;}
"cont"  {return CONT;}
"var"   {return VAR;}
"not"   {return NOT;}
"and"   {return AND;}

"(" |
")" |
"," |
";" |
":" |
"*" |
"-" |
"+" |
"#" {return yytext[0];}
"<="    {return LEQ;}
":="    {return ASSIGN;}

([a-zA-Z]|"_")[a-zA-Z0-9|"_"]* {return ID;}

[0-9]+ |
0x[0-9a-fA-F]+  {return NUM;}

[\n]    {yylineno++;}

"//".* ;

[ \t] ;

. {printf("Lexical error: %s\n", yytext); exit(1);}

%%
int yywrap(void){return 1;}
