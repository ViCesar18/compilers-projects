#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

int main() {
    int automaton[][42] = {
                   /*a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  0  1  2  3  4  5  6  7  8  9  .  - \n bl otr final?*/
        /*state 0*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        /*state 1*/ {4, 4, 4, 4, 4, 4, 4, 4, 1, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 5, 9, 0, 12, 13, 0},
        /*state 2*/ {4, 4, 4, 4, 4, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 1},
        /*state 3*/ {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 1},
        /*state 4*/ {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 1},
        /*state 5*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 0, 0, 0, 0, 0, 1},
        /*state 6*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 0, 0, 0, 0, 0, 1},
        /*state 7*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 0, 0, 0, 0, 1},
        /*state 8*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 1},
        /*state 9*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 1},
       /*state 10*/ {10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 0, 0, 0},
       /*state 11*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
       /*state 12*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 0, 1},
       /*state 13*/ {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    };

    FILE *arq = fopen("ex2.txt", "r");
    if(arq == NULL) {
        perror("Erro na leitura do arquivo!\n");
        exit(1);
    }
    char *subString;
    int fLength;

    fseek(arq, 0, SEEK_END);
    fLength = ftell(arq);
    rewind(arq);

    subString = (char *) malloc(sizeof(char) * fLength);

    int lastFinal = 0, currentState = 1, i = 0;
    char readChar;
    char c = fgetc(arq);

    while(true){
        int column;

        if(c >= '0' && c <= '9') {
            column = c - '0' + 26;   //+26 para ajustar na matriz do automato
        }
        else if(c >= 'a' && c <= 'z' ) {
            column = c - 'a';
        }
        else if(c == '.') {
            column = 36;
        }
        else if(c == '-') {
            column = 37;
        }
        else if(c == '\n') {
            column = 38;
        }
        else if(c == ' ') {
            column = 39;
        }
        else if(c == '\r') {
            c = getc(arq);
            continue;
        }
        else {  //Caso o caractere lido seja "other"
            column = 40;
        }
        
        int nextState = automaton[currentState][column];
        if(nextState == 0) {    //Terminou de ler a cadeia => printa a substring seguida do Token que a representa
            subString[i] = '\0';
            if(subString[0] != ' ')
                printf("%s", subString);
            memset(subString, 0, sizeof(subString));
            i = 0;
            
            switch(currentState) {
                case 2:
                    printf("%s\n", " ID");
                    break;
                case 3:
                    printf("%s\n", " IF");
                    break;
                case 4:
                    printf("%s\n", " ID");
                    break;
                case 5:
                    printf("%s\n", " error");
                    break;
                case 6:
                    printf("%s\n", " REAL");
                    break;
                case 7:
                    printf("%s\n", " NUM");
                    break;
                case 8:
                    printf("%s\n", " REAL");
                    break;
                case 9:
                    printf("%s\n", " error");
                    break;
                case 11:
                    printf("%s\n", " comment");
                    break;
                case 12:
                    printf("%s\n", "white space");
                    break;
                case 13:
                    printf("%s\n", " error");
                    break;
                default:    //Finalizou a leitura num estado não final
                    if(c != '\n')   //Ignora o '\n'
                        printf("%s\n", " Cadeia nao aceita!");   //Autômato tentou ler um caractere que o estado não aceita
                    c = fgetc(arq);                             //porém o estado não era final (logo significa que a cadeia não foi aceita)
                    break;
            }

            currentState = 1;
            lastFinal = 0;

            if(feof(arq))
                break;
            continue;
        }
        else {  //Não terminou de ler a cadeia => adiciona o caractere atual na substring e lê o próximo caractere
            if(c != '\n'){
                subString[i] = c;
                i++;
            }
            c = fgetc(arq);
        }

        //Ajusta o ultimo estado final percorrido
        currentState = nextState;
        if(automaton[currentState][38] == 1) {
            lastFinal = currentState;
        }
    }

    return 0;
}