#include <stdio.h>
#include <stdlib.h>
#include "pilha.h"

typedef struct no {
    int elemento;
    struct no *prox;
} NoImp;

typedef struct pilha {
    int tamanho;
    NoImp *topo;
} PilhaImp;

int getPilhaTamanho(Pilha p) {
    PilhaImp *pilha = (PilhaImp *) p;

    return pilha->tamanho;
}

Pilha iniciarPilha() {
    PilhaImp *pilha = (PilhaImp *) malloc(sizeof(struct pilha));

    pilha->tamanho = 0;
    pilha->topo = NULL; //(NoImp *) malloc(sizeof(struct no));

    return pilha;
}

void push(Pilha p, int num) {
    PilhaImp *pilha = (PilhaImp *) p;

    NoImp *no = (NoImp *) malloc(sizeof(struct no));
    no->elemento = num;
    no->prox = pilha->topo;

    pilha->topo = no;
    pilha->tamanho++;
}

int pop(Pilha p) {
    PilhaImp *pilha = (PilhaImp *) p;

    NoImp *no = pilha->topo;
    int elemento = no->elemento;

    pilha->topo = no->prox;
    pilha->tamanho--;

    free(no);

    return elemento;
}

void destruirPilha(Pilha p) {
    PilhaImp *pilha = (PilhaImp *) p;

    while(pilha->tamanho != 0) {
        pop(pilha);
    }
    free(pilha);
}