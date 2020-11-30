#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
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
    matrixLines = lines;
    matrixColumns = columns;

    memcpy(matrix, m, 10 * 10 * sizeof(double));
}

void showMatrix() {
    //matrix = [ [1, 2], [3, 4, 5, 4], [1] ];
    //matrix = [ [1, 2], [3, 4, 5, 6], [7, 8], [9] ];
    //matrix = [ [1, 2], [3, 4, 5, 6
    int spaces = 12 * matrixColumns + 5;

    printf("\n");
    printf("+-");
    for(int i = 0; i < spaces; i++) {
        printf(" ");
    }
    printf("-+\n");
    for(int i = 0; i < matrixLines; i++) {
        printf("|  ");
        for(int j = 0; j < matrixColumns; j++) {
            printf("%lfe+00 ", matrix[i][j]);
        }
        printf(" |\n");
    }
    printf("+-");
    for(int i = 0; i < spaces; i++) {
        printf(" ");
    }
    printf("-+\n\n");
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