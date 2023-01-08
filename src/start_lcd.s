				AREA    lcdscreen, CODE, READONLY
				THUMB
					
				IMPORT		LCD_SET_XY
				IMPORT		LCD_OUT_STR
							
				EXPORT		startLCD
			
; 0x04: end char
berkin_text   	DCB		"BERKIN ANIK"
				DCB		0x04
berkin_id_text	DCB		"2397123"
				DCB		0x04
empty_line		DCB		"=============="
				DCB		0x04
			
startLCD
				PUSH 	{R0-R5}
				
				MOV		R0, #0
				MOV		R1, #0
				BL		LCD_SET_XY
				LDR		R5,=berkin_text
				BL		LCD_OUT_STR
				
				MOV		R0, #0
				MOV		R1, #1
				BL		LCD_SET_XY
				LDR		R5,=berkin_id_text
				BL		LCD_OUT_STR
				
				MOV		R0, #0
				MOV		R1, #2
				BL		LCD_SET_XY
				LDR		R5,=empty_line
				BL		LCD_OUT_STR
				
				POP		{R0-R5}
				BX		LR

;*****************************************************************

				ALIGN
				END
					