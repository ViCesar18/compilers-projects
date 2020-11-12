%option noyywrap

%{
    #include "sintatico.tab.h"
    #include "stdbool.h"

    int column_counter = 0;

    int end_of_program = 0;

    char *wrong_chars;

    int wrong_chars_count = 0;

    bool lexical_error = false;
%}

%%

"+" {
    column_counter += strlen(yytext);
    return ADD;
}

"-" {
    column_counter += strlen(yytext);
    return SUB;
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
    //printf("Erro de sintaxe na coluna [%d]: %c\n", column_counter, yytext[0]);

    wrong_chars[wrong_chars_count] = yytext[0];
    wrong_chars_count++;

    lexical_error = true;
}

<<EOF>> {
    end_of_program = 1;
    return EOL;
}

%%
