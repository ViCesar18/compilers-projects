void f()
{
    char c;
    int i;
    int v[10];

    int* p;

    
    for(p=&(v[0]);p;p++)
    {
        printf("Conteudo: %d",*p);
    }

    c = (char) i; /*meio certo*/  i << -1; /*errado*/
}