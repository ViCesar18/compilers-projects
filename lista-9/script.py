import os
import time

#Compilar
print('Compilando')
os.system('make')
time.sleep(1)

#Executar
i = 1
entrada = 'entrada_01.txt'
saida = 'saida_01.txt'

while(i <= 6):
    i += 1
    print(f'./ex1.out < entradas/{entrada} > saidas/{saida}')
    os.system(f'./ex1.out < entradas/{entrada} > saidas/{saida}')

    if(i < 10):
        entrada = f'entrada_0{i}.txt'
        saida = f'saida_0{i}.txt'
    else:
        entrada = f'entrada_{i}.txt'
        saida = f'saida_{i}.txt'

#Comparar
i = 1
saida = 'saida_01.txt'
print('\nComparando com saidas esperadas:')

while(i <= 6):
    i += 1
    print(f'diff saidas-esperadas/{saida} saidas/{saida}')
    os.system(f'diff saidas-esperadas/{saida} saidas/{saida}')
    time.sleep(0.5)

    if(i < 10):
        saida = f'saida_0{i}.txt'
    else:
        saida = f'saida_{i}.txt'

os.system('make clean')
