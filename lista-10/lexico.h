#ifndef LEXICO_H
#define LEXICO_H

enum TOKEN {ID = 1, PLUS, TIMES, L_BRACKET, R_BRACKET, END_OF_FILE, BL, ERROR};

int token;

char c;

int getToken();

#endif