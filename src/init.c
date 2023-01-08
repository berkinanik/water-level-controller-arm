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
	SYSCTL->RCGCADC |= 0x03; //enable ADC0
	SYSCTL->RCGCGPIO |= 0x32; //enable port E & F & B
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	
	// Configure Systick
	SysTick->LOAD = 1599999;
	SysTick->CTRL = 7;
	SysTick->VAL = 0;
	
	// Port B Configuration
	GPIOB->DIR |= 0xFF; // enable all output
	GPIOB->AFSEL &= ~0xFF; // no AFSEL
	GPIOB->DEN |= 0xFF; // DEN all
	GPIOB->AMSEL &= ~0xFF; // no AMSEL
	GPIOB->DATA = 0x00;

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
	GPIOE->DIR &= ~0x0C; //set pin PE3 as an input
	GPIOE->AFSEL |= 0x0C; //enable alternate function select for PE3, AIN0 is default for PE3
	GPIOE->DEN &= ~0x0C; //disable digital funtion of pin PE3
	GPIOE->AMSEL |= 0x0C; //enable analog function of pin PE3
	
	ADC0->ACTSS &= ~0x0008; //disable SS3 
	ADC0->EMUX &= ~0xF000; //seq3 is software triggered
	ADC0->SSCTL3 |= 0x0006;
	ADC0->SSMUX3 &= ~0x000F;
	ADC0->PC &= ~0xF;
	ADC0->PC |= 0x1; // 125K samples/sec
	ADC0->SAC |= 0x6; // HW averaging x64
	ADC0->ACTSS |= 0x0008; //enable ADC
	ADC0->IM &= ~0x08; // disable interrupt
	
	ADC1->ACTSS &= ~0x0008; //disable SS3 
	ADC1->EMUX &= ~0xF000; //seq3 is software triggered
	ADC1->SSCTL3 |= 0x0006;
	ADC1->SSMUX3 &= ~0x000F;
	ADC1->SSMUX3 |= 0x0001; // Set channel 1 AIN1 = PE2
	ADC1->PC &= ~0xF;
	ADC1->PC |= 0x7; // 1M samples/sec
	ADC1->SAC |= 0x6; // HW averaging x64
	ADC1->ACTSS |= 0x0008; //enable ADC
	ADC1->IM &= ~0x08; // disable interrupt
}
