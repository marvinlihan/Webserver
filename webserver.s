.intel_syntax noprefix			# use intel_syntax -> no % or & prafix needed
.globl _start				# set the linker the starting point (feels like main in other programming languages)
.section .text				# define code section
_start:
	mov rax, 41			# syscall number for the socket syscall
	mov rdi, 2			# domain = AF_INEt for IPv4 adresses
	mov rsi, 1			# type = SOCK_STREAm for data transfer with tcp
	mov rdx, 0			# protocol = 0 (tcp)
	syscall

	mov rax, 60			# syscall for exit
	mov rdi, 0
	syscall

