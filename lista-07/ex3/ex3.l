/* Nao usar a biblioteca do flex */
%option noyywrap

%%

"aba"+  {printf("action 1\n");}
ab*a    {printf("action 2\n");}
[ab]    {printf("action 3\n");}

%%

int main() {
    yylex();

    return 0;
}