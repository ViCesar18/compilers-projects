#include "dcmat.h"

double hViewLo = -6.5;
double hViewHi = 6.5;
double vViewLo = -3.5;
double vViewHi = 3.5;
int integralSteps = 1000;

bool drawAxis = true;
bool connectDots = false;

TreeNode *expression = NULL;

char plotArea[25][80];

double matrix[10][10];
int matrixLines;
int matrixColumns;
bool flagInsertMatrix = false;

void showSettings() {
    printf("\nh_view_lo: %lf\n", hViewLo);
    printf("h_view_hi: %lf\n", hViewHi);
    printf("v_view_lo: %lf\n", vViewLo);
    printf("v_view_hi: %lf\n", vViewHi);
    printf("integral_steps: %d\n\n", integralSteps);

    if(drawAxis) {
        printf("Draw Axis: ON.\n");
    }
    else {
        printf("Draw Axis: OFF.\n");
    }

    if(connectDots) {
        printf("Connect Dots: ON.");
    }
    else {
        printf("Connect Dots: OFF.\n\n");
    }
}

void resetSettings() {
    hViewLo = -6.5;
    hViewHi = 6.5;
    vViewLo = -3.5;
    vViewHi = 3.5;
    integralSteps = 1000;

    drawAxis = true;
    connectDots = false;
}

void setHView(double newLoValue, double newHiValue) {
    if(newLoValue < newHiValue) {
        hViewLo = newLoValue;
        hViewHi = newHiValue;
    } else {
        printf("\nERROR: h_view_lo must be smaller than h_view_hi\n\n");
    }
}

void setVView(double newLoValue, double newHiValue) {
    if(newLoValue < newHiValue) {
        vViewLo = newLoValue;
        vViewHi = newHiValue;
    } else {
        printf("\nERROR: v_view_lo must be smaller than h_view_hi\n\n");
    }
}

void setAxis(bool newAxisValue) {
    drawAxis = newAxisValue;
}

void plot() {
    if(expression == NULL) {
        printf("\nNo Function defined!\n\n");
        return;
    }

    int i, j;

    for(i = 0; i < 25; i++) {
        for(j = 0; j < 80; j++) {
            if(i == 12) {
                plotArea[i][j] = '-';
            } else if(j == 40) {
                plotArea[i][j] = '|';
            } else {
                plotArea[i][j] = ' ';
            }
        }
    }

    double deltaX = (hViewHi - hViewLo) / 80;
    double deltaY = (vViewHi - vViewLo) / 24;

    for(i = 0; i < 80; i++) {
        double x = deltaX * i + hViewLo;
        double y;

        double funcY = calculateExpression(expression, x);

        for(j = 0; j < 25; j++) {
            y = vViewHi - deltaY * j;

            if(funcY >= y) {
                break;
            }
        }

        if(funcY > vViewLo && funcY < vViewHi) {
            plotArea[j][i] = '*';
        }
    }

    //Plota o gráfico
    printf("\n");
    for(i = 0; i < 25; i++) {
        for(j = 0; j < 80; j++) {
            printf("%c", plotArea[i][j]);
        }
        printf("\n");
    }
    printf("\n\n");
}

void plotExpression(TreeNode *exp) {
    if(expression != NULL) {
        deleteTree(expression);
    }

    expression = exp;

    plot();
}

void setIntegralSteps(int newIntegralSteps) {
    if(newIntegralSteps <= 0) {
        printf("\nERROR: integral_steps must be a positive non-zero integer\n\n");
    } else {
        integralSteps = newIntegralSteps;
    }
}

void integrate(TreeNode *exp, double limiteInferior, double limiteSuperior) {
    if(limiteInferior > limiteSuperior) {
        printf("\nERROR: lower limit must be smaller than upper limit\n\n");
        return;
    }

    double result = 0;
    double deltaX = (limiteSuperior - limiteInferior) / integralSteps;

    for(int i = 0; i < integralSteps; i++) {
        double x = deltaX * i + limiteInferior;

        result += deltaX * calculateExpression(exp, x);
    }

    printf("\n%lf\n\n", result);
}

void saveMatrix(double m[][10], int lines, int columns) {
    if(lines > 10 || columns > 10) {
        printf("\nERROR: Matrix limits out o boundaries.\n\n");
    } else {
        matrixLines = lines;
        matrixColumns = columns;

        memcpy(matrix, m, 10 * 10 * sizeof(double));

        flagInsertMatrix = true;
    }
}

