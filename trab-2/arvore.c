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
            case POWER: {
                printf("^ ");
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
                printf("ERROR: INVALID TYPE");
                break;
            }
        }
    }
}

double calculateExpression(TreeNode *aux, double x) {
    if(aux) {
        double leftValue, rightValue;

        leftValue = calculateExpression(aux->left, x);

        rightValue = calculateExpression(aux->right, x);

        switch(aux->nodeType) {
            case ADD: {
                return leftValue + rightValue;
            }
            case SUB: {
                return leftValue - rightValue;
            }
            case MUL: {
                return leftValue * rightValue;
            }
            case DIV: {
                return leftValue / rightValue;
            }
            case POWER: {
                return pow(leftValue, rightValue);
            }
            case MODULE: {
                return (int) leftValue % (int)rightValue;
            }
            case SEN: {
                if(aux->value > 0) {
                    return sin(rightValue);
                } else {
                    return -sin(rightValue);
                }
            }
            case COS: {
                if(aux->value > 0) {
                    return cos(rightValue);
                } else {
                    return -cos(rightValue);
                }
            }
            case TAN: {
                if(aux->value > 0) {
                    return tan(rightValue);
                } else {
                    return -tan(rightValue);
                }
            }
            case ABS: {
                if(aux->value > 0) {
                    return abs(rightValue);
                } else {
                    return -abs(rightValue);
                }
            }
            case NUM: {
                return aux->value;
            }
            case VAR: {
                return x;
            }
            default: {
                printf("ERROR: INVALID TYPE");
                break;
            }
        }
    }

    return -1;
}

void deleteTree(TreeNode *aux) {
    if(aux) {
        deleteTree(aux->left);
        deleteTree(aux->right);
        free(aux);
    }
}