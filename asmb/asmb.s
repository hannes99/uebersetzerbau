	.file	"asmb.c"
	.text
	.globl	asmb
	.type	asmb, @function
asmb:
.LFB0:
	.cfi_startproc
    pxor    %mm5, %mm5
    movq    %rdi, %rax
    movq    $0x6060606060606060, %r11 #a's
    movq    %r11, %mm2
    movq    $0x2020202020202020, %r9
    movq    $0x7b7b7b7b7b7b7b7b, %r8
.L1:
    movq    %r8, %mm3 #z's
    movq    %r9, %mm4
    movq    (%rdi), %mm0
    movq    %mm0, %mm1
    pcmpgtb %mm2, %mm1
    pcmpgtb %mm0, %mm3
    pand    %mm3, %mm1
    pand    %mm1, %mm4
    psubb   %mm4, %mm0
    movq    %mm0, (%rdi)
    pcmpeqb %mm0, %mm5
    add     $8, %rdi
    movq    %mm5, %r10
    cmpq      $0, %r10
    je	    .L1
	ret
	.cfi_endproc
.LFE0:
	.size	asmb, .-asmb
	.ident	"GCC: (Arch Linux 9.2.1+20200130-2) 9.2.1 20200130"
	.section	.note.GNU-stack,"",@progbits
