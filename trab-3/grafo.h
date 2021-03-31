#ifndef GRAFO_H
#define GRAFO_H

#include <stdbool.h>

typedef void* Grafo;
typedef void* Vertice;

// Retorna o id de um vértice
int getVerticeId(Vertice *v);

// Retorna o spill de um vértice
bool getVerticeSpill(Vertice *v);

// Retorna o número atual de vertices de um grafo
int getNumeroVerticesAtual(Grafo *g);

// Inicializa e retorna um grafo
Grafo iniciarGrafo(int n);

// Insere uma aresta no grafo
void inserirAresta(Grafo *g, int origem, int destino);

// Imprime a matriz de adjacência
void imprimirAdjacencias(Grafo *g);

// Libera a memória alocada para o grafo
void destruirGrafo(Grafo *g);

// Recalcula o grau de todos os vértices
void recalcularGraus(Grafo g);

// Busca o vértice que possui o menor grau
Vertice buscarVerticeMenorGrau(Grafo g, int k);

// Busca um vértice com base no id
Vertice buscarVertice(Grafo g, int id);

// Remove um vértice do grafo
void removerVertice(Grafo g, int id);

// Insere um vértice no grafo
void inserirVertice(Grafo *g, int id);

#endif