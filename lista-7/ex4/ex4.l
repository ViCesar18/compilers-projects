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

%s blank
%s normal
%s comment

%%

"#include"|"#define" {
    preproc_direct++;

    BEGIN(normal);
}

"//".*"\n" {
    comment_lines++;
    total_lines++;

    char *p;

    //Verificar ';' dentro de comentário de uma linha
    p = strchr(yytext, ';');
    while(p != NULL) {
        semi_colons++;
        p = strchr(p + 1, ';');
    }

    //Verificar "#include" dentro de comentário de uma linha
    p = strstr(yytext, "#include");
    while(p != NULL) {
        preproc_direct++;
        p = strstr(p + 8, "#include");
    }

    //Verificar "#define" dentro de comentário de uma linha
    p = strstr(yytext, "#define");
    while(p != NULL) {
        preproc_direct++;
        p = strstr(p + 7, "#define");
    }

    BEGIN(comment);
}

"/*"(.|\n)*"*/".*\n {
    char *p;

    //Verificar quantas linhas existem dentro de comentário de várias linhas
    p = strchr(yytext, '\n');
    while(p != NULL) {
        comment_lines++;
        total_lines++;
        p = strchr(p + 1, '\n');
    }

    //Verificar ';' dentro de comentário de várias linhas
    p = strchr(yytext, ';');
    while(p != NULL) {
        semi_colons++;
        p = strchr(p + 1, ';');
    }

    //Verificar "#include" dentro de comentário de várias linhas
    p = strstr(yytext, "#include");
    while(p != NULL) {
        preproc_direct++;
        p = strstr(p + 8, "#include");
    }

    //Verificar "#define" dentro de comentário de várias linhas
    p = strstr(yytext, "#define");
    while(p != NULL) {
        preproc_direct++;
        p = strstr(p + 7, "#define");
    }

    BEGIN(comment);
}

^[ \t]*[\n] {
    blank_lines++;
    total_lines++;
    BEGIN(blank);
}

; {
    semi_colons++;
}

\n {
    normal_lines++;
    total_lines++;
    BEGIN(normal);
}

<normal><<EOF>> {
    total_lines++;
    normal_lines++;
    return 0;
}

<blank><<EOF>> {
    total_lines++;
    blank_lines++;
    return 0;
}

<comment><<EOF>> {
    total_lines++;
    comment_lines++;
    return 0;
}

[^ \t] {
    BEGIN(normal);
}

. {}

%%

int main(int argc, char *argv[]) {
    int total_tlines = 0;
    int total_blines = 0;
    int total_clines = 0;
    int total_nlines = 0;
    int total_scolons = 0;
    int total_pdirect = 0;

    printf(" total    blank lines w/   nb, nc    semi- preproc. file\n");
    printf(" lines    lines comments    lines   colons  direct.\n");
    printf("------+--------+--------+--------+--------+--------+----\n");

    int i;
    for(i = 1; i < argc; i++) {
        FILE *file;
        freopen(argv[i], "r", stdin);

        yylex();

        printf("    %d        %d        %d        %d        %d        %d %s\n", total_lines, blank_lines, comment_lines, normal_lines, semi_colons, preproc_direct, argv[i]);

        total_tlines += total_lines;
        total_blines += blank_lines;
        total_clines += comment_lines;
        total_nlines += normal_lines;
        total_scolons += semi_colons;
        total_pdirect += preproc_direct;

        total_lines = 0;
        blank_lines = 0;
        comment_lines = 0;
        normal_lines = 0;
        semi_colons = 0;
        preproc_direct = 0;
    }

    printf("    %d        %d        %d        %d        %d        %d total\n", total_tlines, total_blines, total_clines, total_nlines, total_scolons, total_pdirect);

    return 0;
}