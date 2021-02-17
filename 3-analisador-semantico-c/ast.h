#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "hash_table.h"

enum SEMANTICO { S_NUM_OCTAL, S_NUM_HEXA, S_NUM_INTEGER, S_STRING, S_CHARACTER, S_IDENTIFIER, S_EXP_POS_VECTOR, S_EXP_POS_INC, S_EXP_POS_DEC, S_EXP_POS, S_EXP_UN_INC, S_EXP_UN_DEC, S_EXP_UN_BITWISE_AND, S_EXP_UN_MULTIPLY, S_EXP_UN_PLUS, S_EXP_UN_MINUS, S_EXP_UN_BITWISE_NOT, S_EXP_UN_NOT, S_REMAINDER, S_DIV, S_MULTIPLY, S_MINUS, S_PLUS, S_L_SHIFT, S_R_SHIFT, S_GREATER_EQUAL, S_GREATER_THAN, S_LESS_EQUAL, S_LESS_THAN, S_NOT_EQUAL, S_EQUAL, S_BITWISE_AND, S_BITWISE_XOR, S_BITWISE_OR, S_LOGICAL_AND, S_LOGICAL_OR, S_TERNARY_CONDITIONAL, S_ASSIGN, S_ADD_ASSIGN, S_MINUS_ASSIGN, S_EXP, S_DO, S_IF, S_WHILE, S_FOR, S_PRINTF, S_SCANF, S_EXIT, S_RETURN, S_COMMAND_EXPRESSION, S_SEMICOLON, S_INT, S_CHAR, S_VOID, S_DEFINE_DECL };

enum DECLARACAO { D_VARIAVEL, D_PROTOTIPO, D_PARAMETRO, D_CONSTANTE };

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

    ExpressionNode *ternaryExpression;

    ExpressionNode *left;
    ExpressionNode *right;
};

typedef struct declaration DeclarationNode;
struct declaration {
    int tipo;
    char *nome;

    int tipoDeclaracao;

    ExpressionNode *expressao;
    DeclarationNode *next;
};

typedef struct command CommandNode;
struct command {
    int commandType;

    ExpressionNode *exp;
    ExpressionNode *exp2;
    ExpressionNode *exp3;

    CommandNode *then;
    CommandNode *Else;

    CommandNode *next;
};

typedef struct function FunctionNode;
struct function {
    int flgDeclaracao;

    int tipo;
    char *nome;

    HashTableImp tabelaSimbolos;

    DeclarationNode *declarations;
    DeclarationNode *parameters;

    CommandNode *listaComandos;

    FunctionNode *next;
};

typedef struct program ProgramNode;
struct program {
    HashTableImp tabelaSimbolosGlobal;

    FunctionNode *listaFuncoes;
};

//Percorre a árvore em profundidade para obter Reverse Polish Notation
/*void rpnWalk(TreeNode *aux);

//Retorna o valor de uma expressão
double calculateExpression(TreeNode *aux, double x);*/

//Desaloca a árvore
void deleteTree(TreeNode *aux);

#endif