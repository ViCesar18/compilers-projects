%{
    #include <stdio.h>
    
    extern int yylex();

    extern char *yytext;

    void yyerror(char const *s);
%}

%token PLUS
%token MINUS
%token MUL
%token DIV
%token POWER
%token MODULE
%token L_PARENT
%token R_PARENT
%token SEN
%token COS
%token TAN
%token ABS
%token NUM
%token VAR
%token EOL

%%

calclist: {printf("Cadeia Aceita!\n");}

%%

void yyerror(char const *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
    yyparse();

    return 0;
}