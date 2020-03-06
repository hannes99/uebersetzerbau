#include <stdlib.h>
#include <stdio.h>

extern void asma(unsigned char *s);


int main() {
    unsigned char x[16];
    int i;
    for(i=0;i<16;i++) {
        x[i] = 251+i;
    }
    asma(x);
    for(i=0;i<16;i++) {
        printf("%d\n", x[i]);
    }
}
