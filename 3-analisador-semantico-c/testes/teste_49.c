void f()
{
    int i;
    i++;
}

int main()
{
    char c = 'c';
    int w = (int)c;
    
    (void)f();    
    (void)((void)f());
    
    (void) 666;
    (void*) 666;
    (void) 'z';
    (void)(char)(int)(char)77;
    
    w = (int) f();
    
    return 0;
}