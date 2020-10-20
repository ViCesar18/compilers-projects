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

while(i <= 2):
    i += 1
    print(f'./l10e4 < entradas/{entrada} > saidas/{saida}')
    os.system(f'./l10e4 < entradas/{entrada} > saidas/{saida}')

    entrada = f'entrada_0{i}.txt'
    saida = f'saida_0{i}.txt'

#Comparar
i = 1
saida = 'saida_01.txt'
print('\nComparando com saidas esperadas:')

while(i <= 2):
    i += 1
    print(f'diff saidas-esperadas/{saida} saidas/{saida}')
    os.system(f'diff saidas-esperadas/{saida} saidas/{saida}')
    time.sleep(0.5)

    saida = f'saida_0{i}.txt'

os.system('make clean')
