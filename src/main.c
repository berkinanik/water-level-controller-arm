#include "TM4C123GH6PM.h"
#include <stdio.h>
#include <stdint.h>

extern void init_func(void);
extern void initLCD(void);
extern void startLCD(void);

extern void lcdOutWaterLevel(unsigned int x, unsigned int y, unsigned int target);
extern void lcdClearWaterLevel(unsigned int x, unsigned int y);
extern void DELAY100(void);

unsigned int targetReading = 0;
float maxValue = 0xFFF;
int targetConverted;
int sensitivity = 25;
int measurement = 100;

int runCW = 0;

int main(void)
{
	init_func();
	initLCD();
	startLCD();

	while (1)
	{
		DELAY100();
		lcdClearWaterLevel(30, 3);
		lcdOutWaterLevel(30, 3, sensitivity);
		DELAY100();
		lcdClearWaterLevel(30, 4);
		lcdOutWaterLevel(30, 4, targetConverted);
		DELAY100();
		lcdClearWaterLevel(30, 5);
		lcdOutWaterLevel(30, 5, measurement);
	}
}

void SysTick_Handler(void)
{
	ADC0->PSSI |= 0x0008; // initiate sampling by enabling ss3
	
	if (((ADC0->RIS & 0xF) == 0x8)) {
		targetReading = ADC0->SSFIFO3 & 0xFFF;
		targetConverted = (int)(300 * ((float)targetReading / maxValue));
		if (targetConverted >= 0 && targetConverted <= 300) {
			int output = GPIOB->DATA & 0x0F;
			
			if (measurement <= targetConverted - sensitivity) {
				GPIOF->DATA &= ~(0x8 | 0x4);
				GPIOF->DATA |= 0x2; // RED LED
				
			if (output == 0X00 || output == 0x08) {
				GPIOB->DATA &= 0x01;
			} else {
				GPIOB->DATA &= output * 2;
			}
				
			} else if (measurement >= targetConverted - sensitivity && measurement <= targetConverted + sensitivity) {
				GPIOF->DATA &= ~(0x4 | 0x2);
				GPIOF->DATA |= 0x8; // GREEN LED
			} else {
				GPIOF->DATA &= ~(0x8 | 0x2);
				GPIOF->DATA |= 0x4; // BLUE LED
				
				
				if (output == 0X00 || output == 0x01) {
					GPIOB->DATA &= 0x08;
				} else {
					GPIOB->DATA &= output / 2;
				}
			}
		}
		
		ADC0->ISC &= 0x0008;
	}
}
