#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

int main() {
    int automaton[][39] = {
                   /*a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  0  1  2  3  4  5  6  7  8  9  +  - Final?*/
        /*state 0*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        /*state 1*/ {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 3, 4, 0},
        /*state 2*/ {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 1},
        /*state 3*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        /*state 4*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        /*state 5*/ {0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1},
        /*state 6*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 7, 7, 0},
        /*state 7*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0},
        /*state 8*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 1}
    };

    char *subString;
    int fLength;

    fseek(stdin, 0, SEEK_END);
    fLength = ftell(stdin);
    rewind(stdin);

    subString = (char *) malloc(sizeof(char) * fLength);

    int lastFinal = 0, currentState = 1, i = 0;
    char c = fgetc(stdin);

    while(true){
        int column;

        if(c >= '0' && c <= '9') {
            column = c - '0' + 26;  //+26 para ajustar na matriz do automato
        }
        else if(c >= 'a' && c <= 'z' ) {
            column = c - 'a';
        }
        else if(c == '+') {
            column = 36;
        }
        else if(c == '-') {
            column = 37;
        }
        else if(c == '\n') {
            if(i > 0) { //Caso a substring seja só uma quebra de linha, ignora (não entra no if)
                if(currentState != 1 && currentState != 6 && currentState != 7) {
                    subString[i] = '\0';
                    puts(subString);
                }
                else {
                    printf("Cadeia nao aceita!\n");
                }
                memset(subString, 0, sizeof(subString));
                i = 0;
            }

            currentState = 1;
            lastFinal = 0;

            c = fgetc(stdin);

            if(feof(stdin))
                break;
            continue;
        }
        else if (c == '\r') {
            c = getc(stdin);
            continue;
        }
        else {  //Caso o caractere lido não esteja no alfabeto
            column = -1;
        }
        
        int nextState;
        if(column == -1)    //Leu algum caractere que não está no alfabeto do autômato
            nextState = 0;
        else {
            nextState = automaton[currentState][column];
        }

        if(nextState == 0) {    //Terminou de ler a cadeia => printa a substring (ou ERRO caso a coluna seja -1)
            if(column != -1 || currentState != 1) {
                if(currentState != 1 && currentState != 6 && currentState != 7) {
                    subString[i] = '\0';
                    puts(subString);
                }
                else {
                    printf("Cadeia nao aceita!\n");
                }
                memset(subString, 0, sizeof(subString));
                i = 0;

                currentState = 1;
                lastFinal = 0;
            }

            if(column == -1 && !feof(stdin)) {
                printf("ERRO\n");
                c = fgetc(stdin);
            }

            if(feof(stdin))
                break;
            continue;
        }
        else {  //Não terminou de ler a cedeia => adiciona o caractere atual na substring e lê o próximo caractere
            subString[i] = c;
            i++;
            c = fgetc(stdin);
        }

        //Ajusta o último estado final percorrido
        currentState = nextState;
        if(automaton[currentState][38] == 1) {
            lastFinal = currentState;
        }
    }

    return 0;
}