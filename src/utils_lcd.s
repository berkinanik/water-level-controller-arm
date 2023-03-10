GPIO_PORTA_DATA		EQU	0x400043FC	; Port A Data

SSI0_DR				EQU	0x40008008
SSI0_SR				EQU	0x4000800C

ADJUST_COUNT		EQU	0x20001600
ADJUST_STATUS		EQU	0x20001608
	
				AREA    lcdscreen, CODE, READONLY
				THUMB
				
				IMPORT		CONVERT
				
				EXPORT		LCD_SET_XY
				EXPORT		LCD_PRINT_CHAR
				EXPORT		LCD_PRINT_BYTE
				EXPORT		LCD_CLEAR
				EXPORT		LCD_OUT_STR
				EXPORT		lcdOutWaterLevel
				EXPORT		lcdClearWaterLevel
				EXPORT		lcdSettingTarget

unit_ml 		DCB		"ml"
				DCB		0x04
blank_text		DCB		"         "
				DCB		0x04
blank_text2		DCB		"    "
				DCB		0x04
sens_text		DCB		"SENS"
				DCB		0x04
target_text		DCB		"TRGT"
				DCB		0x04

; ASCII table for characters to be displayed
ASCII	DCB		0x00, 0x00, 0x00, 0x00, 0x00 ;// 20
		DCB		0x00, 0x00, 0x5f, 0x00, 0x00 ;// 21 !
		DCB		0x00, 0x07, 0x00, 0x07, 0x00 ;// 22 "
		DCB		0x14, 0x7f, 0x14, 0x7f, 0x14 ;// 23 #
		DCB		0x24, 0x2a, 0x7f, 0x2a, 0x12 ;// 24 $
		DCB		0x23, 0x13, 0x08, 0x64, 0x62 ;// 25 %
		DCB		0x36, 0x49, 0x55, 0x22, 0x50 ;// 26 &
		DCB		0x00, 0x05, 0x03, 0x00, 0x00 ;// 27 '
		DCB		0x00, 0x1c, 0x22, 0x41, 0x00 ;// 28 (
		DCB		0x00, 0x41, 0x22, 0x1c, 0x00 ;// 29 )
		DCB		0x14, 0x08, 0x3e, 0x08, 0x14 ;// 2a *
		DCB		0x08, 0x08, 0x3e, 0x08, 0x08 ;// 2b +
		DCB		0x00, 0x50, 0x30, 0x00, 0x00 ;// 2c ,
		DCB		0x08, 0x08, 0x08, 0x08, 0x08 ;// 2d -
		DCB		0x00, 0x60, 0x60, 0x00, 0x00 ;// 2e .
		DCB		0x20, 0x10, 0x08, 0x04, 0x02 ;// 2f /
		DCB		0x3e, 0x51, 0x49, 0x45, 0x3e ;// 30 0
		DCB		0x00, 0x42, 0x7f, 0x40, 0x00 ;// 31 1
		DCB		0x42, 0x61, 0x51, 0x49, 0x46 ;// 32 2
		DCB		0x21, 0x41, 0x45, 0x4b, 0x31 ;// 33 3
		DCB		0x18, 0x14, 0x12, 0x7f, 0x10 ;// 34 4
		DCB		0x27, 0x45, 0x45, 0x45, 0x39 ;// 35 5
		DCB		0x3c, 0x4a, 0x49, 0x49, 0x30 ;// 36 6
		DCB		0x01, 0x71, 0x09, 0x05, 0x03 ;// 37 7
		DCB		0x36, 0x49, 0x49, 0x49, 0x36 ;// 38 8
		DCB		0x06, 0x49, 0x49, 0x29, 0x1e ;// 39 9
		DCB		0x00, 0x36, 0x36, 0x00, 0x00 ;// 3a :
		DCB		0x00, 0x56, 0x36, 0x00, 0x00 ;// 3b ;
		DCB		0x08, 0x14, 0x22, 0x41, 0x00 ;// 3c <
		DCB		0x14, 0x14, 0x14, 0x14, 0x14 ;// 3d =
		DCB		0x00, 0x41, 0x22, 0x14, 0x08 ;// 3e >
		DCB		0x02, 0x01, 0x51, 0x09, 0x06 ;// 3f ?
		DCB		0x32, 0x49, 0x79, 0x41, 0x3e ;// 40 @
		DCB		0x7e, 0x11, 0x11, 0x11, 0x7e ;// 41 A
		DCB		0x7f, 0x49, 0x49, 0x49, 0x36 ;// 42 B
		DCB		0x3e, 0x41, 0x41, 0x41, 0x22 ;// 43 C
		DCB		0x7f, 0x41, 0x41, 0x22, 0x1c ;// 44 D
		DCB		0x7f, 0x49, 0x49, 0x49, 0x41 ;// 45 E
		DCB		0x7f, 0x09, 0x09, 0x09, 0x01 ;// 46 F
		DCB		0x3e, 0x41, 0x49, 0x49, 0x7a ;// 47 G
		DCB		0x7f, 0x08, 0x08, 0x08, 0x7f ;// 48 H
		DCB		0x00, 0x41, 0x7f, 0x41, 0x00 ;// 49 I
		DCB		0x20, 0x40, 0x41, 0x3f, 0x01 ;// 4a J
		DCB		0x7f, 0x08, 0x14, 0x22, 0x41 ;// 4b K
		DCB		0x7f, 0x40, 0x40, 0x40, 0x40 ;// 4c L
		DCB		0x7f, 0x02, 0x0c, 0x02, 0x7f ;// 4d M
		DCB		0x7f, 0x04, 0x08, 0x10, 0x7f ;// 4e N
		DCB		0x3e, 0x41, 0x41, 0x41, 0x3e ;// 4f O
		DCB		0x7f, 0x09, 0x09, 0x09, 0x06 ;// 50 P
		DCB		0x3e, 0x41, 0x51, 0x21, 0x5e ;// 51 Q
		DCB		0x7f, 0x09, 0x19, 0x29, 0x46 ;// 52 R
		DCB		0x46, 0x49, 0x49, 0x49, 0x31 ;// 53 S
		DCB		0x01, 0x01, 0x7f, 0x01, 0x01 ;// 54 T
		DCB		0x3f, 0x40, 0x40, 0x40, 0x3f ;// 55 U
		DCB		0x1f, 0x20, 0x40, 0x20, 0x1f ;// 56 V
		DCB		0x3f, 0x40, 0x38, 0x40, 0x3f ;// 57 W
		DCB		0x63, 0x14, 0x08, 0x14, 0x63 ;// 58 X
		DCB		0x07, 0x08, 0x70, 0x08, 0x07 ;// 59 Y
		DCB		0x61, 0x51, 0x49, 0x45, 0x43 ;// 5a Z
		DCB		0x00, 0x7f, 0x41, 0x41, 0x00 ;// 5b [
		DCB		0x02, 0x04, 0x08, 0x10, 0x20 ;// 5c '\'
		DCB		0x00, 0x41, 0x41, 0x7f, 0x00 ;// 5d ]
		DCB		0x04, 0x02, 0x01, 0x02, 0x04 ;// 5e ^
		DCB		0x40, 0x40, 0x40, 0x40, 0x40 ;// 5f _
		DCB		0x00, 0x01, 0x02, 0x04, 0x00 ;// 60 `
		DCB		0x20, 0x54, 0x54, 0x54, 0x78 ;// 61 a
		DCB		0x7f, 0x48, 0x44, 0x44, 0x38 ;// 62 b
		DCB		0x38, 0x44, 0x44, 0x44, 0x20 ;// 63 c
		DCB		0x38, 0x44, 0x44, 0x48, 0x7f ;// 64 d
		DCB		0x38, 0x54, 0x54, 0x54, 0x18 ;// 65 e
		DCB		0x08, 0x7e, 0x09, 0x01, 0x02 ;// 66 f
		DCB		0x0c, 0x52, 0x52, 0x52, 0x3e ;// 67 g
		DCB		0x7f, 0x08, 0x04, 0x04, 0x78 ;// 68 h
		DCB		0x00, 0x44, 0x7d, 0x40, 0x00 ;// 69 i
		DCB		0x20, 0x40, 0x44, 0x3d, 0x00 ;// 6a j
		DCB		0x7f, 0x10, 0x28, 0x44, 0x00 ;// 6b k
		DCB		0x00, 0x41, 0x7f, 0x40, 0x00 ;// 6c l
		DCB		0x7c, 0x04, 0x18, 0x04, 0x78 ;// 6d m
		DCB		0x7c, 0x08, 0x04, 0x04, 0x78 ;// 6e n
		DCB		0x38, 0x44, 0x44, 0x44, 0x38 ;// 6f o
		DCB		0x7c, 0x14, 0x14, 0x14, 0x08 ;// 70 p
		DCB		0x08, 0x14, 0x14, 0x18, 0x7c ;// 71 q
		DCB		0x7c, 0x08, 0x04, 0x04, 0x08 ;// 72 r
		DCB		0x48, 0x54, 0x54, 0x54, 0x20 ;// 73 s
		DCB		0x04, 0x3f, 0x44, 0x40, 0x20 ;// 74 t
		DCB		0x3c, 0x40, 0x40, 0x20, 0x7c ;// 75 u
		DCB		0x1c, 0x20, 0x40, 0x20, 0x1c ;// 76 v
		DCB		0x3c, 0x40, 0x30, 0x40, 0x3c ;// 77 w
		DCB		0x44, 0x28, 0x10, 0x28, 0x44 ;// 78 x
		DCB		0x0c, 0x50, 0x50, 0x50, 0x3c ;// 79 y
		DCB		0x44, 0x64, 0x54, 0x4c, 0x44 ;// 7a z
		DCB		0x00, 0x08, 0x36, 0x41, 0x00 ;// 7b {
		DCB		0x00, 0x00, 0x7f, 0x00, 0x00 ;// 7c |
		DCB		0x00, 0x41, 0x36, 0x08, 0x00 ;// 7d }
		DCB		0x10, 0x08, 0x08, 0x10, 0x08 ;// 7e ~

