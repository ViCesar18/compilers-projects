#ifndef DCMAT_H
#define DCMAT_H

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include "arvore.h"
#include "sintatico.tab.h"

//Mostra a configuração atual das variáveis do sistema
void showSettings();

//Reseta as variáveis do sistema para a configuração padrão
void resetSettings();

//Define um novo valor para hViewLo e hViewHi
void setHView(double newLoValue, double newHiValue);

//Define um novo valor para vViewLo e vViewHi
void setVView(double newLoValue, double newHiValue);

//Liga ou desliga o desenho dos eixos X e Y
void setAxis(bool newAxisValue);

//Plota na tela a função anteriormente inserida
void plot();

//Insere e plota a função passada como parâmetro
void plotExpression(TreeNode *exp);

//Define a quantidade de passos para calcular o valor de uma integral
void setIntegralSteps(int newIntegralSteps);

//Calcula o valor da integral e imprime na tela
void integrate(TreeNode *exp, double limiteInferior, double limiteSuperior);

//Salva os dados da matriz inserida
void saveMatrix(double m[][10], int lines, int columns);

//Printa a matriz inserida anteriormente na tela
void showMatrix();

//Resolve o determinante da matriz inserida e printa na tela
void solveDeterminant();

//Resolve o sistema linear da matriz inserida utilizando o método da Fatoração LU
void solveLinearSystem();

//Mostra as informações sobre o desenvolvedor
void about();

#endif