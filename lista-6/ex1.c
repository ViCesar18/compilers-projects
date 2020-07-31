#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

int main() {
    int automaton[][21] = {
                   /* a   c   e   h   i   r   s   t   0   1   2   3   4   5   6   7   8   9   +   -  final? */
       /*State  0*/ { 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0},
       /*State  1*/ { 0, 11,  0,  2,  0,  0,  4,  0, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 17, 18,  0},
       /*State  2*/ { 0,  0,  3,  0,  7,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0},
       /*State  3*/ { 0,  0,  0,  0,  0,  9,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1},
       /*State  4*/ { 0,  0,  0,  5,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0},
       /*State  5*/ { 0,  0,  6,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0},
       /*State  6*/ { 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1},
       /*State  7*/ { 0,  0,  0,  0,  0,  0,  8,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0},
       /*State  8*/ { 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1},
       /*State  9*/ { 0,  0,  0,  0,  0,  0, 10,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0},
       /*State 10*/ { 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1},
       /*State 11*/ {12,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0},
       /*State 12*/ { 0,  0,  0,  0,  0, 14,  0, 13,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0},
       /*State 13*/ { 0,  0,  0,  0,  0,  0, 15,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1},
       /*State 14*/ { 0,  0,  0,  0,  0,  0, 16,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1},
       /*State 15*/ { 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1},
       /*State 16*/ { 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1},
       /*State 17*/ { 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1},
       /*State 18*/ { 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1},
       /*State 19*/ { 0,  0, 20,  0,  0,  0,  0,  0, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19,  0,  0,  1},
       /*State 20*/ { 0,  0,  0,  0,  0,  0,  0,  0, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 21, 21,  0},
       /*State 21*/ { 0,  0,  0,  0,  0,  0,  0,  0, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22,  0,  0,  0},
       /*State 22*/ { 0,  0,  0,  0,  0,  0,  0,  0, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22,  0,  0,  1}
    };

    char *subString;
    int fLength;
    bool first = true;

    fseek(stdin, 0, SEEK_END);
    fLength = ftell(stdin);
    rewind(stdin);

    subString = (char *) calloc(fLength, sizeof(char)); // Aloca o espaço necessário para a subString

    char c;
    int lastFinal = 0, currentState = 1, i = 0;

    c = getc(stdin);

    while(true) {
        int column;

        if(c >= '0' && c <= '9') {  // Verifica qual é o char lido para designar a sua respectiva coluna na matriz do autômato
            column = c - '0' + 8;
        }
        else if(c == 'a')
            column = 0;
        else if(c == 'c')
            column = 1;
        else if(c == 'e')
            column = 2;
        else if(c == 'h')
            column = 3;
        else if(c == 'i')
            column = 4;
        else if(c == 'r')
            column = 5;
        else if(c == 's')
            column = 6;
        else if(c == 't')
            column = 7;
        else if(c == '+')
            column = 18;
        else if(c == '-')
            column = 19;
        else {
            column = -1;
        }

        int nextState;
        if(column == -1){
            nextState = 0;
        }
        else {
            nextState = automaton[currentState][column];
        }

        //printf("(%c)%d = [%d][%d]\n", c, nextState, currentState, column);    // debug

        if(nextState == 0) {    // Caso o próximo estado seja 0 significa que a subString foi completamente lida
            if(lastFinal != 0) {                // Condional que verifica se a subString passou por algum token válido por mais
                if(lastFinal != currentState) { // que tenha finalizado em um estado não final
                    subString[i - 1] = '\0';
                    currentState = lastFinal;
                    if(c != -1)
                        fseek(stdin, -2, SEEK_CUR);
                    else
                        fseek(stdin, -1, SEEK_CUR);
                    c = getc(stdin);
                }
            }

            switch(currentState) {      // Verifica em qual estado a subString finalizou para printar seu devido token
                case 3:
                    first ? printf("ELE") : printf("\nELE");
                    break;
                case 6:
                    first ? printf("ELA") : printf("\nELA");
                    break;
                case 8:
                    first ? printf("DELE") : printf("\nDELE");
                    break;
                case 10:
                    first ? printf("DELA") : printf("\nDELA");
                    break;
                case 13:
                    first ? printf("GATO") : printf("\nGATO");
                    break;
                case 14:
                    first ? printf("CARRO") : printf("\nCARRO");
                    break;
                case 15:
                    first ? printf("GATOS") : printf("\nGATOS");
                    break;
                case 16:
                    first ? printf("CARROS") : printf("\nCARROS");
                    break;
                case 17:
                    first ? printf("MAIS") : printf("\nMAIS");
                    break;
                case 18:
                    first ? printf("MENOS") : printf("\nMENOS");
                    break;
                case 19:
                    first ? printf("INTEIRO ") : printf("\nINTEIRO ");
                    break;
                case 22:
                    first ? printf("REAL ") : printf("\nREAL ");
                    break;
                default:
                    // Não trata como ERRO se o c for espaço, \n ou \r e a subString esteja vazia
                    if((c != ' ' && c != '\n' && c != '\r') || ((c == ' ' || c == '\n' || c == '\r') && i != 0)) {
                        first ? printf("ERRO") : printf("\nERRO");

                        if(column != -1) {  //  c está no alfabeto do autômato
                            c = getc(stdin);
                        }

                        if(feof(stdin))
                            break;

                        fseek(stdin, -(strlen(subString) + 1), SEEK_CUR);   // Volta o tamanho da subString no arquivo para fazer a verificação
                        c = getc(stdin);                                    // nos outros caracteres dela
                        memset(subString, 0, sizeof(subString));
                    }

                    break;
            }
            first = false;

            if(currentState == 19 || currentState == 22) {  // Se o token for REAL ou INTEIRO printa a subString junto com o token
                subString[i] = '\0';
                printf("%s", subString);
            }
            if(column == -1 && strlen(subString) == 0) {    // Caso o caractere lido seja inválido e o token atual tenha sido ERRO, lê o próximo
                c = getc(stdin);
            }

            memset(subString, 0, sizeof(subString));
            i = 0;

            lastFinal = 0;
            currentState = 1;

            if(feof(stdin))
                break;

            continue;
        }
        else {  // subString ainda não foi completamente lida, coloca c na subString e lê o próximo caractere do arquivo
            subString[i] = c;
            i++;
            c = getc(stdin);
        }

        currentState = nextState;   // Atualização do estado atual e do último estado final percorrido
        if(automaton[currentState][20] == 1) {
            lastFinal = currentState;
        }
    }

    return 0;
}