%option noyywrap

%{
    #include "sintatico.tab.h"
%}

%%

"int" {
    return INT;
}

"float" {
    return FLOAT;
}

"char" {
    return CHAR;
}

"," {
    return COMMA;
}

"$" {
    return EOL;
}

[a-z]+ {
    return ID;
}

[ \t\n] {  }

. {
    printf("Simbolo Invalido -> %c\n\n", yytext[0]);

    return ERROR;
}

%%
