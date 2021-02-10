%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include "ast.h"
    #include "hash_table.h"

    extern int yylex();
    extern char *yytext;
    void yyerror(char const *s);

    extern unsigned lineCounter;
    extern unsigned columnCounter;

    extern char *lineError;

    extern bool hasSyntaxError;
%}

%union{
    TreeNode *ast;
    ExpressionNode expressao;
    CommandNode comando;
    FunctionNode funcao;
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
%type <expressao> expressao_primaria
%type <expressao> numero
%type <id> IDENTIFIER

%start S

%%

S: programa EOP{
    ProgramNode *programa = (ProgramNode *) malloc(sizeof(struct program));
    programa->tabelaSimbolosGlobal = createHashTable(211);
    programa->listaFuncoes = $1;

    return programa;
}
;

//Programa
programa:
          declaracoes programa {
            $1->next = $2;
            $$ = $1;
        }
        | funcao programa      {
            $1->next = $2;
            $$ = $1;
        }
        |                      { $$ = NULL; }
;

//Declarações
declaracoes: NUMBER_SIGN DEFINE IDENTIFIER expressao {}
           | declaracao_variaveis                    {}
           | declaracao_prototipos                   {}
;

//Função
funcao: tipo loop_ponteiro IDENTIFIER parametros L_CURLY_BRACKET loop_variaveis comandos R_CURLY_BRACKET {
    FunctionNode *aux = (FunctionNode *) malloc(sizeof(struct function));
    aux->nome = (char *) malloc(sizeof($3) + 1);
    strcpy(aux->nome, $3);

    aux->tabelaSimbolos = HashTable(211);

    aux->listaComandos = $7;

    aux->next = NULL;
    $$ = aux;
}
;

//Declaração de Variáveis
declaracao_variaveis: tipo declaracao_variaveis_prime SEMICOLON {}
;

declaracao_variaveis_prime: loop_ponteiro IDENTIFIER loop_vetor opc_atribuicao declaracao_variaveis_double_prime {}
;

declaracao_variaveis_double_prime: COMMA declaracao_variaveis_prime {}
                                 |                                  {}
;

//Declaração de Protótipos
declaracao_prototipos: tipo loop_ponteiro IDENTIFIER parametros SEMICOLON {}
;

//Parâmetros
parametros: L_PAREN opc_param R_PAREN {}
;

parametros_prime: tipo loop_ponteiro IDENTIFIER opc_atribuicao parametros_double_prime {}
;

parametros_double_prime: COMMA parametros_prime {}
                       |                        {}
;

opc_param: parametros_prime {}
         |                  {}
;

//Tipo
tipo: INT       {}
    | CHAR      {}
    | VOID      {}
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
                    aux->commandType = DO;
                    aux->exp = $5;
                    aux->then = $2;
                    aux->next = NULL;
                    $$ = aux;
                }
              | IF L_PAREN expressao R_PAREN bloco lista_comandos_if                                                             {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = IF;
                  aux->exp = $3;
                  aux->then = $5;
                  aux->else = $6;
                  aux->next = NULL;
                  $$ = aux;
              }
              | WHILE L_PAREN expressao R_PAREN bloco                                                                            {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = WHILE;
                  aux->exp = $3;
                  aux->then = $5;
                  aux->next = NULL;
                  $$ = aux;
              }
              | FOR L_PAREN lista_comandos_exp SEMICOLON lista_comandos_exp SEMICOLON lista_comandos_exp R_PAREN bloco           {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = FOR;
                  aux->exp = $3;
                  aux->exp2 = $5;
                  aux->exp3 = $7;
                  aux->then = $9;
                  aux->next = NULL;
                  $$ = aux;
              }
              | PRINTF L_PAREN STRING lista_comandos_print R_PAREN SEMICOLON                                                     {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = PRINTF;
                  aux->exp = $3;
                  aux->next = NULL;
                  $$ = aux;
              }
              | SCANF L_PAREN STRING COMMA BITWISE_AND IDENTIFIER R_PAREN SEMICOLON                                              {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = SCANF;
                  aux->next = NULL;
                  $$ = aux;
              }
              | EXIT L_PAREN expressao R_PAREN SEMICOLON                                                                         {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = EXIT;
                  aux->exp = $3;
                  aux->next = NULL;
                  $$ = aux;
              }
              | RETURN lista_comandos_exp SEMICOLON                                                                              {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = RETURN;
                  aux->exp = $3;
                  aux->next = NULL;
                  $$ = aux;
              }
              | expressao SEMICOLON                                                                                              {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = EXPRESSAO;
                  aux->exp = $1;
                  aux->next = NULL;
                  $$ = aux;
              }
              | SEMICOLON                                                                                                        {
                  CommandNode *aux = (CommandNode *) malloc(sizeof(struct command));
                  aux->commandType = SEMICOLON;
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
    aux->expType = COMMA;
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

expressao_atribuicao_prime: ASSIGN       { $$ = $1; }
                          | ADD_ASSIGN   { $$ = $1; }
                          | MINUS_ASSIGN { $$ = $1; }
;

//Experssão Condicional
expressao_condicional: expressao_or_logico                                                           { $$ = $1; }
                     | expressao_or_logico TERNARY_CONDITIONAL expressao COLON expressao_condicional {
                         ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                         aux->expType = TERNARY_CONDITIONAL;
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
                       aux->expType = LOGICAL_OR;
                       aux->left = $1;
                       aux->right = $3;
                       $$ = aux;
                   }
;

//Expressão AND Lógico
expressao_and_logico: expressao_or                                  { $$ = $1; }
                    | expressao_and_logico LOGICAL_AND expressao_or {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = LOGICAL_AND;
                        aux->left = $1;
                        aux->right = $3;
                        $$ = aux;
                    }
;

//Expressão OR
expressao_or: expressao_xor                         { $$ = $1; }
            | expressao_or BITWISE_OR expressao_xor {
                ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                aux->expType = BITWISE_OR;
                aux->left = $1;
                aux->right = $3;
                $$ = aux;
            }
;

//Expressão XOR
expressao_xor: expressao_and                           { $$ = $1; }
             | expressao_xor BITWISE_XOR expressao_and {
                 ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                 aux->expType = BITWISE_XOR;
                 aux->left = $1;
                 aux->right = $3;
                 $$ = aux;
             }
;

//Expressão AND
expressao_and: expressao_igualdade                           { $$ = $1; }
             | expressao_and BITWISE_AND expressao_igualdade {
                 ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                 aux->expType = BITWISE_AND;
                 aux->left = $1;
                 aux->right = $3;
                 $$ = aux;
             }
;

//Expressão de Igualdade
expressao_igualdade: expressao_relacional                               { $$ = $1; }
                   | expressao_igualdade EQUAL expressao_relacional     {
                       ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                       aux->expType = EQUAL;
                       aux->left = $1;
                       aux->right = $3;
                       $$ = aux;
                   }
                   | expressao_igualdade NOT_EQUAL expressao_relacional {
                       ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                       aux->expType = NOT_EQUAL;
                       aux->left = $1;
                       aux->right = $3;
                       $$ = aux;
                   }
;

//Expressão Relacional
expressao_relacional: expressao_shift                                    { $$ = $1; }
                    | expressao_relacional LESS_THAN expressao_shift     {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = LESS_THAN;
                        aux->left = $1;
                        aux->right = $3;
                        $$ = aux;
                    }
                    | expressao_relacional LESS_EQUAL expressao_shift    {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = LESS_EQUAL;
                        aux->left = $1;
                        aux->right = $3;
                        $$ = aux;
                    }
                    | expressao_relacional GREATER_THAN expressao_shift  {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = GREATER_THAN;
                        aux->left = $1;
                        aux->right = $3;
                        $$ = aux;
                    }
                    | expressao_relacional GREATER_EQUAL expressao_shift {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = GREATER_EQUAL;
                        aux->left = $1;
                        aux->right = $3;
                        $$ = aux;
                    }
;

//Expressão Shift
expressao_shift: expressao_aditiva                         { $$ = $1; }
               | expressao_shift L_SHIFT expressao_aditiva {
                   ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                   aux->expType = MULTIPLICACAO;
                   aux->left = $1;
                   aux->right = $3;
                   $$ = aux;
               }
               | expressao_shift R_SHIFT expressao_aditiva {}
;

//Expressão Aditiva
expressao_aditiva: expressao_multiplicativa                         { $$ = $1; }
                 | expressao_aditiva PLUS expressao_multiplicativa  {
                     ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                     aux->expType = PLUS;
                     aux->left = $1;
                     aux->right = $3;
                     $$ = aux;
                 }
                 | expressao_aditiva MINUS expressao_multiplicativa {
                     ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                     aux->expType = MINUS;
                     aux->left = $1;
                     aux->right = $3;
                     $$ = aux;
                 }
;

//Expressão Multiplicativa
expressao_multiplicativa: expressao_cast                                    { $$ = $1; }
                        | expressao_multiplicativa MULTIPLY expressao_cast  {
                            ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                            aux->expType = MULTIPLY;
                            aux->left = $1;
                            aux->right = $3;
                            $$ = aux;
                        }
                        | expressao_multiplicativa DIV expressao_cast       {
                            ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                            aux->expType = DIV;
                            aux->left = $1;
                            aux->right = $3;
                            $$ = aux;
                        }
                        | expressao_multiplicativa REMAINDER expressao_cast {
                            ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                            aux->expType = REMAINDER;
                            aux->left = $1;
                            aux->right = $3;
                            $$ = aux;
                        }
;

//Expressão Cast
expressao_cast: expressao_unaria                                  {}
              | L_PAREN tipo loop_ponteiro R_PAREN expressao_cast {}
;

//Expressão Unária
expressao_unaria: expressao_pos_fixa         {}
                | INC expressao_unaria       {}
                | DEC expressao_unaria       {}
                | BITWISE_AND expressao_cast {}
                | MULTIPLY expressao_cast    {}
                | PLUS expressao_cast        {}
                | MINUS expressao_cast       {}
                | BITWISE_NOT expressao_cast {}
                | NOT expressao_cast         {}
;

//Expressão Pós-Fixa
expressao_pos_fixa: expressao_primaria {}
                  | expressao_pos_fixa expressao_pos_fixa_prime {}
;

expressao_pos_fixa_prime: L_SQUARE_BRACKET expressao R_SQUARE_BRACKET {}
                        | INC {}
                        | DEC {}
                        | L_PAREN expressao_pos_fixa_double_prime R_PAREN {}
;

expressao_pos_fixa_double_prime: expressao_atribuicao l_expressao_pos_fixa {}
                               |                                           {}
;

l_expressao_pos_fixa: COMMA expressao_atribuicao l_expressao_pos_fixa {}
                    |                                                 {}
;

//Expressão Primária
expressao_primaria:
                  IDENTIFIER                {
                      ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                      aux->expType = IDENTIFIER;
                      aux->left = NULL;
                      aux->right = NULL;
                      $$ = aux;
                  }
                  | numero                    { $$ = $1; }
                  | CHARACTER                 {
                        ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = CHARACTER;
                        aux->left = NULL;
                        aux->right = NULL;
                        $$ = aux;
                  }
                  | STRING                    {
                         ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
                        aux->expType = STRING;
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
          aux->expType = NUM_INTEGER;
          aux->left = NULL;
          aux->right = NULL;
          $$ = aux;
      }
      | NUM_HEXA    {
            ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
            aux->expType = NUM_HEXA;
            aux->left = NULL;
            aux->right = NULL;
            $$ = aux;
      }
      | NUM_OCTAL   {
          ExpressionNode *aux = (ExpressionNode *) malloc(sizeof(struct expression));
            aux->expType = NUM_OCTAL;
            aux->left = NULL;
            aux->right = NULL;
            $$ = aux;
      }
;

//Loops
loop_ponteiro: MULTIPLY loop_ponteiro {}
             |                        {}
;

loop_variaveis: declaracao_variaveis loop_variaveis {}
             |                                      {}
;

loop_vetor: L_SQUARE_BRACKET expressao R_SQUARE_BRACKET loop_vetor {}
             |                                                     {}
;

//Opcionais
opc_atribuicao: ASSIGN expressao_atribuicao {}
              |                             {}
;

%%

void yyerror(char const *s) {
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

int main() {
    fseek(stdin, 0, SEEK_END);
    int fSize = ftell(stdin);
    rewind(stdin);

    lineError = (char *) calloc(fSize, sizeof(char));

    yyparse();

    return 0;
}