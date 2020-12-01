#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include <math.h>
#include "arvore.h"
#include "sintatico.tab.h"

extern int yylex();
extern char *yytext;

double hViewLo = -6.5;
double hViewHi = 6.5;
double vViewLo = -3.5;
double vViewHi = 3.5;

bool drawAxis = true;
bool connectDots = false;

double matrix[10][10];
int matrixLines;
int matrixColumns;
bool flagInsertMatrix = false;

void showSettings() {
    printf("\nh_view_lo: %lf\n", hViewLo);
    printf("h_view_hi: %lf\n", hViewHi);
    printf("v_view_lo: %lf\n", vViewLo);
    printf("v_view_hi: %lf\n\n", vViewHi);

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
    double **matrix;

    do {
        printf(">");
        yyparse();
    } while(strcmp(yytext, "quit"));

    return 0;
}