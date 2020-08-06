%option noyywrap

%{
    #include "string.h"

    int total_lines = 0;
    int blank_lines = 0;
    int comment_lines = 0;
    int normal_lines = 0;
    int semi_colons = 0;
    int preproc_direct = 0;
%}

%%

"//".*"\n" {
    comment_lines++;
    total_lines++;
}

"/*"(.|\n)*"*/".* {
    char *p;

    p = strchr(yytext, '\n');
    comment_lines++;
    total_lines++;

    while(p != NULL) {
        comment_lines++;
        total_lines++;
        p = strchr(p + 1, '\n');
    }

    p = strchr(yytext, ';');
    while(p != NULL) {
        semi_colons++;
        p = strchr(p + 1, ';');
    }
}

^[ \t]*[\n\r][\n\r] {
    blank_lines++;
    total_lines++;
}

; {
    semi_colons++;
}

[\n] {
     normal_lines++;
     total_lines++;
}

%%

int main() {
    yylex();

    printf("Linhas normais: %d\n", normal_lines);
    printf("Linhas comentadas: %d\n", comment_lines);
    printf("Linhas em branco: %d\n", blank_lines);
    printf("Linhas totais: %d\n", total_lines);
    printf("pontos e virgulas: %d\n", semi_colons);

    return 0;
}