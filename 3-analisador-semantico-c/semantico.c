#include <stdio.h>
#include "ast.h"
#include "sintatico.tab.h"

void encontrarColuna(DeclarationNode *declaracao) {
    char *auxString = (char *) malloc(sizeof(char) * strlen(declaracao->nome) + 1);

    strcpy(auxString, declaracao->nome);
    strcat(auxString, ",");
    char *subString = strstr(declaracao->linhaDeclaracao, auxString);

    if(subString == NULL) {
        strcpy(auxString, declaracao->nome);
        auxString = strcat(auxString, ";");
        subString = strstr(declaracao->linhaDeclaracao, auxString);

        if(subString == NULL) {
            strcpy(auxString, declaracao->nome);
            strcat(auxString, " ");
            subString = strstr(declaracao->linhaDeclaracao, auxString);

            if(subString == NULL) {
                strcpy(auxString, declaracao->nome);
                strcat(auxString, ")");
                subString = strstr(declaracao->linhaDeclaracao, auxString);
            }
        }
    }

    if(subString != NULL) {
        declaracao->column = subString - declaracao->linhaDeclaracao + 1;
    } else {
        declaracao->column = 0;
    }
}

void typeCheckingPrime(DeclarationNode *declaracao, HashTableImp simbolos);

void typeChecking(ProgramNode *ast) {
    FunctionNode *listaFuncoes = ast->listaFuncoes;
    while(listaFuncoes != NULL) {
        HashTableImp simbolos;
        DeclarationNode *parametros;
        DeclarationNode *declaracao = listaFuncoes->declarations;
        if(!listaFuncoes->flgDeclaracao) {
            typeCheckingPrime(listaFuncoes->parameters, listaFuncoes->tabelaSimbolos);
        }

        typeCheckingPrime(declaracao, ast->tabelaSimbolosGlobal);

        listaFuncoes = listaFuncoes->next;
    }
}

void typeCheckingPrime(DeclarationNode *declaracao, HashTableImp simbolos) {
    while(declaracao != NULL) {
        // Pega a coluna de todas as declarações
        encontrarColuna(declaracao);

        // Verifica se é void
        if(declaracao->tipo == S_VOID && (declaracao->tipoDeclaracao == D_VARIAVEL || declaracao->tipoDeclaracao == D_PARAMETRO)) {
            if(declaracao->tipoDeclaracao == D_VARIAVEL) {
                printf("error:semantic:%d:%d: variable '%s' declared void\n",
                declaracao->line,
                declaracao->column,
                declaracao->nome);
            } else {
                printf("error:semantic:%d:%d: parameter '%s' declared void\n",
                declaracao->line,
                declaracao->column,
                declaracao->nome);
            }

            printf("%s\n", declaracao->linhaDeclaracao);
            for(int i = 0; i < declaracao->column - 1; i++) {
                printf(" ");
            }
            printf("^");

            exit(1);
        }

        DeclarationNode *declaracaoAnterior = existInHashTable(simbolos, declaracao);
        if(declaracaoAnterior == NULL) {
            insertHashTable(simbolos, declaracao);
        } else {
            if(declaracaoAnterior->tipo == declaracao->tipo && !strcmp(declaracaoAnterior->nome, declaracao->nome)) {
                printf("error:semantic:%d:%d variable '%s' already declared, previous declaration in line %d column %d\n",
                declaracao->line,
                declaracao->column,
                declaracao->nome,
                declaracaoAnterior->line,
                declaracaoAnterior->column);

                printf("%s\n", declaracao->linhaDeclaracao);
                for(int i = 0; i < declaracao->column - 1; i++) {
                    printf(" ");
                }
                printf("^");

                exit(1);
            } else {
                printf("error:semantic:%d:%d redefinition of '%s', previous defined in line %d column %d\n",
                declaracao->line,
                declaracao->column,
                declaracao->nome,
                declaracaoAnterior->line,
                declaracaoAnterior->column);
                
                printf("%s\n", declaracao->linhaDeclaracao);
                for(int i = 0; i < declaracao->column - 1; i++) {
                    printf(" ");
                }
                printf("^");

                exit(1);
            }
        }
        declaracao = declaracao->next;
    }
}

int main() {
    extern char* lineError;

    fseek(stdin, 0, SEEK_END);
    int fSize = ftell(stdin);
    rewind(stdin);

    lineError = (char *) calloc(fSize, sizeof(char));

    ProgramNode *ast = (ProgramNode *) malloc(sizeof(struct program));

    yyparse(ast);

    typeChecking(ast);

    printf("SUCCESSFUL COMPILATION.");
    
    return 0;
}