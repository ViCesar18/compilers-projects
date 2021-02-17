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
        DeclarationNode *declaration = listaFuncoes->declarations;

        while(declaration != NULL) {
            
            if(!listaFuncoes->flgDeclaracao) {
                printf("Função: %s\n", listaFuncoes->nome);

                DeclarationNode *params = listaFuncoes->parameters;
                printf("Parametros: ");
                while(params != NULL) {
                    printf("%d %s, ", params->tipo, params->nome);
                    params = params->next;
                }
                printf("\n%d %s\n", declaration->tipo, declaration->nome);
            } else {
                printf("%d %s\n", declaration->tipo, declaration->nome);
            }

            declaration = declaration->next;
        }

        listaFuncoes = listaFuncoes->next;
    }
    
    return 0;
}