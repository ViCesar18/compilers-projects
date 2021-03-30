#ifndef GRAFO_H
#define GRAFO_H

typedef void* Grafo;

// Inicializa e retorna um grafo
Grafo iniciarGrafo(int n);

// Insere uma aresta no grafo
void inserirAresta(Grafo *g, int origem, int destino);

// Imprime a matriz de adjacência
void imprimirAdjacencias(Grafo *g);

// Libera a memória alocada para o grafo
void destruirGrafo(Grafo *g);

#endif