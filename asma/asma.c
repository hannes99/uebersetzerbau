unsigned char *asma(unsigned char *s) {
    int i;
    unsigned char c;
    for (i=0; i<16; i++) {

        c=s[i];
        c += (c>='a' && c<='z') ? 'A'-'a' : 0;
        s[i] = c;
    }
    return s;
}
