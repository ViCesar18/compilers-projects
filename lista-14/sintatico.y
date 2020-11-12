%{
    #include <stdio.h>
    #include <stdbool.h>
    #include <string.h>
    #include <stdlib.h>
    
    extern int yylex();

    extern char *yytext;

    extern int column_counter;

    void yyerror(char const *s);

    bool hasError = false;

    extern int end_of_program;

    extern char *wrong_chars;

    int f_len = 0;

    extern bool lexical_error;

    extern int wrong_chars_count;

    bool first = true;
%}

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

%%

calclist: exp_prime EOL {
    if(!hasError && !lexical_error) {
        printf("EXPRESSAO CORRETA\n");
    }
    
    return 1;
}
;

exp: signal term                 {}
   | exp_prime ADD st            {}
   | exp_prime SUB st            {}
   | exp_prime MUL st            {}
   | exp_prime DIV st            {}
   | exp_prime POWER term_prime  {}
   | exp_prime MODULE st         {}
;

exp_prime: exp                   {}
         | L_PARENT exp R_PARENT {}
         | L_PARENT R_PARENT     {}
;

term: NUM                             {}
    | VAR                             {}
    | SEN L_PARENT exp_prime R_PARENT {}
    | COS L_PARENT exp_prime R_PARENT {}
    | TAN L_PARENT exp_prime R_PARENT {}
    | ABS L_PARENT exp_prime R_PARENT {}
;

term_prime: term                   {}
          | L_PARENT term R_PARENT {}
;

signal: ADD {}
      | SUB {}
      |     {}
;

st: signal term                   {}
  | L_PARENT signal term R_PARENT {}
;

%%

void yyerror(char const *s) {
    if(!hasError) {
        if(strcmp(yytext, "\n")) {
            if(first) {
                printf("Erro de sintaxe na coluna [%d]: %s", column_counter - 1, yytext);
                first = false;
            }
            else {
                printf("\nErro de sintaxe na coluna [%d]: %s", column_counter - 1, yytext);
            }
        }
        else {
            if(first) {
                printf("A expressao terminou de forma inesperada.");
                first = false;
            }
            else {
                printf("\nA expressao terminou de forma inesperada.");
            }
        }
        hasError = true;
    }
}

int main() {
    fseek(stdin, 0, SEEK_END);
    f_len = ftell(stdin);
    rewind(stdin);

    wrong_chars = (char *) calloc(f_len, sizeof(char));

    while(!end_of_program) {
        yyparse();

        while(yylex() != EOL);  //Avança até a quebra de linha
        //yylex();

        if(lexical_error) {
            if(first) {
                printf("Caractere(s) invalido(s) -> [");
                first = false;
            }
            else {
                printf("\nCaractere(s) invalido(s) -> [");
            }
            for(int i = 0; i < wrong_chars_count; i++) {
                if(wrong_chars[i + 1] == '\0') {
                    printf("%c", wrong_chars[i]);
                }
                else {
                    printf("%c,", wrong_chars[i]);
                }
            }
            printf("]\n");

            memset(wrong_chars, 0, sizeof(wrong_chars));
            wrong_chars_count = 0;
            lexical_error = false;
        }

        hasError = false;
    };

    return 0;
}