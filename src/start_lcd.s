				AREA    lcdscreen, CODE, READONLY
				THUMB
					
				IMPORT		LCD_SET_XY
				IMPORT		LCD_OUT_STR
							
				EXPORT		startLCD
			
; 0x04: end char
berkin_name  	DCB		"BERKIN ANIK"
				DCB		0x04
berkin_id		DCB		"2397123"
				DCB		0x04
empty_line		DCB		"=============="
				DCB		0x04
water_level		DCB		"WATER LEVEL"
				DCB		0x04
berkin_title	DCB		"BERKINANIK-WLC"
				DCB		0x04
setting			DCB		"ADJUST:"
				DCB		0x04
sensitivity		DCB		"Sens:"
				DCB		0x04
target			DCB		"Trgt:"
				DCB		0x04
current			DCB		"Curr:"
				DCB		0x04
			
startLCD
				PUSH	{LR}
				
				;MOV		R0, #0
				;MOV		R1, #0
				;BL		LCD_SET_XY
				;LDR		R5, =berkin_name
				;BL		LCD_OUT_STR
				
				;MOV		R0, #0
				;MOV		R1, #1
				;BL		LCD_SET_XY
				;LDR		R5,=berkin_id
				;BL		LCD_OUT_STR
				
				MOV		R0, #0
				MOV		R1, #0
				BL		LCD_SET_XY
				LDR		R5,=berkin_title
				BL		LCD_OUT_STR
				
				;MOV		R0, #0
				;MOV		R1, #1
				;BL		LCD_SET_XY
				;LDR		R5,=water_level
				;BL		LCD_OUT_STR
				
				MOV		R0, #0
				MOV		R1, #1
				BL		LCD_SET_XY
				LDR		R5,=empty_line
				BL		LCD_OUT_STR
				
				MOV		R0, #0
				MOV		R1, #2
				BL		LCD_SET_XY
				LDR		R5,=setting
				BL		LCD_OUT_STR
				
				MOV		R0, #0
				MOV		R1, #3
				BL		LCD_SET_XY
				LDR		R5,=sensitivity
				BL		LCD_OUT_STR
				
				MOV		R0, #0
				MOV		R1, #4
				BL		LCD_SET_XY
				LDR		R5,=target
				BL		LCD_OUT_STR
				
				MOV		R0, #0
				MOV		R1, #5
				BL		LCD_SET_XY
				LDR		R5,=current
				BL		LCD_OUT_STR
				
				; Set adjust count starting value
				LDR		R0, =0x20001600
				MOV32	R1, #200
				STR		R1, [R0]
				; Set adjust status starting value
				LDR		R0, =0x20001608
				MOV		R1, #1
				STR		R1, [R0]
				
				POP		{LR}
				BX		LR

;*****************************************************************

				ALIGN
				END
					