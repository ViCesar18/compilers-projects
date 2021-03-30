#include <stdio.h>
#include <stdlib.h>
#include "grafo.h"

typedef struct vertice {
    int index;
    int id;
    int cor;
} Vertice;

typedef struct grafo {
    int **adjacencia;
    int numero_vertices;
    Vertice *vertices;
} GrafoImp;

Grafo iniciarGrafo(int n) {
    GrafoImp *g = (GrafoImp *) malloc(sizeof(struct grafo));

    g->numero_vertices = n;

    g->adjacencia = (int **) calloc(n, sizeof(int *));
    g->vertices = (Vertice *) malloc(n * sizeof(struct vertice));
    for(int i = 0; i < n; i++) {
        g->adjacencia[i] = (int *) calloc(n, sizeof(int));

        g->vertices[i].index = i;
        g->vertices[i].id = i + 32;
        g->vertices[i].cor = -1;
    }

    return g;
}

void inserirAresta(Grafo *g, int origem, int destino) {
    GrafoImp *grafo = (GrafoImp *) g;

    grafo->adjacencia[origem][destino] = 1;
}

void imprimirAdjacencias(Grafo *g) {
    GrafoImp *grafo = (GrafoImp *) g;

    for(int i = 0; i < grafo->numero_vertices; i++) {
        printf("%d: ", i);
        for(int j = 0; j < grafo->numero_vertices; j++) {
            printf("%d ", grafo->adjacencia[i][j]);
        }
        printf("\n");
    }
}

void destruirGrafo(Grafo *g) {
    GrafoImp *grafo = (GrafoImp *) g;

    for(int i = 0; i < grafo->numero_vertices; i++) {
        free(grafo->adjacencia[i]);
    }

    free(grafo->adjacencia);
    free(grafo->vertices);
    free(grafo);
}