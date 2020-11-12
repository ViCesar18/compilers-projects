/* Nao usar a biblioteca do flex */
%option noyywrap

%%

[+-]    {printf("%s\n", yytext);}
[_a-zA-Z][a-zA-Z0-9]*   {printf("%s\n", yytext);}
[0-9]+      {printf("%s\n", yytext);}
[0-9]+"e"[+-]?[0-9]+    {printf("%s\n", yytext);}
"\n"    {}
"\r"    {}
.   {printf("ERRO\n");}

%%

int main() {
    yylex();
    
    return 0;
}