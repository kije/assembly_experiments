section .bss
	popStr: 	resb	64
	popStrLen:	resb	64

section .text
	global _start

_start:
	call	_proc_print_stckpop
	call	_proc_exit


_proc_print_stckpop:
	mov 	eax,	4					; The syscall for write 
	mov		ebx,	1 					; File descriptor 1 - stdout
	pop 	ecx							; put value from top of stack to ecx
	mov		[popStr], ecx				; load content to var popStr
	mov 	edx,	[$-popStr]

	;mov		[popStrLen], 0				; fill var popStrLen with 0
	;sub		popStrLen, byte[popStr] 	; substrsct popStr from popStrLen

	
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