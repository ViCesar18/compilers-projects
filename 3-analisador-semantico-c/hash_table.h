#ifndef HASH_TABLE_H
#define HASH_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct declaration DeclarationNode;

typedef struct ListNodeSt {
    DeclarationNode *declaracao;
    int key;
    struct ListNodeSt *next;
} *ListNodeImp;

typedef struct HashTableSt {
    int size;
    ListNodeImp *list;
} *HashTableImp;

//Cria uma HashTable com o tamanho size
HashTableImp createHashTable(int size);

//Gera uma chave e insere o elemento na HashTable
void insertHashTable(HashTableImp hash, DeclarationNode *declaracao);

//Retorna declaração anterior caso ele já exista na HashTable, ou NULL caso não exista
DeclarationNode *existInHashTable(HashTableImp hash, DeclarationNode *declaracao);

//Retorna declaração baseado no nome da variável
DeclarationNode *findDeclaration(HashTableImp hash, char *nome);

//Desaloca a memória de uma HashTable
void destroyHashTable(HashTableImp hash);

#endif