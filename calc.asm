;;	ASMCALC by kije
;; 	Small 32-bit calcualtor written in assembler


section .data
	;;;; TEXT
	welcomeText 				db		10,'-- ASMCALC by kije --',10,10
	welcomeTextLen				equ		$-welcomeText
	askForCommandTextStart		db		'Enter one of the following commands: ['
	askForCommandTextStartLen	equ		$-askForCommandTextStart
	askForCommandTextEnd		db		']',10
	askForCommandTextEndLen		equ		$-askForCommandTextEnd
	invalidCommandTextStart		db		'-> You have entered a wrong command. Please use ['
	invalidCommandTextStartLen	equ 	$-invalidCommandTextStart
	invalidCommandTextEnd		db		']!', 10,10
	invalidCommandTextEndLen	equ 	$-invalidCommandTextEnd
	askForNumbersText			db 		'Now, enter the numbers for the calculation.',10
	askForNumbersTextLen 		equ 	$-askForNumbersText


	;;;; COMANDS 
	addCommand					db		'+'
	addCommandLen				equ 	$-addCommand
	subCommand					db		'-'
	subCommandLen 				equ 	$-subCommand
	mulCommand					db		'*'
	mulCommandLen 				equ 	$-mulCommand
	divCommand					db		'/'
	divCommandLen 				equ 	$-divCommand
	exitCommand					db 		'exit'
	exitCommandLen 				equ 	$-exitCommand

	;;;; OTHER
	readBufferSize				equ 	128
	comandListSeparatorText		db 		', '
	comandListSeparatorTextLen	equ 	$-comandListSeparatorText
	numberPrefix				db 		'Number '
	numberPrefixLen 			equ 	$-numberPrefix
	eol 						db 		10
	eolLen 						equ 	$-eol


section .bss
	readBuffer:		resb	readBufferSize
	compString1:	resb 	readBufferSize
	compString2:	resb 	readBufferSize
	number1: 		resb 	readBufferSize
	number2: 		resb 	readBufferSize

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
	call 	_proc_print_command_prompt

	call	_proc_readline	
	call	_proc_check_command_input

	mov		ecx, 	5
	loop 	_LOOP_main

;;;; END LOOP

_proc_check_command_input:
	push	ebp
	mov		ebp, esp

	;; IF readBuffer == addCommand
	push 	readBuffer
	push 	addCommand
	call 	strcmp 

	cmp		eax,	0
	jz		_IF_command_add
	
	;; IF readBuffer == subCommand
	push 	readBuffer
	push 	subCommand
	call 	strcmp 

	cmp		eax,	0
	jz		_IF_command_sub

	;; IF readBuffer == divCommand
	push 	readBuffer
	push 	divCommand
	call 	strcmp 

	cmp		eax,	0
	jz		_IF_command_div

	;; IF readBuffer == mulCommand
	push 	readBuffer
	push 	mulCommand
	call 	strcmp 

	cmp		eax,	0
	jz		_IF_command_mul

	;; IF readBuffer == exit
	push 	readBuffer
	push 	exitCommand
	call 	strcmp 

	cmp		eax,	0
	jz		_IF_command_exit

	;; ELSE
	jmp		_IF_command_invalid


;;; IF
_IF_command_add:
	call 	_proc_get_numbers

	jmp		_IF_command_END

_IF_command_sub:
	call 	_proc_get_numbers

	jmp		_IF_command_END

_IF_command_div:
	call 	_proc_get_numbers

	jmp		_IF_command_END

_IF_command_mul:
	call 	_proc_get_numbers

	jmp		_IF_command_END

_IF_command_exit:
	call 	_exit
	jmp		_IF_command_END

_IF_command_invalid:
	mov		ecx,	invalidCommandTextStart
	mov		edx,	invalidCommandTextStartLen
	call	_proc_print

	call 	_proc_print_commands

	mov		ecx,	invalidCommandTextEnd
	mov		edx,	invalidCommandTextEndLen
	call	_proc_print

	jmp		_IF_command_END


_IF_command_END:
	leave
	ret

;; END IF


_proc_print_command_prompt:
	mov		ecx,	askForCommandTextStart
	mov		edx,	askForCommandTextStartLen
	call	_proc_print

	call 	_proc_print_commands

	mov		ecx,	askForCommandTextEnd
	mov		edx,	askForCommandTextEndLen
	call	_proc_print

	ret



