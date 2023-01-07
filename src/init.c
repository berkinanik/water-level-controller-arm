#include "TM4C123GH6PM.h"

void init_func(void);

void init_func(void) {
	// RGB LEDs of TM4C123GXL:
	// PF1 Red LED
	// PF2 Blue LED
	// PF3 Green LED
	// User Switches of TM4C123GXL:
	// PF4 SW1 (Left)
	// PF0 SW2 (Right)
	
	// Enable Port F
	SYSCTL->RCGCGPIO |= 0x20; // 0010_0000 = =0x20: XXFE_DCBA ports
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	SysTick->LOAD = 1599999;
	SysTick->CTRL = 7;
	SysTick->VAL = 0;
	
	// Port F Configuration:
	// PF3, PF2, PF1: outputs for RGB LEDs
	// PF4 & PF0: inputs for SW1 & S2
	GPIOF->DIR &= ~0x11; // XXX0_XXX0 to make PF4 & PF0 inputs
	GPIOF->DIR |= 0x0E; // 1110 = 0xE to make PF3, PF2, PF1 output
	GPIOF->AFSEL &= ~0xFF; // No AFSEL
	GPIOF->DEN |= 0x1F; // XXX1_1111 = Ox1F to DEN PF4, PF3, PF2, PF1, PF0
	GPIOF->AMSEL &= ~0xFF; // No AMSEL
}
