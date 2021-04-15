/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */

#include "stm8s.h"
#include "stdlib.h"

#define BASEPROGRAMFREQUENCY 50
#define TIM1STEPSTO1SECOND 32000
#define MOTORSTEPSPERROTATION 3200
#define MAXPOSITION 16000
#define MAXRPM 15
#define MINRPM 1
#define DEADZONE 0
#define ACCELERATION 1

int8_t motorDirection = 0;
int32_t position=0;
float targetPosition=0;
float kalmanPosition = 0;
float kalmanPositionPrev = 0;
float kalmanK = 0.02;
uint32_t motorSpeedK;
int16_t acc = 0;
int16_t velocity = 0;
uint16_t timerReload = 0;
uint16_t controlVoltage = 0;

void uartTransmit(uint8_t data){
	while(!UART1_SR_TXE);
	UART1->DR = data;
}

uint8_t receive = 0;
@far @interrupt void uartReceive(void)	{
	UART1_ClearITPendingBit(UART1_IT_RXNE);
	receive=UART1_ReceiveData8();
	//targetPosition = receive * 100;
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
	uartTransmit(controlVoltage / 11);
}

void motorDisable(void) {
	TIM1_Cmd(DISABLE);
//	GPIO_WriteHigh(GPIOC, GPIO_PIN_7);
}

void motorEnable(void) {
	GPIO_WriteLow(GPIOC, GPIO_PIN_7);
	TIM1_Cmd(ENABLE);
}

void setMotorSpeed ( int16_t speed ) {
	if ( speed > 0 ) {
		TIM1_SetAutoreload( motorSpeedK / abs( speed ) );
		GPIO_WriteHigh(GPIOC, GPIO_PIN_5);
		motorEnable();
	}
	else if ( speed < 0 ) {
		TIM1_SetAutoreload( motorSpeedK / abs( speed ) );
		GPIO_WriteLow(GPIOC, GPIO_PIN_5);
		motorEnable();
	}
	else motorDisable();
}

@far @interrupt void tim1Update(void)	{
	TIM1_ClearITPendingBit(TIM1_IT_UPDATE);
	position += motorDirection;
}

@far @interrupt void tim2Update(void)	{
	TIM2_ClearITPendingBit(TIM2_IT_UPDATE);
	GPIO_WriteReverse(GPIOB, GPIO_PIN_5);

	controlVoltage = ADC1_GetConversionValue();
	targetPosition = (float)controlVoltage * 2.5;
	
	kalmanPositionPrev = kalmanPosition;
	kalmanPosition = kalmanK * targetPosition + ( 1 - kalmanK ) * kalmanPositionPrev;
	
	if ( position > kalmanPosition - DEADZONE && position < kalmanPosition + DEADZONE ) {
		motorDisable();
		motorDirection = 0;
	}
	else {
		velocity = ( kalmanPosition - position ) / 10;
		if ( velocity > 0 ) motorDirection = 1;
		if ( velocity < 0 ) motorDirection = -1;
		if ( velocity > MAXRPM ) velocity = MAXRPM;
		if ( velocity < -MAXRPM ) velocity = -MAXRPM;
		setMotorSpeed ( velocity );
	}
//	timerReload = motorSpeedK / targetRpm;
//	TIM1_SetAutoreload(timerReload); // ”становить скорость мотора
}

main()
{
	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1|CLK_PRESCALER_CPUDIV1);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
	GPIO_Init(GPIOC, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
	GPIO_Init(GPIOC, GPIO_PIN_7, GPIO_MODE_OUT_PP_HIGH_FAST);
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
	ADC1_DeInit();
	ADC1_Init(	ADC1_CONVERSIONMODE_CONTINUOUS,
							ADC1_CHANNEL_3,
							ADC1_PRESSEL_FCPU_D2,
							ADC1_EXTTRIG_TIM,
							DISABLE,
							ADC1_ALIGN_RIGHT,
							ADC1_SCHMITTTRIG_CHANNEL3,
							DISABLE);
	ADC1_Cmd(ENABLE);
	ADC1_StartConversion();
	
	enableInterrupts();
	
	motorSpeedK = TIM1STEPSTO1SECOND;
	motorSpeedK *= 60;
	motorSpeedK /= MOTORSTEPSPERROTATION;

	TIM1_SetAutoreload(motorSpeedK/MAXRPM); // ”становить скорость мотора

	while (1);
}