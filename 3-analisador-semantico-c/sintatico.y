%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include "hash_table.h"
    #include "ast.h"

    extern int yylex();
    extern char *yytext;
    void yyerror(ProgramNode *ast, char const *s);

    extern unsigned lineCounter;
    extern unsigned columnCounter;
    extern unsigned lineCounterId;

    extern unsigned columnFunction;

    extern char *lineError;

    // Para printar erro semântico em declaração de função e protótipo
    extern char *lineBlock;
    extern bool flgLineFunction;
    unsigned lineFunction = 0;

    extern bool hasSyntaxError;

    int type;
%}

%parse-param {ProgramNode *ast}

%union{
    TreeNode *ast;
    ExpressionNode *expressao;
    CommandNode *comando;
    FunctionNode *funcao;
    DeclarationNode *declaracao;
    int number;
    char *id;
}

%token VOID
%token INT
%token CHAR
%token RETURN
%token BREAK
%token SWITCH
%token CASE
%token DEFAULT
%token DO
%token WHILE
%token FOR
%token IF
%token ELSE
%token TYPEDEF
%token STRUCT
%token PLUS
%token MINUS
%token MULTIPLY
%token DIV
%token REMAINDER
%token INC
%token DEC
%token BITWISE_AND
%token BITWISE_OR
%token BITWISE_NOT
%token BITWISE_XOR
%token NOT
%token LOGICAL_AND
%token LOGICAL_OR
%token EQUAL
%token NOT_EQUAL
%token LESS_THAN
%token GREATER_THAN
%token LESS_EQUAL
%token GREATER_EQUAL
%token R_SHIFT
%token L_SHIFT
%token ASSIGN
%token ADD_ASSIGN
%token MINUS_ASSIGN
%token SEMICOLON
%token COMMA
%token COLON
%token L_PAREN
%token R_PAREN
%token L_CURLY_BRACKET
%token R_CURLY_BRACKET
%token L_SQUARE_BRACKET
%token R_SQUARE_BRACKET
%token TERNARY_CONDITIONAL
%token NUMBER_SIGN
%token POINTER
%token PRINTF
%token SCANF
%token DEFINE
%token EXIT
%token IDENTIFIER
%token NUM_INTEGER
%token NUM_OCTAL
%token NUM_HEXA
%token STRING
%token CHARACTER
%token EOL
%token EOP

%type <funcao> programa
%type <funcao> funcao
%type <comando> bloco
%type <comando> comandos
%type <comando> comandos_prime
%type <comando> lista_comandos
%type <comando> lista_comandos_if
%type <expressao> lista_comandos_exp
%type <expressao> lista_comandos_print
%type <expressao> expressao
%type <expressao> expressao_prime
%type <expressao> expressao_atribuicao
%type <number> expressao_atribuicao_prime
%type <expressao> expressao_condicional
%type <expressao> expressao_or_logico
%type <expressao> expressao_and_logico
%type <expressao> expressao_or
%type <expressao> expressao_xor
%type <expressao> expressao_and
%type <expressao> expressao_igualdade
%type <expressao> expressao_relacional
%type <expressao> expressao_shift
%type <expressao> expressao_aditiva
%type <expressao> expressao_multiplicativa
%type <expressao> expressao_cast
%type <expressao> expressao_unaria
%type <expressao> expressao_pos_fixa
%type <expressao> expressao_pos_fixa_prime
%type <expressao> expressao_pos_fixa_double_prime
%type <expressao> l_expressao_pos_fixa
%type <expressao> expressao_primaria
%type <expressao> numero
%type <id> IDENTIFIER

%type <declaracao> loop_variaveis
%type <declaracao> declaracao_prototipos
%type <declaracao> declaracao_variaveis_double_prime
%type <declaracao> declaracao_variaveis_prime
%type <declaracao> declaracao_variaveis
%type <declaracao> declaracoes
%type <number> tipo

%type <declaracao> parametros
%type <declaracao> parametros_prime
%type <declaracao> parametros_double_prime
%type <declaracao> opc_param

%type <number> loop_ponteiro

%start S

%%

