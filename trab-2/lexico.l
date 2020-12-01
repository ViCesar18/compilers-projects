%option noyywrap

%{
    #include <stdbool.h>
    #include "arvore.h"
    #include "sintatico.tab.h"

    unsigned columnCounter = 1;

    char *wrongChars;
    int wrongCharsCount = 0;

    bool hasLexicalError = false;

    bool endOfProgram = false;
%}

%%

"show settings" { return SHOW_SETTINGS; }

"reset settings" { return RESET_SETTINGS; }

"quit" { return QUIT; }

"set h_view" { return SET_H_VIEW; }

"set v_view" { return SET_V_VIEW; }

"set axis on" { return SET_AXIS_ON; }

"set axis off" { return SET_AXIS_OFF; }

"matrix = " { return MATRIX; }

"show matrix" { return SHOW_MATRIX; }

"solve determinant" { return SOLVE_DETERMINANT; }

"about" { return ABOUT; }

":" { return COLON; }

";" { return SEMICOLON; }

"[" { return L_BRACKET; }

"]" { return R_BRACKET; }

"," { return COMMA; }

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

"x" {
    columnCounter += strlen(yytext);
    return VAR;
}

[0-9]+ {
    columnCounter += strlen(yytext);

    yylval.number = atof(yytext);

    return NUM;
}

[0-9]+"."[0-9]+ {
    columnCounter += strlen(yytext);

    yylval.number = atof(yytext);

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

    printf("Simbolo Invalido -> %c\n\n", yytext[0]);

    hasLexicalError = true;

    return ERROR;
}

<<EOF>> {
    endOfProgram = true;
    return EOL;
}

%%
