; loop example

section .text
	txt 	db	'Round '
	txtLen 	equ	$-txt
	nl 		db 	10
	nlLen	equ	$-nl

section .text
	global _start

_start:
	mov		ecx, 5
	start_loop:
		push	ecx
		mov		ecx,	txt
		mov		edx,	txtLen
		call	_proc_print
		call	_proc_print_newline
		pop 	ecx
	loop start_loop

	call	_proc_exit


_proc_print:
	mov		eax, 	4
	mov		ebx,	1

	call 	_proc_syscall
	ret

_proc_print_newline:
	mov		eax, 	4
	mov		ebx,	1
	mov		ecx,	nl
	mov		edx,	nlLen

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
