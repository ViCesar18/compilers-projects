#include <stdio.h>
#include "ast.h"
#include "sintatico.tab.h"

bool flgDivZero = false;

extern unsigned columnDivision;

extern char* lineError;

extern unsigned lineReturn;
extern unsigned columnReturn;

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

                if(subString == NULL) {
                    strcpy(auxString, declaracao->nome);
                    strcat(auxString, "[");
                    subString = strstr(declaracao->linhaDeclaracao, auxString);
                }
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

    DeclarationNode *prototipo = existInHashTable(ast->tabelaSimbolosGlobal, aux);

    if(prototipo != NULL) {
        // Verifica o tipo do retorno da função
        if(prototipo->tipo != funcao->tipo || prototipo->pointer != funcao->pointer) {
            printf("error:semantic:%d:%d: conflicting types for '%s'\n", funcao->line, funcao->column - 1, funcao->nome);
            printf("%s\n", funcao->linhaDeclaracao);
            for(int i = 0; i < funcao->column - 1 - strlen(funcao->nome); i++) {
                printf(" ");
            }
            printf("^");
            
            exit(1);
        }

        int nParamPrototipo = numeroParametros(prototipo->parameters);
        int nParamFuncao = numeroParametros(funcao->parameters);

        // Verifica a quantidade de parâmetros
        if(nParamPrototipo < nParamFuncao) {
            printf("error:semantic:%d:%d: prototype for '%s' declares fewer arguments\n", funcao->line, funcao->column - 1, funcao->nome);
            printf("%s\n", funcao->linhaDeclaracao);
            for(int i = 0; i < funcao->column - 1 - strlen(funcao->nome); i++) {
                printf(" ");
            }
            printf("^");
            
            exit(1);
        }
        
        if(nParamPrototipo > nParamFuncao) {
            printf("error:semantic:%d:%d: prototype for '%s' declares more arguments\n", funcao->line, funcao->column - 1, funcao->nome);
            printf("%s\n", funcao->linhaDeclaracao);
            for(int i = 0; i < funcao->column - 1 - strlen(funcao->nome); i++) {
                printf(" ");
            }
            printf("^");
            
            exit(1);
        }

        // Verifica o tipo dos parâmetros
        DeclarationNode *parametroFuncao = funcao->parameters;
        DeclarationNode *parametroPrototipo = prototipo->parameters;
        while(parametroFuncao != NULL && parametroPrototipo != NULL) {
            if(parametroPrototipo->tipo != parametroFuncao->tipo || parametroPrototipo->pointer != parametroFuncao->pointer) {
                if(parametroFuncao->column == 0) {
                    encontrarColuna(parametroFuncao);
                }

                printf("error:semantic:%d:%d: argument '%s' does not match prototype\n", funcao->line, parametroFuncao->column + 1 - (int) strlen(funcao->nome), parametroFuncao->nome);
                printf("%s\n", funcao->linhaDeclaracao);
                for(int i = 0; i < parametroFuncao->column - strlen(funcao->nome); i++) {
                    printf(" ");
                }
                printf("^");

                exit(1);
            }

            parametroFuncao = parametroFuncao->next;
            parametroPrototipo = parametroPrototipo->next;
        }
    }
}

void verificarDivisaoZero(DeclarationNode *declaracao) {
    if(flgDivZero) {
        printf("error:semantic:%d:%d: division by zero\n", declaracao->line, columnDivision - 1);
        printf("%s\n", declaracao->linhaDeclaracao);
        for(int i = 0; i < columnDivision - 2; i++) {
            printf(" ");
        }
        printf("^");

        exit(1);
    }
}

void verificarVetor(DeclarationNode *declaracao, HashTableImp simbolos) {
    ExpressionNode *exp = declaracao->array;
    while(exp != NULL) {
        int resultado = calculateExpression(exp, simbolos);
        verificarDivisaoZero(declaracao);

        if(resultado == 0) {
            if(declaracao->column == 0) {
                encontrarColuna(declaracao);
            }

            printf("error:semantic:%d:%d: size of array '%s' is zero\n", declaracao->line, declaracao->column, declaracao->nome);
            printf("%s\n", declaracao->linhaDeclaracao);
            for(int i = 0; i < declaracao->column - 1; i++) {
                printf(" ");
            }
            printf("^");

            exit(1);
        } else if(resultado < 0) {
            if(declaracao->column == 0) {
                encontrarColuna(declaracao);
            }

            printf("error:semantic:%d:%d: size of array '%s' is negative\n", declaracao->line, declaracao->column, declaracao->nome);
            printf("%s\n", declaracao->linhaDeclaracao);
            for(int i = 0; i < declaracao->column - 1; i++) {
                printf(" ");
            }
            printf("^");

            exit(1);
        }

        exp = exp->next;
    }
}

