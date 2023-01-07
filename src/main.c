#include "TM4C123GH6PM.h"
#include <stdio.h>

extern void init_func(void);

char myString[50] = "";
unsigned int result;
float maxValue = 0xFFF;
float resultConverted = 0.0f;

int main(void) {
	init_func();
	
	while (1) {}
}

void SysTick_Handler(void) {
	GPIOF->DATA |= 0x08;
}
