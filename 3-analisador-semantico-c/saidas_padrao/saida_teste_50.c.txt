warning:4:15: right shift count >= width of type
#define c4 c2 >> c3*c3
              ^
warning:11:6: array index out of bounds
    v[c4],c1>v,(char)c2,NULL?v:c3;
     ^
warning:11:13: comparison between 'int' and 'int*' operator '>'
    v[c4],c1>v,(char)c2,NULL?v:c3;
            ^
warning:11:16: cast from 'int' to 'char' of different size
    v[c4],c1>v,(char)c2,NULL?v:c3;
               ^
warning:11:31: 'int*'/'int' type mismatch in conditional expression
    v[c4],c1>v,(char)c2,NULL?v:c3;
                              ^
warning:23:28: right shift count >= width of type
    printf("%s",((char*)v) >> 666);
                           ^
warning:24:33: cast from 'int*' to 'char' of different size
    v=(void*)(v?((void*)((char)((char)(int*)666<(char)(void*)11))):(char*)"Mundo Invertido");
                                ^
warning:24:49: cast from 'void*' to 'char' of different size
    v=(void*)(v?((void*)((char)((char)(int*)666<(char)(void*)11))):(char*)"Mundo Invertido");
                                                ^
warning:24:26: cast from 'int' to 'char' of different size
    v=(void*)(v?((void*)((char)((char)(int*)666<(char)(void*)11))):(char*)"Mundo Invertido");
                         ^
warning:24:67: 'void*'/'char*' type mismatch in conditional expression
    v=(void*)(v?((void*)((char)((char)(int*)666<(char)(void*)11))):(char*)"Mundo Invertido");
                                                                  ^
warning:25:23: array index out of bounds
    return (char)vetor[1 << 1];
                      ^
warning:25:12: cast from 'char*' to 'char' of different size
    return (char)vetor[1 << 1];
           ^
warning:31:36: cast from 'int' to 'char' of different size
    char  c = g(), ch = '\r',  d = (char) 65; int* i = (int*) &p;    
                                   ^
warning:32:23: cast from 'int' to 'char' of different size
    for(ptr = (void*)((char)((int)666)); ptr;ptr++)
                      ^
warning:39:69: cast from 'int' to 'char' of different size
                *i/*666*/; *i/ 666/*Porta para o mundo invertido*/; (char)CALL_ELEVEN;
                                                                    ^
SUCCESSFUL COMPILATION.