void showMatrix() {
    if(flagInsertMatrix) {
        int spaces = 14 * matrixColumns;

        printf("\n");
        printf("+-");
        for(int i = 0; i < spaces; i++) {
            printf(" ");
        }
        printf("-+\n");
        for(int i = 0; i < matrixLines; i++) {
            printf("| ");
            for(int j = 0; j < matrixColumns; j++) {
                if(matrix[i][j] < 0) {
                    printf("%e ", matrix[i][j]);
                } else {
                    printf(" %e ", matrix[i][j]);
                }
            }
            printf(" |\n");
        }
        printf("+-");
        for(int i = 0; i < spaces; i++) {
            printf(" ");
        }
        printf("-+\n\n");
    } else {
        printf("\nNo Matrix defined!\n\n");
    }
}

double determinantOfMatrix(double mat[10][10], int n) {
    double det = 0;

    double temp[10][10];

    if(n == 2) {
        return ((mat[0][0] * mat[1][1]) - (mat[1][0] * mat[0][1]));
    }

    for(int x = 0; x < n; x++) {
        int subi = 0;
        for(int i = 1; i < n; i++) {
            int subj = 0;
            for(int j = 0; j < n; j++) {
                if(j == x) {
                    continue;
                }

                temp[subi][subj] = mat[i][j];
                subj++;
            }
            subi++;
        }
        det += (pow(-1, x) * mat[0][x] * determinantOfMatrix(temp, n - 1));
    }

    return det;
}

void solveDeterminant() {
    if(matrixLines != matrixColumns) {
        printf("\nMatrix format incorrect!\n\n");
    } else {
        double determinant = determinantOfMatrix(matrix, matrixLines);

        printf("\n%lf\n\n", determinant);
    }
}

//matrix = [[10,2,1,7],[1,5,1,-8],[2,3,10,6]]; SPD
//matrix = [[1,1,8],[2,2,16]]; SPI
//matrix = [[3,2,6],[3,2,12]]; SI
void solveLinearSystem() {
    if(matrixLines != matrixColumns - 1) {
        printf("\nMatrix format incorrect!\n\n");
        return;
    }

    double A[10][10], L[10][10], U[10][10];
    double B[10], X[10], Y[10];
    int n = matrixLines;
    int i, j, k;

    //Calcula Matriz A e B
    for(i = 0; i < n; i++) {
        for(j = 0; j < matrixColumns; j++) {
            if(j != matrixColumns - 1) {
                A[i][j] = matrix[i][j];
            }
            else {
                B[i] = matrix[i][j];
            }
        }
    }

    //Verifica se é SPI ou SI
    double det = determinantOfMatrix(A, n);
    if(det == 0) {
        for(i = 0; i < n; i++) {
            double aux[10][10];

            memcpy(aux, A, 10 * 10 * sizeof(double));

            for(j = 0; j < n; j++) {
                aux[j][i] = B[j];
            }

            double secDet = determinantOfMatrix(aux, n);
            if(secDet != 0) {
                printf("\nSI - The Linear System has no solution\n\n");
                return;
            }
        }

        printf("\nSPI - The Linear System has infinitely many solutions\n\n");
        return;
    }

    //Calcula Matriz L e U
    for(j = 0; j < n; j++) {
        for(i = 0; i < n; i++) {
            if(i <= j) {
                U[i][j] = A[i][j];
                for(k = 0; k <= i - 1; k++) {
                    U[i][j] -= L[i][k] * U[k][j];
                }
                if(i == j) {
                    L[i][j] = 1;
                } else {
                    L[i][j] = 0;
                }
            } else {
                L[i][j] = A[i][j];
                for(k = 0; k <= j - 1; k++) {
                    L[i][j] -= L[i][k] * U[k][j];
                }
                L[i][j] /= U[j][j];
                U[i][j] = 0;
            }
        }
    }

    //Calcula resultado Y
    for(i = 0; i < n; i++) {
        Y[i] = B[i];
        for(j = 0; j < i; j++) {
            Y[i] -= L[i][j] * Y[j];
        }
    }

    //Calcula o resultado X
    for(i = n - 1; i >= 0; i--) {
        X[i] = Y[i];
        for(j = i + 1; j < n; j++) {
            X[i] -= U[i][j] * X[j];
        }
        X[i] /= U[i][i];
    }

    printf("\nMatrix x:\n\n");
    for(i = 0; i < n; i++) {
        printf("%lf\n", X[i]);
    }
    printf("\n");
}

void about() {
    printf("\n");
    printf("+--------------------------------------------------+\n");
    printf("|                                                  |\n");
    printf("|     VINICIUS CESAR DOS SANTOS - 201800560288     |\n");
    printf("|                                                  |\n");
    printf("+--------------------------------------------------+\n");
    printf("\n\n");
}

int main() {
    int quit;

    do {
        printf(">");
        quit = yyparse();
    } while(quit);

    return 0;
}