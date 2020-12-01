%{
    #include <stdio.h>
    #include <stdbool.h>
    #include <string.h>
    #include "dcmat.h"
    #include "arvore.h"
    
    extern int yylex();
    extern char *yytext;
    void yyerror(char const *s);

    bool first = true;

    extern unsigned columnCounter;

    bool hasError = false;
    extern bool hasLexicalError;
    char strError[50];

    extern char *wrongChars;
    extern int wrongCharsCount;

    extern bool endOfProgram;

    TreeNode *ARVORE = NULL;

    int mLines = 0;
    int mColumns = 0;
    int mColumnsCounter = 1;

    double m[10][10] = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    };
%}

%union{
    TreeNode *arvore;
    double number;
}

%token ADD
%token SUB
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
//%token SIGNAL_NUMBER
%token VAR
%token EOL
%token ERROR

%token SHOW_SETTINGS
%token RESET_SETTINGS
%token QUIT
%token SET_H_VIEW
%token SET_V_VIEW
%token SET_AXIS_ON
%token SET_AXIS_OFF
%token MATRIX
%token SHOW_MATRIX
%token SOLVE_DETERMINANT;
%token ABOUT

%token COLON
%token SEMICOLON
%token L_BRACKET
%token R_BRACKET
%token COMMA

%type <arvore> calclist
%type <arvore> exp
%type <arvore> factor
%type <arvore> term
%type <arvore> signal
%type <number> NUM
//%type <number> SIGNAL_NUMBER

%start calclist

%%

calclist: exp EOL {
    ARVORE = $1;

    if(ARVORE) {
        printf("\nFunction in RPN format:\n\n");
        rpnWalk(ARVORE);
        printf("\n\n");
        deleteTree(ARVORE);
    } else {
        printf("ARVORE is NULL\n");
    }

    return 1;
}
        | SHOW_SETTINGS SEMICOLON EOL            { showSettings(); return 1; }
        | RESET_SETTINGS SEMICOLON EOL           { resetSettings(); return 1; }
        | SET_H_VIEW NUM COLON NUM SEMICOLON EOL { setHView($2, $4); return 1; }
        | SET_V_VIEW NUM COLON NUM SEMICOLON EOL { setVView($2, $4); return 1; }
        | SET_AXIS_ON SEMICOLON EOL              { setAxis(true); return 1; }
        | SET_AXIS_OFF SEMICOLON EOL             { setAxis(false); return 1; }
        | MATRIX L_BRACKET matrix R_BRACKET SEMICOLON EOL {
            saveMatrix(m, mLines, mColumns);

            mLines = 0;
            mColumns = 0;
            mColumnsCounter = 1;

            memset(m, 0, 10 * 10 * sizeof(double));

            return 1;
        }
        | SHOW_MATRIX SEMICOLON EOL              { showMatrix(); return 1; }
        | SOLVE_DETERMINANT SEMICOLON EOL        { solveDeterminant(); return 1; }
        | ABOUT SEMICOLON EOL                    { about(); return 1; }
        | ERROR EOL { return 1; }
;

matrix
    : matrix_prime matrix_double_prime {}
;

matrix_prime
    : L_BRACKET signal NUM matrix_elements R_BRACKET {
        if($2 != NULL && $2->nodeType == SUB) {
            m[mLines - 1][0] = -$3;
        } else {
            m[mLines - 1][0] = $3;
        }

        if(mColumns < mColumnsCounter) {
            mColumns = mColumnsCounter;
        }

        mColumnsCounter = 1;
    }
;

matrix_elements
    : matrix_elements COMMA signal NUM {
        if($3 != NULL && $3->nodeType == SUB) {
            m[mLines - 1][mColumnsCounter] = -$4;
        } else {
            m[mLines - 1][mColumnsCounter] = $4;
        }

        mColumnsCounter++;
    }
    | %empty {
        mLines++;
    }
;

matrix_double_prime
    : COMMA matrix {}
    | %empty {}

exp
    : factor         {
        $$ = $1;
    }
    | exp ADD factor {
        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = ADD;
        aux->left = $1;
        aux->right = $3;
        $$ = aux;
    }
    | exp SUB factor {
        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = SUB;
        aux->left = $1;
        aux->right = $3;
        $$ = aux;
    }
;

factor
    : signal term {
        if($1 != NULL && $1->nodeType == SUB) {
            $2->value = -$2->value;
        }
        $$ = $2;
    }
    | factor MUL signal term {
        if($3 != NULL && $3->nodeType == SUB) {
            $4->value = -$4->value;
        }

        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = MUL;
        aux->left = $1;
        aux ->right = $4;
        $$ = aux;
    }
    | factor DIV signal term {
        if($3 != NULL && $3->nodeType == SUB) {
            $4->value = $4->value;
        }

        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = DIV;
        aux->left = $1;
        aux ->right = $4;
        $$ = aux;
    }
    | factor POWER term {
        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = POWER;
        aux->left = $1;
        aux ->right = $3;
        $$ = aux;
    }
    | factor MODULE signal term {
        if($3 != NULL && $3->nodeType == SUB) {
            $4->value = -$4->value;
        }

        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = MODULE;
        aux->left = $1;
        aux ->right = $4;
        $$ = aux;
    }
;

term
    : NUM {
        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = NUM;
        aux->value = (double) $1;
        aux->left = NULL;
        aux->right = NULL;
        $$ = (TreeNode *) aux;
    }
    | VAR {
        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = VAR;
        aux->value = 1;
        aux->left = NULL;
        aux->right = NULL;
        $$ = aux;
    }
    | L_PARENT exp R_PARENT {
        $$ = $2;
    }
    | SEN L_PARENT exp R_PARENT {
        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = SEN;
        aux->value = 1;
        aux->left = NULL;
        aux->right = $3;
        $$ = aux;
    }
    | COS L_PARENT exp R_PARENT {
        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = COS;
        aux->value = 1;
        aux->left = NULL;
        aux->right = $3;
        $$ = aux;
    }
    | TAN L_PARENT exp R_PARENT {
        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = TAN;
        aux->value = 1;
        aux->left = NULL;
        aux->right = $3;
        $$ = aux;
    }
    | ABS L_PARENT exp R_PARENT {
        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = ABS;
        aux->value = 1;
        aux->left = NULL;
        aux->right = $3;
        $$ = aux;
    }
;

signal
    : ADD {
        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = ADD;
        aux->value = 0;
        aux->left = NULL;
        aux->right = NULL;
        $$ = aux;
    }
    | SUB {
        TreeNode *aux = (TreeNode *) malloc(sizeof(struct node));
        aux->nodeType = SUB;
        aux->value = 0;
        aux->left = NULL;
        aux->right = NULL;
        $$ = aux;
    }
    | %empty {
        $$ = NULL;
    }
;

%%

void yyerror(char const *s) {
    if(!hasError && !hasLexicalError) {
        unsigned columnNumber = columnCounter - strlen(yytext);

        if(yytext[0] != '\n' && yytext[0] != '\0') {
            sprintf(strError, "Erro de sintaxe na coluna [%u]: %s", columnNumber, yytext);
        }
        else {
            sprintf(strError, "A expressao terminou de forma inesperada.");
        }

        hasError = true;
    }
}