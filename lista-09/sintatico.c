#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include "lexico.h"

enum errorCode {ERROR_EAT, ERROR_S, ERROR_L, ERROR_E};

bool first = true, breakLine = false, errorBool = false;

void advance() {
    do {
        token = getToken();
    } while(token == -1 && !feof(stdin));
}

void error(int error, int t) {
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
        else if(token == -1 || token == BL) {
            if(token == BL) {
                eat(BL);
            }

            errorBool = true;
            breakLine = true;

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
    if(!errorBool) {
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
}

void L() {
    if(!errorBool) {
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
}

void E() {
    if(!errorBool) {
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
}

int main() {
    errorBool = false;
    token = getToken();

    do {
        S();

        if(errorBool && !breakLine) {               //Avança até o final da linha caso a cadeia anterior tenha sido um erro e pega o primeiro
            while(token != BL && !feof(stdin)) {    //token da próxima linha
                advance();
            }
            advance();
        }

        if(!errorBool) {
            if(first) {
                printf("CADEIA ACEITA");
                first = false;
            }
            else {
                printf("\nCADEIA ACEITA");
            }

            if(!feof(stdin)) {      //Come a quebra de linha
                eat(BL);
            }
        }
        else {
            errorBool = false;
        }

        breakLine = false;
    } while(!feof(stdin));

    return 0;
}