#ifndef PILHA_H
#define PILHA_H

typedef void *Pilha;

// Retorna o tamanho da pilha
int getPilhaTamanho(Pilha p)

// Inicia e retorna uma pilha
Pilha iniciarPilha();

// Empilha um elemento
void push(Pilha p, int num);

// Desempilha um elemento
int pop(Pilha p);

// Libera a memória alocada por uma pilha
void destruirPilha(Pilha p);

#endif