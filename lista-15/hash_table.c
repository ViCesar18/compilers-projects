#include "hash_table.h"

HashTableImp createHashTable(int size) {
    HashTableImp hash = (HashTableImp) malloc(sizeof(struct HashTableSt));
    hash->size = size;
    hash->list = (ListNodeImp *) malloc(size * sizeof(ListNodeImp));
    memset(hash->list, 0, size * sizeof(ListNodeImp));

    return hash;
}

void insertHashTable(HashTableImp hash, int type, char *id) {
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
    node->id = idAlocado;
    node->key = key;
    node->type = type;
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

int existInHashTable(HashTableImp hash, int type, char *id) {
    int idSize = strlen(id);
    int key = 0;

    for(int i = 0; i < idSize; i++) {
        key += id[i];
    }

    int position = key % hash->size;

    ListNodeImp node = hash->list[position];

    if(node == NULL) {
        return -1;
    }
    else {
        while(node != NULL) {
            if(!strcmp(node->id, id)) {
                return node->type;
            }
            node = node->next;
        }

        return -1;
    }
}

void destroyHashTable(HashTableImp hash) {
    for(int i = 0; i < hash->size; i++) {
        ListNodeImp node = hash->list[i];

        while(node != NULL) {
            ListNodeImp nextNode = node->next;
            free(node->id);
            free(node);
            node = nextNode;
        }
    }

    free(hash->list);
    free(hash);
}