S: programa EOP{
    ProgramNode *programa = (ProgramNode *) malloc(sizeof(struct program));
    programa->tabelaSimbolosGlobal = createHashTable(211);
    programa->listaFuncoes = $1;

    memcpy(ast, programa, sizeof(struct program));

    return 1;
}
;

//Programa
programa:
          declaracoes programa {
            FunctionNode *aux = (FunctionNode *) malloc(sizeof(struct function));

            aux->flgDeclaracao = 1;

            aux->declarations = $1;
            aux->parameters = NULL;

            aux->next = $2;
            $$ = aux;
        }
        | funcao programa      {
            $1->next = $2;
            $$ = $1;
        }
        |                      { $$ = NULL; }
;

//Declarações
declaracoes:
             NUMBER_SIGN DEFINE IDENTIFIER expressao {
                 DeclarationNode *aux = (DeclarationNode *) malloc(sizeof(struct declaration));
                 aux->tipo = S_DEFINE_DECL;
                 aux->nome = (char *) malloc(sizeof($3) + 1);
                 strcpy(aux->nome, $3);

                 aux->line = lineCounterId;
                 aux->linhaDeclaracao = (char *) malloc(sizeof(char) * strlen(lineError) + 1);
                 strcpy(aux->linhaDeclaracao, lineError);

                 aux->tipoDeclaracao = D_CONSTANTE;

                 aux->expressao = $4;
                 aux->next = NULL;
                 $$ = aux;
             }
           | declaracao_variaveis                    { $$ = $1; }
           | declaracao_prototipos                   { $$ = $1; }
;

//Função
funcao: tipo loop_ponteiro IDENTIFIER parametros L_CURLY_BRACKET loop_variaveis comandos R_CURLY_BRACKET {
    FunctionNode *aux = (FunctionNode *) malloc(sizeof(struct function));

    aux->flgDeclaracao = 0;

    aux->tipo = $1;

    aux->pointer = $2;

    aux->nome = (char *) malloc(sizeof($3) + 1);
    strcpy(aux->nome, $3);

    aux->tabelaSimbolos = createHashTable(211);

    aux->declarations = $6;
    aux->parameters = $4;

    aux->listaComandos = $7;

    aux->linhaDeclaracao = (char *) malloc(sizeof(char) * strlen(lineBlock) + 1);
    strcpy(aux->linhaDeclaracao, lineBlock);
    memset(lineBlock, 0, sizeof(lineBlock));

    aux->line = lineFunction;
    aux->column = columnFunction;

    aux->next = NULL;
    $$ = aux;
}
;

//Declaração de Variáveis
declaracao_variaveis: tipo declaracao_variaveis_prime SEMICOLON {
    DeclarationNode *declaracao = $2;
    while(declaracao != NULL) {
        declaracao->tipo = $1;
        declaracao = declaracao->next;
    }
    $$ = $2;
}
;

declaracao_variaveis_prime: loop_ponteiro IDENTIFIER loop_vetor opc_atribuicao declaracao_variaveis_double_prime {
    DeclarationNode *aux = (DeclarationNode *) malloc(sizeof(struct declaration));

    aux->pointer = $1;

    aux->nome = (char *) malloc(sizeof($2) + 1);
    strcpy(aux->nome, $2);

    aux->line = lineCounterId;
    aux->linhaDeclaracao = (char *) malloc(sizeof(char) * strlen(lineError) + 1);
    strcpy(aux->linhaDeclaracao, lineError);

    aux->tipoDeclaracao = D_VARIAVEL;

    aux->expressao = NULL;
    aux->next = $5;
    $$ = aux;
}
;

declaracao_variaveis_double_prime: COMMA declaracao_variaveis_prime { $$ = $2; }
                                 |                                  { $$ = NULL; }
;

//Declaração de Protótipos
declaracao_prototipos: tipo loop_ponteiro IDENTIFIER parametros SEMICOLON {
    DeclarationNode *aux = (DeclarationNode *) malloc(sizeof(struct declaration));

    aux->tipo = $1;

    aux->pointer = $2;

    aux->nome = (char *) malloc(sizeof($3) + 1);
    strcpy(aux->nome, $3);

    aux->parameters = $4;

    aux->line = lineCounterId;
    aux->linhaDeclaracao = (char *) malloc(sizeof(char) * strlen(lineError) + 1);
    strcpy(aux->linhaDeclaracao, lineError);

    aux->tipoDeclaracao = D_PROTOTIPO;

    aux->expressao = NULL;
    aux->next = NULL;
    $$ = aux;
}
;

