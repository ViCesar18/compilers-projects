%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>

    extern int yylex();
    extern char *yytext;
    void yyerror(char const *s);

    extern unsigned lineCounter;
    extern unsigned columnCounter;

    extern char *lineError;

    extern bool hasSyntaxError;
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
%token EOL
%token EOP

%start S

%%

S: programa EOP{
    printf("SUCCESSFUL COMPILATION.");

    exit(1);
}
;

//Programa
programa: declaracoes programa {}
        | funcao programa      {}
        |                      {}
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
bloco: L_CURLY_BRACKET lista_comandos comandos R_CURLY_BRACKET {}
;

//Comandos
comandos: lista_comandos comandos {}
        |                         {}
;

//Lista de Comandos
lista_comandos: DO bloco WHILE L_PAREN expressao R_PAREN SEMICOLON                                                               {}
              | IF L_PAREN expressao R_PAREN bloco lista_comandos_if                                                             {}
              | WHILE L_PAREN expressao R_PAREN bloco                                                                            {}
              | FOR L_PAREN lista_comandos_exp SEMICOLON lista_comandos_exp SEMICOLON lista_comandos_exp R_PAREN bloco {}
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

expressao_atribuicao_prime: ASSIGN       {}
                          | ADD_ASSIGN   {}
                          | MINUS_ASSIGN {}
;

//Experssão Condicional
expressao_condicional: expressao_or_logico {}
                     | expressao_or_logico TERNARY_CONDITIONAL expressao COLON expressao_condicional
;

//Expressão OR Lógico
expressao_or_logico: expressao_and_logico                                {}
                   | expressao_or_logico LOGICAL_OR expressao_and_logico {}
;

//Expressão AND Lógico
expressao_and_logico: expressao_or                                  {}
                    | expressao_and_logico LOGICAL_AND expressao_or {}
;

//Expressão OR
expressao_or: expressao_xor                         {}
            | expressao_or BITWISE_OR expressao_xor {}
;

//Expressão XOR
expressao_xor: expressao_and                           {}
             | expressao_xor BITWISE_XOR expressao_and {}
;

//Expressão AND
expressao_and: expressao_igualdade                           {}
             | expressao_and BITWISE_AND expressao_igualdade {}
;

//Expressão de Igualdade
expressao_igualdade: expressao_relacional                               {}
                   | expressao_igualdade EQUAL expressao_relacional     {}
                   | expressao_igualdade NOT_EQUAL expressao_relacional {}
;

//Expressão Relacional
expressao_relacional: expressao_shift                                    {}
                    | expressao_relacional LESS_THAN expressao_shift     {}
                    | expressao_relacional LESS_EQUAL expressao_shift    {}
                    | expressao_relacional GREATER_THAN expressao_shift  {}
                    | expressao_relacional GREATER_EQUAL expressao_shift {}
;

//Expressão Shift
expressao_shift: expressao_aditiva                         {}
               | expressao_shift L_SHIFT expressao_aditiva {}
               | expressao_shift R_SHIFT expressao_aditiva {}
;

//Expressão Aditiva
expressao_aditiva: expressao_multiplicativa                         {}
                 | expressao_aditiva PLUS expressao_multiplicativa  {}
                 | expressao_aditiva MINUS expressao_multiplicativa {}
;

//Expressão Multiplicativa
expressao_multiplicativa: expressao_cast                                    {}
                        | expressao_multiplicativa MULTIPLY expressao_cast  {}
                        | expressao_multiplicativa DIV expressao_cast       {}
                        | expressao_multiplicativa REMAINDER expressao_cast {}
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