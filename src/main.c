#include "TM4C123GH6PM.h"
#include <stdio.h>
#include <stdint.h>

extern void init_func(void);
extern void initLCD(void);
extern void startLCD(void);

extern void lcdOutWaterLevel(unsigned int x, unsigned int y, unsigned int target);
extern void lcdClearWaterLevel(unsigned int x, unsigned int y);
extern void lcdSettingTarget(unsigned int x);

unsigned int targetReading = 0;
unsigned int sensReading = 0;
unsigned int measurementReading = 0;

float maxValue = 0xFFF;

int targetConverted;
int sensConverted;
int measurementConverted;

// x64 HW averaging x 4 = 256 samples
int measurementArray[4];
int measurementCount = 0;
int measurementReady = 0;
int measurementAverage = 0;

int sensitivity = 25;
int adjusting = 1; // 0: target 1: sensitivity

int flickerSpeed = 160000;

#define SW1_PRESSED (GPIOF->DATA & 0x10) == 0
int buttonPressed = 0;

int main(void)
{
	init_func();
	initLCD();
	startLCD();

	while (1)
	{
		// 0 => TARGET; 1 => SENSITIVITY
		if (adjusting == 1) {
			lcdSettingTarget(1);
		} else {
			lcdSettingTarget(0);
		}
		
		lcdClearWaterLevel(30, 3);
		lcdOutWaterLevel(35, 3, sensitivity);
		
		lcdClearWaterLevel(30, 4);
		lcdOutWaterLevel(35, 4, targetConverted);
		
		lcdClearWaterLevel(30, 5);
		lcdOutWaterLevel(35, 5, measurementAverage);
	}
}

void SysTick_Handler(void)
{
	if (SW1_PRESSED && buttonPressed == 0) {
		// 0 => TARGET; 1 => SENSITIVITY
		if (adjusting == 1) {
			adjusting = 0;
		} else {
			adjusting = 1;
		}
		buttonPressed = 1;
  } else if (!SW1_PRESSED && buttonPressed == 1) {
		buttonPressed = 0;
	}
	
	ADC0->PSSI |= 0x0008; // initiate sampling by enabling ss3
	ADC1->PSSI |= 0x0008; // initiate sampling by enabling ss3
	
	if (((ADC0->RIS & 0xF) == 0x8)) {
		// 0 => TARGET; 1 => SENSITIVITY
		if (adjusting) {			
			sensReading = ADC0->SSFIFO3 & 0xFFF;
			sensConverted = (int)(40 * ((float)sensReading / maxValue));
			sensitivity = sensConverted + 10;
		} else {			
			targetReading = ADC0->SSFIFO3 & 0xFFF;
			targetConverted = (int)(300 * ((float)targetReading / maxValue));
		}
		
		ADC0->ISC &= 0x0008;
	}
	
	 if (((ADC1->RIS & 0xF) == 0x8)) {
		if (!measurementReady) {
			measurementReading = ADC1->SSFIFO3 & 0xFFF;
			measurementConverted = (int)(300 * ((float)measurementReading / maxValue));
			
			// Store measurements in array
			measurementArray[measurementCount] = measurementConverted;
			measurementCount++;
		}
		
		if (measurementCount == 4) {
			measurementReady = 1;
		}
		
		ADC1->ISC &= 0x0008;
	}
	
	if (measurementReady) {
		int total = 0;
		
		for (int i = 0; i < 4; i++) {
			total += measurementArray[i];
		}
		
		measurementAverage = total / measurementCount;
		
	
		if (targetConverted >= 0 && targetConverted <= 300) {
			int output = GPIOB->DATA & 0x0F;
			
			if (measurementAverage < targetConverted - sensitivity) {
				GPIOF->DATA &= ~(0x8 | 0x4);
				GPIOF->DATA |= 0x2; // RED LED
				
			if (output == 0x00 || output == 0x08) {
				GPIOB->DATA = 0x01;
			} else {
				GPIOB->DATA = output * 2;
			}
				
			} else if (measurementAverage >= targetConverted - sensitivity && measurementAverage <= targetConverted + sensitivity) {
				GPIOF->DATA &= ~(0x4 | 0x2);
				GPIOF->DATA |= 0x8; // GREEN LED
				
				GPIOB->DATA = 0x00;
			} else {
				GPIOF->DATA &= ~(0x8 | 0x2);
				GPIOF->DATA |= 0x4; // BLUE LED
			
				if (output == 0x00 || output == 0x01) {
					GPIOB->DATA = 0x08;
				} else {
					GPIOB->DATA = output / 2;
				}
			}
		}
		
		measurementCount = 0;
		measurementReady = 0;
	}
}
