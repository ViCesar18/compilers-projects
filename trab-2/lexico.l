%option noyywrap

%{
    #include "arvore.h"
    #include "sintatico.tab.h"
%}

%%

"show" { return SHOW; }

"settings" { return SETTINGS; }

"reset" { return RESET; }

"quit" { return QUIT; }

"set" { return SET; }

"h_view" { return H_VIEW; }

"v_view" { return V_VIEW; }

"axis" { return AXIS; }

"on" { return ON; }

"off" { return OFF; }

"plot" { return PLOT; }

"integral_steps" { return INTEGRAL_STEPS; }

"integrate" { return INTEGRATE; }

"matrix" { return MATRIX; }

"solve" { return SOLVE; }

"determinant" { return DETERMINANT; }

"linear_system" { return LINEAR_SYSTEM; }

"about" { return ABOUT; }

":" { return COLON; }

";" { return SEMICOLON; }

"=" { return ASSIGN; }

"[" { return L_BRACKET; }

"]" { return R_BRACKET; }

"," { return COMMA; }

"+" { return ADD; }

"-" { return SUB; }

"*" { return MUL; }

"/" { return DIV; }

"^" { return POWER; }

"%" { return MODULE; }

"(" { return L_PARENT; }

")" { return R_PARENT; }

"sen" { return SEN; }

"cos" { return COS; }

"tan" { return TAN; }

"abs" { return ABS; }

"x" { return VAR; }

[0-9]+ {
    yylval.number = atof(yytext);

    return NUM;
}

[0-9]+"."[0-9]+ {
    yylval.number = atof(yytext);

    return NUM;
}

\n { return EOL; }

[ \t] {  }

. {
    printf("Simbolo Invalido -> %c\n\n", yytext[0]);

    return ERROR;
}

%%
