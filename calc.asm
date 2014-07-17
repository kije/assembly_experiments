section .data
	;;;; TEXT
	welcomeText 			db	'-- ASMCALC by kije --',10
	welcomeTextLen			equ	$-welcomeText
	askForCommandText		db	'Enter one of the following commands: [add, sub, div, mul]',10
	askForCommandTextLen	equ	$-askForCommandText
	invalidCommandText		db	'You have entered a wrong command. Use [add, sub, div, mul] !',10
	invalidCommandTextLen	equ $-invalidCommandText

	;;;; COMANDS 
	addCommand				db	'add'
	subCommand				db	'sub'
	divCommand				db	'div'
	mulCommand				db	'mul'

	;;;; OTHER
	readBufferSize	equ	128

section .bss
	readBuffer:		resw	readBufferSize

section .text
	global _start:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_start:
	mov		ecx,	welcomeText
	mov		edx,	welcomeTextLen
	call	_proc_print

	call	_proc_start_loop		


	call	_exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_proc_print:
	mov		eax, 	4
	mov		ebx,	1

	call 	_syscall
	ret

_proc_readline:
	mov		eax,	3
	mov		ebx,	0
	mov		ecx, 	readBuffer
	mov		edx,	readBufferSize

	call 	_syscall
	ret

_proc_start_loop:
	mov		ecx, 	5
	loop 	_LOOP_main

;;;; LOOP
_LOOP_main:
	mov		ecx,	askForCommandText
	mov		edx,	askForCommandTextLen
	call	_proc_print

	call	_proc_readline	
	call	_proc_check_command_input

	mov		ecx, 	5
	loop 	_LOOP_main

;;;; END LOOP

_proc_check_command_input:
	push	ebp
	mov		ebp, esp

	cmp		[readBuffer], dword addCommand
	je		_IF_command_add
	cmp		[readBuffer], dword subCommand
	je		_IF_command_sub
	cmp		[readBuffer], dword divCommand
	je		_IF_command_div
	cmp		[readBuffer], dword mulCommand
	je		_IF_command_mul
	jmp		_IF_command_invalid


;;; IF
_IF_command_add:
	
	jmp		_IF_command_END

_IF_command_sub:

	jmp		_IF_command_END

_IF_command_div:

	jmp		_IF_command_END

_IF_command_mul:

	jmp		_IF_command_END

_IF_command_invalid:
	mov		ecx,	invalidCommandText
	mov		edx,	invalidCommandTextLen
	call	_proc_print
	jmp		_IF_command_END


_IF_command_END:
	leave
	ret

;; END IF



_syscall:
	int		80h
	ret
	
_exit:
	mov		eax,	1
	mov		ebx,	0

	call	_syscall
	ret
