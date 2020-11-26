#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include "sintatico.tab.h"

extern int yylex();
extern char *yytext;

double hViewLo = -6.5;
double hViewHi = 6.5;
double vViewLo = -3.5;
double vViewHi = 3.5;

bool drawAxis = true;
bool connectDots = false;

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

void setHView() {
    bool negative = false;

    yylex();    //Pega o primeiro número ou o menos
    if(!strcmp(yytext, "-")) {
        yylex();    //Pega o segundo número caso tenha vindo o menos
        negative = true;
    }
    hViewLo = atof(yytext);
    hViewLo = negative ? hViewLo * -1 : hViewLo;

    negative = false;
    
    yylex();    //Pega o dois pontos
    yylex();    //Pega o segundo número ou o menos
    if(!strcmp(yytext, "-")) {
        yylex();    //Pega o segundo número caso tenha vindo o menos
        negative = true;
    }
    hViewHi = atof(yytext);
    hViewHi = negative ? hViewHi * -1 : hViewHi;
}

int main() {
    char command[50];

    do{
        printf(">");
        //fgets(command, sizeof(command), stdin);
        yylex();

        if(!strcmp(yytext, "show settings;")) {
            showSettings();
            yylex();
        }
        else if(!strcmp(yytext, "reset settings;")) {
            resetSettings();
            yylex();
        }
        else if(!strcmp(yytext, "set h_view")) {
            setHView();
            yylex();
            yylex();
        }
    } while(strcmp(yytext, "quit"));

    return 0;
}