#ifndef LEXICO_H
#define LEXICO_H

enum TOKEN {IF = 1, THEN, ELSE, BEGIN, END, PRINT, SEMI, NUM, EQ, BL};

int token;

int getToken();

#endif