%option noyywrap

%{
    #include "sintatico.tab.h"
    #include <stdbool.h>

    unsigned columnCounter = 1;

    char *wrongChars;
    int wrongCharsCount = 0;

    bool hasLexicalError = false;

    bool endOfProgram = false;
%}

%%

"+" {
    columnCounter += strlen(yytext);
    return ADD;
}

"-" {
    columnCounter += strlen(yytext);
    return SUB;
}

"*" {
    columnCounter += strlen(yytext);
    return MUL;
}

"/" {
    columnCounter += strlen(yytext);
    return DIV;
}

"^" {
    columnCounter += strlen(yytext);
    return POWER;
}

"%" {
    columnCounter += strlen(yytext);
    return MODULE;
}

"(" {
    columnCounter += strlen(yytext);
    return L_PARENT;
}

")" {
    columnCounter += strlen(yytext);
    return R_PARENT;
}

"sen" {
    columnCounter += strlen(yytext);
    return SEN;
}

"cos" {
    columnCounter += strlen(yytext);
    return COS;
}

"tan" {
    columnCounter += strlen(yytext);
    return TAN;
}

"abs" {
    columnCounter += strlen(yytext);
    return ABS;
}

[a-z][a-z0-9]* {
    columnCounter += strlen(yytext);
    return VAR;
}

[0-9]+ {
    columnCounter += strlen(yytext);
    return NUM;
}

[0-9]+"."[0-9]+ {
    columnCounter += strlen(yytext);
    return NUM;
}

"."[0-9]+ {
    columnCounter += strlen(yytext);
    return NUM;
}

[0-9]+"." {
    columnCounter += strlen(yytext);
    return NUM;
}

\n {
    columnCounter = 1;
    return EOL;
}

[ \t] {
    columnCounter += strlen(yytext);
}

. {
    columnCounter++;
    //printf("Erro de sintaxe na coluna [%d]: %c\n", columnCounter, yytext[0]);

    wrongChars[wrongCharsCount] = yytext[0];
    wrongCharsCount++;

    hasLexicalError = true;
}

<<EOF>> {
    endOfProgram = true;
    return EOL;
}

%%
