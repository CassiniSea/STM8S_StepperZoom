   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
  17                     	bsct
  18  0000               _targetRpm:
  19  0000 42700000      	dc.w	17008,0
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
  30  000c               _acc:
  31  000c 3c23d70a      	dc.w	15395,-10486
  32  0010               _position:
  33  0010 00000000      	dc.l	0
  34  0014               _targetPosition:
  35  0014 00000000      	dc.l	0
  75                     ; 31 void uartTransmit(uint8_t data){
  77                     .text:	section	.text,new
  78  0000               _uartTransmit:
  82                     ; 33 	UART1->DR = data;
  84  0000 c75231        	ld	21041,a
  85                     ; 34 }
  88  0003 81            	ret
  91                     	bsct
  92  0018               _receive:
  93  0018 00            	dc.b	0
 119                     ; 37 @far @interrupt void uartReceive(void)	{
 121                     .text:	section	.text,new
 122  0000               f_uartReceive:
 124  0000 8a            	push	cc
 125  0001 84            	pop	a
 126  0002 a4bf          	and	a,#191
 127  0004 88            	push	a
 128  0005 86            	pop	cc
 129  0006 3b0002        	push	c_x+2
 130  0009 be00          	ldw	x,c_x
 131  000b 89            	pushw	x
 132  000c 3b0002        	push	c_y+2
 133  000f be00          	ldw	x,c_y
 134  0011 89            	pushw	x
 135  0012 be02          	ldw	x,c_lreg+2
 136  0014 89            	pushw	x
 137  0015 be00          	ldw	x,c_lreg
 138  0017 89            	pushw	x
 141                     ; 38 	UART1_ClearITPendingBit(UART1_IT_RXNE);
 143  0018 ae0255        	ldw	x,#597
 144  001b cd0000        	call	_UART1_ClearITPendingBit
 146                     ; 39 	receive=UART1_ReceiveData8();
 148  001e cd0000        	call	_UART1_ReceiveData8
 150  0021 b718          	ld	_receive,a
 151                     ; 40 	targetPosition = receive * 100;
 153  0023 b618          	ld	a,_receive
 154  0025 97            	ld	xl,a
 155  0026 a664          	ld	a,#100
 156  0028 42            	mul	x,a
 157  0029 cd0000        	call	c_itolx
 159  002c ae0014        	ldw	x,#_targetPosition
 160  002f cd0000        	call	c_rtol
 162                     ; 59 	uartTransmit(receive);
 165  0032 b618          	ld	a,_receive
 166  0034 cd0000        	call	_uartTransmit
 168                     ; 60 }
 171  0037 85            	popw	x
 172  0038 bf00          	ldw	c_lreg,x
 173  003a 85            	popw	x
 174  003b bf02          	ldw	c_lreg+2,x
 175  003d 85            	popw	x
 176  003e bf00          	ldw	c_y,x
 177  0040 320002        	pop	c_y+2
 178  0043 85            	popw	x
 179  0044 bf00          	ldw	c_x,x
 180  0046 320002        	pop	c_x+2
 181  0049 80            	iret
 205                     ; 62 void motorDisable(void) {
 207                     .text:	section	.text,new
 208  0000               _motorDisable:
 212                     ; 63 	TIM1_Cmd(DISABLE);
 214  0000 4f            	clr	a
 215  0001 cd0000        	call	_TIM1_Cmd
 217                     ; 64 	GPIO_WriteHigh(GPIOC, GPIO_PIN_7);
 219  0004 4b80          	push	#128
 220  0006 ae500a        	ldw	x,#20490
 221  0009 cd0000        	call	_GPIO_WriteHigh
 223  000c 84            	pop	a
 224                     ; 65 }
 227  000d 81            	ret
 252                     ; 67 void motorEnable(void) {
 253                     .text:	section	.text,new
 254  0000               _motorEnable:
 258                     ; 68 	GPIO_WriteLow(GPIOC, GPIO_PIN_7);
 260  0000 4b80          	push	#128
 261  0002 ae500a        	ldw	x,#20490
 262  0005 cd0000        	call	_GPIO_WriteLow
 264  0008 84            	pop	a
 265                     ; 69 	TIM1_Cmd(ENABLE);
 267  0009 a601          	ld	a,#1
 268  000b cd0000        	call	_TIM1_Cmd
 270                     ; 70 }
 273  000e 81            	ret
 302                     .const:	section	.text
 303  0000               L61:
 304  0000 00003e80      	dc.l	16000
 305                     ; 72 @far @interrupt void tim1Update(void)	{
 306                     	scross	on
 307                     .text:	section	.text,new
 308  0000               f_tim1Update:
 310  0000 8a            	push	cc
 311  0001 84            	pop	a
 312  0002 a4bf          	and	a,#191
 313  0004 88            	push	a
 314  0005 86            	pop	cc
 315  0006 3b0002        	push	c_x+2
 316  0009 be00          	ldw	x,c_x
 317  000b 89            	pushw	x
 318  000c 3b0002        	push	c_y+2
 319  000f be00          	ldw	x,c_y
 320  0011 89            	pushw	x
 321  0012 be02          	ldw	x,c_lreg+2
 322  0014 89            	pushw	x
 323  0015 be00          	ldw	x,c_lreg
 324  0017 89            	pushw	x
 327                     ; 73 	TIM1_ClearITPendingBit(TIM1_IT_UPDATE);
 329  0018 a601          	ld	a,#1
 330  001a cd0000        	call	_TIM1_ClearITPendingBit
 332                     ; 74 	if(position == targetPosition) motorDisable();
 334  001d ae0010        	ldw	x,#_position
 335  0020 cd0000        	call	c_ltor
 337  0023 ae0014        	ldw	x,#_targetPosition
 338  0026 cd0000        	call	c_lcmp
 340  0029 2605          	jrne	L701
 343  002b cd0000        	call	_motorDisable
 346  002e 2060          	jra	L111
 347  0030               L701:
 348                     ; 76 		if( position < targetPosition) {
 350  0030 ae0010        	ldw	x,#_position
 351  0033 cd0000        	call	c_ltor
 353  0036 ae0014        	ldw	x,#_targetPosition
 354  0039 cd0000        	call	c_lcmp
 356  003c 2426          	jruge	L311
 357                     ; 77 			if( position < MAXPOSITION ) {
 359  003e ae0010        	ldw	x,#_position
 360  0041 cd0000        	call	c_ltor
 362  0044 ae0000        	ldw	x,#L61
 363  0047 cd0000        	call	c_lcmp
 365  004a 2413          	jruge	L511
 366                     ; 78 				GPIO_WriteHigh(GPIOC, GPIO_PIN_5);
 368  004c 4b20          	push	#32
 369  004e ae500a        	ldw	x,#20490
 370  0051 cd0000        	call	_GPIO_WriteHigh
 372  0054 84            	pop	a
 373                     ; 79 				position++;
 375  0055 ae0010        	ldw	x,#_position
 376  0058 a601          	ld	a,#1
 377  005a cd0000        	call	c_lgadc
 380  005d 2031          	jra	L111
 381  005f               L511:
 382                     ; 81 			else motorDisable();
 384  005f cd0000        	call	_motorDisable
 386  0062 202c          	jra	L111
 387  0064               L311:
 388                     ; 83 		else if( position > targetPosition ) {
 390  0064 ae0010        	ldw	x,#_position
 391  0067 cd0000        	call	c_ltor
 393  006a ae0014        	ldw	x,#_targetPosition
 394  006d cd0000        	call	c_lcmp
 396  0070 231e          	jrule	L111
 397                     ; 84 			if( position > 0 ) {
 399  0072 ae0010        	ldw	x,#_position
 400  0075 cd0000        	call	c_lzmp
 402  0078 2713          	jreq	L521
 403                     ; 85 				GPIO_WriteLow(GPIOC, GPIO_PIN_5);
 405  007a 4b20          	push	#32
 406  007c ae500a        	ldw	x,#20490
 407  007f cd0000        	call	_GPIO_WriteLow
 409  0082 84            	pop	a
 410                     ; 86 				position--;
 412  0083 ae0010        	ldw	x,#_position
 413  0086 a601          	ld	a,#1
 414  0088 cd0000        	call	c_lgsbc
 417  008b 2003          	jra	L111
 418  008d               L521:
 419                     ; 88 			else motorDisable();
 421  008d cd0000        	call	_motorDisable
 423  0090               L111:
 424                     ; 91 }
 427  0090 85            	popw	x
 428  0091 bf00          	ldw	c_lreg,x
 429  0093 85            	popw	x
 430  0094 bf02          	ldw	c_lreg+2,x
 431  0096 85            	popw	x
 432  0097 bf00          	ldw	c_y,x
 433  0099 320002        	pop	c_y+2
 434  009c 85            	popw	x
 435  009d bf00          	ldw	c_x,x
 436  009f 320002        	pop	c_x+2
 437  00a2 80            	iret
 464                     ; 93 @far @interrupt void tim2Update(void)	{
 465                     .text:	section	.text,new
 466  0000               f_tim2Update:
 468  0000 8a            	push	cc
 469  0001 84            	pop	a
 470  0002 a4bf          	and	a,#191
 471  0004 88            	push	a
 472  0005 86            	pop	cc
 473  0006 3b0002        	push	c_x+2
 474  0009 be00          	ldw	x,c_x
 475  000b 89            	pushw	x
 476  000c 3b0002        	push	c_y+2
 477  000f be00          	ldw	x,c_y
 478  0011 89            	pushw	x
 479  0012 be02          	ldw	x,c_lreg+2
 480  0014 89            	pushw	x
 481  0015 be00          	ldw	x,c_lreg
 482  0017 89            	pushw	x
 485                     ; 94 	TIM2_ClearITPendingBit(TIM2_IT_UPDATE);
 487  0018 a601          	ld	a,#1
 488  001a cd0000        	call	_TIM2_ClearITPendingBit
 490                     ; 95 	GPIO_WriteReverse(GPIOB, GPIO_PIN_5);
 492  001d 4b20          	push	#32
 493  001f ae5005        	ldw	x,#20485
 494  0022 cd0000        	call	_GPIO_WriteReverse
 496  0025 84            	pop	a
 497                     ; 96 	if( position != targetPosition && ( ( position < targetPosition && position < MAXPOSITION ) || ( position > targetPosition && position > 0 ) ) ) motorEnable();
 499  0026 ae0010        	ldw	x,#_position
 500  0029 cd0000        	call	c_ltor
 502  002c ae0014        	ldw	x,#_targetPosition
 503  002f cd0000        	call	c_lcmp
 505  0032 2735          	jreq	L141
 507  0034 ae0010        	ldw	x,#_position
 508  0037 cd0000        	call	c_ltor
 510  003a ae0014        	ldw	x,#_targetPosition
 511  003d cd0000        	call	c_lcmp
 513  0040 240e          	jruge	L541
 515  0042 ae0010        	ldw	x,#_position
 516  0045 cd0000        	call	c_ltor
 518  0048 ae0000        	ldw	x,#L61
 519  004b cd0000        	call	c_lcmp
 521  004e 2516          	jrult	L341
 522  0050               L541:
 524  0050 ae0010        	ldw	x,#_position
 525  0053 cd0000        	call	c_ltor
 527  0056 ae0014        	ldw	x,#_targetPosition
 528  0059 cd0000        	call	c_lcmp
 530  005c 230b          	jrule	L141
 532  005e ae0010        	ldw	x,#_position
 533  0061 cd0000        	call	c_lzmp
 535  0064 2703          	jreq	L141
 536  0066               L341:
 539  0066 cd0000        	call	_motorEnable
 541  0069               L141:
 542                     ; 100 }
 545  0069 85            	popw	x
 546  006a bf00          	ldw	c_lreg,x
 547  006c 85            	popw	x
 548  006d bf02          	ldw	c_lreg+2,x
 549  006f 85            	popw	x
 550  0070 bf00          	ldw	c_y,x
 551  0072 320002        	pop	c_y+2
 552  0075 85            	popw	x
 553  0076 bf00          	ldw	c_x,x
 554  0078 320002        	pop	c_x+2
 555  007b 80            	iret
 599                     	switch	.const
 600  0004               L42:
 601  0004 00000c80      	dc.l	3200
 602                     ; 102 main()
 602                     ; 103 {
 603                     	scross	off
 604                     .text:	section	.text,new
 605  0000               _main:
 609                     ; 104 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1|CLK_PRESCALER_CPUDIV1);
 611  0000 a680          	ld	a,#128
 612  0002 cd0000        	call	_CLK_HSIPrescalerConfig
 614                     ; 105 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
 616  0005 ae0701        	ldw	x,#1793
 617  0008 cd0000        	call	_CLK_PeripheralClockConfig
 619                     ; 106 	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
 621  000b 4bf0          	push	#240
 622  000d 4b20          	push	#32
 623  000f ae5005        	ldw	x,#20485
 624  0012 cd0000        	call	_GPIO_Init
 626  0015 85            	popw	x
 627                     ; 107 	GPIO_Init(GPIOC, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
 629  0016 4bf0          	push	#240
 630  0018 4b20          	push	#32
 631  001a ae500a        	ldw	x,#20490
 632  001d cd0000        	call	_GPIO_Init
 634  0020 85            	popw	x
 635                     ; 108 	GPIO_Init(GPIOC, GPIO_PIN_7, GPIO_MODE_OUT_PP_HIGH_FAST);
 637  0021 4bf0          	push	#240
 638  0023 4b80          	push	#128
 639  0025 ae500a        	ldw	x,#20490
 640  0028 cd0000        	call	_GPIO_Init
 642  002b 85            	popw	x
 643                     ; 109 	TIM1_DeInit();
 645  002c cd0000        	call	_TIM1_DeInit
 647                     ; 110 	TIM1_TimeBaseInit(	16000000/TIM1STEPSTO1SECOND,
 647                     ; 111 											TIM1_COUNTERMODE_UP,
 647                     ; 112 											32000,
 647                     ; 113 											0);
 649  002f 4b00          	push	#0
 650  0031 ae7d00        	ldw	x,#32000
 651  0034 89            	pushw	x
 652  0035 4b00          	push	#0
 653  0037 ae01f4        	ldw	x,#500
 654  003a cd0000        	call	_TIM1_TimeBaseInit
 656  003d 5b04          	addw	sp,#4
 657                     ; 114 	TIM1_ARRPreloadConfig(ENABLE); // «агружать новое значение Autoreload при событии обновлени€, а не сразу
 659  003f a601          	ld	a,#1
 660  0041 cd0000        	call	_TIM1_ARRPreloadConfig
 662                     ; 119 	TIM1_OC1Init(	TIM1_OCMODE_PWM1,
 662                     ; 120 								TIM1_OUTPUTSTATE_ENABLE,
 662                     ; 121 								TIM1_OUTPUTNSTATE_ENABLE,
 662                     ; 122 								200,
 662                     ; 123 								TIM1_OCPOLARITY_LOW,
 662                     ; 124 								TIM1_OCNPOLARITY_HIGH,
 662                     ; 125 								TIM1_OCIDLESTATE_RESET,
 662                     ; 126 								TIM1_OCNIDLESTATE_RESET);
 664  0044 4b00          	push	#0
 665  0046 4b00          	push	#0
 666  0048 4b00          	push	#0
 667  004a 4b22          	push	#34
 668  004c ae00c8        	ldw	x,#200
 669  004f 89            	pushw	x
 670  0050 4b44          	push	#68
 671  0052 ae6011        	ldw	x,#24593
 672  0055 cd0000        	call	_TIM1_OC1Init
 674  0058 5b07          	addw	sp,#7
 675                     ; 127 	TIM1_SetCompare1(1);
 677  005a ae0001        	ldw	x,#1
 678  005d cd0000        	call	_TIM1_SetCompare1
 680                     ; 128 	TIM1_ITConfig(TIM1_IT_UPDATE, ENABLE);
 682  0060 ae0101        	ldw	x,#257
 683  0063 cd0000        	call	_TIM1_ITConfig
 685                     ; 129 	TIM1_CtrlPWMOutputs(ENABLE); 
 687  0066 a601          	ld	a,#1
 688  0068 cd0000        	call	_TIM1_CtrlPWMOutputs
 690                     ; 130 	TIM1_Cmd(ENABLE);
 692  006b a601          	ld	a,#1
 693  006d cd0000        	call	_TIM1_Cmd
 695                     ; 131 	TIM2_DeInit();
 697  0070 cd0000        	call	_TIM2_DeInit
 699                     ; 132 	TIM2_TimeBaseInit(	TIM2_PRESCALER_1024, // 16MHz / 1024 = base frequency
 699                     ; 133 											15625/BASEPROGRAMFREQUENCY);
 701  0073 ae0138        	ldw	x,#312
 702  0076 89            	pushw	x
 703  0077 a60a          	ld	a,#10
 704  0079 cd0000        	call	_TIM2_TimeBaseInit
 706  007c 85            	popw	x
 707                     ; 134 	TIM2_ITConfig(TIM2_IT_UPDATE,ENABLE);
 709  007d ae0101        	ldw	x,#257
 710  0080 cd0000        	call	_TIM2_ITConfig
 712                     ; 135 	TIM2_Cmd(ENABLE);
 714  0083 a601          	ld	a,#1
 715  0085 cd0000        	call	_TIM2_Cmd
 717                     ; 136 	UART1_DeInit();
 719  0088 cd0000        	call	_UART1_DeInit
 721                     ; 137 	UART1_Init(	57600,
 721                     ; 138 							UART1_WORDLENGTH_8D,
 721                     ; 139 							UART1_STOPBITS_1,
 721                     ; 140 							UART1_PARITY_NO,
 721                     ; 141 							UART1_SYNCMODE_CLOCK_DISABLE,
 721                     ; 142 							UART1_MODE_TXRX_ENABLE);
 723  008b 4b0c          	push	#12
 724  008d 4b80          	push	#128
 725  008f 4b00          	push	#0
 726  0091 4b00          	push	#0
 727  0093 4b00          	push	#0
 728  0095 aee100        	ldw	x,#57600
 729  0098 89            	pushw	x
 730  0099 ae0000        	ldw	x,#0
 731  009c 89            	pushw	x
 732  009d cd0000        	call	_UART1_Init
 734  00a0 5b09          	addw	sp,#9
 735                     ; 143 	UART1_ITConfig(	UART1_IT_RXNE, ENABLE);
 737  00a2 4b01          	push	#1
 738  00a4 ae0255        	ldw	x,#597
 739  00a7 cd0000        	call	_UART1_ITConfig
 741  00aa 84            	pop	a
 742                     ; 144 	UART1_Cmd(ENABLE);
 744  00ab a601          	ld	a,#1
 745  00ad cd0000        	call	_UART1_Cmd
 747                     ; 145 	enableInterrupts();
 750  00b0 9a            rim
 752                     ; 147 	motorSpeedK = TIM1STEPSTO1SECOND;
 755  00b1 ae7d00        	ldw	x,#32000
 756  00b4 bf02          	ldw	_motorSpeedK+2,x
 757  00b6 ae0000        	ldw	x,#0
 758  00b9 bf00          	ldw	_motorSpeedK,x
 759                     ; 148 	motorSpeedK *= 60;
 761  00bb ae003c        	ldw	x,#60
 762  00be bf02          	ldw	c_lreg+2,x
 763  00c0 ae0000        	ldw	x,#0
 764  00c3 bf00          	ldw	c_lreg,x
 765  00c5 ae0000        	ldw	x,#_motorSpeedK
 766  00c8 cd0000        	call	c_lgmul
 768                     ; 149 	motorSpeedK /= MOTORSTEPSPERROTATION;
 770  00cb ae0000        	ldw	x,#_motorSpeedK
 771  00ce cd0000        	call	c_ltor
 773  00d1 ae0004        	ldw	x,#L42
 774  00d4 cd0000        	call	c_ludv
 776  00d7 ae0000        	ldw	x,#_motorSpeedK
 777  00da cd0000        	call	c_rtol
 779                     ; 151 	TIM1_SetAutoreload(motorSpeedK/MAXRPM); // ”становить скорость мотора
 781  00dd ae0258        	ldw	x,#600
 782  00e0 cd0000        	call	_TIM1_SetAutoreload
 784  00e3               L751:
 785                     ; 153 	while (1);
 787  00e3 20fe          	jra	L751
 910                     	xdef	_main
 911                     	xdef	f_tim2Update
 912                     	xdef	f_tim1Update
 913                     	xdef	_motorEnable
 914                     	xdef	_motorDisable
 915                     	xdef	f_uartReceive
 916                     	xdef	_receive
 917                     	xdef	_uartTransmit
 918                     	switch	.ubsct
 919  0000               _motorSpeedK:
 920  0000 00000000      	ds.b	4
 921                     	xdef	_motorSpeedK
 922  0004               _timerReload:
 923  0004 00000000      	ds.b	4
 924                     	xdef	_timerReload
 925                     	xdef	_targetPosition
 926                     	xdef	_position
 927                     	xdef	_acc
 928                     	xdef	_currentSpeed
 929                     	xdef	_targetSpeed
 930                     	xdef	_currentDir
 931                     	xdef	_targetDir
 932                     	xdef	_currentRpm
 933                     	xdef	_targetRpm
 934                     	xref	_UART1_ClearITPendingBit
 935                     	xref	_UART1_ReceiveData8
 936                     	xref	_UART1_ITConfig
 937                     	xref	_UART1_Cmd
 938                     	xref	_UART1_Init
 939                     	xref	_UART1_DeInit
 940                     	xref	_TIM2_ClearITPendingBit
 941                     	xref	_TIM2_ITConfig
 942                     	xref	_TIM2_Cmd
 943                     	xref	_TIM2_TimeBaseInit
 944                     	xref	_TIM2_DeInit
 945                     	xref	_TIM1_ClearITPendingBit
 946                     	xref	_TIM1_SetCompare1
 947                     	xref	_TIM1_SetAutoreload
 948                     	xref	_TIM1_ARRPreloadConfig
 949                     	xref	_TIM1_ITConfig
 950                     	xref	_TIM1_CtrlPWMOutputs
 951                     	xref	_TIM1_Cmd
 952                     	xref	_TIM1_OC1Init
 953                     	xref	_TIM1_TimeBaseInit
 954                     	xref	_TIM1_DeInit
 955                     	xref	_GPIO_WriteReverse
 956                     	xref	_GPIO_WriteLow
 957                     	xref	_GPIO_WriteHigh
 958                     	xref	_GPIO_Init
 959                     	xref	_CLK_HSIPrescalerConfig
 960                     	xref	_CLK_PeripheralClockConfig
 961                     	xref.b	c_lreg
 962                     	xref.b	c_x
 963                     	xref.b	c_y
 983                     	xref	c_ludv
 984                     	xref	c_lgmul
 985                     	xref	c_lgsbc
 986                     	xref	c_lzmp
 987                     	xref	c_lgadc
 988                     	xref	c_lcmp
 989                     	xref	c_ltor
 990                     	xref	c_rtol
 991                     	xref	c_itolx
 992                     	end
