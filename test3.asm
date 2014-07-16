section .data
	hello:		db 'Hello World!',10	; Hello World with \n
	helloLen:	equ	$-hello 			; Length of hello World string

section .text
	global _start

_start:
	call 	_hello_world_endless
	call 	_exit

_hello_world:
	mov 	eax,	4					; The syscall for write 
	mov		ebx,	1 					; File descriptor 1 - stdout
	mov		ecx,	hello 				; put offset of hello to ecx
	mov		edx, 	helloLen 			; set srin lenght. is allready a constant, so we ont need to do mov edx, [helloLen]

	int		80h
	ret

_hello_world_endless:
	call 	_hello_world
	call 	_hello_world_endless
	ret 

_exit:
	mov		eax,	1 					; Syscall for exit (sys_exit)
	mov		ebx,	0					; rturn code 0

	int		80h							; Call to the kernel (execute the syscall)
	ret