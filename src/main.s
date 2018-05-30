;******************** (C) COPYRIGHT 2018 IoTality ********************
;* File Name          : main.s
;* Author             : Gopal
;* Date               : 25-May-2018
;* Description        : Main code to demonstrate SVC exception
;*                      - Executes 5 SVC instructions each time with a 
;*                      - different parameter (1, 2, 3, 4 and then 0xFF)
;*						- SVC handler in isr.s gets executed each time
;*						- SVC instrucion is executed
;*						- Since there is no delay between successive SVC
;*						- instructions, it is best to execute this code
;*						- in debug mode with breakpoints at each SVC call
;*						- After every SVC instruction, you should see the
;*						- corresponding LED switched on (PD12-PD15 for 
;*						- parameters 1 to 4 respectively and all LEDs switched
;*						- for any other parameter (including 0xFF)
;*********************************************************************
	GET reg_stm32f407xx.inc

; Export functions so they can be called from other file

	EXPORT SystemInit
	EXPORT __main

	AREA	MYCODE, CODE, READONLY
		
; ******* Function SystemInit *******
; * Called from startup code
; * Calls - None
; * Enables GPIO clock 
; * Configures GPIO-D Pins 12 to 15 as:
; ** Output
; ** Push-pull (Default configuration)
; ** High speed
; ** Pull-up enabled
; **************************

SystemInit FUNCTION

	; Enable GPIO clock
	LDR		R1, =RCC_AHB1ENR	;Pseudo-load address in R1
	LDR		R0, [R1]			;Copy contents at address in R1 to R0
	ORR.W 	R0, #0x08			;Bitwise OR entire word in R0, result in R0
	STR		R0, [R1]			;Store R0 contents to address in R1

	; Set mode as output
	LDR		R1, =GPIOD_MODER	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]			
	ORR.W 	R0, #0x55000000		;Mode bits set to '01' makes the pin mode as output
	AND.W	R0, #0x55FFFFFF		;OR and AND both operations reqd for 2 bits
	STR		R0, [R1]

	; Set type as push-pull	(Default)
	LDR		R1, =GPIOD_OTYPER	;Type bit '0' configures pin for push-pull
	LDR		R0, [R1]
	AND.W 	R0, #0xFFFF0FFF	
	STR		R0, [R1]
	
	; Set Speed slow
	LDR		R1, =GPIOD_OSPEEDR	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	AND.W 	R0, #0x00FFFFFF		;Speed bits set to '00' configures pin for slow speed
	STR		R0, [R1]	
	
	; Set pull-up
	LDR		R1, =GPIOD_PUPDR	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	AND.W	R0, #0x00FFFFFF		;Clear bits to disable pullup/pulldown
	STR		R0, [R1]

	BX		LR					;Return from function
	
	ENDFUNC
	

; ******* Function main *******
;* Called from startup code after SystemInit
;* Never returns. 
;* Executes SVC instructions with 5 different parameters
;* See the comment block at top of this file for details
;* Add breakpoints on each line of SVC and execute code
;* in debug mode.
; **************************

__main FUNCTION
	
	SVC	#0x01
	SVC	#0x02
	SVC	#0x03
	SVC	#0x04
	SVC	#0xFF
	B	.

	ENDFUNC
	
	
	END
