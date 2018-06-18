;******************** (C) COPYRIGHT 2018 IoTality ********************
;* File Name          : services.s
;* Author             : Gopal
;* Date               : 25-May-2018
;* Description        : Routines to carry out system services
;*                      - Only switches on an LED connected to a port pin
;*                      - These are called from the SVC exception handler
;*						- One function each of the 4 LEDs on PD12-PD15
;*						- A default service handler switches on all LEDs
;*********************************************************************
	
	GET reg_stm32f407xx.inc
		
	AREA	SERVICECODE, CODE, READONLY
	
	
	EXPORT	Service_Call_1
	EXPORT	Service_Call_2
	EXPORT	Service_Call_3
	EXPORT	Service_Call_4
	EXPORT	Service_Call_Default

;*********************************************************************
;All the service calls follow a simple flow
;Load the GPIO-D BSRR register address in R1
;Load value to control the LEDs in R3
;The LED to be switched on needs to be written '1' 
;at the corresponding bit in lower half of BSRR
;The LEDs to be switched off needs to be written '1'
;in the upper half of BSRR
;Store the value back to BSRR
;*********************************************************************

;*********************************************************************
Service_Call_1	FUNCTION
	
	LDR		R1, =GPIOD_BSRR
	LDR		R3, =LED1
	STR		R3, [R1]
	BX	LR
	ENDFUNC
;*********************************************************************

;*********************************************************************
Service_Call_2	FUNCTION
	;EXPORT	Service_Call_2	
	LDR		R1, =GPIOD_BSRR
	LDR		R3, =LED2
	STR		R3, [R1]
	BX	LR
	ENDFUNC
;*********************************************************************

;*********************************************************************
Service_Call_3	FUNCTION
	;EXPORT	Service_Call_3	
	LDR		R1, =GPIOD_BSRR
	LDR		R3, =LED3
	STR		R3, [R1]
	BX	LR
	ENDFUNC
;*********************************************************************

;*********************************************************************
Service_Call_4	FUNCTION
	;EXPORT	Service_Call_4	
	LDR		R1, =GPIOD_BSRR
	LDR		R3, =LED4
	STR		R3, [R1]
	BX	LR
	ENDFUNC
;*********************************************************************

;*********************************************************************
Service_Call_Default	FUNCTION
	;EXPORT	Service_Call_Default	
	LDR		R1, =GPIOD_BSRR
	LDR		R3, =ALL_ON
	STR		R3, [R1]
	BX	LR
	ENDFUNC
;*********************************************************************	
		
	ALIGN 4
LED1		EQU	0xE0001000		;Switch on LED at PD12 and switch off PD13,PD14,PD15
LED2		EQU	0xD0002000		;Switch on LED at PD13 and switch off PD12,PD14,PD15
LED3		EQU	0xB0004000		;Switch on LED at PD14 and switch off PD12,PD13,PD15
LED4		EQU	0x70008000		;Switch on LED at PD15 and switch off PD12,PD13,PD14
ALL_ON		EQU	0x0000F000		;Switch on all LEDs PD12 - PD15
ALL_OFF		EQU	0xF0000000		;Switch off all LEDs PD12 - PD15
	
	END