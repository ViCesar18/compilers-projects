#include <stdio.h>
#include "sintatico.tab.h"
#include "hash_table.h"

extern HashTableImp hash;

int currentLine;

int main() {
    int numberOfLines = 0;
    char c = getc(stdin);
    while(!feof(stdin)) {
        if(c == '\n'){
            numberOfLines++;
        }
        c = getc(stdin);
    }
    rewind(stdin);

    for(currentLine = 0; currentLine < numberOfLines + 1; currentLine++) {
        yyparse();
        destroyHashTable(hash);
        hash = NULL;
    }

    return 0;
}