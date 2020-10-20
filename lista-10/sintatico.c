#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include "lexico.h"

enum errorCode {ERROR_S, ERROR_E, ERROR_E_PRIME, ERROR_T, ERROR_T_PRIME, ERROR_F};

bool first = true, breakLine = false, errorBool = false;

void advance() {
    do {
        token = getToken();
        printf("%d\n", token);
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
    } while(!feof(stdin));
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
            //error(ERROR_EAT, t);
        }
    }
}

void error(int errorCode) {
    char receivedToken[10];

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
    }

    if(errorCode == ERROR_S || ERROR_E || ERROR_T || ERROR_F) {
        if(first) {
            printf("ERRO SINTATICO EM: %s ESPERADO: id, (", receivedToken);
            first = false;
        }
        else {
            printf("\nERRO SINTATICO EM: %s ESPERADO: id, (", receivedToken);
        }
    }
    else if(errorCode == ERROR_E_PRIME) {
        if(first) {
            printf("ERRO SINTATICO EM: %s ESPERADO: +, ), $", receivedToken);
            first = false;
        }
        else {
            printf("\nERRO SINTATICO EM: %s ESPERADO: +, ), $", receivedToken);
        }
    }
    else if(errorCode == ERROR_T_PRIME) {
        if(first) {
            printf("ERRO SINTATICO EM: %s ESPERADO: +, *, ), $", receivedToken);
            first = false;
        }
        else {
            printf("\nERRO SINTATICO EM: %s ESPERADO: +, *, ), $", receivedToken);
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

            default: error(ERROR_S); break;
        }
    }
}

void E() {
    if(!errorBool) {
        switch(token) {
            case ID:
            case L_BRACKET: T(); Eprime(); break;

            default: error(ERROR_E); break;
        }
    }
}

void Eprime() {
    if(!errorBool) {
        switch(token) {
            case PLUS: eat(PLUS); T(); Eprime(); break;

            case R_BRACKET:
            case END_OF_FILE: break;

            default: error(ERROR_E_PRIME); break;
        }
    }
}

void T() {
    if(!errorBool) {
        switch(token) {
            case ID:
            case L_BRACKET: F(); Tprime(); break;

            default: error(ERROR_T); break;
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

            default: error(ERROR_T_PRIME); break;
        }
    }
}

void F() {
    if(!errorBool) {
        switch(token) {
            case ID: eat(ID); break;

            case L_BRACKET: eat(L_BRACKET); E(); eat(R_BRACKET); break;

            default: error(ERROR_F); break;
        }
    }
}

int main() {
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