//Parâmetros
parametros: L_PAREN opc_param R_PAREN {
    strcpy(lineBlock, lineError);
    flgLineFunction = true;
    lineFunction = lineCounter;
    $$ = $2;
}
;

parametros_prime: tipo loop_ponteiro IDENTIFIER opc_atribuicao parametros_double_prime {
    DeclarationNode *aux = (DeclarationNode *) malloc(sizeof(struct declaration));

    aux->tipo = $1;

    aux->pointer = $2;

    aux->nome = (char *) malloc(sizeof($3) + 1);
    strcpy(aux->nome, $3);

    aux->tipoDeclaracao = D_PARAMETRO;

    aux->line = lineCounterId;
    aux->linhaDeclaracao = (char *) malloc(sizeof(char) * strlen(lineError) + 1);
    strcpy(aux->linhaDeclaracao, lineError);

    aux->expressao = NULL;
    aux->next = $5;
    $$ = aux;
}
;

parametros_double_prime: COMMA parametros_prime { $$ = $2; }
                       |                        { $$ = NULL; }
;

opc_param: parametros_prime { $$ = $1; }
         |                  { $$ = NULL; }
;

//Tipo
tipo: INT       { $$ = S_INT; }
    | CHAR      { $$ = S_CHAR; }
    | VOID      { $$ = S_VOID; }
;

//Bloco
bloco: L_CURLY_BRACKET comandos R_CURLY_BRACKET { $$ = $2; }
;

//Comandos
comandos: lista_comandos comandos_prime {
    $1->next = $2;
    $$ = $1;
}
;

comandos_prime: comandos { $$ = $1; }
              |          { $$ = NULL; }
;

//Lista de Comandos
lista_comandos:
                DO bloco WHILE L_PAREN expressao R_PAREN SEMICOLON                                                               {
                    CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                    aux->commandType = S_DO;
                    aux->exp = $5;
                    aux->then = $2;
                    aux->next = NULL;
                    $$ = aux;
                }
              | IF L_PAREN expressao R_PAREN bloco lista_comandos_if                                                             {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = S_IF;
                  aux->exp = $3;
                  aux->then = $5;
                  aux->Else = $6;
                  aux->next = NULL;
                  $$ = aux;
              }
              | WHILE L_PAREN expressao R_PAREN bloco                                                                            {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = S_WHILE;
                  aux->exp = $3;
                  aux->then = $5;
                  aux->next = NULL;
                  $$ = aux;
              }
              | FOR L_PAREN lista_comandos_exp SEMICOLON lista_comandos_exp SEMICOLON lista_comandos_exp R_PAREN bloco           {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = S_FOR;
                  aux->exp = $3;
                  aux->exp2 = $5;
                  aux->exp3 = $7;
                  aux->then = $9;
                  aux->next = NULL;
                  $$ = aux;
              }
              | PRINTF L_PAREN STRING lista_comandos_print R_PAREN SEMICOLON                                                     {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = S_PRINTF;
                  aux->exp = $4;
                  aux->next = NULL;
                  $$ = aux;
              }
              | SCANF L_PAREN STRING COMMA BITWISE_AND IDENTIFIER R_PAREN SEMICOLON                                              {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = S_SCANF;
                  aux->next = NULL;
                  $$ = aux;
              }
              | EXIT L_PAREN expressao R_PAREN SEMICOLON                                                                         {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = S_EXIT;
                  aux->exp = $3;
                  aux->next = NULL;
                  $$ = aux;
              }
              | RETURN lista_comandos_exp SEMICOLON                                                                              {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = S_RETURN;
                  aux->exp = $2;
                  aux->next = NULL;
                  $$ = aux;
              }
              | expressao SEMICOLON                                                                                              {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = S_COMMAND_EXPRESSION;
                  aux->exp = $1;
                  aux->next = NULL;
                  $$ = aux;
              }
              | SEMICOLON                                                                                                        {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = S_SEMICOLON;
                  aux->next = NULL;
                  $$ = aux;
              }
              | bloco                                                                                                            {
                  $$ = $1;
              }
