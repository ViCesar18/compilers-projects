#include <stdio.h>
#include "ast.h"
#include "sintatico.tab.h"

int main() {
    extern char* lineError;

    fseek(stdin, 0, SEEK_END);
    int fSize = ftell(stdin);
    rewind(stdin);

    lineError = (char *) calloc(fSize, sizeof(char));

    ProgramNode *ast = (ProgramNode *) malloc(sizeof(struct program));

    yyparse(ast);

    FunctionNode *listaFuncoes = ast->listaFuncoes;
    while(listaFuncoes != NULL) {
        if(listaFuncoes->flgDeclaracao == 1) {
            DeclarationNode *declaration = listaFuncoes->declarations;

            while(declaration != NULL) {
                printf("%d ", declaration->tipo);
                if(declaration->tipo == 54 || declaration->flgPrototipo == 1) {
                    printf("%s ", declaration->nome);
                } else {
                    VariableNode *variable = declaration->variables;
                    while(variable != NULL) {
                        printf("%s ", variable->nome);
                        variable = variable->next;
                    }
                }
                printf("\n");
                declaration = declaration->next;
            }
        }
        printf("\n");
        listaFuncoes = listaFuncoes->next;
    }
    
    return 0;
}