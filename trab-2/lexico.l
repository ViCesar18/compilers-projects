%option noyywrap

%{
    #include "arvore.h"
    #include "sintatico.tab.h"
%}

%%

"show settings" { return SHOW_SETTINGS; }

"reset settings" { return RESET_SETTINGS; }

"quit" { return QUIT; }

"set h_view" { return SET_H_VIEW; }

"set v_view" { return SET_V_VIEW; }

"set axis on" { return SET_AXIS_ON; }

"set axis off" { return SET_AXIS_OFF; }

"plot" { return PLOT; }

"set integral_steps" { return SET_INTEGRAL_STEPS; }

"integrate" { return INTEGRATE; }

"matrix = " { return MATRIX; }

"show matrix" { return SHOW_MATRIX; }

"solve determinant" { return SOLVE_DETERMINANT; }

"solve linear_system" { return SOLVE_LINEAR_SYSTEM; }

"about" { return ABOUT; }

":" { return COLON; }

";" { return SEMICOLON; }

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

[ \t] {}

. {
    printf("Simbolo Invalido -> %c\n\n", yytext[0]);

    return ERROR;
}

%%