_proc_print_commands:
	;; ADD
	mov		ecx,	addCommand
	mov		edx,	addCommandLen
	call	_proc_print

	mov		ecx, 	comandListSeparatorText
	mov		edx, 	comandListSeparatorTextLen
	call 	_proc_print

	;; SUB
	mov		ecx,	subCommand
	mov		edx,	subCommandLen
	call	_proc_print

	mov		ecx, 	comandListSeparatorText
	mov		edx, 	comandListSeparatorTextLen
	call 	_proc_print

	;; DIV
	mov		ecx,	divCommand
	mov		edx,	divCommandLen
	call	_proc_print

	mov		ecx, 	comandListSeparatorText
	mov		edx, 	comandListSeparatorTextLen
	call 	_proc_print

	;; MUL
	mov		ecx,	mulCommand
	mov		edx,	mulCommandLen
	call	_proc_print

	mov		ecx, 	comandListSeparatorText
	mov		edx, 	comandListSeparatorTextLen
	call 	_proc_print

	;; EXIT
	mov		ecx,	exitCommand
	mov		edx,	exitCommandLen
	call	_proc_print

	ret




_proc_get_numbers:
	call 	_proc_promtp_for_numbers


	ret

_proc_promtp_for_numbers:
	mov		ecx,	askForNumbersText
	mov		edx,	askForNumbersTextLen
	call	_proc_print

	ret


_syscall:
	int		80h
	ret
	
_exit:
	mov		eax,	1
	mov		ebx,	0

	call	_syscall
	ret


;;;;;;; BORROWED STRING FUNCTIONS FROM http://forum.codecall.net/topic/65299-assembly-intro-to-algorithms-with-string-functions-win32-nasm/

strlen: 
	enter 0, 0      						;; The stack frame. 
	pusha           						;; We push EAX, ECX, EDX, EBX, ESP, EBP, ESI, EDI (in that order). 

	mov eax, dword [ebp+8]          		;; Get the address of the string; it's the first argument. 
	mov ebx, eax                         	;; b= address of the string 

	xor ecx, ecx                          	;; c= 0 
	.lp1:                                   ;; local label loop 1 
	  	;; if byte [b] is 0 then go to loop 1 stop 
	  	cmp byte [ebx], 0 
	  	jz .lp1s 
	  
	  	inc ecx                               ;; c= c + 1 
	  	inc ebx                               ;; b= b + 1 
	  
	  	jmp .lp1                              ;; go to loop 1 
	.lp1s: 
	;; return c 
	mov eax, ecx 
	mov dword [ebp-4], eax 

	popa 
	leave 
	ret 4

strcmp: 
	enter 0, 0                    ;; We don't really need any memory local variables, right now. 
	pusha                         ;; Save the values of all the general-purpose registers. 

	;; b= argument 1 
	mov eax, dword [ebp+08] 
	mov ebx, eax 

	;; d= argument 2 
	mov eax, dword [ebp+12] 
	mov edx, eax 

	;; We'll use EAX for both integer c and character a. 
	xor eax, eax 
	.lp12: 
		mov al, byte [ebx]                 ;; Get byte [b] 
	  	mov ah, byte [edx]                ;; Get byte [d] 
	  	sub al, ah                            ;; See if they're the same. 
	  	jnz .lp1s2                              ;; If not, the strings are not equal for sure. 
	  
	  	cmp ah, 0                            ;; They're the same; but are they 0? 
	  	;; Note that we can't use AL, here, because it'll always be 0 if the processor 
	  	;; makes it to this instruction, because of the SUB instruction, above. 
	  	jz .lp1s2                                ;; If so, the strings ended already, and we need to return. 
	  
	  	inc ebx                                ;; b= b + 1 
	  	inc edx                                ;; d= d + 1 
	  
	  	jmp .lp12 
	.lp1s2: 

	cbw                                     ;; This instruction converts a byte value to a word value. 
	                                          ;; This helps in situations where AL is a signed integer, because 
	                                          ;; if you just clear AH then AX will be 256 - |the integer| for negative numbers. 
	                                          ;; 00000010 is binary for 2 
	                                          ;; 11111110 is binary for -2 
	                                          ;; 11111101 is binary for -3 
	                                          ;; 11111100 is binary for -4 
	                                          ;; ... and so on ...  
	                                          ;; But if you include AH to make AX, then it would be (if AH is 0): 
	                                          ;; 00000000 00000010 is binary for 2 
	                                          ;; 00000000 11111110 is binary for 254 
	                                          ;; 00000000 11111101 is binary for 253 
	                                          ;; ... and so on ...  
	                                          ;; So what CBW does is it takes the left-most bit of AL and 
	                                          ;; it sets every bit in AH to that value. 
	                                          ;; 00000000 00000010 is binary for 2 
	                                          ;; 11111111 11111110 is binary for -2 
	                                          ;; 11111111 11111101 is binary for -3 
	                                          ;; ... and so on ...  
	cwde                                   ;; Then we have to convert the word (in AX) to a double-word; same idea as before. 

	mov dword [ebp-4], eax            ;; return c 

	popa                                      ;; Restore the register values. 
	leave                                     ;; Switch back to the previous stack frame. 
	ret 8                                      ;; Free 8 bytes after return.
		
