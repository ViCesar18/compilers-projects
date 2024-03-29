%{
    #include <stdio.h>
    #include <stdbool.h>
    #include <string.h>
    #include "dcmat.h"
    #include "arvore.h"
    
    extern int yylex();
    extern char *yytext;
    void yyerror(char const *s);

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
%token VAR
%token EOL
%token ERROR

%token SHOW
%token SETTINGS
%token RESET
%token QUIT
%token SET
%token H_VIEW
%token V_VIEW
%token AXIS
%token ON
%token OFF
%token PLOT
%token INTEGRAL_STEPS
%token INTEGRATE
%token MATRIX
%token SOLVE
%token DETERMINANT
%token LINEAR_SYSTEM
%token ABOUT

%token COLON
%token SEMICOLON
%token ASSIGN
%token L_BRACKET
%token R_BRACKET
%token COMMA

%type <arvore> calclist
%type <arvore> exp
%type <arvore> factor
%type <arvore> term
%type <arvore> signal
%type <number> NUM

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
        | SHOW SETTINGS SEMICOLON EOL                             { showSettings(); return 1; }
        | RESET SETTINGS SEMICOLON EOL                            { resetSettings(); return 1; }
        | QUIT EOL                                                { return 0; }
        | SET H_VIEW signal NUM COLON signal NUM SEMICOLON EOL    {
            double low, high;

            if($3 != NULL && $3->nodeType == SUB) {
                low = -$4;
            } else {
                low = $4;
            }

            if($6 != NULL && $6->nodeType == SUB) {
                high = -$7;
            } else {
                high = $7;
            }

            setHView(low, high);
            
            return 1;
        }
        | SET V_VIEW signal NUM COLON signal NUM SEMICOLON EOL    {
            double low, high;

            if($3 != NULL && $3->nodeType == SUB) {
                low = -$4;
            } else {
                low = $4;
            }

            if($6 != NULL && $6->nodeType == SUB) {
                high = -$7;
            } else {
                high = $7;
            }

            setVView(low, high);

            return 1;
        }
        | SET AXIS ON SEMICOLON EOL                               { setAxis(true); return 1; }
        | SET AXIS OFF SEMICOLON EOL                              { setAxis(false); return 1; }
        | PLOT SEMICOLON EOL                                      { plot(); return 1; }
        | PLOT L_PARENT exp R_PARENT SEMICOLON EOL                { plotExpression($3); return 1; }
        | SET INTEGRAL_STEPS signal NUM SEMICOLON EOL   {
            if($3 != NULL && $3->nodeType == SUB) {
                setIntegralSteps((int) -$4);
            } else {
                setIntegralSteps((int) $4);
            }

            return 1;
        }
        | INTEGRATE L_PARENT signal NUM COLON signal NUM COMMA exp R_PARENT SEMICOLON EOL {
            double limiteInferior, limiteSuperior;

            if($3 != NULL && $3->nodeType == SUB) {
                limiteInferior = -$4;
            } else {
                limiteInferior = $4;
            }

            if($6 != NULL && $6->nodeType == SUB) {
                limiteSuperior = -$7;
            } else {
                limiteSuperior = $7;
            }

            integrate($9, limiteInferior, limiteSuperior);

            return 1;
        }
        | MATRIX ASSIGN L_BRACKET matrix R_BRACKET SEMICOLON EOL {
            saveMatrix(m, mLines, mColumns);

            mLines = 0;
            mColumns = 0;
            mColumnsCounter = 1;

            memset(m, 0, 10 * 10 * sizeof(double));

            return 1;
        }
        | SHOW MATRIX SEMICOLON EOL              { showMatrix(); return 1; }
        | SOLVE DETERMINANT SEMICOLON EOL        { solveDeterminant(); return 1; }
        | SOLVE LINEAR_SYSTEM SEMICOLON EOL      { solveLinearSystem(); return 1; }
        | ABOUT SEMICOLON EOL                    { about(); return 1; }
        | ERROR EOL                              { return 1; }
        | EOL                                    { return 1; }
;

matrix
    : matrix_prime matrix_double_prime {}
;

matrix_prime
    : L_BRACKET signal NUM matrix_elements R_BRACKET {
        if(mLines - 1 < 10) {
            if($2 != NULL && $2->nodeType == SUB) {
                m[mLines - 1][0] = -$3;
            } else {
                m[mLines - 1][0] = $3;
            }
        }

        if(mColumns < mColumnsCounter) {
            mColumns = mColumnsCounter;
        }

        mColumnsCounter = 1;
    }
;

matrix_elements
    : matrix_elements COMMA signal NUM {
        if(mLines - 1 < 10 && mColumnsCounter < 10) {
            if($3 != NULL && $3->nodeType == SUB) {
                m[mLines - 1][mColumnsCounter] = -$4;
            } else {
                m[mLines - 1][mColumnsCounter] = $4;
            }
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
    if(!strcmp(yytext, "\n")) {
        printf("Erro de Sintaxe: Comando Incompleto\n\n");
    } else {
        printf("Erro de Sintaxe: [%s]\n\n", yytext);
        
        while(yylex() != EOL);
    }

    mLines = 0;
    mColumns = 0;
    mColumnsCounter = 1;

    memset(m, 0, 10 * 10 * sizeof(double));
}