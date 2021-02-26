#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

HashTableImp createHashTable(int size) {
    HashTableImp hash = (HashTableImp) malloc(sizeof(struct HashTableSt));
    hash->size = size;
    hash->list = (ListNodeImp *) malloc(size * sizeof(ListNodeImp));
    memset(hash->list, 0, size * sizeof(ListNodeImp));

    return hash;
}

void insertHashTable(HashTableImp hash, DeclarationNode *declaracao) {
    char *id = declaracao->nome;

    int idSize = strlen(id);
    char *idAlocado;

    idAlocado = malloc(idSize * sizeof(char));
    strcpy(idAlocado, id);

    int key = 0;
    for(int i = 0; i < idSize; i++) {
        key += idAlocado[i];
    }

    int position = key % hash->size;

    ListNodeImp node = (ListNodeImp) malloc(sizeof(struct ListNodeSt));
    node->declaracao = declaracao;
    node->key = key;
    node->next = NULL;

    if(hash->list[position] == NULL) {
        hash->list[position] = node;
    }
    else {
        ListNodeImp currentNode = hash->list[position];

        while(currentNode->next != NULL)
            currentNode = currentNode->next;

        currentNode->next = node;
    }
}

DeclarationNode *existInHashTable(HashTableImp hash, DeclarationNode *declaracao) {
    char *id = declaracao->nome;

    int idSize = strlen(id);
    int key = 0;

    for(int i = 0; i < idSize; i++) {
        key += id[i];
    }

    int position = key % hash->size;

    ListNodeImp node = hash->list[position];

    if(node == NULL) {
        return NULL;
    }
    else {
        while(node != NULL) {
            if(!strcmp(node->declaracao->nome, id) && node->declaracao->tipoDeclaracao == declaracao->tipoDeclaracao) {
                return node->declaracao;
            }
            node = node->next;
        }

        return NULL;
    }
}

void destroyHashTable(HashTableImp hash) {
    for(int i = 0; i < hash->size; i++) {
        ListNodeImp node = hash->list[i];

        while(node != NULL) {
            ListNodeImp nextNode = node->next;
            free(node);
            node = nextNode;
        }
    }

    free(hash->list);
    free(hash);
}