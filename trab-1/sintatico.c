#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include "lexico.h"

extern int lineNumber;
extern int columnNumber;

void advance() {
    do {
        token = getToken();
    } while(token == COMMENT);  //Recebe o próximo token (menos comentário)
}

void eat(int t) {
    if(token == t) {
        advance();
    }
    else {
        if(columnNumber == 1) { //Caso o erro tenha ocorrido no último token da linha
            lineNumber--;
        }

        printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString);
        exit(1);
    }
}

void eatLast(int t) {
    if(columnNumber == 1) { //Caso o erro tenha ocorrido no último token da linha
        lineNumber--;
    }
    
    if(token != t) {
        printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString);
        exit(1);
    }
}

void P();
void B();
void BV();
void Bprime();
void LBV();
void T();
void Tprime();
void PF();
void PV();
void LPF();
void V();
void COM();
void COMprime();
void ECOM();
void EX();
void EXprime();
void OP();
void EXS();
void LEXS();
void SG();
void TERM();
void LTERM();
void F();
void Fprime();
void Fprime2();
void CONS();
void LID();
void LCOM();
void LT();
void LEX();

void S() {
    switch(token) {
        case PROGRAM: P(); break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void P() {
    switch(token) {
        case PROGRAM: eat(PROGRAM); eat(ID); eat(SEMICOLON); B(); eatLast(DOT); break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void B() {
    switch(token) {
        case VAR:
        case PROCEDURE:
        case FUNCTION:
        case BEGIN: BV(); Bprime(); eat(BEGIN); COM(); LCOM(); eat(END); break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void BV() {
    switch(token) {
        case VAR: eat(VAR); eat(ID); LID(); eat(COLON); T(); eat(SEMICOLON); LBV(); break;

        case PROCEDURE:
        case FUNCTION:
        case BEGIN: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void Bprime() {
    switch(token) {
        case PROCEDURE: eat(PROCEDURE); eat(ID); PF(); eat(SEMICOLON); B(); eat(SEMICOLON); Bprime(); break;

        case FUNCTION: eat(FUNCTION); eat(ID); PF(); eat(COLON); eat(ID); eat(SEMICOLON); B(); eat(SEMICOLON); Bprime(); break;

        case BEGIN: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void LBV() {
    switch(token) {
        case ID: eat(ID); LID(); eat(COLON); T(); eat(SEMICOLON); LBV(); break;

        case PROCEDURE:
        case FUNCTION:
        case BEGIN: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void T() {
    switch(token) {
        case ID: eat(ID); Tprime(); break;

        case ARRAY: eat(ARRAY); eat(L_RECT_BRACKET); T(); LT(); eat(R_RECT_BRACKET); eat(OF); T(); break;

        case PLUS:
        case MINUS:
        case NUM: SG(); eat(NUM); eat(DOUBLE_DOT); CONS(); break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void Tprime() {
    switch(token) {
        case DOUBLE_DOT: eat(DOUBLE_DOT); CONS(); break;

        case SEMICOLON:
        case R_RECT_BRACKET:
        case COMMA: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void PF() {
    switch(token) {
        case L_BRACKET: eat(L_BRACKET); PV(); eat(ID); LID(); eat(COLON); eat(ID); LPF(); eat(R_BRACKET); break;

        case SEMICOLON:
        case COLON: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void PV() {
    switch(token) {
        case VAR: eat(VAR); break;

        case ID: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void LPF() {
    switch(token) {
        case SEMICOLON: eat(SEMICOLON); PV(); eat(ID); LID(); eat(COLON); eat(ID); LPF(); break;

        case R_BRACKET: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void V() {
    switch(token) {
        case L_RECT_BRACKET: eat(L_RECT_BRACKET); EX(); LEX(); eat(R_RECT_BRACKET); V(); break;

        case SEMICOLON:
        case END:
        case R_RECT_BRACKET:
        case R_BRACKET:
        case ASSIGNMENT:
        case THEN:
        case DO:
        case EQUAL:
        case DIFFERENT:
        case LESS_THAN:
        case LESS_EQUAL:
        case GREATER_EQUAL:
        case GREATER_THAN:
        case PLUS:
        case MINUS:
        case OR:
        case ASTERISK:
        case DIV:
        case AND:
        case COMMA: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void COM() {
    switch(token) {
        case ID: eat(ID); COMprime(); break;

        case BEGIN: eat(BEGIN); COM(); LCOM(); eat(END); break;

        case IF: eat(IF); EX(); eat(THEN); eat(BEGIN); COM(); LCOM(); eat(END); ECOM(); break;

        case WHILE: eat(WHILE); EX(); eat(DO); COM(); break;

        case SEMICOLON:
        case END: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void COMprime() {
    switch(token) {
        case L_RECT_BRACKET:
        case ASSIGNMENT: V(); eat(ASSIGNMENT); EX(); break;

        case L_BRACKET: eat(L_BRACKET); EX(); LEX(); eat(R_BRACKET); break;

        case SEMICOLON:
        case END: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void ECOM() {
    switch(token) {
        case ELSE: eat(ELSE); eat(BEGIN); COM(); LCOM(); eat(END); break;

        case SEMICOLON:
        case END: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void EX() {
    switch(token) {
        case ID:
        case L_BRACKET:
        case PLUS:
        case MINUS:
        case NUM:
        case NOT: EXS(); EXprime(); break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void EXprime() {
    switch(token) {
        case EQUAL:
        case DIFFERENT:
        case LESS_THAN:
        case LESS_EQUAL:
        case GREATER_EQUAL:
        case GREATER_THAN: OP(); EXS(); break;

        case SEMICOLON:
        case END:
        case R_RECT_BRACKET:
        case R_BRACKET:
        case THEN:
        case DO:
        case COMMA: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void OP() {
    switch(token) {
        case EQUAL: eat(EQUAL); break;

        case DIFFERENT: eat(DIFFERENT); break;

        case LESS_THAN: eat(LESS_THAN); break;

        case LESS_EQUAL: eat(LESS_EQUAL); break;

        case GREATER_EQUAL: eat(GREATER_EQUAL); break;

        case GREATER_THAN: eat(GREATER_THAN); break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void EXS() {
    switch(token) {
        case ID:
        case L_BRACKET:
        case PLUS:
        case MINUS:
        case NUM:
        case NOT: SG(); TERM(); LEXS(); break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void LEXS() {
    switch(token) {
        case PLUS: eat(PLUS); TERM(); LEXS(); break;

        case MINUS: eat(MINUS); TERM(); LEXS(); break;

        case OR: eat(OR); TERM(); LEXS(); break;

        case SEMICOLON:
        case END:
        case R_RECT_BRACKET:
        case R_BRACKET:
        case THEN:
        case DO:
        case EQUAL:
        case DIFFERENT:
        case LESS_THAN:
        case LESS_EQUAL:
        case GREATER_EQUAL:
        case GREATER_THAN:
        case COMMA: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void SG() {
    switch(token) {
        case PLUS: eat(PLUS); break;

        case MINUS: eat(MINUS); break;

        case ID:
        case L_BRACKET:
        case NUM:
        case NOT: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void TERM() {
    switch(token) {
        case ID:
        case L_BRACKET:
        case NUM:
        case NOT: F(); LTERM(); break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void LTERM() {
    switch(token) {
        case ASTERISK: eat(ASTERISK); F(); LTERM(); break;

        case DIV: eat(DIV); F(); LTERM(); break;

        case AND: eat(AND); F(); LTERM(); break;

        case SEMICOLON:
        case END:
        case R_RECT_BRACKET:
        case R_BRACKET:
        case THEN:
        case DO:
        case EQUAL:
        case DIFFERENT:
        case LESS_THAN:
        case LESS_EQUAL:
        case GREATER_EQUAL:
        case GREATER_THAN:
        case PLUS:
        case MINUS:
        case OR:
        case COMMA: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void F() {
    switch(token) {
        case ID: eat(ID); Fprime(); break;

        case L_BRACKET: eat(L_BRACKET); EX(); eat(R_BRACKET); break;

        case NUM: eat(NUM); break;

        case NOT: eat(NOT); F(); break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void Fprime() {
    switch(token) {
        case SEMICOLON:
        case END:
        case L_RECT_BRACKET:
        case R_RECT_BRACKET:
        case R_BRACKET:
        case THEN:
        case DO:
        case EQUAL:
        case DIFFERENT:
        case LESS_THAN:
        case LESS_EQUAL:
        case GREATER_EQUAL:
        case GREATER_THAN:
        case PLUS:
        case MINUS:
        case OR:
        case ASTERISK:
        case DIV:
        case AND:
        case COMMA: V(); break;

        case L_BRACKET: eat(L_BRACKET); Fprime2(); eat(R_BRACKET); break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void Fprime2() {
    switch(token) {
        case ID:
        case L_BRACKET:
        case PLUS:
        case MINUS:
        case NUM:
        case NOT: EX(); LEX(); break;

        case R_BRACKET: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void CONS() {
    switch(token) {
        case ID: eat(ID); break;

        case PLUS:
        case MINUS:
        case NUM: SG(); eat(NUM); break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void LID() {
    switch(token) {
        case COMMA: eat(COMMA); eat(ID); LID(); break;

        case COLON: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void LCOM() {
    switch(token) {
        case SEMICOLON: eat(SEMICOLON); COM(); LCOM(); break;

        case END: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void LT() {
    switch(token) {
        case COMMA: eat(COMMA); T(); LT(); break;

        case R_RECT_BRACKET: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

void LEX() {
    switch(token) {
        case COMMA: eat(COMMA); EX(); LEX(); break;

        case R_RECT_BRACKET:
        case R_BRACKET: break;

        default: printf("ERRO DE SINTAXE. Linha: %d -> \"%s\"", lineNumber, subString); exit(1); break;
    }
}

int main() {
    allocSubstring();

    token = getToken();

    S();

    printf("PROGRAMA CORRETO.");

    return 0;
}