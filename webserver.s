.intel_syntax noprefix			# use intel_syntax -> no % or & prafix needed 
.globl _start				# set the linker the starting point (feels like main in other programming languages)
.section .text				# text section where the code lays 
_start:
	mov rax, 60			# syscall for exit 
	mov rdi, 0
	syscall

