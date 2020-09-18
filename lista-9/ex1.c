#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

enum TOKEN {IF = 1, THEN, ELSE, BEGIN, END, PRINT, SEMI, NUM, EQ};
enum TOKEN token;

enum errorCode {ERROR_EAT, ERROR_S, ERROR_L, ERROR_E};

bool first = true, errorBool = false;

int getToken() {
    int automaton[][28] = {
                   /*b  d  e  f  g  h  i  l  n  p  r  s  t  0  1  2  3  4  5  6  7  8  9  ;  +  -  =  final?*/
        /*State 0*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        /*State 1*/ {12, 0, 8, 0, 0, 0, 2, 0, 0, 19, 0, 0, 4, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 24, 25, 25, 27, 0},
        /*State 2*/ {0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        /*State 3*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},  //IF
        /*State 4*/ {0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        /*State 5*/ {0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        /*State 6*/ {0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        /*State 7*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},   //THEN
        /*State 8*/ {0, 0, 0, 0, 0, 0, 0, 9, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        /*State 9*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
       /*State 10*/ {0, 0, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
       /*State 11*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},   //ELSE
       /*State 12*/ {0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
       /*State 13*/ {0, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
       /*State 14*/ {0, 0, 0, 0, 0, 0, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
       /*State 15*/ {0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
       /*State 16*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},   //BEGIN
       /*State 17*/ {0, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
       /*State 18*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},   //END
       /*State 19*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
       /*State 20*/ {0, 0, 0, 0, 0, 0, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
       /*State 21*/ {0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
       /*State 22*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
       /*State 23*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},   //PRINT
       /*State 24*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},   //SEMI
       /*State 25*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 0, 0, 0, 0},
       /*State 26*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 0, 0, 0, 0, 1},   //NUM
       /*State 27*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}   //EQ
    };

    char c;
    int lastFinal = 0, currentState = 1;

    c = getc(stdin);

    while(true) {
        int column;

        if(c >= '0' && c <= '9') {
            column = c - '0' + 13;
        }
        else if (c == 'b') {
            column = 0;
        }
        else if (c == 'd') {
            column = 1;
        }
        else if( c >= 'e' && c <= 'i') {
            column = c - 'e' + 2;
        }
        else if(c == 'l') {
            column = 7;
        }
        else if(c == 'n') {
            column = 8;
        }
        else if(c == 'p') {
            column = 9;
        }
        else if(c >= 'r' && c <= 't') {
            column = c - 'r' + 10;
        }
        else if(c == ';') {
            column = 23;
        }
        else if(c == '+') {
            column = 24;
        }
        else if(c == '-') {
            column = 25;
        }
        else if(c == '=') {
            column = 26;
        }
        else {
            column = -1;
        }
        

        int nextState;
        if(column == -1) {
            nextState = 0;
        }
        else {
            nextState = automaton[currentState][column];
        }

        if(nextState == 0) {
            if(!feof(stdin) && currentState != 1)  //Caso termine de ler a cadeia, mas não seja o final do arquivo e
                fseek(stdin, -1, SEEK_CUR);        //nem um estado não final, volta um caractere na entrada padrão

            switch (currentState) {
                case 3:
                    return IF;

                case 7:
                    return THEN;

                case 11:
                    return ELSE;

                case 16:
                    return BEGIN;

                case 18:
                    return END;
                
                case 23:
                    return PRINT;
                
                case 24:
                    return SEMI;

                case 26:
                    return NUM;
                
                case 27:
                    return EQ;

                default:
                    return -1;
            }
        }
        else {
            c = getc(stdin);
        }

        currentState = nextState;
        if(automaton[currentState][27] == 1) {
            lastFinal = currentState;
        }
    }
}

void advance() {
    if(!errorBool) {
        do {
            token = getToken();
        } while(token == -1 && !feof(stdin));
    }
}

void error(enum errorCode error, int t) {
    char expectedToken[10], receivedToken[10];

    errorBool = true;

    switch(t) {
        case IF:
            strcpy(expectedToken, "if");
            break;

        case THEN:
            strcpy(expectedToken, "then");
            break;

        case ELSE:
            strcpy(expectedToken, "else");
            break;

        case BEGIN:
            strcpy(expectedToken, "begin");
            break;

        case END:
            strcpy(expectedToken, "end");
            break;
        
        case PRINT:
            strcpy(expectedToken, "print");
            break;
        
        case SEMI:
            strcpy(expectedToken, ";");
            break;

        case NUM:
            strcpy(expectedToken, "num");
            break;
        
        case EQ:
            strcpy(expectedToken, "=");
            break;

        default:
            break;
    }

    switch(token) {
        case IF:
            strcpy(receivedToken, "if");
            break;

        case THEN:
            strcpy(receivedToken, "then");
            break;

        case ELSE:
            strcpy(receivedToken, "else");
            break;

        case BEGIN:
            strcpy(receivedToken, "begin");
            break;

        case END:
            strcpy(receivedToken, "end");
            break;
        
        case PRINT:
            strcpy(receivedToken, "print");
            break;
        
        case SEMI:
            strcpy(receivedToken, ";");
            break;

        case NUM:
            strcpy(receivedToken, "num");
            break;
        
        case EQ:
            strcpy(receivedToken, "=");
            break;

        default:
            break;
    }

    switch (error) {
        case ERROR_EAT:
            if(first) {
                printf("ERRO SINTATICO EM: %s ESPERADO: %s", receivedToken, expectedToken);
                first = false;
            }
            else {
                printf("\nERRO SINTATICO EM: %s ESPERADO: %s", receivedToken, expectedToken);
            }
            break;
        
        case ERROR_S:
            if(first) {
                printf("ERRO SINTATICO EM: %s ESPERADO: if, begin, print", receivedToken);
                first = false;
            }
            else {
                printf("\nERRO SINTATICO EM: %s ESPERADO: if, begin, print", receivedToken);
            }
            break;
        
        case ERROR_L:
            if(first) {
                printf("ERRO SINTATICO EM: %s ESPERADO: end, ;", receivedToken);
                first = false;
            }
            else {
                printf("\nERRO SINTATICO EM: %s ESPERADO: end, ;", receivedToken);
            }
            break;
        
        case ERROR_E:
            if(first) {
                printf("ERRO SINTATICO EM: %s ESPERADO: num", receivedToken);
                first = false;
            }
            else {
                printf("\nERRO SINTATICO EM: %s ESPERADO: num", receivedToken);
            }
            break;
            
        default:
            break;
    }
}

void eat(int t) {
    if(!errorBool) {
        if(token == t) {
            advance();
        }
        else if(token == -1) {
            errorBool = true;

            if(first) {
                printf("ERRO SINTATICO: CADEIA INCOMPLETA");
                first = false;
            }
            else {
                printf("\nERRO SINTATICO: CADEIA INCOMPLETA");
            }
        }
        else {
            error(ERROR_EAT, t);
        }
    }
}

void E();
void L();

void S() {
    switch(token) {
        case IF:
            eat(IF);
            E();
            eat(THEN);
            S();
            eat(ELSE);
            S();
            break;
        
        case BEGIN:
            eat(BEGIN);
            S();
            L();
            break;
        
        case PRINT:
            eat(PRINT);
            E();
            break;
        
        default:
            error(ERROR_S, 0);
            break;
    }
}

void L() {
    switch(token) {
        case END:
            eat(END);
            break;

        case SEMI:
            eat(SEMI);
            S();
            L();
            break;
        
        default:
            error(ERROR_L, 0);
            break;
    }
}

void E() {
    switch(token) {
        case NUM:
            eat(NUM);
            eat(EQ);
            eat(NUM);
            break;
        
        default:
            error(ERROR_E, 0);
            break;
    }
}

int main() {
    token = getToken();
    char c;
    do {
        S();

        if(!errorBool) {
            if(first) {
                printf("CADEIA ACEITA");
                first = false;
            }
            else {
                printf("\nCADEIA ACEITA");
            }
        }
        else {
            errorBool = false;
        }

        while(true) {           //Avança até o final da linha
            c = getc(stdin);

            if(c == '\n' || feof(stdin)) {
                break;
            }
        }

        advance();

    } while(!feof(stdin));

    return 0;
}