section .text
	global _start

_start:
	pop		eax			; load top value from stack to eax
	pop		ebx			; progr name
	pop		ebx			; 1th arg 
	pop		ecx			; 2th arg 
	pop		edx			; 3th arg 


	mov		eax,	1
	mov 	ebx,	0	
	int		80h