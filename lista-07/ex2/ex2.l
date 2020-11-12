/* Nao usar a biblioteca do flex */
%option noyywrap

%%

"if"    {printf("%s IF\n", yytext);}
[a-z][a-z0-9]*   {printf("%s ID\n", yytext);}
[0-9]+      {printf("%s NUM\n", yytext);}
[0-9]*"."[0-9]+     {printf("%s REAL\n", yytext);}
[0-9]+"."[0-9]*     {printf("%s REAL\n", yytext);}
"--"[a-z]*      {printf("%s comment\n", yytext);}
" "     {printf("white space\n");}
"\n"    {}
"\r"    {}
.       {printf("%s error\n", yytext);}

%%

int main() {
    yylex();
    
    return 0;
}