#ifndef DCMAT_H
#define DCMAT_H

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

//Salva os dados da matriz inserida
void saveMatrix(double m[][10], int lines, int columns);

//Printa a matriz inserida anteriormente na tela
void showMatrix();

//Mostra as informações sobre o desenvolvedor
void about();

#endif