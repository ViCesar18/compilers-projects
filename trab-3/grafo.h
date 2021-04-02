#ifndef GRAFO_H
#define GRAFO_H

#include <stdbool.h>
#include "pilha.h"

typedef void* Grafo;
typedef void* Vertice;

// Retorna o id de um vértice
int getVerticeId(Vertice *v);

// Retorna o spill de um vértice
bool getVerticeSpill(Vertice *v);

// Retorna o número atual de vertices de um grafo
int getNumeroVerticesAtual(Grafo *g);

// Inicializa e retorna um grafo
Grafo iniciarGrafo(Pilha pilha_registradores_logicos);

// Insere uma aresta no grafo
void inserirAresta(Grafo *g, int origem, int destino);

// Imprime a matriz de adjacência
void imprimirAdjacencias(Grafo *g);

// Libera a memória alocada para o grafo
void destruirGrafo(Grafo g);

// Busca o vértice que possui o menor grau
Vertice buscarVerticeMenorGrau(Grafo g, int k);

// Remove um vértice do grafo
void removerVertice(Grafo g, int id);

// Insere um vértice no grafo
void pintarVertice(Grafo *g, int id, int cor);

// Ajustas as adjacências do vértice que vai ser pintado
void ajustarAdjacencias(Grafo g, int id);

// Retorna a próxima cor livre para pintar o vértice id, ou -1 caso não haja mais cores
int getCorLivre(Grafo *g, int id, int k);

#endif