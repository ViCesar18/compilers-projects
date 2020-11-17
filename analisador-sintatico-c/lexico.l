%option noyywrap

%{
    #include "sintatico.tab.h"
    #include <stdbool.h>

    int line_counter = 1;
    int column_counter = 1;
    int comment_start_line = 0;
    int comment_start_column = 0;

    bool first = true;
%}

%x string
%x character
%x comment
%x linecomment

%%

"void" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return VOID;
}

"int" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return INT;
}

"char" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return CHAR;
}

"return" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return RETURN;
}

"break" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return BREAK;
}

"switch" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return SWITCH;
}

"case" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);
    
    return CASE;
}

"default" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return DEFAULT;
}

"do" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return DO;
}

"while" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return WHILE;
}
"for" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return FOR;
}

"if" {
    if(!first) printf("\n");
    first = false;
    column_counter += 2;

    return IF;
}

"else" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return ELSE;
}

"typedef" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return TYPEDEF;
}

"struct" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return STRUCT;
}

"+" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return PLUS;
}
"-" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return MINUS;
}

"*" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return MULTIPLY;
}

"/" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return DIV;
}
"%" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return REMAINDER;
}

"++" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return INC;
}

"--" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return DEC;
}

"&" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return BITWISE_AND;
}
"|" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return BITWISE_OR;
}

"~" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return BITWISE_NOT;
}

"^" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return BITWISE_XOR;
}

"!" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return NOT;
}

"&&" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return LOGICAL_AND;
}

"||" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return LOGICAL_OR;
}

"==" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return EQUAL;
}

"!=" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return NOT_EQUAL;
}

"<" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return LESS_THAN;
}

">" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return GREATER_THAN;
}

"<=" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return LESS_EQUAL;
}

">=" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return GREATER_EQUAL;
}

">>" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return R_SHIFT;
}

"<<" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return L_SHIFT;
}

"=" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return ASSIGN;
}

"+=" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return ADD_ASSIGN;
}

"-=" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return MINUS_ASSIGN;
}

";" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return SEMICOLON;
}
"," {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return COMMA;
}

":" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return COLON;
}

"(" {
    if(!first) printf("\n");
    first = false;
    column_counter++;

    return L_PAREN;
}
")" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return R_PAREN;
}

"{" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return L_CURLY_BRACKET;
}

"}" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return R_CURLY_BRACKET;
}

"[" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return L_SQUARE_BRACKET;
}

"]" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return R_SQUARE_BRACKET;
}

"?" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return TERNARY_CONDITIONAL;
}

"#" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return NUMBER_SIGN;
}

"->" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return POINTER;
}

"printf" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return PRINTF;
}

"scanf" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return SCANF;
}

"define" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return DEFINE;
}

"exit" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return EXIT;
}

[_a-zA-Z][_a-zA-Z0-9]* {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return IDENTIFIER;
}

0|[1-9][0-9]* {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return NUM_INTEGER;
}

0[0-7]+ {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return NUM_OCTAL;
}

("0x"|"0X")[0-9a-fA-F]+ {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return NUM_HEXA;
}

\" {
    BEGIN(string);
    column_counter += strlen(yytext);
}

\"\" {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return STRING;  //String vazia
}

<string>([^"]|\\\")* {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return STRING;
}
<string>\" {
    BEGIN(INITIAL);
    column_counter += strlen(yytext);
}

\' {
    BEGIN(character);
    column_counter += strlen(yytext);
}

<character>\\?[^\'] {
    if(!first) printf("\n");
    first = false;
    column_counter += strlen(yytext);

    return CHARACTER;
}
    
<character>[^\']* {}

<character>\' {
    BEGIN(INITIAL);
    column_counter += strlen(yytext);
}

"/*" {
    BEGIN(comment);
    comment_start_column = column_counter;
    comment_start_line = line_counter;
    column_counter += strlen(yytext);
}

<comment>\n {
    line_counter++;
    column_counter = 1;
}

<comment>"*/" {
    BEGIN(INITIAL);
    column_counter += strlen(yytext);
}

<comment>.  {}

<comment><<EOF>> {
    if(!first) printf("\n");
    first = false;
    printf("error:lexical:%d:%d: unterminated comment", comment_start_line, comment_start_column);

    return EOP;
}

"//" {
    BEGIN(linecomment);
    column_counter += strlen(yytext);
}

<linecomment>.* {
    column_counter += strlen(yytext);
}

<linecomment>\n {
    line_counter++;
    column_counter = 1;
    BEGIN(INITIAL);
}

\n  {
    line_counter++;
    column_counter = 1;
}

[^ \t] {
    if(!first) printf("\n");
    first = false;
    printf("error:lexical:%d:%d: %s", line_counter, column_counter, yytext);
    column_counter += strlen(yytext);
}

. {
    column_counter++;
}

%%