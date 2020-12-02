#ifndef ARVORE_H
#define ARVORE_H

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct node TreeNode;

struct node {
    int nodeType;
    double value;
    TreeNode *left;
    TreeNode *right;
};

//Percorre a árvore em profundidade para obter Reverse Polish Notation
void rpnWalk(TreeNode *aux);

//Retorna o valor de uma expressão
double calculateExpression(TreeNode *aux, double x);

//Desaloca a árvore
void deleteTree(TreeNode *aux);

#endif