int existeRetorno(CommandNode *comando, char **returnLine) {
    while(comando != NULL) {
        if(comando->commandType == S_RETURN) {
            if(comando->exp != NULL) {
                return 1;
            }

            if(returnLine != NULL) {
                *returnLine = malloc(strlen(comando->returnLine) + 1);
                strcpy(*returnLine, comando->returnLine);
            }

            return 0;
        }

        comando = comando->next;
    }

    return -1;
}

void verificarRetornoFuncao(FunctionNode *funcao) {
    if(funcao->tipo != S_VOID && (funcao->listaComandos == NULL || existeRetorno(funcao->listaComandos, NULL) == -1)) {
        printf("error:semantic:%d:%d: no return statement in function returning non-void\n", funcao->line, funcao->column - 1);
        printf("%s\n", funcao->linhaDeclaracao);
        for(int i = 0; i < funcao->column - 1 - strlen(funcao->nome); i++) {
            printf(" ");
        }
        printf("^");
        
        exit(1);
    }

    if(funcao->tipo == S_VOID && funcao->listaComandos != NULL && existeRetorno(funcao->listaComandos, NULL)) {
        printf("error:semantic:%d:%d: return with a value, in function returning void\n", funcao->line, funcao->column - 1);
        printf("%s\n", funcao->linhaDeclaracao);
        for(int i = 0; i < funcao->column - 1 - strlen(funcao->nome); i++) {
            printf(" ");
        }
        printf("^");
        
        exit(1);
    }

    char *returnLine = NULL;

    if(funcao->tipo != S_VOID && existeRetorno(funcao->listaComandos, &returnLine) == 0) {
        printf("error:semantic:%d:%d: return with no value, in function returning non-void\n", lineReturn, columnReturn);
        printf("%s\n", returnLine);
        for(int i = 0; i < columnReturn - 1; i++) {
            printf(" ");
        }
        printf("^");
        
        exit(1);
    }
}

void typeChecking(ProgramNode *ast) {
    FunctionNode *funcao = ast->listaFuncoes;
    while(funcao != NULL) {
        DeclarationNode *parametros;
        DeclarationNode *declaracao = funcao->declarations;

        if(!funcao->flgDeclaracao) {
            if(declaracao != NULL && declaracao->expressao != NULL) {
                declaracao->value = calculateExpression(declaracao->expressao, funcao->tabelaSimbolos);
                verificarDivisaoZero(declaracao);
            }

            verificarRetornoFuncao(funcao);

            verificarPrototipos(ast, funcao);
            typeCheckingPrime(funcao->parameters, funcao->tabelaSimbolos);
            typeCheckingPrime(declaracao, funcao->tabelaSimbolos);
        } else {
            if(declaracao != NULL && declaracao->expressao != NULL) {
                declaracao->value = calculateExpression(declaracao->expressao, ast->tabelaSimbolosGlobal);
                verificarDivisaoZero(declaracao);
            }

            typeCheckingPrime(declaracao, ast->tabelaSimbolosGlobal);
        }

        funcao = funcao->next;
    }
}

void typeCheckingPrime(DeclarationNode *declaracao, HashTableImp simbolos) {
    while(declaracao != NULL) {
        // Pega a coluna de todas as declarações
        if(declaracao->column == 0) {
            encontrarColuna(declaracao);
        }

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
            if(declaracaoAnterior->tipo == declaracao->tipo && declaracaoAnterior->pointer == declaracao->pointer && !strcmp(declaracaoAnterior->nome, declaracao->nome)) {
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

        verificarVetor(declaracao, simbolos);
        
        declaracao = declaracao->next;
    }
}

int main() {
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