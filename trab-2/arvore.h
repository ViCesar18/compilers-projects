#ifndef ARVORE_H
#define ARVORE_H

#include <stdio.h>
#include <stdlib.h>

typedef struct node TreeNode;

struct node {
    int nodeType;
    double value;
    TreeNode *left;
    TreeNode *right;
};

void rpnWalk(TreeNode *aux);

void deleteTree(TreeNode *aux);

#endif