;*****************************************************************

			;SEND ONE BYTE ON R5
LCD_PRINT_BYTE	
				PUSH	{R0,R1}
BYTELOOP		
				LDR		R1,=SSI0_SR				; CHECK UNTIL NOT FULL
				LDR		R0,[R1]
				ANDS	R0,R0,#0x02
				BEQ		BYTELOOP
				LDR		R1,=SSI0_DR
				STRB	R5,[R1]
				
				POP		{R0,R1}
				BX		LR
				
;*****************************************************************

			; DISPLAY ASCII CHARACTER ON R5
LCD_PRINT_CHAR	
				PUSH	{R0-R4,LR}
				LDR		R1,=GPIO_PORTA_DATA		; PA6 high for Data
				LDR		R0,[R1]
				ORR		R0,#0x40
				STR		R0,[R1]
				LDR		R1,=ASCII
				SUB		R2,R5,#0x20				; OFFSET
				MOV		R3,#0x05
				MUL		R2,R2,R3				; EACH CHAR IS 5 BYTE
				ADD		R1,R1,R2
				MOV		R0,#0x05				; EACH CHAR IS 5 BYTE					
DISP_CHAR		
				LDRB	R5,[R1],#1				
				BL		LCD_PRINT_BYTE				
				SUBS	R0,R0,#1
				BNE		DISP_CHAR
				MOV		R5,#0X00				; SPACE AFTER
				BL		LCD_PRINT_BYTE				
