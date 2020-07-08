#include <stdio.h>
#include "asm.h"

const char* reg_to_str(enum Register r) {
    switch(r) {
        case RDI: return "rdi";
        case RSI: return "rsi";
        case RDX: return "rdx";
        case RCX: return "rcx";
        case R8: return "r8";
        case R9: return "r9";
        case R10: return "r10";
        case R11: return "r11";
        case RAX: return "rax";
        case R15: return "r15";
 //       case REGISTER_NONE: return "unknown";
        default: return "none";
    }
}

void a_immidiate(long long value, enum Register reg) {
	const char *to = reg_to_str(reg);
	printf("\tmovq $%d, %%%s\n", value, to);
}

void a_move_reg_reg(enum Register s, enum Register t) {
	if(s != t) {
		const char *from = reg_to_str(s);
		const char *to = reg_to_str(t);
		printf("\tmovq %%%s, %%%s\n", from, to);
	}
}

void a_add(enum Register s, enum Register d) {
    const char *source = reg_to_str(s);
    const char *dest = reg_to_str(d);
    printf("\tadd %%%s, %%%s\n", source, dest);
}

void a_add_i(unsigned long long val, enum Register t) {
    if(val != -1) {
        const char *dest = reg_to_str(t);
        printf("\tadd $%d, %%%s\n", val, dest); 
    }
}

void a_mv_reg_reg(enum Register s, enum Register d) {
    const char *source = reg_to_str(s);
    const char *dest = reg_to_str(d);
    printf("\tmovq %%%s, %%%s\n", source, dest);
}

void a_ret() {
    printf("\tret\n");
}
