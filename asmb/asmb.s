	.file	"asmb.c"
	.text
	.globl	asmb
	.type	asmb, @function
asmb:
.LFB0:
	.cfi_startproc
    pxor    %mm5, %mm5
    movq    %rdi, %rax
    movq    $0x6060606060606060, %r8
    movq    %r8, %mm2
    movq    $0x2020202020202020, %r8
    movq    %r8, %mm4
    movq    $0x7b7b7b7b7b7b7b7b, %r8
.L1:
    movq    %r8, %mm3 #z's
    movq    (%rdi), %mm0
    movq    %mm0, %mm1
    pcmpeqb %mm0, %mm5
    pcmpgtb %mm2, %mm1
    pcmpgtb %mm0, %mm3
    pand    %mm3, %mm1
    psubb   %mm4, %mm0
    pand    %mm1, %mm0
    movq    %mm0, (%rdi)
    add     $8, %rdi
    movq    %mm5, %r12
    cmpq	$0, %r12
    je	    .L1
	ret
	.cfi_endproc
.LFE0:
	.size	asmb, .-asmb
	.ident	"GCC: (Arch Linux 9.2.1+20200130-2) 9.2.1 20200130"
	.section	.note.GNU-stack,"",@progbits
