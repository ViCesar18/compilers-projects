#include <stdio.h>
#include <stdbool.h>
#include "lexico.h"

int getToken() {
    int automaton[][43] = {
                   /*a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  0  1  2  3  4  5  6  7  8  9  +  *  (  )  $ \n  final?*/
        /*State 0*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        /*State 1*/ {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4, 5, 6, 7, 8, 0},
        /*State 2*/ {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 1},  //ID
        /*State 3*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},  //PLUS
        /*State 4*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},  //TIMES
        /*State 5*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},  //L_BRACKET
        /*State 6*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},  //R_BRACKET
        /*State 7*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},  //END OF FILE
        /*State 8*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},  //QUEBRA DE LINHA
    };

    int currentState = 1, lastFinal = 0;
    c = getc(stdin);
    
    while(true) {
        int column;

        do {
            if(c >= 'a' && c <= 'z') {
                column = 'a' - 97;
            }
            else if(c >= '0' && c <= '9') {
                column = 26 + '0' - 48;
            }
            else if(c == '+') {
                column = 36;
            }
            else if(c == '*') {
                column = 37;
            }
            else if(c == '(') {
                column = 38;
            }
            else if(c == ')') {
                column = 39;
            }
            else if(c == '$') {
                column = 40;
            }
            else if(c == '\n') {
                column = 41;
            }
            else if(c == ' ') {
                if(automaton[currentState][42]) {
                    column = -1;
                }
                else {
                    column = -2;
                    c = getc(stdin);
                }
            }
            else {
                column = -1;
            }
        } while(column == -2);

        int nextState;
        if(column == -1) {
            nextState = 0;
        }
        else {
            nextState = automaton[currentState][column];
        }

        if(nextState == 0) {
            if(!feof(stdin) && automaton[currentState][42]){  //Caso termine de ler a cadeia, mas não seja o final do arquivo e
                fseek(stdin, -1, SEEK_CUR);                   //nem um estado não final, volta um caractere na entrada padrão
            }

            switch(currentState) {
                case 2:
                    return ID;
                case 3:
                    return PLUS;
                case 4:
                    return TIMES;
                case 5:
                    return L_BRACKET;
                case 6:
                    return R_BRACKET;
                case 7:
                    return END_OF_FILE;
                case 8:
                    return BL;
                default:
                    return ERROR;
            }
        }
        else {
            c = getc(stdin);
        }

        currentState = nextState;
        if(automaton[currentState][42]) {
            lastFinal = currentState;
        }
    }
}