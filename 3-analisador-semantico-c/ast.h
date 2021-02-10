#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "hash_table.h"

typedef struct tree TreeNode;
struct tree {
    int nodeType;
    double value;
    TreeNode *left;
    TreeNode *right;
};

typedef struct expression ExpressionNode;
struct expression {
    int expType;

    ExpressionNode ternaryExpression;

    ExpressionNode *left;
    ExpressionNode *right;
}

typedef struct command CommandNode;
struct command {
    int commandType;

    ExpressionNode *exp;
    ExpressionNode *exp2;
    ExpressionNode *exp3;

    CommandNode *then;
    CommandNode *else;

    CommandNode *next;
}

typedef struct function FunctionNode;
struct function {
    char *nome;

    HashTableImp *tabelaSimbolos;

    CommandNode *listaComandos;

    FunctionNode *next;
}

typedef struct program ProgramNode;
struct program {
    HashTableImp *tabelaSimbolosGlobal;

    FunctionNode *listaFuncoes;
}

//Percorre a árvore em profundidade para obter Reverse Polish Notation
void rpnWalk(TreeNode *aux);

//Retorna o valor de uma expressão
double calculateExpression(TreeNode *aux, double x);

//Desaloca a árvore
void deleteTree(TreeNode *aux);

#endif