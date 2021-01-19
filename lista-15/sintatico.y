%{
    #include <stdio.h>
    #include <stdbool.h>
    #include <string.h>
    #include <stdbool.h>
    #include "hash_table.h"
    
    extern int yylex();
    extern char *yytext;
    void yyerror(char const *s);

    extern int currentLine;

    int type = -1;
    HashTableImp hash = NULL;

    bool error = false;
    bool first = true;
%}

%token INT
%token FLOAT
%token CHAR
%token ID
%token COMMA
%token EOL
%token ERROR

%start s

%%

s: d d_prime EOL {
    if(!error) {
        if(first) {
            printf("%d: All Identifiers on Hash.", currentLine + 1);
            first = false;
        }
        else {
            printf("\n%d: All Identifiers on Hash.", currentLine + 1);
        }
    }

    error = false;

    return 1;
}
;

d_prime: d d_prime {}
       |           {}
;

d: t i {}
;

t: INT   {
    type = INT;
}
 | FLOAT {
     type = FLOAT;
 }
 | CHAR  {
     type = CHAR;
 }
;

i: ID         {
    if(hash == NULL) {
        hash = createHashTable(211);
    }

    int exist = existInHashTable(hash, type, yytext);
    
    if(exist == -1) {
        insertHashTable(hash, type, yytext);
    }
    else {
        error = true;

        if(exist == type) {
            if(first) {
                printf("%d: identifier '%s' already declared", currentLine + 1, yytext);
                first = false;
            }
            else {
                printf("\n%d: identifier '%s' already declared", currentLine + 1, yytext);
            }
        }
        else {
            if(first) {
                printf("%d: redefinition of identifier '%s'", currentLine + 1, yytext);
                first = false;
            }
            else {
                printf("\n%d: redefinition of identifier '%s'", currentLine + 1, yytext);
            }
        }
    }
}
 | i COMMA ID {
    if(hash == NULL) {
        hash = createHashTable(211);
    }

    int exist = existInHashTable(hash, type, yytext);

    if(exist == -1) {
        insertHashTable(hash, type, yytext);
    }
    else {
        error = true;

        if(exist == type) {
            if(first) {
                printf("%d: identifier '%s' already declared", currentLine + 1, yytext);
                first = false;
            }
            else {
                printf("\n%d: identifier '%s' already declared", currentLine + 1, yytext);
            }
        }
        else {
            if(first) {
                printf("%d: redefinition of identifier '%s'", currentLine + 1, yytext);
                first = false;
            }
            else {
                printf("\n%d: redefinition of identifier '%s'", currentLine + 1, yytext);
            }
        }
    }
 }
;

%%

void yyerror(char const *s) {
    if(!strcmp(yytext, "\n")) {
        printf("Erro de Sintaxe: Comando Incompleto\n\n");
    } else {
        printf("Erro de Sintaxe: [%s]\n\n", yytext);
        
        while(yylex() != EOL);
    }
}