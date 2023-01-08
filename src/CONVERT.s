FIRST	   	EQU	    	0x20000480
COUNT		EQU			0x20000488

;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	convert, READONLY, CODE
			THUMB
				
			EXPORT  	CONVERT

CONVERT		PROC
						
start		PUSH		{R0-R12}
			MOV	    	R0,R4
			LDR			R5,=FIRST
			MOV 		R6,#1
			MOV			R7,#0x04
			MOV			R10,#10
			MOV 		R8,#1
			UDIV 		R9, R0,R10
loop1 		UDIV 		R9,R9,R10
			ADDS		R9,#0
			ADD			R8,#1
			MUL			R6,R10
			BNE			loop1
			PUSH		{R5}
			LDR			R5, =COUNT
			STR			R8, [R5]
			POP			{R5}
			ADDS 		R6,#0
loop2		UDIV		R3,R0,R6
			MUL			R4,R3,R6
			SUB			R0,R0,R4
			SUBS		R8,#1
			UDIV		R6,R10
			ADD			R3,#48
			STRB		R3, [R5]
			ADD			R5,#1
			BNE 		loop2
			STRB		R7,[R5]
		
			POP         {R0-R12}
			BX			LR	
			
			ALIGN
			ENDP
