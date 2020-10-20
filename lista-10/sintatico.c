#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include "lexico.h"

enum errorCode {ERROR_S, ERROR_E, ERROR_E_PRIME, ERROR_T, ERROR_T_PRIME, ERROR_F, ERROR_EAT};

bool first = true, breakLine = false, errorBool = false;

void advance() {
    do {
        token = getToken();

        if(!errorBool && token == ERROR && !feof(stdin)) {
            if(first) {
                printf("ERRO LEXICO: %c", c);
                first = false;
            }
            else {
                printf("\nERRO LEXICO: %c", c);
            }
            
            errorBool = true;
        }
    } while(token == ERROR && !feof(stdin));
}

void error();

void eat(int t) {
    if(!errorBool) {
        if(token == t) {
            advance();
        }
        /* else if(token == -1 || token == BL) {
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
        } */
        else {
            error(ERROR_EAT, t);
        }
    }
}

void error(int errorCode, int t) {
    char receivedToken[10], expectedToken[10];
    bool invalidToken = false;

    errorBool = true;

    switch(token) {
        case ID:
            strcpy(receivedToken, "id");
            break;
        case PLUS:
            strcpy(receivedToken, "+");
            break;
        case TIMES:
            strcpy(receivedToken, "*");
            break;
        case L_BRACKET:
            strcpy(receivedToken, "(");
            break;
        case R_BRACKET:
            strcpy(receivedToken, ")");
            break;
        case END_OF_FILE:
            strcpy(receivedToken, "$");
            break;
        default:
            invalidToken = true;
            break;
    }

    if(errorCode == ERROR_S || errorCode ==  ERROR_E || errorCode ==  ERROR_T || errorCode ==  ERROR_F) {
        if(!invalidToken) {
            if(first) {
                printf("ERRO SINTATICO EM: %s ESPERADO: id, (", receivedToken);
                first = false;
            }
            else {
                printf("\nERRO SINTATICO EM: %s ESPERADO: id, (", receivedToken);
            }
        }
        else {
            if(first) {
                printf("ERRO SINTATICO EM: ESPERADO: id, (");
                first = false;
            }
            else {
                printf("\nERRO SINTATICO EM: ESPERADO: id, (");
            }
        }
    }
    else if(errorCode == ERROR_E_PRIME) {
        if(!invalidToken) {
            if(first) {
                printf("ERRO SINTATICO EM: %s ESPERADO: +, ), $", receivedToken);
                first = false;
            }
            else {
                printf("\nERRO SINTATICO EM: %s ESPERADO: +, ), $", receivedToken);
            }
        }
        else {
            if(first) {
                printf("ERRO SINTATICO EM: ESPERADO: +, ), $");
                first = false;
            }
            else {
                printf("\nERRO SINTATICO EM: ESPERADO: +, ), $");
            }
        }
    }
    else if(errorCode == ERROR_T_PRIME) {
        if(!invalidToken) {
            if(first) {
                printf("ERRO SINTATICO EM: %s ESPERADO: +, *, ), $", receivedToken);
                first = false;
            }
            else {
                printf("\nERRO SINTATICO EM: %s ESPERADO: +, *, ), $", receivedToken);
            }
        }
        else {
            if(first) {
                printf("ERRO SINTATICO EM: ESPERADO: +, *, ), $");
                first = false;
            }
            else {
                printf("\nERRO SINTATICO EM: ESPERADO: +, *, ), $");
            }
        }
    }
    else if(errorCode == ERROR_EAT) {
        switch(t) {
            case ID:
                strcpy(expectedToken, "id");
                break;
            case PLUS:
                strcpy(expectedToken, "+");
                break;
            case TIMES:
                strcpy(expectedToken, "*");
                break;
            case L_BRACKET:
                strcpy(expectedToken, "(");
                break;
            case R_BRACKET:
                strcpy(expectedToken, ")");
                break;
            case END_OF_FILE:
                strcpy(expectedToken, "$");
                break;
        }

        if(!invalidToken) {
            if(first) {
                printf("ERRO SINTATICO EM: %s ESPERADO: %s", receivedToken, expectedToken);
                first = true;
            }
            else {
                printf("\nERRO SINTATICO EM: %s ESPERADO: %s", receivedToken, expectedToken);
            }
        }
        else {
            if(first) {
                printf("ERRO SINTATICO EM: ESPERADO: %s", expectedToken);
                first = true;
            }
            else {
                printf("\nERRO SINTATICO EM: ESPERADO: %s", expectedToken);
            }
        }
    }
}

void E();
void T();
void Eprime();
void Tprime();
void F();

void S() {
    if(!errorBool) {
        switch(token) {
            case ID: 
            case L_BRACKET: E(); eat(END_OF_FILE); break;

            default: error(ERROR_S, 0); break;
        }
    }
}

void E() {
    if(!errorBool) {
        switch(token) {
            case ID:
            case L_BRACKET: T(); Eprime(); break;

            default: error(ERROR_E, 0); break;
        }
    }
}

void Eprime() {
    if(!errorBool) {
        switch(token) {
            case PLUS: eat(PLUS); T(); Eprime(); break;

            case R_BRACKET:
            case END_OF_FILE: break;

            default: error(ERROR_E_PRIME, 0); break;
        }
    }
}

void T() {
    if(!errorBool) {
        switch(token) {
            case ID:
            case L_BRACKET: F(); Tprime(); break;

            default: error(ERROR_T, 0); break;
        }
    }
}

void Tprime() {
    if(!errorBool) {
        switch(token) {
            case TIMES: eat(TIMES); F(); Tprime(); break;

            case PLUS:
            case R_BRACKET:
            case END_OF_FILE: break;

            default: error(ERROR_T_PRIME, 0); break;
        }
    }
}

void F() {
    if(!errorBool) {
        switch(token) {
            case ID: eat(ID); break;

            case L_BRACKET: eat(L_BRACKET); E(); eat(R_BRACKET); break;

            default: error(ERROR_F, 0); break;
        }
    }
}

int main() {
    token = getToken();

    do {
        S();

        while(token != BL && !feof(stdin)) { //Avança até o final da linha
            advance();
        }
        advance();

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

        breakLine = false;
    } while(!feof(stdin));

    return 0;
}