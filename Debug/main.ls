   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
  17                     	bsct
  18  0000               _motorDirection:
  19  0000 00            	dc.b	0
  20  0001               _position:
  21  0001 00000000      	dc.l	0
  22  0005               _targetPosition:
  23  0005 00000000      	dc.w	0,0
  24  0009               _kalmanPosition:
  25  0009 00000000      	dc.w	0,0
  26  000d               _kalmanPositionPrev:
  27  000d 00000000      	dc.w	0,0
  28  0011               _kalmanK:
  29  0011 3ca3d70a      	dc.w	15523,-10486
  30  0015               _acc:
  31  0015 0000          	dc.w	0
  32  0017               _velocity:
  33  0017 0000          	dc.w	0
  34  0019               _timerReload:
  35  0019 0000          	dc.w	0
  36  001b               _controlVoltage:
  37  001b 0000          	dc.w	0
  77                     ; 30 void uartTransmit(uint8_t data){
  79                     .text:	section	.text,new
  80  0000               _uartTransmit:
  84                     ; 32 	UART1->DR = data;
  86  0000 c75231        	ld	21041,a
  87                     ; 33 }
  90  0003 81            	ret
  93                     	bsct
  94  001d               _receive:
  95  001d 00            	dc.b	0
 121                     ; 36 @far @interrupt void uartReceive(void)	{
 123                     .text:	section	.text,new
 124  0000               f_uartReceive:
 126  0000 8a            	push	cc
 127  0001 84            	pop	a
 128  0002 a4bf          	and	a,#191
 129  0004 88            	push	a
 130  0005 86            	pop	cc
 131  0006 3b0002        	push	c_x+2
 132  0009 be00          	ldw	x,c_x
 133  000b 89            	pushw	x
 134  000c 3b0002        	push	c_y+2
 135  000f be00          	ldw	x,c_y
 136  0011 89            	pushw	x
 139                     ; 37 	UART1_ClearITPendingBit(UART1_IT_RXNE);
 141  0012 ae0255        	ldw	x,#597
 142  0015 cd0000        	call	_UART1_ClearITPendingBit
 144                     ; 38 	receive=UART1_ReceiveData8();
 146  0018 cd0000        	call	_UART1_ReceiveData8
 148  001b b71d          	ld	_receive,a
 149                     ; 58 	uartTransmit(controlVoltage / 11);
 152  001d be1b          	ldw	x,_controlVoltage
 153  001f 90ae000b      	ldw	y,#11
 154  0023 65            	divw	x,y
 155  0024 9f            	ld	a,xl
 156  0025 cd0000        	call	_uartTransmit
 158                     ; 59 }
 161  0028 85            	popw	x
 162  0029 bf00          	ldw	c_y,x
 163  002b 320002        	pop	c_y+2
 164  002e 85            	popw	x
 165  002f bf00          	ldw	c_x,x
 166  0031 320002        	pop	c_x+2
 167  0034 80            	iret
 190                     ; 61 void motorDisable(void) {
 192                     .text:	section	.text,new
 193  0000               _motorDisable:
 197                     ; 62 	TIM1_Cmd(DISABLE);
 199  0000 4f            	clr	a
 200  0001 cd0000        	call	_TIM1_Cmd
 202                     ; 64 }
 205  0004 81            	ret
 230                     ; 66 void motorEnable(void) {
 231                     .text:	section	.text,new
 232  0000               _motorEnable:
 236                     ; 67 	GPIO_WriteLow(GPIOC, GPIO_PIN_7);
 238  0000 4b80          	push	#128
 239  0002 ae500a        	ldw	x,#20490
 240  0005 cd0000        	call	_GPIO_WriteLow
 242  0008 84            	pop	a
 243                     ; 68 	TIM1_Cmd(ENABLE);
 245  0009 a601          	ld	a,#1
 246  000b cd0000        	call	_TIM1_Cmd
 248                     ; 69 }
 251  000e 81            	ret
 292                     ; 71 void setMotorSpeed ( int16_t speed ) {
 293                     .text:	section	.text,new
 294  0000               _setMotorSpeed:
 296  0000 89            	pushw	x
 297  0001 5204          	subw	sp,#4
 298       00000004      OFST:	set	4
 301                     ; 72 	if ( speed > 0 ) {
 303  0003 9c            	rvf
 304  0004 a30000        	cpw	x,#0
 305  0007 2d2d          	jrsle	L511
 306                     ; 73 		TIM1_SetAutoreload( motorSpeedK / abs( speed ) );
 308  0009 cd0000        	call	_abs
 310  000c cd0000        	call	c_itolx
 312  000f 96            	ldw	x,sp
 313  0010 1c0001        	addw	x,#OFST-3
 314  0013 cd0000        	call	c_rtol
 316  0016 ae0000        	ldw	x,#_motorSpeedK
 317  0019 cd0000        	call	c_ltor
 319  001c 96            	ldw	x,sp
 320  001d 1c0001        	addw	x,#OFST-3
 321  0020 cd0000        	call	c_ludv
 323  0023 be02          	ldw	x,c_lreg+2
 324  0025 cd0000        	call	_TIM1_SetAutoreload
 326                     ; 74 		GPIO_WriteHigh(GPIOC, GPIO_PIN_5);
 328  0028 4b20          	push	#32
 329  002a ae500a        	ldw	x,#20490
 330  002d cd0000        	call	_GPIO_WriteHigh
 332  0030 84            	pop	a
 333                     ; 75 		motorEnable();
 335  0031 cd0000        	call	_motorEnable
 338  0034 2037          	jra	L711
 339  0036               L511:
 340                     ; 77 	else if ( speed < 0 ) {
 342  0036 9c            	rvf
 343  0037 1e05          	ldw	x,(OFST+1,sp)
 344  0039 2e2f          	jrsge	L121
 345                     ; 78 		TIM1_SetAutoreload( motorSpeedK / abs( speed ) );
 347  003b 1e05          	ldw	x,(OFST+1,sp)
 348  003d cd0000        	call	_abs
 350  0040 cd0000        	call	c_itolx
 352  0043 96            	ldw	x,sp
 353  0044 1c0001        	addw	x,#OFST-3
 354  0047 cd0000        	call	c_rtol
 356  004a ae0000        	ldw	x,#_motorSpeedK
 357  004d cd0000        	call	c_ltor
 359  0050 96            	ldw	x,sp
 360  0051 1c0001        	addw	x,#OFST-3
 361  0054 cd0000        	call	c_ludv
 363  0057 be02          	ldw	x,c_lreg+2
 364  0059 cd0000        	call	_TIM1_SetAutoreload
 366                     ; 79 		GPIO_WriteLow(GPIOC, GPIO_PIN_5);
 368  005c 4b20          	push	#32
 369  005e ae500a        	ldw	x,#20490
 370  0061 cd0000        	call	_GPIO_WriteLow
 372  0064 84            	pop	a
 373                     ; 80 		motorEnable();
 375  0065 cd0000        	call	_motorEnable
 378  0068 2003          	jra	L711
 379  006a               L121:
 380                     ; 82 	else motorDisable();
 382  006a cd0000        	call	_motorDisable
 384  006d               L711:
 385                     ; 83 }
 388  006d 5b06          	addw	sp,#6
 389  006f 81            	ret
 415                     ; 85 @far @interrupt void tim1Update(void)	{
 417                     .text:	section	.text,new
 418  0000               f_tim1Update:
 420  0000 8a            	push	cc
 421  0001 84            	pop	a
 422  0002 a4bf          	and	a,#191
 423  0004 88            	push	a
 424  0005 86            	pop	cc
 425  0006 3b0002        	push	c_x+2
 426  0009 be00          	ldw	x,c_x
 427  000b 89            	pushw	x
 428  000c 3b0002        	push	c_y+2
 429  000f be00          	ldw	x,c_y
 430  0011 89            	pushw	x
 431  0012 be02          	ldw	x,c_lreg+2
 432  0014 89            	pushw	x
 433  0015 be00          	ldw	x,c_lreg
 434  0017 89            	pushw	x
 437                     ; 86 	TIM1_ClearITPendingBit(TIM1_IT_UPDATE);
 439  0018 a601          	ld	a,#1
 440  001a cd0000        	call	_TIM1_ClearITPendingBit
 442                     ; 87 	position += motorDirection;
 444  001d b600          	ld	a,_motorDirection
 445  001f b703          	ld	c_lreg+3,a
 446  0021 48            	sll	a
 447  0022 4f            	clr	a
 448  0023 a200          	sbc	a,#0
 449  0025 b702          	ld	c_lreg+2,a
 450  0027 b701          	ld	c_lreg+1,a
 451  0029 b700          	ld	c_lreg,a
 452  002b ae0001        	ldw	x,#_position
 453  002e cd0000        	call	c_lgadd
 455                     ; 88 }
 458  0031 85            	popw	x
 459  0032 bf00          	ldw	c_lreg,x
 460  0034 85            	popw	x
 461  0035 bf02          	ldw	c_lreg+2,x
 462  0037 85            	popw	x
 463  0038 bf00          	ldw	c_y,x
 464  003a 320002        	pop	c_y+2
 465  003d 85            	popw	x
 466  003e bf00          	ldw	c_x,x
 467  0040 320002        	pop	c_x+2
 468  0043 80            	iret
 503                     ; 90 @far @interrupt void tim2Update(void)	{
 504                     .text:	section	.text,new
 505  0000               f_tim2Update:
 507  0000 8a            	push	cc
 508  0001 84            	pop	a
 509  0002 a4bf          	and	a,#191
 510  0004 88            	push	a
 511  0005 86            	pop	cc
 512       00000004      OFST:	set	4
 513  0006 3b0002        	push	c_x+2
 514  0009 be00          	ldw	x,c_x
 515  000b 89            	pushw	x
 516  000c 3b0002        	push	c_y+2
 517  000f be00          	ldw	x,c_y
 518  0011 89            	pushw	x
 519  0012 be02          	ldw	x,c_lreg+2
 520  0014 89            	pushw	x
 521  0015 be00          	ldw	x,c_lreg
 522  0017 89            	pushw	x
 523  0018 5204          	subw	sp,#4
 526                     ; 91 	TIM2_ClearITPendingBit(TIM2_IT_UPDATE);
 528  001a a601          	ld	a,#1
 529  001c cd0000        	call	_TIM2_ClearITPendingBit
 531                     ; 92 	GPIO_WriteReverse(GPIOB, GPIO_PIN_5);
 533  001f 4b20          	push	#32
 534  0021 ae5005        	ldw	x,#20485
 535  0024 cd0000        	call	_GPIO_WriteReverse
 537  0027 84            	pop	a
 538                     ; 94 	controlVoltage = ADC1_GetConversionValue();
 540  0028 cd0000        	call	_ADC1_GetConversionValue
 542  002b bf1b          	ldw	_controlVoltage,x
 543                     ; 95 	targetPosition = (float)controlVoltage * 2.5;
 545  002d be1b          	ldw	x,_controlVoltage
 546  002f cd0000        	call	c_uitof
 548  0032 ae0008        	ldw	x,#L151
 549  0035 cd0000        	call	c_fmul
 551  0038 ae0005        	ldw	x,#_targetPosition
 552  003b cd0000        	call	c_rtol
 554                     ; 97 	kalmanPositionPrev = kalmanPosition;
 556  003e be0b          	ldw	x,_kalmanPosition+2
 557  0040 bf0f          	ldw	_kalmanPositionPrev+2,x
 558  0042 be09          	ldw	x,_kalmanPosition
 559  0044 bf0d          	ldw	_kalmanPositionPrev,x
 560                     ; 98 	kalmanPosition = kalmanK * targetPosition + ( 1 - kalmanK ) * kalmanPositionPrev;
 562  0046 a601          	ld	a,#1
 563  0048 cd0000        	call	c_ctof
 565  004b ae0011        	ldw	x,#_kalmanK
 566  004e cd0000        	call	c_fsub
 568  0051 ae000d        	ldw	x,#_kalmanPositionPrev
 569  0054 cd0000        	call	c_fmul
 571  0057 96            	ldw	x,sp
 572  0058 1c0001        	addw	x,#OFST-3
 573  005b cd0000        	call	c_rtol
 575  005e ae0011        	ldw	x,#_kalmanK
 576  0061 cd0000        	call	c_ltor
 578  0064 ae0005        	ldw	x,#_targetPosition
 579  0067 cd0000        	call	c_fmul
 581  006a 96            	ldw	x,sp
 582  006b 1c0001        	addw	x,#OFST-3
 583  006e cd0000        	call	c_fadd
 585  0071 ae0009        	ldw	x,#_kalmanPosition
 586  0074 cd0000        	call	c_rtol
 588                     ; 105 		velocity = ( kalmanPosition - position ) / 10;
 590  0077 ae0001        	ldw	x,#_position
 591  007a cd0000        	call	c_ltor
 593  007d cd0000        	call	c_ltof
 595  0080 96            	ldw	x,sp
 596  0081 1c0001        	addw	x,#OFST-3
 597  0084 cd0000        	call	c_rtol
 599  0087 ae0009        	ldw	x,#_kalmanPosition
 600  008a cd0000        	call	c_ltor
 602  008d 96            	ldw	x,sp
 603  008e 1c0001        	addw	x,#OFST-3
 604  0091 cd0000        	call	c_fsub
 606  0094 ae0004        	ldw	x,#L161
 607  0097 cd0000        	call	c_fdiv
 609  009a cd0000        	call	c_ftoi
 611  009d bf17          	ldw	_velocity,x
 612                     ; 106 		if ( velocity > 0 ) motorDirection = 1;
 614  009f 9c            	rvf
 615  00a0 be17          	ldw	x,_velocity
 616  00a2 2d04          	jrsle	L561
 619  00a4 35010000      	mov	_motorDirection,#1
 620  00a8               L561:
 621                     ; 107 		if ( velocity < 0 ) motorDirection = -1;
 623  00a8 9c            	rvf
 624  00a9 be17          	ldw	x,_velocity
 625  00ab 2e04          	jrsge	L761
 628  00ad 35ff0000      	mov	_motorDirection,#255
 629  00b1               L761:
 630                     ; 108 		if ( velocity > MAXRPM ) velocity = MAXRPM;
 632  00b1 9c            	rvf
 633  00b2 be17          	ldw	x,_velocity
 634  00b4 a30010        	cpw	x,#16
 635  00b7 2f05          	jrslt	L171
 638  00b9 ae000f        	ldw	x,#15
 639  00bc bf17          	ldw	_velocity,x
 640  00be               L171:
 641                     ; 109 		if ( velocity < -MAXRPM ) velocity = -MAXRPM;
 643  00be 9c            	rvf
 644  00bf be17          	ldw	x,_velocity
 645  00c1 a3fff1        	cpw	x,#65521
 646  00c4 2e05          	jrsge	L371
 649  00c6 aefff1        	ldw	x,#65521
 650  00c9 bf17          	ldw	_velocity,x
 651  00cb               L371:
 652                     ; 110 		setMotorSpeed ( velocity );
 654  00cb be17          	ldw	x,_velocity
 655  00cd cd0000        	call	_setMotorSpeed
 657                     ; 118 }
 660  00d0 5b04          	addw	sp,#4
 661  00d2 85            	popw	x
 662  00d3 bf00          	ldw	c_lreg,x
 663  00d5 85            	popw	x
 664  00d6 bf02          	ldw	c_lreg+2,x
 665  00d8 85            	popw	x
 666  00d9 bf00          	ldw	c_y,x
 667  00db 320002        	pop	c_y+2
 668  00de 85            	popw	x
 669  00df bf00          	ldw	c_x,x
 670  00e1 320002        	pop	c_x+2
 671  00e4 80            	iret
 719                     .const:	section	.text
 720  0000               L42:
 721  0000 00000c80      	dc.l	3200
 722                     ; 120 main()
 722                     ; 121 {
 723                     	scross	off
 724                     .text:	section	.text,new
 725  0000               _main:
 729                     ; 122 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1|CLK_PRESCALER_CPUDIV1);
 731  0000 a680          	ld	a,#128
 732  0002 cd0000        	call	_CLK_HSIPrescalerConfig
 734                     ; 123 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
 736  0005 ae0701        	ldw	x,#1793
 737  0008 cd0000        	call	_CLK_PeripheralClockConfig
 739                     ; 124 	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
 741  000b 4bf0          	push	#240
 742  000d 4b20          	push	#32
 743  000f ae5005        	ldw	x,#20485
 744  0012 cd0000        	call	_GPIO_Init
 746  0015 85            	popw	x
 747                     ; 125 	GPIO_Init(GPIOC, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
 749  0016 4bf0          	push	#240
 750  0018 4b20          	push	#32
 751  001a ae500a        	ldw	x,#20490
 752  001d cd0000        	call	_GPIO_Init
 754  0020 85            	popw	x
 755                     ; 126 	GPIO_Init(GPIOC, GPIO_PIN_7, GPIO_MODE_OUT_PP_HIGH_FAST);
 757  0021 4bf0          	push	#240
 758  0023 4b80          	push	#128
 759  0025 ae500a        	ldw	x,#20490
 760  0028 cd0000        	call	_GPIO_Init
 762  002b 85            	popw	x
 763                     ; 127 	TIM1_DeInit();
 765  002c cd0000        	call	_TIM1_DeInit
 767                     ; 128 	TIM1_TimeBaseInit(	16000000/TIM1STEPSTO1SECOND,
 767                     ; 129 											TIM1_COUNTERMODE_UP,
 767                     ; 130 											32000,
 767                     ; 131 											0);
 769  002f 4b00          	push	#0
 770  0031 ae7d00        	ldw	x,#32000
 771  0034 89            	pushw	x
 772  0035 4b00          	push	#0
 773  0037 ae01f4        	ldw	x,#500
 774  003a cd0000        	call	_TIM1_TimeBaseInit
 776  003d 5b04          	addw	sp,#4
 777                     ; 132 	TIM1_ARRPreloadConfig(ENABLE); // «агружать новое значение Autoreload при событии обновлени€, а не сразу
 779  003f a601          	ld	a,#1
 780  0041 cd0000        	call	_TIM1_ARRPreloadConfig
 782                     ; 137 	TIM1_OC1Init(	TIM1_OCMODE_PWM1,
 782                     ; 138 								TIM1_OUTPUTSTATE_ENABLE,
 782                     ; 139 								TIM1_OUTPUTNSTATE_ENABLE,
 782                     ; 140 								200,
 782                     ; 141 								TIM1_OCPOLARITY_LOW,
 782                     ; 142 								TIM1_OCNPOLARITY_HIGH,
 782                     ; 143 								TIM1_OCIDLESTATE_RESET,
 782                     ; 144 								TIM1_OCNIDLESTATE_RESET);
 784  0044 4b00          	push	#0
 785  0046 4b00          	push	#0
 786  0048 4b00          	push	#0
 787  004a 4b22          	push	#34
 788  004c ae00c8        	ldw	x,#200
 789  004f 89            	pushw	x
 790  0050 4b44          	push	#68
 791  0052 ae6011        	ldw	x,#24593
 792  0055 cd0000        	call	_TIM1_OC1Init
 794  0058 5b07          	addw	sp,#7
 795                     ; 145 	TIM1_SetCompare1(1);
 797  005a ae0001        	ldw	x,#1
 798  005d cd0000        	call	_TIM1_SetCompare1
 800                     ; 146 	TIM1_ITConfig(TIM1_IT_UPDATE, ENABLE);
 802  0060 ae0101        	ldw	x,#257
 803  0063 cd0000        	call	_TIM1_ITConfig
 805                     ; 147 	TIM1_CtrlPWMOutputs(ENABLE); 
 807  0066 a601          	ld	a,#1
 808  0068 cd0000        	call	_TIM1_CtrlPWMOutputs
 810                     ; 148 	TIM1_Cmd(ENABLE);
 812  006b a601          	ld	a,#1
 813  006d cd0000        	call	_TIM1_Cmd
 815                     ; 149 	TIM2_DeInit();
 817  0070 cd0000        	call	_TIM2_DeInit
 819                     ; 150 	TIM2_TimeBaseInit(	TIM2_PRESCALER_1024, // 16MHz / 1024 = base frequency
 819                     ; 151 											15625/BASEPROGRAMFREQUENCY);
 821  0073 ae0138        	ldw	x,#312
 822  0076 89            	pushw	x
 823  0077 a60a          	ld	a,#10
 824  0079 cd0000        	call	_TIM2_TimeBaseInit
 826  007c 85            	popw	x
 827                     ; 152 	TIM2_ITConfig(TIM2_IT_UPDATE,ENABLE);
 829  007d ae0101        	ldw	x,#257
 830  0080 cd0000        	call	_TIM2_ITConfig
 832                     ; 153 	TIM2_Cmd(ENABLE);
 834  0083 a601          	ld	a,#1
 835  0085 cd0000        	call	_TIM2_Cmd
 837                     ; 154 	UART1_DeInit();
 839  0088 cd0000        	call	_UART1_DeInit
 841                     ; 155 	UART1_Init(	57600,
 841                     ; 156 							UART1_WORDLENGTH_8D,
 841                     ; 157 							UART1_STOPBITS_1,
 841                     ; 158 							UART1_PARITY_NO,
 841                     ; 159 							UART1_SYNCMODE_CLOCK_DISABLE,
 841                     ; 160 							UART1_MODE_TXRX_ENABLE);
 843  008b 4b0c          	push	#12
 844  008d 4b80          	push	#128
 845  008f 4b00          	push	#0
 846  0091 4b00          	push	#0
 847  0093 4b00          	push	#0
 848  0095 aee100        	ldw	x,#57600
 849  0098 89            	pushw	x
 850  0099 ae0000        	ldw	x,#0
 851  009c 89            	pushw	x
 852  009d cd0000        	call	_UART1_Init
 854  00a0 5b09          	addw	sp,#9
 855                     ; 161 	UART1_ITConfig(	UART1_IT_RXNE, ENABLE);
 857  00a2 4b01          	push	#1
 858  00a4 ae0255        	ldw	x,#597
 859  00a7 cd0000        	call	_UART1_ITConfig
 861  00aa 84            	pop	a
 862                     ; 162 	UART1_Cmd(ENABLE);
 864  00ab a601          	ld	a,#1
 865  00ad cd0000        	call	_UART1_Cmd
 867                     ; 163 	ADC1_DeInit();
 869  00b0 cd0000        	call	_ADC1_DeInit
 871                     ; 164 	ADC1_Init(	ADC1_CONVERSIONMODE_CONTINUOUS,
 871                     ; 165 							ADC1_CHANNEL_3,
 871                     ; 166 							ADC1_PRESSEL_FCPU_D2,
 871                     ; 167 							ADC1_EXTTRIG_TIM,
 871                     ; 168 							DISABLE,
 871                     ; 169 							ADC1_ALIGN_RIGHT,
 871                     ; 170 							ADC1_SCHMITTTRIG_CHANNEL3,
 871                     ; 171 							DISABLE);
 873  00b3 4b00          	push	#0
 874  00b5 4b03          	push	#3
 875  00b7 4b08          	push	#8
 876  00b9 4b00          	push	#0
 877  00bb 4b00          	push	#0
 878  00bd 4b00          	push	#0
 879  00bf ae0103        	ldw	x,#259
 880  00c2 cd0000        	call	_ADC1_Init
 882  00c5 5b06          	addw	sp,#6
 883                     ; 172 	ADC1_Cmd(ENABLE);
 885  00c7 a601          	ld	a,#1
 886  00c9 cd0000        	call	_ADC1_Cmd
 888                     ; 173 	ADC1_StartConversion();
 890  00cc cd0000        	call	_ADC1_StartConversion
 892                     ; 175 	enableInterrupts();
 895  00cf 9a            rim
 897                     ; 177 	motorSpeedK = TIM1STEPSTO1SECOND;
 900  00d0 ae7d00        	ldw	x,#32000
 901  00d3 bf02          	ldw	_motorSpeedK+2,x
 902  00d5 ae0000        	ldw	x,#0
 903  00d8 bf00          	ldw	_motorSpeedK,x
 904                     ; 178 	motorSpeedK *= 60;
 906  00da ae003c        	ldw	x,#60
 907  00dd bf02          	ldw	c_lreg+2,x
 908  00df ae0000        	ldw	x,#0
 909  00e2 bf00          	ldw	c_lreg,x
 910  00e4 ae0000        	ldw	x,#_motorSpeedK
 911  00e7 cd0000        	call	c_lgmul
 913                     ; 179 	motorSpeedK /= MOTORSTEPSPERROTATION;
 915  00ea ae0000        	ldw	x,#_motorSpeedK
 916  00ed cd0000        	call	c_ltor
 918  00f0 ae0000        	ldw	x,#L42
 919  00f3 cd0000        	call	c_ludv
 921  00f6 ae0000        	ldw	x,#_motorSpeedK
 922  00f9 cd0000        	call	c_rtol
 924                     ; 181 	TIM1_SetAutoreload(motorSpeedK/MAXRPM); // ”становить скорость мотора
 926  00fc ae0028        	ldw	x,#40
 927  00ff cd0000        	call	_TIM1_SetAutoreload
 929  0102               L502:
 930                     ; 183 	while (1);
 932  0102 20fe          	jra	L502
1055                     	xdef	_main
1056                     	xdef	f_tim2Update
1057                     	xdef	f_tim1Update
1058                     	xdef	_setMotorSpeed
1059                     	xdef	_motorEnable
1060                     	xdef	_motorDisable
1061                     	xdef	f_uartReceive
1062                     	xdef	_receive
1063                     	xdef	_uartTransmit
1064                     	xdef	_controlVoltage
1065                     	xdef	_timerReload
1066                     	xdef	_velocity
1067                     	xdef	_acc
1068                     	switch	.ubsct
1069  0000               _motorSpeedK:
1070  0000 00000000      	ds.b	4
1071                     	xdef	_motorSpeedK
1072                     	xdef	_kalmanK
1073                     	xdef	_kalmanPositionPrev
1074                     	xdef	_kalmanPosition
1075                     	xdef	_targetPosition
1076                     	xdef	_position
1077                     	xdef	_motorDirection
1078                     	xref	_abs
1079                     	xref	_UART1_ClearITPendingBit
1080                     	xref	_UART1_ReceiveData8
1081                     	xref	_UART1_ITConfig
1082                     	xref	_UART1_Cmd
1083                     	xref	_UART1_Init
1084                     	xref	_UART1_DeInit
1085                     	xref	_TIM2_ClearITPendingBit
1086                     	xref	_TIM2_ITConfig
1087                     	xref	_TIM2_Cmd
1088                     	xref	_TIM2_TimeBaseInit
1089                     	xref	_TIM2_DeInit
1090                     	xref	_TIM1_ClearITPendingBit
1091                     	xref	_TIM1_SetCompare1
1092                     	xref	_TIM1_SetAutoreload
1093                     	xref	_TIM1_ARRPreloadConfig
1094                     	xref	_TIM1_ITConfig
1095                     	xref	_TIM1_CtrlPWMOutputs
1096                     	xref	_TIM1_Cmd
1097                     	xref	_TIM1_OC1Init
1098                     	xref	_TIM1_TimeBaseInit
1099                     	xref	_TIM1_DeInit
1100                     	xref	_GPIO_WriteReverse
1101                     	xref	_GPIO_WriteLow
1102                     	xref	_GPIO_WriteHigh
1103                     	xref	_GPIO_Init
1104                     	xref	_CLK_HSIPrescalerConfig
1105                     	xref	_CLK_PeripheralClockConfig
1106                     	xref	_ADC1_GetConversionValue
1107                     	xref	_ADC1_StartConversion
1108                     	xref	_ADC1_Cmd
1109                     	xref	_ADC1_Init
1110                     	xref	_ADC1_DeInit
1111                     	switch	.const
1112  0004               L161:
1113  0004 41200000      	dc.w	16672,0
1114  0008               L151:
1115  0008 40200000      	dc.w	16416,0
1116                     	xref.b	c_lreg
1117                     	xref.b	c_x
1118                     	xref.b	c_y
1138                     	xref	c_lgmul
1139                     	xref	c_ftoi
1140                     	xref	c_fdiv
1141                     	xref	c_ltof
1142                     	xref	c_fadd
1143                     	xref	c_fsub
1144                     	xref	c_ctof
1145                     	xref	c_fmul
1146                     	xref	c_uitof
1147                     	xref	c_lgadd
1148                     	xref	c_ludv
1149                     	xref	c_rtol
1150                     	xref	c_itolx
1151                     	xref	c_ltor
1152                     	end
