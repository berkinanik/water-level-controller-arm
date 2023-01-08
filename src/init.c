#include "TM4C123GH6PM.h"

void init_func(void);

void init_func(void)
{
	// RGB LEDs of TM4C123GXL:
	// PF1 Red LED
	// PF2 Blue LED
	// PF3 Green LED
	// User Switches of TM4C123GXL:
	// PF4 SW1 (Left)
	// PF0 SW2 (Right)

	// XXFE_DCBA ports
	SYSCTL->RCGCADC |= 0x0001; //enable ADC0
	SYSCTL->RCGCGPIO |= 0x32; //enable port E & F & B
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	
	// Configure Systick
	SysTick->LOAD = 159999;
	SysTick->CTRL = 7;
	SysTick->VAL = 0;
	
	// Port B Configuration
	GPIOB->DIR |= 0x0F; /* set pin 4-7 input & pins 0-3 output */
	GPIOB->DEN |= 0x0F; /* enable all pins digital */
	GPIOB->DATA = ~0xFF;

	// Port F Configuration:
	// PF3, PF2, PF1: outputs for RGB LEDs
	// PF4 & PF0: inputs for SW1 & S2
	// PF4 & PF0: pull-up resistors
	GPIOF->DIR &= ~0x11;	 // XXX0_XXX0 to make PF4 & PF0 inputs
	GPIOF->DIR |= 0x0E;		 // 1110 = 0xE to make PF3, PF2, PF1 output
	GPIOF->PUR |= 0x11;		 // XXX1_XXX1 to enable pull-up resistors
	GPIOF->AFSEL &= ~0xFF; // No AFSEL
	GPIOF->DEN |= 0x1F;		 // XXX1_1111 = Ox1F to DEN PF4, PF3, PF2, PF1, PF0
	GPIOF->AMSEL &= ~0xFF; // No AMSEL
	
	// Port E Configuration
	GPIOE->DIR &= ~0x08; //set pin PE3 as an input
	GPIOE->AFSEL |= 0x08; //enable alternate function select for PE3, AIN0 is default for PE3
	GPIOE->DEN &= ~0x08; //disable digital funtion of pin PE3
	GPIOE->AMSEL |= 0x08; //enable analog function of pin PE3
	
	ADC0->ACTSS &= ~0x0008; //disable SS3 
	ADC0->EMUX &= ~0xF000; //seq3 is software triggered
	ADC0->SSCTL3 |= 0x0006;
	ADC0->SSMUX3 &= ~0x000F;
	ADC0->PC &= ~0xF;
	ADC0->PC |= 0x1; //125k samples/sec
	ADC0->ACTSS |= 0x0008; //enable ADC
	ADC0->IM &= ~0x08; // disable interrupt
}
