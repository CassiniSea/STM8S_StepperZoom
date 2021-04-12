/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */

#include "stm8s.h"
#include "stdlib.h"

#define BASEPROGRAMFREQUENCY 20
#define TIM1STEPSTO1SECOND 32000
#define MAXRPM 2
#define MINRPM 0.01
#define CW 0 // Positive
#define CCW 1 // Negative

float targetRpm = 0;
float currentRpm = 0;
uint8_t targetDir = CW;
uint8_t currentDir = CW;
int8_t targetSpeed = 1; // Main var
int8_t currentSpeed = 0;
float acc = 0.01;



void uartTransmit(uint8_t data){
	while(!UART1_SR_TXE);
	UART1->DR = data;
}

uint8_t receive;
@far @interrupt void uartReceive(void)	{
	UART1_ClearITPendingBit(UART1_IT_RXNE);
	receive=UART1_ReceiveData8();
	targetSpeed = receive;
	switch (receive)	{
		case 1:
		break;			
		case 2:
		break;
		case 3:
		break;
		case 4:
		break;
		case 5:
		break;
		case 6:
		break;
		case 7:
		break;
		case 8:
		break;
	}
	uartTransmit(receive);
}

@far @interrupt void tim1Update(void)	{
	TIM1_ClearITPendingBit(TIM1_IT_UPDATE);

}

uint16_t timerReload;
@far @interrupt void tim2Update(void)	{
	TIM2_ClearITPendingBit(TIM2_IT_UPDATE);
	GPIO_WriteReverse(GPIOB, GPIO_PIN_5);
	
	targetRpm = (float)abs(targetSpeed)*MAXRPM/127;
	if(targetSpeed > 0) GPIO_WriteHigh(GPIOC, GPIO_PIN_5);
	else if(targetSpeed < 0) GPIO_WriteLow(GPIOC, GPIO_PIN_5);
	if(currentRpm + acc <= targetRpm) currentRpm += acc;
	else if(currentRpm - acc >= targetRpm) currentRpm -= acc;
	
	if(-MINRPM < currentRpm < MINRPM) {
		TIM1_CtrlPWMOutputs(DISABLE); 
	}
	else {
		TIM1_SetAutoreload(TIM1STEPSTO1SECOND/200/16/currentRpm); // ”становить скорость мотора
		TIM1_CtrlPWMOutputs(ENABLE); 
	}
}

void Delay(uint32_t t)	{
	uint16_t i;
	while(t>0) {
		t--;
		for(i=1000;i>0;i--);
	}
}

main()
{
	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1|CLK_PRESCALER_CPUDIV1);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
	GPIO_Init(GPIOC, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
	TIM1_DeInit();
	TIM1_TimeBaseInit(	16000000/TIM1STEPSTO1SECOND,
											TIM1_COUNTERMODE_UP,
											32000,
											0);
	TIM1_ARRPreloadConfig(ENABLE); // «агружать новое значение Autoreload при событии обновлени€, а не сразу
	
//	TIM1_SetAutoreload(uint16_t Autoreload)
//	TIM1_PrescalerConfig(16000, TIM1_PSCRELOADMODE_IMMEDIATE)

	TIM1_OC1Init(	TIM1_OCMODE_PWM1,
								TIM1_OUTPUTSTATE_ENABLE,
								TIM1_OUTPUTNSTATE_ENABLE,
								200,
								TIM1_OCPOLARITY_LOW,
								TIM1_OCNPOLARITY_HIGH,
								TIM1_OCIDLESTATE_RESET,
								TIM1_OCNIDLESTATE_RESET);
	TIM1_SetCompare1(1);
	TIM1_ITConfig(TIM1_IT_UPDATE, ENABLE);
	TIM1_CtrlPWMOutputs(ENABLE); 
	TIM1_Cmd(ENABLE);
	TIM2_DeInit();
	TIM2_TimeBaseInit(	TIM2_PRESCALER_1024, // 16MHz / 1024 = base frequency
											15625/BASEPROGRAMFREQUENCY);
	TIM2_ITConfig(TIM2_IT_UPDATE,ENABLE);
	TIM2_Cmd(ENABLE);
	UART1_DeInit();
	UART1_Init(	57600,
							UART1_WORDLENGTH_8D,
							UART1_STOPBITS_1,
							UART1_PARITY_NO,
							UART1_SYNCMODE_CLOCK_DISABLE,
							UART1_MODE_TXRX_ENABLE);
	UART1_ITConfig(	UART1_IT_RXNE, ENABLE);
	UART1_Cmd(ENABLE);
	enableInterrupts();
	
	TIM1_SetAutoreload(TIM1STEPSTO1SECOND/200/16/currentRpm); // ”становить скорость мотора

	GPIO_WriteReverse(GPIOB, GPIO_PIN_5);
	Delay(1000);
	GPIO_WriteReverse(GPIOB, GPIO_PIN_5);

	while (1) {}
}