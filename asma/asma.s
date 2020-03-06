	.file	"asma.c"
	.text
	.globl	asma
	.type	asma, @function
asma:
.LFB0:
	.cfi_startproc
	movq	%rdi, %rdx
	leaq	16(%rdi), %rsi
.L3:
	movzbl	(%rdx), %ecx
	leal	-97(%rcx), %eax
	cmpb	$26, %al
	sbbl	%eax, %eax
	andl	$-32, %eax
	addl	%ecx, %eax
	movb	%al, (%rdx)
	addq	$1, %rdx
	cmpq	%rsi, %rdx
	jne	.L3
	movq	%rdi, %rax
	ret
	.cfi_endproc
.LFE0:
	.size	asma, .-asma
	.ident	"GCC: (Arch Linux 9.2.1+20200130-2) 9.2.1 20200130"
	.section	.note.GNU-stack,"",@progbits
