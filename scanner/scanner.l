
%%

"if"	 |    
"end"    |
"return" |
"then"   |
"else"  |
"loop"  |
"break" |
"cont"  |
"var"   |
"not"   |
"and"   |
"(" 	|
")" 	|
"," 	|
";" 	|
":" 	|
"*" 	|
"-" 	|
"+" 	|
"#" 	|
"<="	|
":="	{ printf("%s\n", yytext); }

([a-zA-Z]|"_")[a-zA-Z0-9|"_"]* { printf("id %s\n", yytext); }

[0-9]+ 	{ printf("num %ld\n", atoll(yytext)); }
0x[0-9a-fA-F]+  { printf("num %ld\n", strtoll(yytext+2, 0, 16)); }

[\n]    {yylineno++;}

"//".* ;

[ \t] ;

. {printf("Lexical error at line: %d: %s\n", yylineno, yytext); exit(1);}

%%
int yywrap(void){return 1;}
