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
  71                     ; 26 void uartTransmit(uint8_t data){
  73                     .text:	section	.text,new
  74  0000               _uartTransmit:
  78                     ; 28 	UART1->DR = data;
  80  0000 c75231        	ld	21041,a
  81                     ; 29 }
  84  0003 81            	ret
 112                     ; 32 @far @interrupt void uartReceive(void)	{
 114                     .text:	section	.text,new
 115  0000               f_uartReceive:
 117  0000 8a            	push	cc
 118  0001 84            	pop	a
 119  0002 a4bf          	and	a,#191
 120  0004 88            	push	a
 121  0005 86            	pop	cc
 122  0006 3b0002        	push	c_x+2
 123  0009 be00          	ldw	x,c_x
 124  000b 89            	pushw	x
 125  000c 3b0002        	push	c_y+2
 126  000f be00          	ldw	x,c_y
 127  0011 89            	pushw	x
 130                     ; 33 	UART1_ClearITPendingBit(UART1_IT_RXNE);
 132  0012 ae0255        	ldw	x,#597
 133  0015 cd0000        	call	_UART1_ClearITPendingBit
 135                     ; 34 	receive=UART1_ReceiveData8();
 137  0018 cd0000        	call	_UART1_ReceiveData8
 139  001b b702          	ld	_receive,a
 140                     ; 35 	targetSpeed = receive;
 142  001d 45020a        	mov	_targetSpeed,_receive
 143                     ; 54 	uartTransmit(receive);
 146  0020 b602          	ld	a,_receive
 147  0022 cd0000        	call	_uartTransmit
 149                     ; 55 }
 152  0025 85            	popw	x
 153  0026 bf00          	ldw	c_y,x
 154  0028 320002        	pop	c_y+2
 155  002b 85            	popw	x
 156  002c bf00          	ldw	c_x,x
 157  002e 320002        	pop	c_x+2
 158  0031 80            	iret
 181                     ; 57 @far @interrupt void tim1Update(void)	{
 182                     .text:	section	.text,new
 183  0000               f_tim1Update:
 185  0000 8a            	push	cc
 186  0001 84            	pop	a
 187  0002 a4bf          	and	a,#191
 188  0004 88            	push	a
 189  0005 86            	pop	cc
 190  0006 3b0002        	push	c_x+2
 191  0009 be00          	ldw	x,c_x
 192  000b 89            	pushw	x
 193  000c 3b0002        	push	c_y+2
 194  000f be00          	ldw	x,c_y
 195  0011 89            	pushw	x
 198                     ; 58 	TIM1_ClearITPendingBit(TIM1_IT_UPDATE);
 200  0012 a601          	ld	a,#1
 201  0014 cd0000        	call	_TIM1_ClearITPendingBit
 203                     ; 60 }
 206  0017 85            	popw	x
 207  0018 bf00          	ldw	c_y,x
 208  001a 320002        	pop	c_y+2
 209  001d 85            	popw	x
 210  001e bf00          	ldw	c_x,x
 211  0020 320002        	pop	c_x+2
 212  0023 80            	iret
 245                     ; 63 @far @interrupt void tim2Update(void)	{
 246                     .text:	section	.text,new
 247  0000               f_tim2Update:
 249  0000 8a            	push	cc
 250  0001 84            	pop	a
 251  0002 a4bf          	and	a,#191
 252  0004 88            	push	a
 253  0005 86            	pop	cc
 254  0006 3b0002        	push	c_x+2
 255  0009 be00          	ldw	x,c_x
 256  000b 89            	pushw	x
 257  000c 3b0002        	push	c_y+2
 258  000f be00          	ldw	x,c_y
 259  0011 89            	pushw	x
 260  0012 be02          	ldw	x,c_lreg+2
 261  0014 89            	pushw	x
 262  0015 be00          	ldw	x,c_lreg
 263  0017 89            	pushw	x
 266                     ; 64 	TIM2_ClearITPendingBit(TIM2_IT_UPDATE);
 268  0018 a601          	ld	a,#1
 269  001a cd0000        	call	_TIM2_ClearITPendingBit
 271                     ; 65 	GPIO_WriteReverse(GPIOB, GPIO_PIN_5);
 273  001d 4b20          	push	#32
 274  001f ae5005        	ldw	x,#20485
 275  0022 cd0000        	call	_GPIO_WriteReverse
 277  0025 84            	pop	a
 278                     ; 67 	targetRpm = (float)abs(targetSpeed)*MAXRPM/127;
 280  0026 5f            	clrw	x
 281  0027 b60a          	ld	a,_targetSpeed
 282  0029 2a01          	jrpl	L41
 283  002b 53            	cplw	x
 284  002c               L41:
 285  002c 97            	ld	xl,a
 286  002d cd0000        	call	_abs
 288  0030 cd0000        	call	c_itof
 290  0033 ae0008        	ldw	x,#L301
 291  0036 cd0000        	call	c_fmul
 293  0039 ae0004        	ldw	x,#L311
 294  003c cd0000        	call	c_fdiv
 296  003f ae0000        	ldw	x,#_targetRpm
 297  0042 cd0000        	call	c_rtol
 299                     ; 68 	if(targetSpeed > 0) GPIO_WriteHigh(GPIOC, GPIO_PIN_5);
 301  0045 9c            	rvf
 302  0046 b60a          	ld	a,_targetSpeed
 303  0048 a100          	cp	a,#0
 304  004a 2d0b          	jrsle	L711
 307  004c 4b20          	push	#32
 308  004e ae500a        	ldw	x,#20490
 309  0051 cd0000        	call	_GPIO_WriteHigh
 311  0054 84            	pop	a
 313  0055 2010          	jra	L121
 314  0057               L711:
 315                     ; 69 	else if(targetSpeed < 0) GPIO_WriteLow(GPIOC, GPIO_PIN_5);
 317  0057 9c            	rvf
 318  0058 b60a          	ld	a,_targetSpeed
 319  005a a100          	cp	a,#0
 320  005c 2e09          	jrsge	L121
 323  005e 4b20          	push	#32
 324  0060 ae500a        	ldw	x,#20490
 325  0063 cd0000        	call	_GPIO_WriteLow
 327  0066 84            	pop	a
 328  0067               L121:
 329                     ; 70 	if(currentRpm + acc <= targetRpm) currentRpm += acc;
 331  0067 9c            	rvf
 332  0068 ae0004        	ldw	x,#_currentRpm
 333  006b cd0000        	call	c_ltor
 335  006e ae000c        	ldw	x,#_acc
 336  0071 cd0000        	call	c_fadd
 338  0074 ae0000        	ldw	x,#_targetRpm
 339  0077 cd0000        	call	c_fcmp
 341  007a 2c0e          	jrsgt	L521
 344  007c ae000c        	ldw	x,#_acc
 345  007f cd0000        	call	c_ltor
 347  0082 ae0004        	ldw	x,#_currentRpm
 348  0085 cd0000        	call	c_fgadd
 351  0088 2021          	jra	L721
 352  008a               L521:
 353                     ; 71 	else if(currentRpm - acc >= targetRpm) currentRpm -= acc;
 355  008a 9c            	rvf
 356  008b ae0004        	ldw	x,#_currentRpm
 357  008e cd0000        	call	c_ltor
 359  0091 ae000c        	ldw	x,#_acc
 360  0094 cd0000        	call	c_fsub
 362  0097 ae0000        	ldw	x,#_targetRpm
 363  009a cd0000        	call	c_fcmp
 365  009d 2f0c          	jrslt	L721
 368  009f ae000c        	ldw	x,#_acc
 369  00a2 cd0000        	call	c_ltor
 371  00a5 ae0004        	ldw	x,#_currentRpm
 372  00a8 cd0000        	call	c_fgsub
 374  00ab               L721:
 375                     ; 73 	if(-MINRPM < currentRpm < MINRPM) {
 377  00ab 9c            	rvf
 378  00ac 9c            	rvf
 379  00ad ae0004        	ldw	x,#_currentRpm
 380  00b0 cd0000        	call	c_ltor
 382  00b3 ae0000        	ldw	x,#L141
 383  00b6 cd0000        	call	c_fcmp
 385  00b9 2d05          	jrsle	L61
 386  00bb ae0001        	ldw	x,#1
 387  00be 2001          	jra	L02
 388  00c0               L61:
 389  00c0 5f            	clrw	x
 390  00c1               L02:
 391  00c1 cd0000        	call	c_itof
 393  00c4 ae000c        	ldw	x,#L151
 394  00c7 cd0000        	call	c_fcmp
 396  00ca 2e06          	jrsge	L331
 397                     ; 74 		TIM1_CtrlPWMOutputs(DISABLE); 
 399  00cc 4f            	clr	a
 400  00cd cd0000        	call	_TIM1_CtrlPWMOutputs
 403  00d0 2016          	jra	L551
 404  00d2               L331:
 405                     ; 77 		TIM1_SetAutoreload(TIM1STEPSTO1SECOND/200/16/currentRpm); // ”становить скорость мотора
 407  00d2 a60a          	ld	a,#10
 408  00d4 cd0000        	call	c_ctof
 410  00d7 ae0004        	ldw	x,#_currentRpm
 411  00da cd0000        	call	c_fdiv
 413  00dd cd0000        	call	c_ftoi
 415  00e0 cd0000        	call	_TIM1_SetAutoreload
 417                     ; 78 		TIM1_CtrlPWMOutputs(ENABLE); 
 419  00e3 a601          	ld	a,#1
 420  00e5 cd0000        	call	_TIM1_CtrlPWMOutputs
 422  00e8               L551:
 423                     ; 80 }
 426  00e8 85            	popw	x
 427  00e9 bf00          	ldw	c_lreg,x
 428  00eb 85            	popw	x
 429  00ec bf02          	ldw	c_lreg+2,x
 430  00ee 85            	popw	x
 431  00ef bf00          	ldw	c_y,x
 432  00f1 320002        	pop	c_y+2
 433  00f4 85            	popw	x
 434  00f5 bf00          	ldw	c_x,x
 435  00f7 320002        	pop	c_x+2
 436  00fa 80            	iret
 478                     ; 82 void Delay(uint32_t t)	{
 480                     .text:	section	.text,new
 481  0000               _Delay:
 483  0000 89            	pushw	x
 484       00000002      OFST:	set	2
 487  0001 2019          	jra	L302
 488  0003               L102:
 489                     ; 85 		t--;
 491  0003 96            	ldw	x,sp
 492  0004 1c0005        	addw	x,#OFST+3
 493  0007 a601          	ld	a,#1
 494  0009 cd0000        	call	c_lgsbc
 496                     ; 86 		for(i=1000;i>0;i--);
 498  000c ae03e8        	ldw	x,#1000
 499  000f 1f01          	ldw	(OFST-1,sp),x
 500  0011               L702:
 504  0011 1e01          	ldw	x,(OFST-1,sp)
 505  0013 1d0001        	subw	x,#1
 506  0016 1f01          	ldw	(OFST-1,sp),x
 509  0018 1e01          	ldw	x,(OFST-1,sp)
 510  001a 26f5          	jrne	L702
 511  001c               L302:
 512                     ; 84 	while(t>0) {
 514  001c 96            	ldw	x,sp
 515  001d 1c0005        	addw	x,#OFST+3
 516  0020 cd0000        	call	c_lzmp
 518  0023 26de          	jrne	L102
 519                     ; 88 }
 522  0025 85            	popw	x
 523  0026 81            	ret
 570                     ; 90 main()
 570                     ; 91 {
 571                     .text:	section	.text,new
 572  0000               _main:
 576                     ; 92 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1|CLK_PRESCALER_CPUDIV1);
 578  0000 a680          	ld	a,#128
 579  0002 cd0000        	call	_CLK_HSIPrescalerConfig
 581                     ; 93 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
 583  0005 ae0701        	ldw	x,#1793
 584  0008 cd0000        	call	_CLK_PeripheralClockConfig
 586                     ; 94 	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
 588  000b 4bf0          	push	#240
 589  000d 4b20          	push	#32
 590  000f ae5005        	ldw	x,#20485
 591  0012 cd0000        	call	_GPIO_Init
 593  0015 85            	popw	x
 594                     ; 95 	GPIO_Init(GPIOC, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
 596  0016 4bf0          	push	#240
 597  0018 4b20          	push	#32
 598  001a ae500a        	ldw	x,#20490
 599  001d cd0000        	call	_GPIO_Init
 601  0020 85            	popw	x
 602                     ; 96 	TIM1_DeInit();
 604  0021 cd0000        	call	_TIM1_DeInit
 606                     ; 97 	TIM1_TimeBaseInit(	16000000/TIM1STEPSTO1SECOND,
 606                     ; 98 											TIM1_COUNTERMODE_UP,
 606                     ; 99 											32000,
 606                     ; 100 											0);
 608  0024 4b00          	push	#0
 609  0026 ae7d00        	ldw	x,#32000
 610  0029 89            	pushw	x
 611  002a 4b00          	push	#0
 612  002c ae01f4        	ldw	x,#500
 613  002f cd0000        	call	_TIM1_TimeBaseInit
 615  0032 5b04          	addw	sp,#4
 616                     ; 101 	TIM1_ARRPreloadConfig(ENABLE); // «агружать новое значение Autoreload при событии обновлени€, а не сразу
 618  0034 a601          	ld	a,#1
 619  0036 cd0000        	call	_TIM1_ARRPreloadConfig
 621                     ; 106 	TIM1_OC1Init(	TIM1_OCMODE_PWM1,
 621                     ; 107 								TIM1_OUTPUTSTATE_ENABLE,
 621                     ; 108 								TIM1_OUTPUTNSTATE_ENABLE,
 621                     ; 109 								200,
 621                     ; 110 								TIM1_OCPOLARITY_LOW,
 621                     ; 111 								TIM1_OCNPOLARITY_HIGH,
 621                     ; 112 								TIM1_OCIDLESTATE_RESET,
 621                     ; 113 								TIM1_OCNIDLESTATE_RESET);
 623  0039 4b00          	push	#0
 624  003b 4b00          	push	#0
 625  003d 4b00          	push	#0
 626  003f 4b22          	push	#34
 627  0041 ae00c8        	ldw	x,#200
 628  0044 89            	pushw	x
 629  0045 4b44          	push	#68
 630  0047 ae6011        	ldw	x,#24593
 631  004a cd0000        	call	_TIM1_OC1Init
 633  004d 5b07          	addw	sp,#7
 634                     ; 114 	TIM1_SetCompare1(1);
 636  004f ae0001        	ldw	x,#1
 637  0052 cd0000        	call	_TIM1_SetCompare1
 639                     ; 115 	TIM1_ITConfig(TIM1_IT_UPDATE, ENABLE);
 641  0055 ae0101        	ldw	x,#257
 642  0058 cd0000        	call	_TIM1_ITConfig
 644                     ; 116 	TIM1_CtrlPWMOutputs(ENABLE); 
 646  005b a601          	ld	a,#1
 647  005d cd0000        	call	_TIM1_CtrlPWMOutputs
 649                     ; 117 	TIM1_Cmd(ENABLE);
 651  0060 a601          	ld	a,#1
 652  0062 cd0000        	call	_TIM1_Cmd
 654                     ; 118 	TIM2_DeInit();
 656  0065 cd0000        	call	_TIM2_DeInit
 658                     ; 119 	TIM2_TimeBaseInit(	TIM2_PRESCALER_1024, // 16MHz / 1024 = base frequency
 658                     ; 120 											15625/BASEPROGRAMFREQUENCY);
 660  0068 ae030d        	ldw	x,#781
 661  006b 89            	pushw	x
 662  006c a60a          	ld	a,#10
 663  006e cd0000        	call	_TIM2_TimeBaseInit
 665  0071 85            	popw	x
 666                     ; 121 	TIM2_ITConfig(TIM2_IT_UPDATE,ENABLE);
 668  0072 ae0101        	ldw	x,#257
 669  0075 cd0000        	call	_TIM2_ITConfig
 671                     ; 122 	TIM2_Cmd(ENABLE);
 673  0078 a601          	ld	a,#1
 674  007a cd0000        	call	_TIM2_Cmd
 676                     ; 123 	UART1_DeInit();
 678  007d cd0000        	call	_UART1_DeInit
 680                     ; 124 	UART1_Init(	57600,
 680                     ; 125 							UART1_WORDLENGTH_8D,
 680                     ; 126 							UART1_STOPBITS_1,
 680                     ; 127 							UART1_PARITY_NO,
 680                     ; 128 							UART1_SYNCMODE_CLOCK_DISABLE,
 680                     ; 129 							UART1_MODE_TXRX_ENABLE);
 682  0080 4b0c          	push	#12
 683  0082 4b80          	push	#128
 684  0084 4b00          	push	#0
 685  0086 4b00          	push	#0
 686  0088 4b00          	push	#0
 687  008a aee100        	ldw	x,#57600
 688  008d 89            	pushw	x
 689  008e ae0000        	ldw	x,#0
 690  0091 89            	pushw	x
 691  0092 cd0000        	call	_UART1_Init
 693  0095 5b09          	addw	sp,#9
 694                     ; 130 	UART1_ITConfig(	UART1_IT_RXNE, ENABLE);
 696  0097 4b01          	push	#1
 697  0099 ae0255        	ldw	x,#597
 698  009c cd0000        	call	_UART1_ITConfig
 700  009f 84            	pop	a
 701                     ; 131 	UART1_Cmd(ENABLE);
 703  00a0 a601          	ld	a,#1
 704  00a2 cd0000        	call	_UART1_Cmd
 706                     ; 132 	enableInterrupts();
 709  00a5 9a            rim
 711                     ; 134 	TIM1_SetAutoreload(TIM1STEPSTO1SECOND/200/16/currentRpm); // ”становить скорость мотора
 714  00a6 a60a          	ld	a,#10
 715  00a8 cd0000        	call	c_ctof
 717  00ab ae0004        	ldw	x,#_currentRpm
 718  00ae cd0000        	call	c_fdiv
 720  00b1 cd0000        	call	c_ftoi
 722  00b4 cd0000        	call	_TIM1_SetAutoreload
 724                     ; 136 	GPIO_WriteReverse(GPIOB, GPIO_PIN_5);
 726  00b7 4b20          	push	#32
 727  00b9 ae5005        	ldw	x,#20485
 728  00bc cd0000        	call	_GPIO_WriteReverse
 730  00bf 84            	pop	a
 731                     ; 137 	Delay(1000);
 733  00c0 ae03e8        	ldw	x,#1000
 734  00c3 89            	pushw	x
 735  00c4 ae0000        	ldw	x,#0
 736  00c7 89            	pushw	x
 737  00c8 cd0000        	call	_Delay
 739  00cb 5b04          	addw	sp,#4
 740                     ; 138 	GPIO_WriteReverse(GPIOB, GPIO_PIN_5);
 742  00cd 4b20          	push	#32
 743  00cf ae5005        	ldw	x,#20485
 744  00d2 cd0000        	call	_GPIO_WriteReverse
 746  00d5 84            	pop	a
 747  00d6               L522:
 749  00d6 20fe          	jra	L522
 845                     	xdef	_main
 846                     	xdef	_Delay
 847                     	xdef	f_tim2Update
 848                     	switch	.ubsct
 849  0000               _timerReload:
 850  0000 0000          	ds.b	2
 851                     	xdef	_timerReload
 852                     	xdef	f_tim1Update
 853                     	xdef	f_uartReceive
 854  0002               _receive:
 855  0002 00            	ds.b	1
 856                     	xdef	_receive
 857                     	xdef	_uartTransmit
 858                     	xdef	_acc
 859                     	xdef	_currentSpeed
 860                     	xdef	_targetSpeed
 861                     	xdef	_currentDir
 862                     	xdef	_targetDir
 863                     	xdef	_currentRpm
 864                     	xdef	_targetRpm
 865                     	xref	_abs
 866                     	xref	_UART1_ClearITPendingBit
 867                     	xref	_UART1_ReceiveData8
 868                     	xref	_UART1_ITConfig
 869                     	xref	_UART1_Cmd
 870                     	xref	_UART1_Init
 871                     	xref	_UART1_DeInit
 872                     	xref	_TIM2_ClearITPendingBit
 873                     	xref	_TIM2_ITConfig
 874                     	xref	_TIM2_Cmd
 875                     	xref	_TIM2_TimeBaseInit
 876                     	xref	_TIM2_DeInit
 877                     	xref	_TIM1_ClearITPendingBit
 878                     	xref	_TIM1_SetCompare1
 879                     	xref	_TIM1_SetAutoreload
 880                     	xref	_TIM1_ARRPreloadConfig
 881                     	xref	_TIM1_ITConfig
 882                     	xref	_TIM1_CtrlPWMOutputs
 883                     	xref	_TIM1_Cmd
 884                     	xref	_TIM1_OC1Init
 885                     	xref	_TIM1_TimeBaseInit
 886                     	xref	_TIM1_DeInit
 887                     	xref	_GPIO_WriteReverse
 888                     	xref	_GPIO_WriteLow
 889                     	xref	_GPIO_WriteHigh
 890                     	xref	_GPIO_Init
 891                     	xref	_CLK_HSIPrescalerConfig
 892                     	xref	_CLK_PeripheralClockConfig
 893                     .const:	section	.text
 894  0000               L141:
 895  0000 bc23d70a      	dc.w	-17373,-10486
 896  0004               L311:
 897  0004 42fe0000      	dc.w	17150,0
 898  0008               L301:
 899  0008 40000000      	dc.w	16384,0
 900  000c               L151:
 901  000c 3c23d70a      	dc.w	15395,-10486
 902                     	xref.b	c_lreg
 903                     	xref.b	c_x
 904                     	xref.b	c_y
 924                     	xref	c_lzmp
 925                     	xref	c_lgsbc
 926                     	xref	c_ftoi
 927                     	xref	c_ctof
 928                     	xref	c_fgsub
 929                     	xref	c_fsub
 930                     	xref	c_fgadd
 931                     	xref	c_fcmp
 932                     	xref	c_fadd
 933                     	xref	c_ltor
 934                     	xref	c_rtol
 935                     	xref	c_fdiv
 936                     	xref	c_fmul
 937                     	xref	c_itof
 938                     	end
