; if test

section .data
	welcomeText		db	'--- Controll Structures ---',10
	welcomeTextLen	equ	$-welcomeText
	txt 			db 	'equal',10
	txtLen 			equ $-txt 
	txt2 			db 	'not Equal',10
	txt2Len			equ $-txt2
	endText			db	'END',10
	endTextLen 		equ $-endText


section .bss
	var1:	resw	1
	var2:	resw	1

section .text
	global _start


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_start:
	call	proc_print_welcome_text
	mov		[var1],	dword 2
	call	proc_check_if_equal

	call	proc_print_end

	call	_exit



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



proc_check_if_equal:
	push	ebp
	mov		ebp, esp
	
	cmp		[var1], dword 1

	je		IF_EQUAL
	jmp		IF_NOT_EQUAL

IF_EQUAL:
	call	proc_print_equal
	jmp		IF_END
	
IF_NOT_EQUAL:
	call	proc_print_notequal
	jmp		IF_END

IF_END:
	leave
	ret



proc_print_equal:
	mov		eax, 	4
	mov		ebx, 	1
	mov		ecx,	txt
	mov		edx,	txtLen

	call	_syscall
	ret

proc_print_notequal:
	mov		eax, 	4
	mov		ebx, 	1
	mov		ecx,	txt2
	mov		edx,	txt2Len

	call	_syscall
	ret


proc_print_welcome_text:
	mov		eax, 	4
	mov		ebx, 	1
	mov		ecx,	welcomeText
	mov		edx,	welcomeTextLen

	call	_syscall
	ret

proc_print_end:
	mov		eax, 	4
	mov		ebx, 	1
	mov		ecx,	endText
	mov		edx,	endTextLen

	call	_syscall
	ret


_syscall:
	int		80h
	ret
	
_exit:
	mov		eax,	1
	mov		ebx,	0

	call	_syscall
	ret
