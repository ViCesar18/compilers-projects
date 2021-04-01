#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "grafo.h"

typedef struct vertice {
    int id;
    int cor;
    int grau;
    bool spill;
    struct vertice *prox;
} VerticeImp;

typedef struct grafo {
    int **adjacencia_original;
    int **adjacencia;
    int numero_vertices;
    VerticeImp *vertices;
} GrafoImp;

int getVerticeId(Vertice *v) {
    VerticeImp *vertice = (VerticeImp *) v;

    return vertice->id;
}

bool getVerticeSpill(Vertice *v) {
    VerticeImp *vertice = (VerticeImp *) v;

    return vertice->spill;
}

int getGrafoNumeroVertices(Grafo *g) {
    GrafoImp *grafo = (GrafoImp *) g;

    return grafo->numero_vertices;
}

int getNumeroVerticesAtual(Grafo *g) {
    GrafoImp *grafo = (GrafoImp *) g;

    if(grafo->vertices == NULL) {
        return 0;
    } else {
        int count = 1;
        VerticeImp *v = grafo->vertices;
        while(v->prox != NULL) {
            count++;
            v = v->prox;
        }

        return count;
    }
}

Grafo iniciarGrafo(int n) {
    GrafoImp *g = (GrafoImp *) malloc(sizeof(struct grafo));

    g->numero_vertices = n + 1;

    g->adjacencia = (int **) calloc(n, sizeof(int *));
    g->adjacencia_original = (int **) calloc(n, sizeof(int *));
    g->vertices = NULL;
    for(int i = 0; i < n + 1; i++) {
        g->adjacencia[i] = (int *) calloc(n, sizeof(int));
        g->adjacencia_original[i] = (int *) calloc(n, sizeof(int));

        if(i >= 32) {
            VerticeImp *novo_vertice = (VerticeImp *) malloc(sizeof(struct vertice));
            novo_vertice->id = i;
            novo_vertice->cor = -1;
            novo_vertice->grau = 0;
            novo_vertice->spill = false;
            novo_vertice->prox = NULL;

            if(g->vertices == NULL) {
                g->vertices = novo_vertice;
            } else {
                VerticeImp *v = g->vertices;
                while(v->prox != NULL) {
                    v = v->prox;
                }

                v->prox = novo_vertice;
            }
        }
    }

    return g;
}