CHAREND			
				LDR		R1,=SSI0_SR			
				LDR		R0,[R1]
				ANDS	R0,R0,#0x10				; CHECK BUSY
				BNE		CHAREND
				
				POP		{R0-R4,LR}
				BX		LR
								
;*****************************************************************

			; Set cursor, X: R0, Y: R1
LCD_SET_XY		
				PUSH	{R0-R5,LR}
				PUSH	{R0-R1}
				LDR		R1,=GPIO_PORTA_DATA		; PA6 low for Command
				LDR		R0,[R1]
				BIC		R0,#0x40
				STR		R0,[R1]
				MOV		R5,#0x20				; H=0
				BL		LCD_PRINT_BYTE	
				POP		{R0-R1}
				MOV		R5,R1					; Y
				ORR		R5,#0x40
				BL		LCD_PRINT_BYTE
				MOV		R5,R0					; X
				ORR		R5,#0x80
				BL		LCD_PRINT_BYTE
XYEND			
				LDR		R1,=SSI0_SR				; wait until SSI is done
				LDR		R0,[R1]
				ANDS	R0,R0,#0x10
				BNE		XYEND
				LDR		R1,=GPIO_PORTA_DATA		; PA6 high for Data
				LDR		R0,[R1]
				ORR		R0,#0x40
				STR		R0,[R1]
				
				POP		{R0-R5,LR}
				BX		LR
								
;*****************************************************************

			; clear LCD screen
LCD_CLEAR
				PUSH	{R0-R5,LR}
				LDR		R1,=GPIO_PORTA_DATA		; set PA6 low for Command
				LDR		R0,[R1]
				BIC		R0,#0x40
				STR		R0,[R1]
				MOV		R5,#0x20				; ensure H=0
				BL		LCD_PRINT_BYTE	
				MOV		R5,#0x40				; set Y address to 0
				BL		LCD_PRINT_BYTE
				MOV		R5,#0x80				; set X address to 0
				BL		LCD_PRINT_BYTE	
