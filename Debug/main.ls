   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
  17                     	bsct
  18  0000               _targetRpm:
  19  0000 3f000000      	dc.w	16128,0
  20  0004               _currentRpm:
  21  0004 00000000      	dc.w	0,0
  22  0008               _targetDir:
  23  0008 00            	dc.b	0
  24  0009               _currentDir:
  25  0009 00            	dc.b	0
  26  000a               _targetSpeed:
  27  000a 00            	dc.b	0
  28  000b               _currentSpeed:
  29  000b 00            	dc.b	0
  69                     ; 22 void uartTransmit(uint8_t data){
  71                     .text:	section	.text,new
  72  0000               _uartTransmit:
  76                     ; 24 	UART1->DR = data;
  78  0000 c75231        	ld	21041,a
  79                     ; 25 }
  82  0003 81            	ret
 111                     ; 28 @far @interrupt void uartReceive(void)	{
 113                     .text:	section	.text,new
 114  0000               f_uartReceive:
 116  0000 8a            	push	cc
 117  0001 84            	pop	a
 118  0002 a4bf          	and	a,#191
 119  0004 88            	push	a
 120  0005 86            	pop	cc
 121  0006 3b0002        	push	c_x+2
 122  0009 be00          	ldw	x,c_x
 123  000b 89            	pushw	x
 124  000c 3b0002        	push	c_y+2
 125  000f be00          	ldw	x,c_y
 126  0011 89            	pushw	x
 129                     ; 29 	UART1_ClearITPendingBit(UART1_IT_RXNE);
 131  0012 ae0255        	ldw	x,#597
 132  0015 cd0000        	call	_UART1_ClearITPendingBit
 134                     ; 30 	receive=UART1_ReceiveData8();
 136  0018 cd0000        	call	_UART1_ReceiveData8
 138  001b b700          	ld	_receive,a
 139                     ; 31 	switch (receive)	{
 141  001d b600          	ld	a,_receive
 143                     ; 48 		case 8:
 143                     ; 49 		break;
 144  001f 4a            	dec	a
 145  0020 2705          	jreq	L72
 146  0022 4a            	dec	a
 147  0023 270d          	jreq	L13
 148  0025 2014          	jra	L16
 149  0027               L72:
 150                     ; 32 		case 1:
 150                     ; 33 			GPIO_WriteHigh(GPIOB, GPIO_PIN_5);
 152  0027 4b20          	push	#32
 153  0029 ae5005        	ldw	x,#20485
 154  002c cd0000        	call	_GPIO_WriteHigh
 156  002f 84            	pop	a
 157                     ; 34 		break;			
 159  0030 2009          	jra	L16
 160  0032               L13:
 161                     ; 35 		case 2:
 161                     ; 36 			GPIO_WriteLow(GPIOB, GPIO_PIN_5);
 163  0032 4b20          	push	#32
 164  0034 ae5005        	ldw	x,#20485
 165  0037 cd0000        	call	_GPIO_WriteLow
 167  003a 84            	pop	a
 168                     ; 37 		break;
 170  003b               L33:
 171                     ; 38 		case 3:
 171                     ; 39 		break;
 173  003b               L53:
 174                     ; 40 		case 4:
 174                     ; 41 		break;
 176  003b               L73:
 177                     ; 42 		case 5:
 177                     ; 43 		break;
 179  003b               L14:
 180                     ; 44 		case 6:
 180                     ; 45 		break;
 182  003b               L34:
 183                     ; 46 		case 7:
 183                     ; 47 		break;
 185  003b               L54:
 186                     ; 48 		case 8:
 186                     ; 49 		break;
 188  003b               L16:
 189                     ; 51 	uartTransmit(receive);
 191  003b b600          	ld	a,_receive
 192  003d cd0000        	call	_uartTransmit
 194                     ; 52 }
 197  0040 85            	popw	x
 198  0041 bf00          	ldw	c_y,x
 199  0043 320002        	pop	c_y+2
 200  0046 85            	popw	x
 201  0047 bf00          	ldw	c_x,x
 202  0049 320002        	pop	c_x+2
 203  004c 80            	iret
 226                     ; 54 @far @interrupt void tim1Update(void)	{
 227                     .text:	section	.text,new
 228  0000               f_tim1Update:
 230  0000 8a            	push	cc
 231  0001 84            	pop	a
 232  0002 a4bf          	and	a,#191
 233  0004 88            	push	a
 234  0005 86            	pop	cc
 235  0006 3b0002        	push	c_x+2
 236  0009 be00          	ldw	x,c_x
 237  000b 89            	pushw	x
 238  000c 3b0002        	push	c_y+2
 239  000f be00          	ldw	x,c_y
 240  0011 89            	pushw	x
 243                     ; 55 	TIM1_ClearITPendingBit(TIM1_IT_UPDATE);
 245  0012 a601          	ld	a,#1
 246  0014 cd0000        	call	_TIM1_ClearITPendingBit
 248                     ; 57 }
 251  0017 85            	popw	x
 252  0018 bf00          	ldw	c_y,x
 253  001a 320002        	pop	c_y+2
 254  001d 85            	popw	x
 255  001e bf00          	ldw	c_x,x
 256  0020 320002        	pop	c_x+2
 257  0023 80            	iret
 280                     ; 59 @far @interrupt void tim2Update(void)	{
 281                     .text:	section	.text,new
 282  0000               f_tim2Update:
 284  0000 8a            	push	cc
 285  0001 84            	pop	a
 286  0002 a4bf          	and	a,#191
 287  0004 88            	push	a
 288  0005 86            	pop	cc
 289  0006 3b0002        	push	c_x+2
 290  0009 be00          	ldw	x,c_x
 291  000b 89            	pushw	x
 292  000c 3b0002        	push	c_y+2
 293  000f be00          	ldw	x,c_y
 294  0011 89            	pushw	x
 297                     ; 60 	TIM2_ClearITPendingBit(TIM2_IT_UPDATE);
 299  0012 a601          	ld	a,#1
 300  0014 cd0000        	call	_TIM2_ClearITPendingBit
 302                     ; 62 }
 305  0017 85            	popw	x
 306  0018 bf00          	ldw	c_y,x
 307  001a 320002        	pop	c_y+2
 308  001d 85            	popw	x
 309  001e bf00          	ldw	c_x,x
 310  0020 320002        	pop	c_x+2
 311  0023 80            	iret
 354                     ; 64 main()
 354                     ; 65 {
 356                     .text:	section	.text,new
 357  0000               _main:
 361                     ; 66 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1|CLK_PRESCALER_CPUDIV1);
 363  0000 a680          	ld	a,#128
 364  0002 cd0000        	call	_CLK_HSIPrescalerConfig
 366                     ; 67 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
 368  0005 ae0701        	ldw	x,#1793
 369  0008 cd0000        	call	_CLK_PeripheralClockConfig
 371                     ; 68 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, ENABLE);
 373  000b ae0501        	ldw	x,#1281
 374  000e cd0000        	call	_CLK_PeripheralClockConfig
 376                     ; 69 	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
 378  0011 4bf0          	push	#240
 379  0013 4b20          	push	#32
 380  0015 ae5005        	ldw	x,#20485
 381  0018 cd0000        	call	_GPIO_Init
 383  001b 85            	popw	x
 384                     ; 70 	GPIO_Init(GPIOA, GPIO_PIN_1, GPIO_MODE_OUT_PP_HIGH_FAST);
 386  001c 4bf0          	push	#240
 387  001e 4b02          	push	#2
 388  0020 ae5000        	ldw	x,#20480
 389  0023 cd0000        	call	_GPIO_Init
 391  0026 85            	popw	x
 392                     ; 71 	TIM1_DeInit();
 394  0027 cd0000        	call	_TIM1_DeInit
 396                     ; 72 	TIM1_TimeBaseInit(	16000000/TIM1STEPSTO1SECOND,
 396                     ; 73 											TIM1_COUNTERMODE_UP,
 396                     ; 74 											32000,
 396                     ; 75 											0);
 398  002a 4b00          	push	#0
 399  002c ae7d00        	ldw	x,#32000
 400  002f 89            	pushw	x
 401  0030 4b00          	push	#0
 402  0032 ae01f4        	ldw	x,#500
 403  0035 cd0000        	call	_TIM1_TimeBaseInit
 405  0038 5b04          	addw	sp,#4
 406                     ; 79 	TIM1_OC1Init(	TIM1_OCMODE_PWM1,
 406                     ; 80 								TIM1_OUTPUTSTATE_ENABLE,
 406                     ; 81 								TIM1_OUTPUTNSTATE_ENABLE,
 406                     ; 82 								200,
 406                     ; 83 								TIM1_OCPOLARITY_HIGH,
 406                     ; 84 								TIM1_OCNPOLARITY_HIGH,
 406                     ; 85 								TIM1_OCIDLESTATE_RESET,
 406                     ; 86 								TIM1_OCNIDLESTATE_RESET);
 408  003a 4b00          	push	#0
 409  003c 4b00          	push	#0
 410  003e 4b00          	push	#0
 411  0040 4b00          	push	#0
 412  0042 ae00c8        	ldw	x,#200
 413  0045 89            	pushw	x
 414  0046 4b44          	push	#68
 415  0048 ae6011        	ldw	x,#24593
 416  004b cd0000        	call	_TIM1_OC1Init
 418  004e 5b07          	addw	sp,#7
 419                     ; 87 	TIM1_SetCompare1(1);
 421  0050 ae0001        	ldw	x,#1
 422  0053 cd0000        	call	_TIM1_SetCompare1
 424                     ; 88 	TIM1_ITConfig(TIM1_IT_UPDATE, ENABLE);
 426  0056 ae0101        	ldw	x,#257
 427  0059 cd0000        	call	_TIM1_ITConfig
 429                     ; 89 	TIM1_CtrlPWMOutputs(ENABLE); 
 431  005c a601          	ld	a,#1
 432  005e cd0000        	call	_TIM1_CtrlPWMOutputs
 434                     ; 90 	TIM1_Cmd(ENABLE);
 436  0061 a601          	ld	a,#1
 437  0063 cd0000        	call	_TIM1_Cmd
 439                     ; 91 	TIM2_DeInit();
 441  0066 cd0000        	call	_TIM2_DeInit
 443                     ; 92 	TIM2_TimeBaseInit(	TIM2_PRESCALER_1024, // 16MHz / 1024 = base frequency
 443                     ; 93 											15625/BASEPROGRAMFREQUENCY);
 445  0069 ae3d09        	ldw	x,#15625
 446  006c 89            	pushw	x
 447  006d a60a          	ld	a,#10
 448  006f cd0000        	call	_TIM2_TimeBaseInit
 450  0072 85            	popw	x
 451                     ; 94 	TIM2_ITConfig(TIM2_IT_UPDATE,ENABLE);
 453  0073 ae0101        	ldw	x,#257
 454  0076 cd0000        	call	_TIM2_ITConfig
 456                     ; 95 	TIM2_Cmd(ENABLE);
 458  0079 a601          	ld	a,#1
 459  007b cd0000        	call	_TIM2_Cmd
 461                     ; 96 	UART1_DeInit();
 463  007e cd0000        	call	_UART1_DeInit
 465                     ; 97 	UART1_Init(	57600,
 465                     ; 98 							UART1_WORDLENGTH_8D,
 465                     ; 99 							UART1_STOPBITS_1,
 465                     ; 100 							UART1_PARITY_NO,
 465                     ; 101 							UART1_SYNCMODE_CLOCK_DISABLE,
 465                     ; 102 							UART1_MODE_TXRX_ENABLE);
 467  0081 4b0c          	push	#12
 468  0083 4b80          	push	#128
 469  0085 4b00          	push	#0
 470  0087 4b00          	push	#0
 471  0089 4b00          	push	#0
 472  008b aee100        	ldw	x,#57600
 473  008e 89            	pushw	x
 474  008f ae0000        	ldw	x,#0
 475  0092 89            	pushw	x
 476  0093 cd0000        	call	_UART1_Init
 478  0096 5b09          	addw	sp,#9
 479                     ; 103 	UART1_ITConfig(	UART1_IT_RXNE, ENABLE);
 481  0098 4b01          	push	#1
 482  009a ae0255        	ldw	x,#597
 483  009d cd0000        	call	_UART1_ITConfig
 485  00a0 84            	pop	a
 486                     ; 104 	UART1_Cmd(ENABLE);
 488  00a1 a601          	ld	a,#1
 489  00a3 cd0000        	call	_UART1_Cmd
 491                     ; 105 	enableInterrupts();
 494  00a6 9a            rim
 496                     ; 107 	TIM1_SetAutoreload(TIM1STEPSTO1SECOND/200/16/currentRpm); // Установить скорость мотора
 499  00a7 a60a          	ld	a,#10
 500  00a9 cd0000        	call	c_ctof
 502  00ac ae0004        	ldw	x,#_currentRpm
 503  00af cd0000        	call	c_fdiv
 505  00b2 cd0000        	call	c_ftoi
 507  00b5 cd0000        	call	_TIM1_SetAutoreload
 509  00b8               L311:
 510                     ; 109 	while (1);
 512  00b8 20fe          	jra	L311
 590                     	xdef	_main
 591                     	xdef	f_tim2Update
 592                     	xdef	f_tim1Update
 593                     	xdef	f_uartReceive
 594                     	switch	.ubsct
 595  0000               _receive:
 596  0000 00            	ds.b	1
 597                     	xdef	_receive
 598                     	xdef	_uartTransmit
 599                     	xdef	_currentSpeed
 600                     	xdef	_targetSpeed
 601                     	xdef	_currentDir
 602                     	xdef	_targetDir
 603                     	xdef	_currentRpm
 604                     	xdef	_targetRpm
 605                     	xref	_UART1_ClearITPendingBit
 606                     	xref	_UART1_ReceiveData8
 607                     	xref	_UART1_ITConfig
 608                     	xref	_UART1_Cmd
 609                     	xref	_UART1_Init
 610                     	xref	_UART1_DeInit
 611                     	xref	_TIM2_ClearITPendingBit
 612                     	xref	_TIM2_ITConfig
 613                     	xref	_TIM2_Cmd
 614                     	xref	_TIM2_TimeBaseInit
 615                     	xref	_TIM2_DeInit
 616                     	xref	_TIM1_ClearITPendingBit
 617                     	xref	_TIM1_SetCompare1
 618                     	xref	_TIM1_SetAutoreload
 619                     	xref	_TIM1_ITConfig
 620                     	xref	_TIM1_CtrlPWMOutputs
 621                     	xref	_TIM1_Cmd
 622                     	xref	_TIM1_OC1Init
 623                     	xref	_TIM1_TimeBaseInit
 624                     	xref	_TIM1_DeInit
 625                     	xref	_GPIO_WriteLow
 626                     	xref	_GPIO_WriteHigh
 627                     	xref	_GPIO_Init
 628                     	xref	_CLK_HSIPrescalerConfig
 629                     	xref	_CLK_PeripheralClockConfig
 630                     	xref.b	c_x
 631                     	xref.b	c_y
 651                     	xref	c_ftoi
 652                     	xref	c_fdiv
 653                     	xref	c_ctof
 654                     	end
