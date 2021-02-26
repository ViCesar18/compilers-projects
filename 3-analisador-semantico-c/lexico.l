%option noyywrap

%{
    #include "ast.h"
    #include "sintatico.tab.h"
    #include <stdbool.h>

    unsigned lineCounter = 1;
    unsigned columnCounter = 1;
    unsigned commentStartLine = 0;
    unsigned commentStartColumn = 0;

    unsigned lineCounterId = 0;

    char *lineError;
    char *lineBlock;

    unsigned columnFunction = 0;
    bool flgLineFunction = false;

    bool hasSyntaxError = false;
%}

%x string
%x character
%x comment
%x linecomment

%%

"void" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return VOID;
}

"int" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return INT;
}

"char" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return CHAR;
}

"return" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return RETURN;
}

"break" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return BREAK;
}

"switch" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return SWITCH;
}

"case" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);
    
    return CASE;
}

"default" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return DEFAULT;
}

"do" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return DO;
}

"while" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return WHILE;
}
"for" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return FOR;
}

"if" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return IF;
}

"else" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return ELSE;
}

"typedef" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return TYPEDEF;
}

"struct" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return STRUCT;
}

"+" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return PLUS;
}
"-" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return MINUS;
}

"*" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return MULTIPLY;
}

"/" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return DIV;
}
"%" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return REMAINDER;
}

"++" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return INC;
}

"--" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return DEC;
}

"&" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return BITWISE_AND;
}
"|" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return BITWISE_OR;
}

"~" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return BITWISE_NOT;
}

"^" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return BITWISE_XOR;
}

"!" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return NOT;
}

"&&" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return LOGICAL_AND;
}

"||" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return LOGICAL_OR;
}

"==" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return EQUAL;
}

"!=" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return NOT_EQUAL;
}

"<" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return LESS_THAN;
}

">" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return GREATER_THAN;
}

"<=" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return LESS_EQUAL;
}

">=" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return GREATER_EQUAL;
}

">>" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return R_SHIFT;
}

"<<" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return L_SHIFT;
}

"=" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return ASSIGN;
}

"+=" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return ADD_ASSIGN;
}

"-=" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return MINUS_ASSIGN;
}

";" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return SEMICOLON;
}
"," {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return COMMA;
}

":" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return COLON;
}

"(" {
    columnFunction = columnCounter;

    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return L_PAREN;
}
")" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return R_PAREN;
}

"{" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    if(flgLineFunction) {
        strcat(lineBlock, yytext);
    }

    return L_CURLY_BRACKET;
}

"}" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return R_CURLY_BRACKET;
}

"[" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return L_SQUARE_BRACKET;
}

"]" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return R_SQUARE_BRACKET;
}

"?" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return TERNARY_CONDITIONAL;
}

"#" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return NUMBER_SIGN;
}

"->" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return POINTER;
}

"printf" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return PRINTF;
}

"scanf" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return SCANF;
}

"define" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return DEFINE;
}

"exit" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return EXIT;
}

[_a-zA-Z][_a-zA-Z0-9]* {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    lineCounterId = lineCounter;

    yylval.id = (char *) malloc(sizeof(yytext) + 1);
    strcpy(yylval.id, yytext);

    return IDENTIFIER;
}

0|[1-9][0-9]* {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return NUM_INTEGER;
}

0[0-7]+ {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return NUM_OCTAL;
}

("0x"|"0X")[0-9a-fA-F]+ {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return NUM_HEXA;
}

\" {
    BEGIN(string);
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);
}

\"\" {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return STRING;  //String vazia
}

<string>([^"]|\\\")* {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return STRING;
}
<string>\" {
    BEGIN(INITIAL);
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);
}

\' {
    BEGIN(character);
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);
}

<character>\\?[^\']|\\\' {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);

    return CHARACTER;
}

<character>\' {
    BEGIN(INITIAL);
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);
}

"/*" {
    BEGIN(comment);
    commentStartColumn = columnCounter;
    commentStartLine = lineCounter;
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);
}

<comment>\n {
    lineCounter++;
    columnCounter = 1;

    if(!hasSyntaxError) {
        memset(lineError, 0, sizeof(lineError));
    }
    else {
        return EOL;
    }
}

<comment>"*/" {
    BEGIN(INITIAL);
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);
}

<comment>.  {
    columnCounter += strlen(yytext);
    strcat(lineError, yytext);
}

<comment><<EOF>> {
    printf("error:lexical:%u:%u: unterminated comment", commentStartLine, commentStartColumn);
    exit(1);
}

"//" {
    BEGIN(linecomment);
    strcat(lineError, yytext);
}

<linecomment>. {
    strcat(lineError, yytext);
}

<linecomment>\n {
    lineCounter++;
    columnCounter = 1;
    BEGIN(INITIAL);

    if(!hasSyntaxError) {
        memset(lineError, 0, sizeof(lineError));
    }
    else {
        return EOL;
    }
}

\n  {
    lineCounter++;
    columnCounter = 1;

    if(!hasSyntaxError) {
        memset(lineError, 0, sizeof(lineError));
    }
    else {
        return EOL;
    }

    flgLineFunction = false;
}

[^ \t] {
    printf("error:lexical:%u:%u: %s", lineCounter, columnCounter, yytext);
    exit(1);
}

. {
    columnCounter++;
    strcat(lineError, yytext);

    if(flgLineFunction) {
        strcat(lineBlock, yytext);
    }
}

<<EOF>> {
    return EOP;
}

%%