void inserirAresta(Grafo *g, int origem, int destino) {
    GrafoImp *grafo = (GrafoImp *) g;

    grafo->adjacencia[origem][destino] = 1;
    grafo->adjacencia_original[origem][destino] = 1;

    VerticeImp *v = grafo->vertices;
    while(v != NULL) {
        if(v->id == origem) {
            break;
        }

        v = v->prox;
    }
    v->grau++;
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

void destruirGrafo(Grafo g) {
    GrafoImp *grafo = (GrafoImp *) g;

    for(int i = 0; i < grafo->numero_vertices; i++) {
        free(grafo->adjacencia[i]);
        free(grafo->adjacencia_original[i]);
    }

    VerticeImp *v = grafo->vertices;
    while(v != NULL) {
        VerticeImp *aux = v;
        v = v->prox;
        free(aux);
    }

    free(grafo->adjacencia);
    free(grafo->adjacencia_original);
    free(grafo);
}

void recalcularGraus(Grafo g) {
    GrafoImp *grafo = (GrafoImp *) g;

    VerticeImp *v = grafo->vertices;
    int count = 0;
    
    while(v != NULL) {
        for(int i = 0; i < grafo->numero_vertices; i++) {
            if(grafo->adjacencia[v->id][i] == 1) {
                count++;
            }
        }
        v->grau = count;
        count = 0;
        v = v->prox;
    }
}

Vertice buscarPotencialSpill(Grafo g) {
    GrafoImp *grafo = (GrafoImp *) g;
    int maior_grau = -1;
    int menor_id = __INT_MAX__;
    VerticeImp *vertice_potencial_spill = NULL;

    VerticeImp *v = grafo->vertices;
    while(v != NULL) {
        if((v->grau > maior_grau) || (v->grau == maior_grau && v->id < menor_id)) {
            vertice_potencial_spill = v;
            maior_grau = v->grau;
            menor_id = v->id;
        }
        v = v->prox;
    }

    return vertice_potencial_spill;
}

Vertice buscarVerticeMenorGrau(Grafo g, int k) {
    GrafoImp *grafo = (GrafoImp *) g;
    int menor_grau = k;
    int menor_id = __INT_MAX__;
    VerticeImp *vertice_menor_grau = NULL;

    VerticeImp *v = grafo->vertices;
    while(v != NULL) {
        if((v->grau < menor_grau) || (v->grau < k && v->grau == menor_grau && v->id < menor_id)) {
            vertice_menor_grau = v;
            menor_grau = v->grau;
            menor_id = v->id;
        }
        v = v->prox;
    }

    // Potencial Spill
    if(vertice_menor_grau == NULL) {
        // Busca o vertice com menor grau sem usar K como base
        VerticeImp *v = (VerticeImp *) buscarPotencialSpill(grafo);

        v->spill = true;
        vertice_menor_grau = v;
    }

    return vertice_menor_grau;
}

Vertice buscarVertice(Grafo g, int id) {
    GrafoImp *grafo = (GrafoImp *) g;

    VerticeImp *v = grafo->vertices;
    
    while(v != NULL && v->id != id) {
        v = v->prox;
    }
    

    return v;
}

void removerVertice(Grafo g, int id) {
    GrafoImp *grafo = (GrafoImp *) g;

    VerticeImp *v = (VerticeImp *) buscarVertice(grafo, id);
    
    if(grafo->vertices == v) {
        grafo->vertices = grafo->vertices->prox;
    } else {
        VerticeImp *aux = grafo->vertices;
        while(aux != NULL) {
            if(aux->prox == v) {
                break;
            }

            aux = aux->prox;
        }
        aux->prox = v->prox;
    }

    // Remove da Matriz de Adjacência
    for(int i = 0; i < grafo->numero_vertices; i++) {
        grafo->adjacencia[i][v->id] = 0;
    }
    
    free(v);

    recalcularGraus(grafo);
}

void pintarVertice(Grafo *g, int id, int cor) {
    GrafoImp *grafo = (GrafoImp *) g;

    VerticeImp *novo_vertice = (VerticeImp *) malloc(sizeof(struct vertice));
    novo_vertice->id = id;
    novo_vertice->cor = cor;
    novo_vertice->grau = 0;
    novo_vertice->spill = false;
    novo_vertice->prox = NULL;

    if(grafo->vertices == NULL) {
        grafo->vertices = novo_vertice;
    } else {
        VerticeImp *v = grafo->vertices;
        while(v->prox != NULL) {
            v = v->prox;
        }

        v->prox = novo_vertice;
    }
}

void ajustarAdjacencias(Grafo g, int id) {
    GrafoImp *grafo = (GrafoImp*) g;

    //memcpy(&grafo->adjacencia[id], &grafo->adjacencia_original[id], grafo->numero_vertices - 1 * sizeof(int));

    for(int i = 0; i < grafo->numero_vertices; i++) {
        grafo->adjacencia[id][i] = grafo->adjacencia_original[id][i];
    }
    
    recalcularGraus(grafo);
}

int getCorLivre(Grafo *g, int id, int k) {
    GrafoImp *grafo = (GrafoImp *) g;
    int cores[k];
    int count = 0;
    bool flg_cor_valida = true;

    for(int i = 0; i < k; i++) {
        if(grafo->adjacencia[id][i] == 0) {
            cores[count] = i;
            count++;
        }
    }

    for(int i = 0; i < count; i++) {
        for(int j = k; j < grafo->numero_vertices; j++) {
            if(grafo->adjacencia[id][j] == 1) {
                VerticeImp *v = buscarVertice(grafo, j);
                if(v != NULL && v->cor == cores[i]) {
                    flg_cor_valida = false;
                    break;
                }
            }
        }

        if(flg_cor_valida) {
            return cores[i];
        }

        flg_cor_valida = true;
    }

    return -1;
}