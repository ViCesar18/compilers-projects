%option noyywrap

%{
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
    printf("VOID");
    column_counter += strlen(yytext);
}

"int" {
    if(!first) printf("\n");
    first = false;
    printf("INT");
    column_counter += strlen(yytext);
}

"char" {
    if(!first) printf("\n");
    first = false;
    printf("CHAR");
    column_counter += strlen(yytext);
}

"return" {
    if(!first) printf("\n");
    first = false;
    printf("RETURN");
    column_counter += strlen(yytext);
}

"break" {
    if(!first) printf("\n");
    first = false;
    printf("BREAK");
    column_counter += strlen(yytext);
}

"switch" {
    if(!first) printf("\n");
    first = false;
    printf("SWITCH");
    column_counter += strlen(yytext);
}

"case" {
    if(!first) printf("\n");
    first = false;
    printf("CASE");
    column_counter += strlen(yytext);
}

"default" {
    if(!first) printf("\n");
    first = false;
    printf("DEFAULT");
    column_counter += strlen(yytext);
}

"do" {
    if(!first) printf("\n");
    first = false;
    printf("DO");
    column_counter += strlen(yytext);
}

"while" {
    if(!first) printf("\n");
    first = false;
    printf("WHILE");
    column_counter += strlen(yytext);
}
"for" {
    if(!first) printf("\n");
    first = false;
    printf("FOR");
    column_counter += strlen(yytext);
}

"if" {
    if(!first) printf("\n");
    first = false;
    printf("IF");
    column_counter += 2;
}

"else" {
    if(!first) printf("\n");
    first = false;
    printf("ELSE");
    column_counter += strlen(yytext);
}

"typedef" {
    if(!first) printf("\n");
    first = false;
    printf("TYPEDEF");
    column_counter += strlen(yytext);
}

"struct" {
    if(!first) printf("\n");
    first = false;
    printf("STRUCT");
    column_counter += strlen(yytext);
}

"+" {
    if(!first) printf("\n");
    first = false;
    printf("PLUS");
    column_counter += strlen(yytext);
}
"-" {
    if(!first) printf("\n");
    first = false;
    printf("MINUS");
    column_counter += strlen(yytext);
}

"*" {
    if(!first) printf("\n");
    first = false;
    printf("MULTIPLY");
    column_counter += strlen(yytext);
}

"/" {
    if(!first) printf("\n");
    first = false;
    printf("DIV");
    column_counter += strlen(yytext);
}
"%" {
    if(!first) printf("\n");
    first = false;
    printf("REMAINDER");
    column_counter += strlen(yytext);
}

"++" {
    if(!first) printf("\n");
    first = false;
    printf("INC");
    column_counter += strlen(yytext);
}

"--" {
    if(!first) printf("\n");
    first = false;
    printf("DEC");
    column_counter += strlen(yytext);
}

"&" {
    if(!first) printf("\n");
    first = false;
    printf("BITWISE_AND");
    column_counter += strlen(yytext);
}
"|" {
    if(!first) printf("\n");
    first = false;
    printf("BITWISE_OR");
    column_counter += strlen(yytext);
}

"~" {
    if(!first) printf("\n");
    first = false;
    printf("BITWISE_NOT");
    column_counter += strlen(yytext);
}

"^" {
    if(!first) printf("\n");
    first = false;
    printf("BITWISE_XOR");
    column_counter += strlen(yytext);
}

"!" {
    if(!first) printf("\n");
    first = false;
    printf("NOT");
    column_counter += strlen(yytext);
}

"&&" {
    if(!first) printf("\n");
    first = false;
    printf("LOGICAL_AND");
    column_counter += strlen(yytext);
}

"||" {
    if(!first) printf("\n");
    first = false;
    printf("LOGICAL_OR");
    column_counter += strlen(yytext);
}

"==" {
    if(!first) printf("\n");
    first = false;
    printf("EQUAL");
    column_counter += strlen(yytext);
}

"!=" {
    if(!first) printf("\n");
    first = false;
    printf("NOT_EQUAL");
    column_counter += strlen(yytext);
}

"<" {
    if(!first) printf("\n");
    first = false;
    printf("LESS_THAN");
    column_counter += strlen(yytext);
}

">" {
    if(!first) printf("\n");
    first = false;
    printf("GREATER_THAN");
    column_counter += strlen(yytext);
}

"<=" {
    if(!first) printf("\n");
    first = false;
    printf("LESS_EQUAL");
    column_counter += strlen(yytext);
}

">=" {
    if(!first) printf("\n");
    first = false;
    printf("GREATER_EQUAL");
    column_counter += strlen(yytext);
}

