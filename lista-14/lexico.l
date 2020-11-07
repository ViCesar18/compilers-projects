%option noyywrap

%{
    #include "sintatico.tab.h"

    int column_counter = 1;
%}

%%

"+" {
    column_counter += strlen(yytext);
    return PLUS;
}

"-" {
    column_counter += strlen(yytext);
    return MINUS;
}

"*" {
    column_counter += strlen(yytext);
    return MUL;
}

"/" {
    column_counter += strlen(yytext);
    return DIV;
}

"^" {
    column_counter += strlen(yytext);
    return POWER;
}

"%" {
    column_counter += strlen(yytext);
    return MODULE;
}

"(" {
    column_counter += strlen(yytext);
    return L_PARENT;
}

")" {
    column_counter += strlen(yytext);
    return R_PARENT;
}

"sen" {
    column_counter += strlen(yytext);
    return SEN;
}

"cos" {
    column_counter += strlen(yytext);
    return COS;
}

"tan" {
    column_counter += strlen(yytext);
    return TAN;
}

"abs" {
    column_counter += strlen(yytext);
    return ABS;
}

[a-z][a-z0-9]* {
    column_counter += strlen(yytext);
    return VAR;
}

[0-9]+ {
    column_counter += strlen(yytext);
    return NUM;
}

[0-9]+"."[0-9]+ {
    column_counter += strlen(yytext);
    return NUM;
}

"."[0-9]+ {
    column_counter += strlen(yytext);
    return NUM;
}

[0-9]+"." {
    column_counter += strlen(yytext);
    return NUM;
}

\n {
    column_counter = 1;
    return EOL;
}

[ \t] {
    column_counter += strlen(yytext);
}

. {
    column_counter++;
    printf("Caracter Misterioso: %c\n", *yytext);
    exit(0);
}

%%