CLRREADY		
				LDR		R1,=SSI0_SR				; wait until SSI is done
				LDR		R0,[R1]
				ANDS	R0,R0,#0x10
				BNE		CLRREADY
				LDR		R1,=GPIO_PORTA_DATA		; set PA6 high for Data
				LDR		R0,[R1]
				ORR		R0,#0x40
				STR		R0,[R1]	
				MOV		R0,#504					; 504 bytes in full image
				MOV		R5,#0x00				; load zeros to send
CLRNEXT		
				BL		LCD_PRINT_BYTE
				SUBS	R0,#1
				BNE		CLRNEXT
CLRDONE			
				LDR		R1,=SSI0_SR				; wait until SSI is done
				LDR		R0,[R1]
				ANDS	R0,R0,#0x10
				BNE		CLRDONE					

				POP		{R0-R5,LR}
				BX		LR
				
;*****************************************************************		

			; output ASCII character to LCD screen
			; ASCII Char at R5
			; Coordinates are ready at R0: X and R1: Y
LCD_OUT_CHAR
				PUSH	{R0-R4,LR}
				LDR		R1,=GPIO_PORTA_DATA		; PA6 high 
				LDR		R0,[R1]
				ORR		R0,#0x40
				STR		R0,[R1]
				LDR		R1,=ASCII				; load address of ASCII table
				SUB		R2,R5,#0x20				; calculate offset of char
				MOV		R3,#0x05
				MUL		R2,R2,R3
				ADD		R1,R1,R2
				PUSH	{R5}					; save state of R5
				MOV		R0,#0x05				; 5 bytes in every char
				MOV		R2,#0x00				; 1 empty column between chars
SENDCHARBYTE
				LDRB	R5,[R1],#1				
				BL		LCD_PRINT_BYTE				; send each byte of char
				SUBS	R0,R0,#1
				BNE		SENDCHARBYTE
				MOV		R5,R2
				BL		LCD_PRINT_BYTE				; tack space on after char
CHARDONE		
				LDR		R1,=SSI0_SR				; wait until SSI is done
				LDR		R0,[R1]
				ANDS	R0,R0,#0x10
				BNE		CHARDONE
				
				POP		{R5}
				POP		{R0-R4,LR}
				BX		LR

;*****************************************************************

			; Print string to LCD screen
			; Starting address:  R5
LCD_OUT_STR		
				PUSH	{R0-R5,LR}
				MOV		R1,R5
NEXTSTRCHAR
				LDRB	R5,[R1],#1
				CMP		R5,#0x04
				BEQ		STRDONE
				BL		LCD_OUT_CHAR
				B		NEXTSTRCHAR
STRDONE
				POP		{R0-R5,LR}
				BX		LR
				
;*********************************************************************

lcdOutWaterLevel
				PUSH	{R0-R5, LR}
				BL		LCD_SET_XY
				MOV		R4, R2
				BL		CONVERT
				LDR		R5,=0x20000480
				BL		LCD_OUT_STR
				LDR		R3,=0x20000488
				LDR		R4, [R3]
				MOV		R5, #5
ADDOFFSET		ADD		R0, R5
				SUBS	R4, R4, #0x01
				BNE		ADDOFFSET
				ADD		R0, R3
				BL		LCD_SET_XY
				LDR		R5,=unit_ml
				BL		LCD_OUT_STR
				POP		{R0-R5, LR}
				BX		LR

;**********************************************************************

lcdClearWaterLevel
				PUSH	{R0-R5, LR}
				BL		LCD_SET_XY
				LDR		R5, =blank_text
				BL		LCD_OUT_STR
				POP		{R0-R5, LR}
				BX		LR

;**********************************************************************

lcdSettingTarget
				PUSH	{R0-R5, LR}
				MOV		R6, R0
				MOV		R0, #50
				MOV		R1, #2
				BL		LCD_SET_XY
				
				LDR		R3, =ADJUST_COUNT
				LDR		R4, [R3]
				SUBS	R4, R4, #1
				BNE		EXIT
				
				LDR		R1, =ADJUST_STATUS; 0: OFF 1: ON
				LDR		R2, [R1]
				CMP		R2, #0
				BEQ		TURNON
				MOV32	R4, #150
				LDR		R5, =blank_text2
				MOV		R2, #0
				STR		R2, [R1]
				B		DONE

TURNON
				CMP		R6, #0
				MOV32	R4, #200
				BNE		SENSITIVITY
				LDR		R5, =target_text
				MOV		R2, #1
				STR		R2, [R1]
				B		DONE
SENSITIVITY
				LDR		R5, =sens_text
				MOV		R2, #1
				STR		R2, [R1]
DONE			
				BL		LCD_OUT_STR

EXIT
				STR		R4, [R3]
				POP		{R0-R5, LR}
				BX		LR

;**********************************************************************


				ALIGN
				END
