#include <stdio.h>

int main() {

    char c;

    while(fscanf(stdin, "%c", &c) != EOF) {
        //printf("alo\n");
        printf("%c", c);
    }

    return 0;
}