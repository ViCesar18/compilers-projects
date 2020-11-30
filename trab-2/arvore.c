#include "arvore.h"
#include "sintatico.tab.h"

void rpnWalk(TreeNode *aux) {
    if(aux) {
        rpnWalk(aux->left);

        rpnWalk(aux->right);

        switch(aux->nodeType) {
            case ADD: {
                printf("+ ");
                break;
            }
            case SUB: {
                printf("- ");
                break;
            }
            case MUL: {
                printf("* ");
                break;
            }
            case DIV: {
                printf("/ ");
                break;
            }
            case MODULE: {
                printf("%% ");
                break;
            }
            case SEN: {
                aux->value > 0 ? printf("SEN ") : printf("-SEN ");
                break;
            }
            case COS: {
                aux->value > 0 ? printf("COS ") : printf("-COS ");
                break;
            }
            case TAN: {
                aux->value > 0 ? printf("TAN ") : printf("-TAN ");
                break;
            }
            case ABS: {
                aux->value > 0 ? printf("ABS ") : printf("-ABS ");
                break;
            }
            case NUM: {
                printf("%lf ", aux->value);
                break;
            }
            case VAR: {
                aux->value > 0 ? printf("x ") : printf("-x ");
                break;
            }
            default: {
                printf("ERROR: INVALID TYPE ");
                break;
            }
        }
    }
}

void deleteTree(TreeNode *aux) {
    if(aux) {
        deleteTree(aux->left);
        deleteTree(aux->right);
        free(aux);
    }
}