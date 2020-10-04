#ifndef LEXICO_H
#define LEXICO_H

enum TOKEN {ID = 1, AND, ARRAY, BEGIN, DO, DIV, END, ELSE, FUNCTION, IF, NOT, OF, OR, PROGRAM, PROCEDURE, THEN, VAR, WHILE,
            SEMICOLON, DOT, DOUBLE_DOT, COLON, ASSIGNMENT, L_RECT_BRACKET, R_RECT_BRACKET, COMMA, L_BRACKET, R_BRACKET,
            EQUAL, LESS_THAN, LESS_EQUAL, DIFFERENT, GREATER_THAN, GREATER_EQUAL, PLUS, MINUS, ASTERISK, NUM, COMMENT};

/*Token lido do léxico.*/
int token;

/*subString com a palavra que será printada em caso de erro sintático.*/
char *subString;

/*Aloca memória para a subString.*/
void allocSubstring();

/*Retorna o primeiro token lido da entrada padrão.*/
int getToken();

#endif