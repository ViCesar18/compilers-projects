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

int numeroParametros(DeclarationNode *parametro) {
    int count = 0;

    while(parametro != NULL) {
        count++;
        parametro = parametro->next;
    }

    return count;
}

void verificarPrototipos(ProgramNode *ast, FunctionNode *funcao) {
    DeclarationNode *aux = (DeclarationNode *) malloc(sizeof(struct declaration));

    aux->nome = funcao->nome;
    aux->tipoDeclaracao = D_PROTOTIPO;

    DeclarationNode *declaracaoAnterior = existInHashTable(ast->tabelaSimbolosGlobal, aux);

    if(declaracaoAnterior != NULL) {
        int nParamPrototipo = numeroParametros(declaracaoAnterior->parameters);
        int nParamFuncao = numeroParametros(funcao->parameters);

        // Verifica a quantidade de parâmetros
        if(nParamPrototipo < nParamFuncao) {
            printf("error:semantic:%d:%d: prototype for '%s' declares fewer arguments\n", funcao->line, funcao->column - 1, funcao->nome);
            printf("%s\n", funcao->linhaDeclaracao);
            for(int i = 0; i < funcao->column - 1 - strlen(aux->nome); i++) {
                printf(" ");
            }
            printf("^");
            
            exit(1);
        }
        
        if(nParamPrototipo > nParamFuncao) {
            printf("error:semantic:%d:%d: prototype for '%s' declares more arguments\n", funcao->line, funcao->column - 1, funcao->nome);
            printf("%s\n", funcao->linhaDeclaracao);
            for(int i = 0; i < funcao->column - 1 - strlen(aux->nome); i++) {
                printf(" ");
            }
            printf("^");
            
            exit(1);
        }

        // Verifica o tipo dos parâmetros
        DeclarationNode *parametroFuncao = funcao->parameters;
        DeclarationNode *parametroPrototipo = declaracaoAnterior->parameters;
        while(parametroFuncao != NULL && parametroPrototipo != NULL) {
            if(parametroPrototipo->tipo != parametroFuncao->tipo || parametroPrototipo->pointer != parametroFuncao->pointer) {
                printf("error:semantic:%d:%d: argument '%s' does not match prototype\n", funcao->line, funcao->column - 1, parametroFuncao->nome);
                printf("%s\n", funcao->linhaDeclaracao);
                for(int i = 0; i < parametroFuncao->column - strlen(aux->nome); i++) {
                    printf(" ");
                }
                printf("^");
            }

            parametroFuncao = parametroFuncao->next;
            parametroPrototipo = parametroPrototipo->next;

            exit(1);
        }
    }
}

void typeChecking(ProgramNode *ast) {
    FunctionNode *funcao = ast->listaFuncoes;
    while(funcao != NULL) {
        HashTableImp simbolos;
        DeclarationNode *parametros;
        DeclarationNode *declaracao = funcao->declarations;
        if(!funcao->flgDeclaracao) {
            typeCheckingPrime(funcao->parameters, funcao->tabelaSimbolos);
            typeCheckingPrime(declaracao, funcao->tabelaSimbolos);
            verificarPrototipos(ast, funcao);
        } else {
            typeCheckingPrime(declaracao, ast->tabelaSimbolosGlobal);
        }

        funcao = funcao->next;
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
                printf("error:semantic:%d:%d: variable '%s' already declared, previous declaration in line %d column %d\n",
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
                printf("error:semantic:%d:%d: redefinition of '%s' previous defined in line %d column %d\n",
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
    extern char* lineBlock;

    fseek(stdin, 0, SEEK_END);
    int fSize = ftell(stdin);
    rewind(stdin);

    lineError = (char *) calloc(fSize, sizeof(char));
    lineBlock = (char *) calloc(fSize, sizeof(char));

    ProgramNode *ast = (ProgramNode *) malloc(sizeof(struct program));

    yyparse(ast);

    typeChecking(ast);

    printf("SUCCESSFUL COMPILATION.");
    
    return 0;
}