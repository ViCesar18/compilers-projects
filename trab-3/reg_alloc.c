#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include "grafo.h"
#include "pilha.h"

int main() {
    int graph_number, k;
    bool *sucesso;
    Pilha pilha_registradores_logicos = iniciarPilha();

    // Lê o maior e o menor registrador lógico
    fscanf(stdin, "Grafo %d:\n", &graph_number);
    fscanf(stdin, "K=%d\n", &k);

    sucesso = malloc((k + 1) * sizeof(bool));

    while(!feof(stdin)) {
        int registrador_logico, registrador_des;
        fscanf(stdin, "%d -->", &registrador_logico);

        while(1) {
            char c = getc(stdin);
            if(c == '\n' || feof(stdin)) {
                break;
            }
            fseek(stdin, -1, SEEK_CUR);
            fscanf(stdin, "%d", &registrador_des);
        }

        push(pilha_registradores_logicos, registrador_logico);
    }
    rewind(stdin);

    Grafo grafo = iniciarGrafo(pilha_registradores_logicos);
    destruirPilha(pilha_registradores_logicos);

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
                break;
            }

            fseek(stdin, -1, SEEK_CUR);

            fscanf(stdin, "%d", &registrador_des);
            inserirAresta(grafo, registrador_origem, registrador_des);
        }
    }
    
    printf("Graph %d -> Physical Registers: %d\n", graph_number, k);
    printf("----------------------------------------\n");

    bool flgPrint = true;
    for(int i = k; i >= 2; i--) {
        printf("----------------------------------------\n");
        printf("K = %d\n\n", i);

        // Simplify
        Pilha pilha = iniciarPilha();
        while(getNumeroVerticesAtual(grafo) != 0) {
            Vertice *v = buscarVerticeMenorGrau(grafo, i);

            if(getVerticeSpill(v)) {
                printf("Push: %d *\n", getVerticeId(v));
            } else {
                printf("Push: %d\n", getVerticeId(v));
            }
            push(pilha, getVerticeId(v));
            removerVertice(grafo, getVerticeId(v));
        }

        // Select/Assign
        while(getPilhaTamanho(pilha) != 0) {
            int id = pop(pilha);

            ajustarAdjacencias(grafo, id);

            int cor_livre = getCorLivre(grafo, id, i);

            if(flgPrint) {
                if(cor_livre == -1) {
                    printf("Pop: %d -> NO COLOR AVAILABLE\n", id);
                    flgPrint = false;
                    sucesso[i] = false;
                } else {
                    printf("Pop: %d -> %d\n", id, cor_livre);
                    sucesso[i] = true;
                }
            }
            
            pintarVertice(grafo, id, cor_livre);
        }

        destruirPilha(pilha);
        flgPrint = true;
    }

    printf("----------------------------------------\n");
    printf("----------------------------------------\n");
    for(int i = k; i >= 2; i--) {
        if(i < 10) {
            if(sucesso[i]) {
                printf("Graph %d -> K =  %d: Successful Allocation", graph_number, i);
            } else {
                printf("Graph %d -> K =  %d: SPILL", graph_number, i);
            }
        } else {
            if(sucesso[i]) {
                printf("Graph %d -> K = %d: Successful Allocation", graph_number, i);
            } else {
                printf("Graph %d -> K = %d: SPILL", graph_number, i);
            }
        }

        if(i != 2) {
            printf("\n");
        }
    }

    destruirGrafo(grafo);
    free(sucesso);

    return 0;
}