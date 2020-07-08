#ifndef __ASM_H__
#define __ASM_H__

enum Register {
    RDI = 0,
    RSI,
    RDX,
    RCX,
    R8,
    R9,
    R10,
    R11,
    REG_COUNT,
    RAX,
    R15,
	REG_NONE    
};
const char* reg_to_str(enum Register r);

void a_immidiate(long long value, enum Register reg);

void a_move_reg_reg(enum Register s, enum Register t);

void a_add(enum Register s, enum Register d);
void a_add_i(unsigned long long val, enum Register d);

void a_mv_reg_reg(enum Register s, enum Register d);

void a_ret();

#endif

