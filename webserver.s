.intel_syntax noprefix			# use intel_syntax -> no % or & prafix needed
.globl _start				# set the linker the starting point (feels like main in other programming languages)
.section .text				# define code section
_start:
	mov rax, 41			# syscall number for the socket syscall
	mov rdi, 2			# domain = AF_INEt for IPv4 adresses
	mov rsi, 1			# type = SOCK_STREAm for data transfer with tcp
	mov rdx, 0			# protocol = 0 (tcp)
	syscall				# on sucess return a file descriptor

	mov r12, rax			# bind need socket_fd and because rax is used for syscall for bind we need to safe the fd somewhere else

	mov rax, 49			# syscall number for the bind syscall
	mov rdi, r12			# socket_fd
	lea rsi, [sockaddr]		# struct for the adress of the socket
	mov rdx, 16			# length adress (16 bytes)
	syscall


	mov rax, 60			# syscall for exit
	mov rdi, 0
	syscall

.section .data
sockaddr:
	.word 2              # AF_INEt
	.word 0x5000         # Port 80 (htons(80)) in big endian
   	.long 0x00000000     # 0.0.0.0 (INADDR_ANy)
    	.long 0x00000000     # padding

