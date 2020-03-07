
%%

"end" |
"return" |
"if" |
"then" |
"else" |
"loop" |
"break" |
"cont" |
"var" |
"not" |
"and" {printf("%s\n", yytext);}

"(" |
")" |
"," |
";" |
":" |
":=" |
"*" |
"-" |
"+" |
"<=" |
"#" {printf("%s\n", yytext);}

([a-zA-Z]|"_")[a-zA-Z0-9|"_"]* {printf("id %s\n", yytext);}

[0-9]+ {printf("num %ld\n", atol(yytext));}
0x[0-9a-fA-F]+ {printf("num %ld\n", strtol(yytext + 2, 0, 16));}

"//".* ;

[ \t\n] ;

. printf("Lexical error: %s\n", yytext); exit(1);
