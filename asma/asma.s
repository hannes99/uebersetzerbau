	.file	"asma.c"
	.text
	.globl	asma
	.type	asma, @function
asma:
.LFB0:
	.cfi_startproc
    leaq    16(%rdi), %r9
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
    pcmpgtb %mm2, %mm1 # Generate 1’s in MM1 everywhere chars >= ‘a’
    pcmpgtb %mm0, %mm3 # Generate 1’s in MM3 everywhere chars <= ‘z’
    pand    %mm3, %mm1 # Generate 1’s in MM1 when ‘a’<=chars<=’z’
    psubb   %mm4, %mm0
    pand    %mm1, %mm0
    movq    %mm0, (%rdi)
    add     $8, %rdi
    cmpq	%rdi, %r9
    jne	    .L1
	ret
	.cfi_endproc
.LFE0:
	.size	asma, .-asma
	.ident	"GCC: (Arch Linux 9.2.1+20200130-2) 9.2.1 20200130"
	.section	.note.GNU-stack,"",@progbits