;

lista_comandos_if: ELSE bloco { $$ = $2; }
                 |            { $$ = NULL; }
;

lista_comandos_exp: expressao { $$ = $1; }
                  |           { $$ = NULL; }
;

lista_comandos_print: COMMA expressao { $$ = $2; }
                    |                 { $$ = NULL; }
;

//Expressão
expressao: expressao_atribuicao expressao_prime {
    ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
    aux->expType = S_EXP;
    aux->left = $1;
    aux->right = $2;
    $$ = aux;
}
;

expressao_prime: COMMA expressao { $$ = $2; }
               |                 { $$ = NULL; }
;

//Expressão de Atribuição
expressao_atribuicao: expressao_condicional                                            { $$ = $1; }
                    | expressao_unaria expressao_atribuicao_prime expressao_atribuicao {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = $2;
                        aux->left = $1;
                        aux->right = $3;
                        $$ = aux;
                    }
;

expressao_atribuicao_prime: ASSIGN       { $$ = S_ASSIGN; }
                          | ADD_ASSIGN   { $$ = S_ADD_ASSIGN; }
                          | MINUS_ASSIGN { $$ = S_MINUS_ASSIGN; }
;

//Experssão Condicional
expressao_condicional: expressao_or_logico                                                           { $$ = $1; }
                     | expressao_or_logico TERNARY_CONDITIONAL expressao COLON expressao_condicional {
                         ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                         aux->expType = S_TERNARY_CONDITIONAL;
                         aux->ternaryExpression = $1;
                         aux->left = $3;
                         aux->right = $5;
                         $$ = aux;
                     }
;

//Expressão OR Lógico
expressao_or_logico: expressao_and_logico                                { $$ = $1; }
                   | expressao_or_logico LOGICAL_OR expressao_and_logico {
                       ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                       aux->expType = S_LOGICAL_OR;
                       aux->left = $1;
                       aux->right = $3;
                       $$ = aux;
                   }
;

//Expressão AND Lógico
expressao_and_logico: expressao_or                                  { $$ = $1; }
                    | expressao_and_logico LOGICAL_AND expressao_or {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = S_LOGICAL_AND;
                        aux->left = $1;
                        aux->right = $3;
                        $$ = aux;
                    }
;

//Expressão OR
expressao_or: expressao_xor                         { $$ = $1; }
            | expressao_or BITWISE_OR expressao_xor {
                ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                aux->expType = S_BITWISE_OR;
                aux->left = $1;
                aux->right = $3;
                $$ = aux;
            }
;

//Expressão XOR
expressao_xor: expressao_and                           { $$ = $1; }
             | expressao_xor BITWISE_XOR expressao_and {
                 ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                 aux->expType = S_BITWISE_XOR;
                 aux->left = $1;
                 aux->right = $3;
                 $$ = aux;
             }
;

//Expressão AND
expressao_and: expressao_igualdade                           { $$ = $1; }
             | expressao_and BITWISE_AND expressao_igualdade {
                 ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                 aux->expType = S_BITWISE_AND;
                 aux->left = $1;
                 aux->right = $3;
                 $$ = aux;
             }
;

//Expressão de Igualdade
expressao_igualdade: expressao_relacional                               { $$ = $1; }
                   | expressao_igualdade EQUAL expressao_relacional     {
                       ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                       aux->expType = S_EQUAL;
                       aux->left = $1;
                       aux->right = $3;
                       $$ = aux;
                   }
                   | expressao_igualdade NOT_EQUAL expressao_relacional {
                       ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                       aux->expType = S_NOT_EQUAL;
                       aux->left = $1;
                       aux->right = $3;
                       $$ = aux;
                   }
;

//Expressão Relacional
expressao_relacional: expressao_shift                                    { $$ = $1; }
                    | expressao_relacional LESS_THAN expressao_shift     {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = S_LESS_THAN;
                        aux->left = $1;
                        aux->right = $3;
                        $$ = aux;
                    }
                    | expressao_relacional LESS_EQUAL expressao_shift    {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = S_LESS_EQUAL;
                        aux->left = $1;
                        aux->right = $3;
                        $$ = aux;
                    }
                    | expressao_relacional GREATER_THAN expressao_shift  {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = S_GREATER_THAN;
                        aux->left = $1;
                        aux->right = $3;
                        $$ = aux;
                    }
                    | expressao_relacional GREATER_EQUAL expressao_shift {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = S_GREATER_EQUAL;
                        aux->left = $1;
                        aux->right = $3;
                        $$ = aux;
                    }
