#include "TM4C123GH6PM.h"
#include <stdio.h>

extern void init_func(void);
extern void initLCD(void);
extern void startLCD(void);

int main(void)
{
	init_func();
	initLCD();
	startLCD();

	while (1)
	{
	}
}

void SysTick_Handler(void)
{
	// variable to store the current state of the GPIOF port
	uint32_t current_state = GPIOF->DATA;
	// switch and LED values from current state
	uint32_t switch_value = current_state & 0x11;
	uint32_t led_value = current_state & 0x0E;
	
	// GPIOA->DATA |= 0x10;

	// check if SW1 is pressed
	if ((current_state & 0x10) == 0)
	{
		// turn on the red LED
		GPIOF->DATA |= 0x02;
	}
	else
	{
		// turn off the red LED
		GPIOF->DATA &= ~0x02;
	}
}
