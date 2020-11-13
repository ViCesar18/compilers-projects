%{
    #include <stdio.h>

    extern int yylex();
    extern char *yytext;
    void yyerror(char const *s);
%}

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
%token EOP

%start S

%%

S: programa EOP {
    printf("PROGRAMA CORRETO!\n");
}
;

//Programa
programa: declaracoes programa {}
        | funcao programa      {}
;

//Declarações
declaracoes: NUMBER_SIGN DEFINE IDENTIFIER expressao {}
           | declaracao_variaveis                    {}
           | declaracao_prototipos                   {}
;

//Função
funcao: tipo loop_ponteiro IDENTIFIER parametros L_CURLY_BRACKET loop_variaveis comandos R_CURLY_BRACKET {}
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
declaracao_prototipos: loop_ponteiro IDENTIFIER parametros SEMICOLON {}
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
bloco: L_CURLY_BRACKET comandos R_CURLY_BRACKET {}
;

//Comandos
comandos: lista_comandos comandos {}
        |                         {}
;

//Lista de Comandos
lista_comandos: DO bloco WHILE L_PAREN expressao R_PAREN SEMICOLON                                                               {}
              | IF L_PAREN expressao R_PAREN bloco lista_comandos_if                                                             {}
              | WHILE L_PAREN expressao R_PAREN bloco                                                                            {}
              | FOR L_PAREN lista_comandos_exp SEMICOLON lista_comandos_exp SEMICOLON lista_comandos_exp SEMICOLON R_PAREN bloco {}
              | PRINTF L_PAREN STRING lista_comandos_print R_PAREN SEMICOLON                                                     {}
              | SCANF L_PAREN STRING COMMA BITWISE_AND IDENTIFIER R_PAREN SEMICOLON                                              {}
              | EXIT L_PAREN expressao R_PAREN SEMICOLON                                                                         {}
              | RETURN lista_comandos_exp SEMICOLON                                                                              {}
              | expressao SEMICOLON                                                                                              {}
              | SEMICOLON                                                                                                        {}
              | bloco                                                                                                            {}
;

lista_comandos_if: ELSE bloco {}
                 |            {}
;

lista_comandos_exp: expressao {}
                  |           {}
;

lista_comandos_print: COMMA expressao {}
                    |                 {}
;

//Expressão
expressao: expressao_atribuicao expressao_prime {}
;

expressao_prime: COMMA expressao {}
               |                 {}
;

//Expressão de Atribuição
expressao_atribuicao: expressao_condicional                                            {}
                    | expressao_unaria expressao_atribuicao_prime expressao_atribuicao {}
;

expressao_atribuicao_prime: EQUAL        {}
                          | ADD_ASSIGN   {}
                          | MINUS_ASSIGN {}
;

//Experssão Condicional
expressao_condicional: expressao_or_logico expressao_condicional_prime {}
;

expressao_condicional_prime: TERNARY_CONDITIONAL expressao COLON expressao_condicional {}
                           |                                                           {}
;

//Expressão OR Lógico
expressao_or_logico: expressao_and_logico expressao_or_logico_prime {}
;

expressao_or_logico_prime: LOGICAL_OR expressao_or_logico {}
                         |                                {}
;

//Expressão AND Lógico
expressao_and_logico: expressao_or expressao_and_logico_prime {}
;

expressao_and_logico_prime: LOGICAL_AND expressao_and_logico {}
                          |                                  {}
;

//Expressão OR
expressao_or: expressao_xor expressao_or_prime {}
;

expressao_or_prime: BITWISE_OR expressao_or {}
                  |                         {}
;

//Expressão XOR
expressao_xor: expressao_and expressao_xor_prime {}
;

expressao_xor_prime: BITWISE_XOR expressao_xor {}
                   |                           {}
;

//Expressão AND
expressao_and: expressao_igualdade expressao_and_prime {}
;

expressao_and_prime: BITWISE_AND expressao_and {}
                   |                           {}
;

//Expressão de Igualdade
expressao_igualdade: expressao_relacional expressao_igualdade_prime {}
;

expressao_igualdade_prime: EQUAL expressao_igualdade     {}
                         | NOT_EQUAL expressao_igualdade {}
                         |                               {}
;

//Expressão Relacional
expressao_relacional: expressao_shift expressao_relacional_prime {}
;

expressao_relacional_prime: LESS_THAN expressao_relacional     {}
                          | LESS_EQUAL expressao_relacional    {}
                          | GREATER_THAN expressao_relacional  {}
                          | GREATER_EQUAL expressao_relacional {}
                          |                                    {}
;

//Expressão Shift
expressao_shift: expressao_aditiva expressao_shift_prime {}
;

expressao_shift_prime: L_SHIFT expressao_shift {}
                     | R_SHIFT expressao_shift {}
                     |                         {}
;

//Expressão Aditiva
expressao_aditiva: expressao_multiplicativa expressao_aditiva_prime {}
;

expressao_aditiva_prime: PLUS expressao_aditiva  {}
                       | MINUS expressao_aditiva {}
                       |                         {}
;

//Expressão Multiplicativa
expressao_multiplicativa: expressao_cast expressao_multiplicativa_prime {}
;

expressao_multiplicativa_prime: MULTIPLY expressao_multiplicativa  {}
                              | DIV expressao_multiplicativa       {}
                              | REMAINDER expressao_multiplicativa {}
                              |                                    {}
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
expressao_primaria: IDENTIFIER                {}
                  | numero                    {}
                  | CHARACTER                 {}
                  | STRING                    {}
                  | L_PAREN expressao R_PAREN {}
;

//Número
numero: NUM_INTEGER {}
      | NUM_HEXA    {}
      | NUM_OCTAL   {}
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

}

int main() {
    yyparse();

    return 0;
}