import os
import time

#Compilar
print('Compilando')
os.system('make')
time.sleep(1)

#Executar
i = 1
entrada = 'tc01.pas'
saida = 'saida_01.txt'

while(i <= 5):
    i += 1
    print(f'./pascal < testes/{entrada} > saidas/{saida}')
    os.system(f'./pascal < testes/{entrada} > saidas/{saida}')

    entrada = f'tc0{i}.pas'
    saida = f'saida_0{i}.txt'

#Make Clean
os.system('make clean')

#Comparar
i = 1
saida = 'saida_01.txt'
print('\nComparando com saidas esperadas:')

while(i <= 5):
    i += 1
    print(f'diff saidas-esperadas/{saida} saidas/{saida}')
    os.system(f'diff saidas-esperadas/{saida} saidas/{saida}')
    time.sleep(0.5)

    saida = f'saida_0{i}.txt'
