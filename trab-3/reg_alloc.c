#include <stdio.h>
#include "grafo.h"
#include "pilha.h"

int main() {
    int graph_number, k, maior_registrador_logico = -1;

    // Lê o maior registrador lógico
    fscanf(stdin, "Grafo %d:\n", &graph_number);
    fscanf(stdin, "K=%d\n", &k);

    while(!feof(stdin)) {
        int registrador_logico;
        fscanf(stdin, "%d -->", &registrador_logico);

        if(registrador_logico > maior_registrador_logico) {
            maior_registrador_logico = registrador_logico;
        }
    }
    rewind(stdin);

    Grafo grafo = iniciarGrafo(maior_registrador_logico + 1);

    // Lê os dados do grafo
    fscanf(stdin, "Grafo %d:\n", &graph_number);
    fscanf(stdin, "K=%d\n", &k);

    while(!feof(stdin)) {
        int registrador_origem, registrador_des;

        fscanf(stdin, "%d -->", &registrador_origem);
        
        // Lê todos os registradores que estão conflitando com o registrador_des
        while(1) {
            char c = getc(stdin);

            if(c == '\n' || feof(stdin)) {
                printf("\n");
                break;
            }

            fseek(stdin, -1, SEEK_CUR);

            fscanf(stdin, "%d", &registrador_des);

            inserirAresta(grafo, registrador_origem, registrador_des);
        }
    }

    imprimirAdjacencias(grafo);

    destruirGrafo(grafo);

    return 0;
}