">>" {
    if(!first) printf("\n");
    first = false;
    printf("R_SHIFT");
    column_counter += strlen(yytext);
}

"<<" {
    if(!first) printf("\n");
    first = false;
    printf("L_SHIFT");
    column_counter += strlen(yytext);
}

"=" {
    if(!first) printf("\n");
    first = false;
    printf("ASSIGN");
    column_counter += strlen(yytext);
}

"+=" {
    if(!first) printf("\n");
    first = false;
    printf("ADD_ASSIGN");
    column_counter += strlen(yytext);
}

"-=" {
    if(!first) printf("\n");
    first = false;
    printf("MINUS_ASSIGN");
    column_counter += strlen(yytext);
}

";" {
    if(!first) printf("\n");
    first = false;
    printf("SEMICOLON");
    column_counter += strlen(yytext);
}
"," {
    if(!first) printf("\n");
    first = false;
    printf("COMMA");
    column_counter += strlen(yytext);
}

":" {
    if(!first) printf("\n");
    first = false;
    printf("COLON");
    column_counter += strlen(yytext);
}

"(" {
    if(!first) printf("\n");
    first = false;
    printf("L_PAREN");
    column_counter++;
}
")" {
    if(!first) printf("\n");
    first = false;
    printf("R_PAREN");
    column_counter += strlen(yytext);
}

"{" {
    if(!first) printf("\n");
    first = false;
    printf("L_CURLY_BRACKET");
    column_counter += strlen(yytext);
}

"}" {
    if(!first) printf("\n");
    first = false;
    printf("R_CURLY_BRACKET");
    column_counter += strlen(yytext);
}

"[" {
    if(!first) printf("\n");
    first = false;
    printf("L_SQUARE_BRACKET");
    column_counter += strlen(yytext);
}

"]" {
    if(!first) printf("\n");
    first = false;
    printf("R_SQUARE_BRACKET");
    column_counter += strlen(yytext);
}

"?" {
    if(!first) printf("\n");
    first = false;
    printf("TERNARY_CONDITIONAL");
    column_counter += strlen(yytext);
}

"#" {
    if(!first) printf("\n");
    first = false;
    printf("NUMBER_SIGN");
    column_counter += strlen(yytext);
}

"->" {
    if(!first) printf("\n");
    first = false;
    printf("POINTER");
    column_counter += strlen(yytext);
}

"printf" {
    if(!first) printf("\n");
    first = false;
    printf("PRINTF");
    column_counter += strlen(yytext);
}

"scanf" {
    if(!first) printf("\n");
    first = false;
    printf("SCANF");
    column_counter += strlen(yytext);
}

"define" {
    if(!first) printf("\n");
    first = false;
    printf("DEFINE");
    column_counter += strlen(yytext);
}

"exit" {
    if(!first) printf("\n");
    first = false;
    printf("EXIT");
    column_counter += strlen(yytext);
}

[_a-zA-Z][_a-zA-Z0-9]* {
    if(!first) printf("\n");
    first = false;
    printf("IDENTIFIER(%s)", yytext);
    column_counter += strlen(yytext);
}

0|[1-9]+ {
    if(!first) printf("\n");
    first = false;
    printf("NUM_INTEGER(%s)", yytext);
    column_counter += strlen(yytext);
}

0[1-7]+ {
    if(!first) printf("\n");
    first = false;
    printf("NUM_OCTAL(%s)", yytext);
    column_counter += strlen(yytext);
}

("0x"|"0X")[1-9a-fA-F]+ {
    if(!first) printf("\n");
    first = false;
    printf("NUM_HEXA(%s)", yytext);
    column_counter += strlen(yytext);
}

\" {
    BEGIN(string);
    column_counter += strlen(yytext);
}

<string>([^"]|\\\")* {
    if(!first) printf("\n");
    first = false;
    printf("STRING(%s)", yytext);
    column_counter += strlen(yytext);
}
<string>\" {
    BEGIN(INITIAL);
    column_counter += strlen(yytext);
}

\' {
    BEGIN(character);
    column_counter += strlen(yytext);
}

<character>[^\'] {
    if(!first) printf("\n");
    first = false;
    printf("CHARACTER(%s)", yytext);
    column_counter += strlen(yytext);
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

<comment>[^*/\n]* {}

<comment>\n {
    line_counter++;
    column_counter = 1;
}

<comment>"*/" {
    BEGIN(INITIAL);
    column_counter += strlen(yytext);
}

<comment><<EOF>> {
    if(!first) printf("\n");
    first = false;
    printf("error:lexical:%d:%d: unterminated comment", comment_start_line, comment_start_column);
    return 0;
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

int main() {
    yylex();

    return 0;
}