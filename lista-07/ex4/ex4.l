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

%x normal
%x comment
%x linecomment

%%

<*>"#include"|"#define" {
    preproc_direct++;
}

<*>; {
    semi_colons++;
}

<*>"//" {
    BEGIN(linecomment);
}

<linecomment>\n {
    comment_lines++;
    total_lines++;
    BEGIN(INITIAL);
}

<linecomment><<EOF>> {
    comment_lines++;
    total_lines++;
    return 0;
}

<*>"/*" {
    BEGIN(comment);
}

<comment>"*/".*\n {
    comment_lines++;
    total_lines++;
    BEGIN(INITIAL);
}

<comment>\n {
    comment_lines++;
    total_lines++;
}

<comment><<EOF>> {
    comment_lines++;
    total_lines++;
    return 0;
}

[^ \t\n] {
    BEGIN(normal);
}

<normal>\n {
    normal_lines++;
    total_lines++;
    BEGIN(INITIAL);
}

<normal><<EOF>> {
    normal_lines++;
    total_lines++;
    return 0;
}

\n {
    blank_lines++;
    total_lines++;
    BEGIN(INITIAL);
}

<<EOF>> {
    blank_lines++;
    total_lines++;
    return 0;
}

. {}

<comment>. {}

<normal>. {}

<linecomment>. {}

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