;

//Expressão Shift
expressao_shift: expressao_aditiva                         { $$ = $1; }
               | expressao_shift L_SHIFT expressao_aditiva {
                   ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                   aux->expType = S_L_SHIFT;
                   aux->left = $1;
                   aux->right = $3;
                   $$ = aux;
               }
               | expressao_shift R_SHIFT expressao_aditiva {
                   ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                   aux->expType = S_R_SHIFT;
                   aux->left = $1;
                   aux->right = $3;
                   $$ = aux;
               }
;

//Expressão Aditiva
expressao_aditiva: expressao_multiplicativa                         { $$ = $1; }
                 | expressao_aditiva PLUS expressao_multiplicativa  {
                     ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                     aux->expType = S_PLUS;
                     aux->left = $1;
                     aux->right = $3;
                     $$ = aux;
                 }
                 | expressao_aditiva MINUS expressao_multiplicativa {
                     ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                     aux->expType = S_MINUS;
                     aux->left = $1;
                     aux->right = $3;
                     $$ = aux;
                 }
;

//Expressão Multiplicativa
expressao_multiplicativa: expressao_cast                                    { $$ = $1; }
                        | expressao_multiplicativa MULTIPLY expressao_cast  {
                            ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                            aux->expType = S_MULTIPLY;
                            aux->left = $1;
                            aux->right = $3;
                            $$ = aux;
                        }
                        | expressao_multiplicativa DIV expressao_cast       {
                            ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                            aux->expType = S_DIV;
                            aux->left = $1;
                            aux->right = $3;
                            $$ = aux;
                        }
                        | expressao_multiplicativa REMAINDER expressao_cast {
                            ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                            aux->expType = S_REMAINDER;
                            aux->left = $1;
                            aux->right = $3;
                            $$ = aux;
                        }
;

//Expressão Cast
expressao_cast: expressao_unaria                                  { $$ = $1; }
              | L_PAREN tipo loop_ponteiro R_PAREN expressao_cast { $$ = NULL; }
;

//Expressão Unária
expressao_unaria: expressao_pos_fixa         { $$ = $1; }
                | INC expressao_unaria       {
                    ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                    aux->expType = S_EXP_UN_INC;
                    aux->left = NULL;
                    aux->right = $2;
                    $$ = aux;
                }
                | DEC expressao_unaria       {
                    ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                    aux->expType = S_EXP_UN_DEC;
                    aux->left = NULL;
                    aux->right = $2;
                    $$ = aux;
                }
                | BITWISE_AND expressao_cast {
                    ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                    aux->expType = S_EXP_UN_BITWISE_AND;
                    aux->left = NULL;
                    aux->right = $2;
                    $$ = aux;
                }
                | MULTIPLY expressao_cast    {
                    ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                    aux->expType = S_EXP_UN_MULTIPLY;
                    aux->left = NULL;
                    aux->right = $2;
                    $$ = aux;
                }
                | PLUS expressao_cast        {
                    ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                    aux->expType = S_EXP_UN_PLUS;
                    aux->left = NULL;
                    aux->right = $2;
                    $$ = aux;
                }
                | MINUS expressao_cast       {
                    ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                    aux->expType = S_EXP_UN_MINUS;
                    aux->left = NULL;
                    aux->right = $2;
                    $$ = aux;
                }
                | BITWISE_NOT expressao_cast {
                    ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                    aux->expType = S_EXP_UN_BITWISE_NOT;
                    aux->left = NULL;
                    aux->right = $2;
                    $$ = aux;
                }
                | NOT expressao_cast         {
                    ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                    aux->expType = S_EXP_UN_NOT;
                    aux->left = NULL;
                    aux->right = $2;
                    $$ = aux;
                }
;

//Expressão Pós-Fixa
expressao_pos_fixa: expressao_primaria                          { $$ = $1; }
                  | expressao_pos_fixa expressao_pos_fixa_prime {
                      $2->left = $1;
                      $$ = $2;
                  }
