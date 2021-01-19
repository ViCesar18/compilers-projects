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

while(i <= 5):
    i += 1
    if i < 10:
        print(f'./l15e1 < testes/{entrada} > saidas/{saida}')
        os.system(f'./l15e1 < testes/{entrada} > saidas/{saida}')

        entrada = f'entrada_0{i}.txt'
        saida = f'saida_0{i}.txt'
    else:
        print(f'./l15e1 < testes/{entrada} > saidas/{saida}')
        os.system(f'./l15e1 < testes/{entrada} > saidas/{saida}')

        entrada = f'entrada_0{i}.txt'
        saida = f'saida_0{i}.txt'

#Make Clean
os.system('make clean')

#Comparar
i = 1
saida = 'saida_01.txt'
print('\nComparando com saidas esperadas:')

while(i <= 5):
    i += 1
    if i < 10:
        print(f'diff saidas-esperadas/{saida} saidas/{saida}')
        os.system(f'diff saidas-esperadas/{saida} saidas/{saida}')
        time.sleep(0.5)

        saida = f'saida_0{i}.txt'
    else:
        print(f'diff saidas-esperadas/{saida} saidas/{saida}')
        os.system(f'diff saidas-esperadas/{saida} saidas/{saida}')
        time.sleep(0.5)

        saida = f'saida_{i}.txt'
