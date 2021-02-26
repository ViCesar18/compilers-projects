#include "ast.h"

extern bool flgDivZero;

/*void rpnWalk(TreeNode *aux) {
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
}*/

int calculateExpression(ExpressionNode *aux, HashTableImp hash) {
    if(aux) {
        int leftValue, rightValue;

        leftValue = calculateExpression(aux->left, hash);

        rightValue = calculateExpression(aux->right, hash);

        switch(aux->expType) {
            case S_LOGICAL_OR: {
                return leftValue || rightValue;
            }
            case S_LOGICAL_AND: {
                return leftValue && rightValue;
            }
            case S_EQUAL: {
                return leftValue == rightValue;
            }
            case S_NOT_EQUAL: {
                return leftValue != rightValue;
            }
            case S_LESS_THAN: {
                return leftValue < rightValue;
            }
            case S_LESS_EQUAL: {
                return leftValue <= rightValue;
            }
            case S_GREATER_THAN: {
                return leftValue > rightValue;
            }
            case S_GREATER_EQUAL: {
                return leftValue >= rightValue;
            }
            case S_PLUS: {
                return leftValue + rightValue;
            }
            case S_MINUS: {
                return leftValue - rightValue;
            }
            case S_MULTIPLY: {
                return leftValue * rightValue;
            }
            case S_DIV: {
                if(rightValue == 0) {
                    flgDivZero = true;
                    rightValue = 1;
                }

                return leftValue / rightValue;
            }
            case S_REMAINDER: {
                return (int) leftValue % (int)rightValue;
            }
            case S_NUM_INTEGER: {
                return aux->value;
            }
            case S_IDENTIFIER: {
                DeclarationNode *declaracao = findDeclaration(hash, aux->nome);
                
                if(declaracao != NULL) {
                    return declaracao->value;
                } else {
                    printf("error:semantic:%d:%d: '%s' undeclared", aux->line, aux->column, aux->nome);
                    printf("%s\n", aux->linhaErro);
                    for(int i = 0; i < aux->column - 1; i++) {
                        printf(" ");
                    }
                    printf("^");
                    
                    exit(1);
                }
                break;
            }
            case S_EXP: {
                return leftValue;
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