;

expressao_pos_fixa_prime:
                          L_SQUARE_BRACKET expressao R_SQUARE_BRACKET {
                              ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                              aux->expType = S_EXP_POS_VECTOR;
                              aux->left = NULL;
                              aux->right = NULL;

                              aux->ternaryExpression = $2;

                              $$ = aux;
                          }
                        | INC {
                            ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                            aux->expType = S_EXP_POS_INC;
                            aux->left = NULL;
                            aux->right = NULL;
                            $$ = aux;
                        }
                        | DEC {
                            ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                            aux->expType = S_EXP_POS_DEC;
                            aux->left = NULL;
                            aux->right = NULL;
                            $$ = aux;
                        }
                        | L_PAREN expressao_pos_fixa_double_prime R_PAREN { 
                            ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                            aux->expType = S_EXP_POS;
                            aux->left = NULL;
                            aux->right = NULL;

                            aux->ternaryExpression = $2;
                            
                            $$ = aux;
                         }
;

expressao_pos_fixa_double_prime:
                                 expressao_atribuicao l_expressao_pos_fixa {
                                     $1->left = $2;
                                     $$ = $1;
                                 }
                               |                                           { $$ = NULL; }
;

l_expressao_pos_fixa:
                     COMMA expressao_atribuicao l_expressao_pos_fixa {
                         $2->left = $3;
                         $$ = $2;
                     }
                    |                                                { $$ = NULL; }
;

//Expressão Primária
expressao_primaria:
                  IDENTIFIER                {
                      ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                      aux->expType = S_IDENTIFIER;
                      aux->left = NULL;
                      aux->right = NULL;
                      $$ = aux;
                  }
                  | numero                    { $$ = $1; }
                  | CHARACTER                 {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = S_CHARACTER;
                        aux->left = NULL;
                        aux->right = NULL;
                        $$ = aux;
                  }
                  | STRING                    {
                         ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = S_STRING;
                        aux->left = NULL;
                        aux->right = NULL;
                        $$ = aux;
                  }
                  | L_PAREN expressao R_PAREN { $$ = $2; }
;

//Número
numero:
      NUM_INTEGER {
          ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
          aux->expType = S_NUM_INTEGER;
          aux->left = NULL;
          aux->right = NULL;
          $$ = aux;
      }
      | NUM_HEXA    {
            ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
            aux->expType = S_NUM_HEXA;
            aux->left = NULL;
            aux->right = NULL;
            $$ = aux;
      }
      | NUM_OCTAL   {
          ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
            aux->expType = S_NUM_OCTAL;
            aux->left = NULL;
            aux->right = NULL;
            $$ = aux;
      }
;

//Loops
loop_ponteiro: MULTIPLY loop_ponteiro { $$ = $2 + 1; }
             |                        { $$ = 0; }
;

loop_variaveis:
               declaracao_variaveis loop_variaveis {
                   $1->next = $2;
                   $$ = $1;
               }
             |                                      { $$ = NULL; }
;

loop_vetor: L_SQUARE_BRACKET expressao R_SQUARE_BRACKET loop_vetor {}
             |                                                     {}
;

//Opcionais
opc_atribuicao: ASSIGN expressao_atribuicao {}
              |                             {}
;

%%

void yyerror(ProgramNode *ast, char const *s) {
    hasSyntaxError = true;
    unsigned columnNumber = columnCounter - strlen(yytext);
    unsigned lineNumber = lineCounter;
    char strToken[8];
    int token;

    strcpy(strToken, yytext);

    if(yytext[0] != '\n' && yytext[0] != '\0') {
        while(true) {
            token = yylex();

            if(token == EOL || token == EOP) {
                break;
            }
        }  //Avança até a quebra de linha para pegar a linha completa onde ocorreu o erro
    }

    if(yytext[0] != '\0') {
        printf("error:syntax:%u:%u: %s\n", lineNumber, columnNumber, strToken);
    }
    else {
        printf("error:syntax:%u:%u: expected declaration or statement at end of input\n", lineNumber, columnNumber);
    }
    printf("%s\n", lineError);
    for(int i = 0; i < columnNumber - 1; i++) {
        printf(" ");
    }
    printf("^");

    exit(1);
}
