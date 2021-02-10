#ifndef HASH_TABLE_H
#define HASH_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct ListNodeSt {
    int type;
    char *id;
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
void insertHashTable(HashTableImp hash, int type, char *id);

//Retorna o tipo do elemento caso ele já exista na HashTable, ou -1 caso não exista
int existInHashTable(HashTableImp hash, int type, char *id);

//Desaloca a memória de uma HashTable
void destroyHashTable(HashTableImp hash);

#endif