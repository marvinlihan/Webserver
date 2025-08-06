.intel_syntax noprefix			# use intel syntax -> no % or & prafix needed
.globl _start				# set the starting point for the linker (feels like main in other programming languages)
.section .text				# define code section
_start:
	mov rax, 41			# syscall number for the socket syscall
	mov rdi, 2			# domain = AF_INEt for IPv4 adresses
	mov rsi, 1			# type = SOCK_STREAm for tcp stream communication
	mov rdx, 0			# protocol = 0 (tcp)
	syscall				# on sucess return a file descriptor

	mov r12, rax			# bind need socket_fd and because rax is used for syscall for bind we need to save the fd somewhere else

	mov rax, 49			# syscall number for the bind syscall
	mov rdi, r12			# socket_fd
	lea rsi, [sockaddr]		# struct for the adress of the socket
	mov rdx, 16			# length of adress (16 bytes)
	syscall

	mov rax, 50			# syscall number for the listen syscall
	mov rdi, r12			# socket_fd
	mov rsi, 10			# how many connections at the same time -> 10 here magic number
	syscall

	mov rax, 43			# syscall number for the accept syscall
	mov rdi, r12			# socket_fd
	mov rsi, 0			# here both rsi/rdx are information about the client connecting which is optional
	mov rdx, 0
	syscall				# on sucess return a file descriptor

	mov r13, rax			# used for reading/writing the client response

	mov rax, 0			# syscall number for the read syscall -> read http request from client
	mov rdi, r13			# fd from accept
	lea rsi, [read_location]	# buffer
	mov rdx, 512			# bytes to read
	syscall

	mov rax, 2			# syscall number for open syscall
	lea rdi, [path_buffer]		# read path from the http request
	mov rsi, 0			# 0 = o_RDONLY
	mov rdx, 0			# mode not needed
	syscall

	mov r14, rax			# fd from open for read2

	mov rax, 0			# syscall number for the read syscall -> now we want to read the content where the request leads
	mov rdi, r14			# fd from open
	lea rsi, [read_content]		# storage of content
	mov rdx, 512			# bytes to read
	syscall

	mov rax, 1			# syscall number for the write syscall
	mov rdi, r13			# fd from client
	lea rsi, [read_content]		# buffer to write the content
	mov rdx, 512			# bytes to write (max)
	syscall

	mov rax, 60                     # syscall for exit
        mov rdi, 0
        syscall

.section .data
sockaddr:
	.word 2              # AF_INEt
	.word 0x901f         # Port 8080 (htons(8080)) in big endian
   	.long 0x00000000     # 0.0.0.0 (INADDR_ANy)
    	.long 0x00000000     # padding

read_location:			# storage for the http-request to find location
	.space 512

read_content:
	.space 512		# storage to hold content of the content from the object which got opened

path_buffer:
	.asciz "index.html"
