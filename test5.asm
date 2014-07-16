; This Programm tries to read a value from stdin and print it to stdout

section .data
	welcomeText		db	'------- WELCOME TO MY LITTLE ASSEMBLY PROGRAMM -------', 10
	welcomeTextLen	equ	$-welcomeText
	newline			db	10
	newlineLen		equ	$-newline

	read_line_len	equ	100

section .bss
	read_line: 	resw	read_line_len

section .text
	global _start

_start:
	call 	_proc_print_welcome_message
	call	_proc_readline
	;call	_proc_print_read_line

	call 	_proc_exit

_proc_print_welcome_message:
	mov		eax, 	4
	mov		ebx,	1
	mov		ecx,	welcomeText
	mov		edx,	welcomeTextLen

	call 	_proc_syscall
	call 	_proc_print_newline
	ret

_proc_print_newline:
	mov		eax, 	4
	mov		ebx,	1
	mov		ecx,	newline
	mov		edx,	newlineLen

	call 	_proc_syscall
	ret

_proc_readline:
	mov		eax,	3
	mov		ebx,	0
	mov		ecx, 	[read_line]
	mov		edx,	read_line_len

	call 	_proc_syscall
	ret

_proc_print_read_line:
	mov		eax,	4
	mov		ebx,	1
	mov		ecx, 	[read_line]
	mov		edx,	read_line_len

	call 	_proc_syscall
	ret


_proc_exit:
	mov		eax,	1 					; Syscall for exit (sys_exit)
	mov		ebx,	0					; rturn code 0
	call 	_proc_syscall
	ret

_proc_syscall:
	int		80h
	ret