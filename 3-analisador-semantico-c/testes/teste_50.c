#define c1 10
#define c2 -c1
#define c3 c1 << 2
#define c4 c2 >> c3*c3
#define NULL 0
#define CALL_ELEVEN 11
int v[c2+c3];

void* f()
{
    v[c4],c1>v,(char)c2,NULL?v:c3;
    return (void*) 0;
}

#define TRUE  1
#define FALSE 0
#define SERA_VERDADE (TRUE || FALSE)?TRUE:FALSE
char* vetor[SERA_VERDADE];

char g()
{
    void* v = (void*) "DDominar o mundo\n" + 1;
    printf("%s",((char*)v) >> 666);
    v=(void*)(v?((void*)((char)((char)(int*)666<(char)(void*)11))):(char*)"Mundo Invertido");
    return (char)vetor[1 << 1];
}

int main()
{
    void* p = f(), *vp = (void*) 0, *ptr = (void*)NULL;
    char  c = g(), ch = '\r',  d = (char) 65; int* i = (int*) &p;    
    for(ptr = (void*)((char)((int)666)); ptr;ptr++)
    {
        while(ptr) 
        {
            if(ptr<=(void*)0)
            {
                ptr = (void*) &c;
                *i/*666*/; *i/ 666/*Porta para o mundo invertido*/; (char)CALL_ELEVEN;
            }
            else
            {
                do{ ptr++; }while(v);
            }
        }
    }
    return (((int)ptr) + *i);
}