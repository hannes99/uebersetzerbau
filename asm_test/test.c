#include <stdlib.h>
#include <stdio.h>

extern void asma(unsigned char *s);
extern void asmb(unsigned char *s);

void testA() {
    unsigned char x[16];
    int i;
    for(i=0;i<16;i++) {
        x[i] = 115+i;
    }
    asma(x);
    for(i=0;i<16;i++) {
        printf("%d\n", x[i]);
    }
}

void testB() {
    unsigned char x[51];
    int i;
    for(i=0;i<50;i++) {
        x[i] = 80+i;
    }
    x[50] = 0;
    asmb(x);
    for(i=0;i<51;i++) {
        printf("%d\n", x[i]);
    }
}


int main() {
    testA();
    //testB();
}
