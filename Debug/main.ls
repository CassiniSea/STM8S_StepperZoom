   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
  17                     	bsct
  18  0000               _targetRpm:
  19  0000 00000000      	dc.w	0,0
  20  0004               _currentRpm:
  21  0004 00000000      	dc.w	0,0
  22  0008               _targetDir:
  23  0008 00            	dc.b	0
  24  0009               _currentDir:
  25  0009 00            	dc.b	0
  26  000a               _targetSpeed:
  27  000a 01            	dc.b	1
  28  000b               _currentSpeed:
  29  000b 00            	dc.b	0
  30  000c               _acc:
  31  000c 3c23d70a      	dc.w	15395,-10486
  71                     ; 23 void uartTransmit(uint8_t data){
  73                     .text:	section	.text,new
  74  0000               _uartTransmit:
  78                     ; 25 	UART1->DR = data;
  80  0000 c75231        	ld	21041,a
  81                     ; 26 }
  84  0003 81            	ret
 114                     ; 29 @far @interrupt void uartReceive(void)	{
 116                     .text:	section	.text,new
 117  0000               f_uartReceive:
 119  0000 8a            	push	cc
 120  0001 84            	pop	a
 121  0002 a4bf          	and	a,#191
 122  0004 88            	push	a
 123  0005 86            	pop	cc
 124  0006 3b0002        	push	c_x+2
 125  0009 be00          	ldw	x,c_x
 126  000b 89            	pushw	x
 127  000c 3b0002        	push	c_y+2
 128  000f be00          	ldw	x,c_y
 129  0011 89            	pushw	x
 132                     ; 30 	disableInterrupts();
 135  0012 9b            sim
 137                     ; 31 	UART1_ClearITPendingBit(UART1_IT_RXNE);
 140  0013 ae0255        	ldw	x,#597
 141  0016 cd0000        	call	_UART1_ClearITPendingBit
 143                     ; 32 	receive=UART1_ReceiveData8();
 145  0019 cd0000        	call	_UART1_ReceiveData8
 147  001c b700          	ld	_receive,a
 148                     ; 33 	targetSpeed = receive;
 150  001e 45000a        	mov	_targetSpeed,_receive
 151                     ; 52 	uartTransmit(receive);
 154  0021 b600          	ld	a,_receive
 155  0023 cd0000        	call	_uartTransmit
 157                     ; 53 	enableInterrupts();
 160  0026 9a            rim
 162                     ; 54 }
 166  0027 85            	popw	x
 167  0028 bf00          	ldw	c_y,x
 168  002a 320002        	pop	c_y+2
 169  002d 85            	popw	x
 170  002e bf00          	ldw	c_x,x
 171  0030 320002        	pop	c_x+2
 172  0033 80            	iret
 195                     ; 56 @far @interrupt void tim1Update(void)	{
 196                     .text:	section	.text,new
 197  0000               f_tim1Update:
 199  0000 8a            	push	cc
 200  0001 84            	pop	a
 201  0002 a4bf          	and	a,#191
 202  0004 88            	push	a
 203  0005 86            	pop	cc
 204  0006 3b0002        	push	c_x+2
 205  0009 be00          	ldw	x,c_x
 206  000b 89            	pushw	x
 207  000c 3b0002        	push	c_y+2
 208  000f be00          	ldw	x,c_y
 209  0011 89            	pushw	x
 212                     ; 57 	TIM1_ClearITPendingBit(TIM1_IT_UPDATE);
 214  0012 a601          	ld	a,#1
 215  0014 cd0000        	call	_TIM1_ClearITPendingBit
 217                     ; 59 }
 220  0017 85            	popw	x
 221  0018 bf00          	ldw	c_y,x
 222  001a 320002        	pop	c_y+2
 223  001d 85            	popw	x
 224  001e bf00          	ldw	c_x,x
 225  0020 320002        	pop	c_x+2
 226  0023 80            	iret
 258                     ; 61 @far @interrupt void tim2Update(void)	{
 259                     .text:	section	.text,new
 260  0000               f_tim2Update:
 262  0000 8a            	push	cc
 263  0001 84            	pop	a
 264  0002 a4bf          	and	a,#191
 265  0004 88            	push	a
 266  0005 86            	pop	cc
 267  0006 3b0002        	push	c_x+2
 268  0009 be00          	ldw	x,c_x
 269  000b 89            	pushw	x
 270  000c 3b0002        	push	c_y+2
 271  000f be00          	ldw	x,c_y
 272  0011 89            	pushw	x
 273  0012 be02          	ldw	x,c_lreg+2
 274  0014 89            	pushw	x
 275  0015 be00          	ldw	x,c_lreg
 276  0017 89            	pushw	x
 279                     ; 62 	TIM2_ClearITPendingBit(TIM2_IT_UPDATE);
 281  0018 a601          	ld	a,#1
 282  001a cd0000        	call	_TIM2_ClearITPendingBit
 284                     ; 63 	targetRpm = (float)abs(targetSpeed)*MAXRPM/127;
 286  001d 5f            	clrw	x
 287  001e b60a          	ld	a,_targetSpeed
 288  0020 2a01          	jrpl	L41
 289  0022 53            	cplw	x
 290  0023               L41:
 291  0023 97            	ld	xl,a
 292  0024 cd0000        	call	_abs
 294  0027 cd0000        	call	c_itof
 296  002a ae0004        	ldw	x,#L301
 297  002d cd0000        	call	c_fmul
 299  0030 ae0000        	ldw	x,#L311
 300  0033 cd0000        	call	c_fdiv
 302  0036 ae0000        	ldw	x,#_targetRpm
 303  0039 cd0000        	call	c_rtol
 305                     ; 64 	if(targetSpeed > 0) GPIO_WriteHigh(GPIOC, GPIO_PIN_5);
 307  003c 9c            	rvf
 308  003d b60a          	ld	a,_targetSpeed
 309  003f a100          	cp	a,#0
 310  0041 2d0b          	jrsle	L711
 313  0043 4b20          	push	#32
 314  0045 ae500a        	ldw	x,#20490
 315  0048 cd0000        	call	_GPIO_WriteHigh
 317  004b 84            	pop	a
 319  004c 2010          	jra	L121
 320  004e               L711:
 321                     ; 65 	else if(targetSpeed < 0) GPIO_WriteLow(GPIOC, GPIO_PIN_5);
 323  004e 9c            	rvf
 324  004f b60a          	ld	a,_targetSpeed
 325  0051 a100          	cp	a,#0
 326  0053 2e09          	jrsge	L121
 329  0055 4b20          	push	#32
 330  0057 ae500a        	ldw	x,#20490
 331  005a cd0000        	call	_GPIO_WriteLow
 333  005d 84            	pop	a
 334  005e               L121:
 335                     ; 66 	if(currentRpm + acc <= targetRpm) currentRpm += acc;
 337  005e 9c            	rvf
 338  005f ae0004        	ldw	x,#_currentRpm
 339  0062 cd0000        	call	c_ltor
 341  0065 ae000c        	ldw	x,#_acc
 342  0068 cd0000        	call	c_fadd
 344  006b ae0000        	ldw	x,#_targetRpm
 345  006e cd0000        	call	c_fcmp
 347  0071 2c0e          	jrsgt	L521
 350  0073 ae000c        	ldw	x,#_acc
 351  0076 cd0000        	call	c_ltor
 353  0079 ae0004        	ldw	x,#_currentRpm
 354  007c cd0000        	call	c_fgadd
 357  007f 2021          	jra	L721
 358  0081               L521:
 359                     ; 67 	else if(currentRpm - acc >= targetRpm) currentRpm -= acc;
 361  0081 9c            	rvf
 362  0082 ae0004        	ldw	x,#_currentRpm
 363  0085 cd0000        	call	c_ltor
 365  0088 ae000c        	ldw	x,#_acc
 366  008b cd0000        	call	c_fsub
 368  008e ae0000        	ldw	x,#_targetRpm
 369  0091 cd0000        	call	c_fcmp
 371  0094 2f0c          	jrslt	L721
 374  0096 ae000c        	ldw	x,#_acc
 375  0099 cd0000        	call	c_ltor
 377  009c ae0004        	ldw	x,#_currentRpm
 378  009f cd0000        	call	c_fgsub
 380  00a2               L721:
 381                     ; 69 	if(currentRpm != 0) {
 383  00a2 9c            	rvf
 384  00a3 3d04          	tnz	_currentRpm
 385  00a5 2718          	jreq	L331
 386                     ; 70 		TIM1_SetAutoreload(TIM1STEPSTO1SECOND/200/16/currentRpm); // Установить скорость мотора
 388  00a7 a60a          	ld	a,#10
 389  00a9 cd0000        	call	c_ctof
 391  00ac ae0004        	ldw	x,#_currentRpm
 392  00af cd0000        	call	c_fdiv
 394  00b2 cd0000        	call	c_ftoi
 396  00b5 cd0000        	call	_TIM1_SetAutoreload
 398                     ; 71 		TIM1_CtrlPWMOutputs(ENABLE); 
 400  00b8 a601          	ld	a,#1
 401  00ba cd0000        	call	_TIM1_CtrlPWMOutputs
 404  00bd 2004          	jra	L531
 405  00bf               L331:
 406                     ; 74 		TIM1_CtrlPWMOutputs(DISABLE); 
 408  00bf 4f            	clr	a
 409  00c0 cd0000        	call	_TIM1_CtrlPWMOutputs
 411  00c3               L531:
 412                     ; 77 }
 415  00c3 85            	popw	x
 416  00c4 bf00          	ldw	c_lreg,x
 417  00c6 85            	popw	x
 418  00c7 bf02          	ldw	c_lreg+2,x
 419  00c9 85            	popw	x
 420  00ca bf00          	ldw	c_y,x
 421  00cc 320002        	pop	c_y+2
 422  00cf 85            	popw	x
 423  00d0 bf00          	ldw	c_x,x
 424  00d2 320002        	pop	c_x+2
 425  00d5 80            	iret
 467                     ; 79 void Delay(uint32_t t)	{
 469                     .text:	section	.text,new
 470  0000               _Delay:
 472  0000 89            	pushw	x
 473       00000002      OFST:	set	2
 476  0001 2019          	jra	L361
 477  0003               L161:
 478                     ; 82 		t--;
 480  0003 96            	ldw	x,sp
 481  0004 1c0005        	addw	x,#OFST+3
 482  0007 a601          	ld	a,#1
 483  0009 cd0000        	call	c_lgsbc
 485                     ; 83 		for(i=1000;i>0;i--);
 487  000c ae03e8        	ldw	x,#1000
 488  000f 1f01          	ldw	(OFST-1,sp),x
 489  0011               L761:
 493  0011 1e01          	ldw	x,(OFST-1,sp)
 494  0013 1d0001        	subw	x,#1
 495  0016 1f01          	ldw	(OFST-1,sp),x
 498  0018 1e01          	ldw	x,(OFST-1,sp)
 499  001a 26f5          	jrne	L761
 500  001c               L361:
 501                     ; 81 	while(t>0) {
 503  001c 96            	ldw	x,sp
 504  001d 1c0005        	addw	x,#OFST+3
 505  0020 cd0000        	call	c_lzmp
 507  0023 26de          	jrne	L161
 508                     ; 85 }
 511  0025 85            	popw	x
 512  0026 81            	ret
 560                     ; 87 main()
 560                     ; 88 {
 561                     .text:	section	.text,new
 562  0000               _main:
 566                     ; 89 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1|CLK_PRESCALER_CPUDIV1);
 568  0000 a680          	ld	a,#128
 569  0002 cd0000        	call	_CLK_HSIPrescalerConfig
 571                     ; 90 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
 573  0005 ae0701        	ldw	x,#1793
 574  0008 cd0000        	call	_CLK_PeripheralClockConfig
 576                     ; 91 	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
 578  000b 4bf0          	push	#240
 579  000d 4b20          	push	#32
 580  000f ae5005        	ldw	x,#20485
 581  0012 cd0000        	call	_GPIO_Init
 583  0015 85            	popw	x
 584                     ; 92 	GPIO_Init(GPIOC, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
 586  0016 4bf0          	push	#240
 587  0018 4b20          	push	#32
 588  001a ae500a        	ldw	x,#20490
 589  001d cd0000        	call	_GPIO_Init
 591  0020 85            	popw	x
 592                     ; 93 	TIM1_DeInit();
 594  0021 cd0000        	call	_TIM1_DeInit
 596                     ; 94 	TIM1_TimeBaseInit(	16000000/TIM1STEPSTO1SECOND,
 596                     ; 95 											TIM1_COUNTERMODE_UP,
 596                     ; 96 											32000,
 596                     ; 97 											0);
 598  0024 4b00          	push	#0
 599  0026 ae7d00        	ldw	x,#32000
 600  0029 89            	pushw	x
 601  002a 4b00          	push	#0
 602  002c ae01f4        	ldw	x,#500
 603  002f cd0000        	call	_TIM1_TimeBaseInit
 605  0032 5b04          	addw	sp,#4
 606                     ; 101 	TIM1_OC1Init(	TIM1_OCMODE_PWM1,
 606                     ; 102 								TIM1_OUTPUTSTATE_ENABLE,
 606                     ; 103 								TIM1_OUTPUTNSTATE_ENABLE,
 606                     ; 104 								200,
 606                     ; 105 								TIM1_OCPOLARITY_LOW,
 606                     ; 106 								TIM1_OCNPOLARITY_HIGH,
 606                     ; 107 								TIM1_OCIDLESTATE_RESET,
 606                     ; 108 								TIM1_OCNIDLESTATE_RESET);
 608  0034 4b00          	push	#0
 609  0036 4b00          	push	#0
 610  0038 4b00          	push	#0
 611  003a 4b22          	push	#34
 612  003c ae00c8        	ldw	x,#200
 613  003f 89            	pushw	x
 614  0040 4b44          	push	#68
 615  0042 ae6011        	ldw	x,#24593
 616  0045 cd0000        	call	_TIM1_OC1Init
 618  0048 5b07          	addw	sp,#7
 619                     ; 109 	TIM1_SetCompare1(1);
 621  004a ae0001        	ldw	x,#1
 622  004d cd0000        	call	_TIM1_SetCompare1
 624                     ; 110 	TIM1_ITConfig(TIM1_IT_UPDATE, ENABLE);
 626  0050 ae0101        	ldw	x,#257
 627  0053 cd0000        	call	_TIM1_ITConfig
 629                     ; 111 	TIM1_CtrlPWMOutputs(ENABLE); 
 631  0056 a601          	ld	a,#1
 632  0058 cd0000        	call	_TIM1_CtrlPWMOutputs
 634                     ; 112 	TIM1_Cmd(ENABLE);
 636  005b a601          	ld	a,#1
 637  005d cd0000        	call	_TIM1_Cmd
 639                     ; 113 	TIM2_DeInit();
 641  0060 cd0000        	call	_TIM2_DeInit
 643                     ; 114 	TIM2_TimeBaseInit(	TIM2_PRESCALER_1024, // 16MHz / 1024 = base frequency
 643                     ; 115 											15625/BASEPROGRAMFREQUENCY);
 645  0063 ae0138        	ldw	x,#312
 646  0066 89            	pushw	x
 647  0067 a60a          	ld	a,#10
 648  0069 cd0000        	call	_TIM2_TimeBaseInit
 650  006c 85            	popw	x
 651                     ; 116 	TIM2_ITConfig(TIM2_IT_UPDATE,ENABLE);
 653  006d ae0101        	ldw	x,#257
 654  0070 cd0000        	call	_TIM2_ITConfig
 656                     ; 117 	TIM2_Cmd(ENABLE);
 658  0073 a601          	ld	a,#1
 659  0075 cd0000        	call	_TIM2_Cmd
 661                     ; 118 	UART1_DeInit();
 663  0078 cd0000        	call	_UART1_DeInit
 665                     ; 119 	UART1_Init(	57600,
 665                     ; 120 							UART1_WORDLENGTH_8D,
 665                     ; 121 							UART1_STOPBITS_1,
 665                     ; 122 							UART1_PARITY_NO,
 665                     ; 123 							UART1_SYNCMODE_CLOCK_DISABLE,
 665                     ; 124 							UART1_MODE_TXRX_ENABLE);
 667  007b 4b0c          	push	#12
 668  007d 4b80          	push	#128
 669  007f 4b00          	push	#0
 670  0081 4b00          	push	#0
 671  0083 4b00          	push	#0
 672  0085 aee100        	ldw	x,#57600
 673  0088 89            	pushw	x
 674  0089 ae0000        	ldw	x,#0
 675  008c 89            	pushw	x
 676  008d cd0000        	call	_UART1_Init
 678  0090 5b09          	addw	sp,#9
 679                     ; 125 	UART1_ITConfig(	UART1_IT_RXNE, ENABLE);
 681  0092 4b01          	push	#1
 682  0094 ae0255        	ldw	x,#597
 683  0097 cd0000        	call	_UART1_ITConfig
 685  009a 84            	pop	a
 686                     ; 126 	UART1_Cmd(ENABLE);
 688  009b a601          	ld	a,#1
 689  009d cd0000        	call	_UART1_Cmd
 691                     ; 127 	enableInterrupts();
 694  00a0 9a            rim
 696                     ; 129 	TIM1_SetAutoreload(TIM1STEPSTO1SECOND/200/16/currentRpm); // Установить скорость мотора
 699  00a1 a60a          	ld	a,#10
 700  00a3 cd0000        	call	c_ctof
 702  00a6 ae0004        	ldw	x,#_currentRpm
 703  00a9 cd0000        	call	c_fdiv
 705  00ac cd0000        	call	c_ftoi
 707  00af cd0000        	call	_TIM1_SetAutoreload
 709                     ; 130 	GPIO_WriteReverse(GPIOB, GPIO_PIN_5);
 711  00b2 4b20          	push	#32
 712  00b4 ae5005        	ldw	x,#20485
 713  00b7 cd0000        	call	_GPIO_WriteReverse
 715  00ba 84            	pop	a
 716                     ; 131 	Delay(1000);
 718  00bb ae03e8        	ldw	x,#1000
 719  00be 89            	pushw	x
 720  00bf ae0000        	ldw	x,#0
 721  00c2 89            	pushw	x
 722  00c3 cd0000        	call	_Delay
 724  00c6 5b04          	addw	sp,#4
 725                     ; 132 	GPIO_WriteReverse(GPIOB, GPIO_PIN_5);
 727  00c8 4b20          	push	#32
 728  00ca ae5005        	ldw	x,#20485
 729  00cd cd0000        	call	_GPIO_WriteReverse
 731  00d0 84            	pop	a
 732  00d1               L502:
 733                     ; 134 		if(targetSpeed > 0) targetDir = CW;
 735  00d1 9c            	rvf
 736  00d2 b60a          	ld	a,_targetSpeed
 737  00d4 a100          	cp	a,#0
 738  00d6 2d04          	jrsle	L112
 741  00d8 3f08          	clr	_targetDir
 743  00da 20f5          	jra	L502
 744  00dc               L112:
 745                     ; 135 		else if(targetSpeed < 0) targetDir = CCW;
 747  00dc 9c            	rvf
 748  00dd b60a          	ld	a,_targetSpeed
 749  00df a100          	cp	a,#0
 750  00e1 2eee          	jrsge	L502
 753  00e3 35010008      	mov	_targetDir,#1
 754  00e7 20e8          	jra	L502
 841                     	xdef	_main
 842                     	xdef	_Delay
 843                     	xdef	f_tim2Update
 844                     	xdef	f_tim1Update
 845                     	xdef	f_uartReceive
 846                     	switch	.ubsct
 847  0000               _receive:
 848  0000 00            	ds.b	1
 849                     	xdef	_receive
 850                     	xdef	_uartTransmit
 851                     	xdef	_acc
 852                     	xdef	_currentSpeed
 853                     	xdef	_targetSpeed
 854                     	xdef	_currentDir
 855                     	xdef	_targetDir
 856                     	xdef	_currentRpm
 857                     	xdef	_targetRpm
 858                     	xref	_abs
 859                     	xref	_UART1_ClearITPendingBit
 860                     	xref	_UART1_ReceiveData8
 861                     	xref	_UART1_ITConfig
 862                     	xref	_UART1_Cmd
 863                     	xref	_UART1_Init
 864                     	xref	_UART1_DeInit
 865                     	xref	_TIM2_ClearITPendingBit
 866                     	xref	_TIM2_ITConfig
 867                     	xref	_TIM2_Cmd
 868                     	xref	_TIM2_TimeBaseInit
 869                     	xref	_TIM2_DeInit
 870                     	xref	_TIM1_ClearITPendingBit
 871                     	xref	_TIM1_SetCompare1
 872                     	xref	_TIM1_SetAutoreload
 873                     	xref	_TIM1_ITConfig
 874                     	xref	_TIM1_CtrlPWMOutputs
 875                     	xref	_TIM1_Cmd
 876                     	xref	_TIM1_OC1Init
 877                     	xref	_TIM1_TimeBaseInit
 878                     	xref	_TIM1_DeInit
 879                     	xref	_GPIO_WriteReverse
 880                     	xref	_GPIO_WriteLow
 881                     	xref	_GPIO_WriteHigh
 882                     	xref	_GPIO_Init
 883                     	xref	_CLK_HSIPrescalerConfig
 884                     	xref	_CLK_PeripheralClockConfig
 885                     .const:	section	.text
 886  0000               L311:
 887  0000 42fe0000      	dc.w	17150,0
 888  0004               L301:
 889  0004 40000000      	dc.w	16384,0
 890                     	xref.b	c_lreg
 891                     	xref.b	c_x
 892                     	xref.b	c_y
 912                     	xref	c_lzmp
 913                     	xref	c_lgsbc
 914                     	xref	c_ftoi
 915                     	xref	c_ctof
 916                     	xref	c_fgsub
 917                     	xref	c_fsub
 918                     	xref	c_fgadd
 919                     	xref	c_fcmp
 920                     	xref	c_fadd
 921                     	xref	c_ltor
 922                     	xref	c_rtol
 923                     	xref	c_fdiv
 924                     	xref	c_fmul
 925                     	xref	c_itof
 926                     	end
