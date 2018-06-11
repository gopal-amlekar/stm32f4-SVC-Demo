;******************** (C) COPYRIGHT 2018 IoTality ********************
;* File Name          : isr.s
;* Author             : IoTality
;* Date               : 24-May-2018
;* Description        : Exception handler for SVC
;*                      - Executes when SVC instruction is executed from main code
;*                      - SVC parameter is used to switch ON LED on GPIO-D pins PD12 to PD15
;*                      - Parameter 1 to 4 switches on LEDs on PD12-PD15 respectively
;*                      - Any other Parameter switches on all LEDs

;*********************************************************************


	GET reg_stm32f407xx.inc

	AREA	ISRCODE, CODE, READONLY
	

	IMPORT	Service_Call_1
	IMPORT	Service_Call_2
	IMPORT	Service_Call_3
	IMPORT	Service_Call_4
	IMPORT	Service_Call_Default


;*********************************************************************
;* SVC exception handler
;* Redefined here (startup code contains a weak definition)
;* Extracts the parameter passed on in SVC instruction.
;* The parameter is stored in lower byte of SVC encoding
;* and it is retrieved in the following way.

;* Before switching to exception handler execution, the 
;* processor puts a number of registers on stack. This is 
;* called the stacking process. The registers stacked are as below,
;* in the same order as listed.

;* PSR
;* PC (Of the next instruction to be executed)
;* LR
;* R12
;* R3
;* R2
;* R1
;* R0

;* The execption handler first finds out which stack pointer
;* is being used (either MSP or PSP). Then it reads the value
;* of the stack pointer being used.
;* 
;* It then traverses the stack 24 bytes (6 registers R0-R3, R12, LR  
;* on stack with 4 bytes each) to retrieve stacked PC.
;* This stacked PC is the address of next instruction to be executed
;* after the handler returns to application code.
;* 
;* Once it gets the PC, it reads the lower byte of the earlier instruction
;* which is precisely the SVC instruction. The parameter is stored in 
;* lower byte of SVC encoding (Little Endian). Thus we get the SVC parameter
;* in R0 now.
;* 
;* Based on this parameter value, different functions are called from the
;* file services.s. This is quite straightforward as it compares the parameter
;* to a value between 1 to 4. If the value is other than these 4 values,
;* a default handler is called.
;*********************************************************************

SVC_Handler PROC
	EXPORT  SVC_Handler

; Extract the SVC parameter
	TST		LR, #4
	MRSEQ	R0, MSP
	MRSNE	R0, PSP
	
	LDR		R0, [R0, #24]
	LDRB	R0, [R0, #-2]
	
	CMP		R0, #01
	LDREQ	R1, =Service_Call_1
	BEQ		Done
	
	CMP		R0, #02
	LDREQ	R1, =Service_Call_2
	BEQ		Done
	
	CMP		R0, #03
	LDREQ	R1, =Service_Call_3
	BEQ		Done
	
	CMP		R0, #04
	LDREQ	R1, =Service_Call_4
	BEQ		Done

	LDR		R1, =Service_Call_Default
	
Done	
	PUSH 	{LR}
	BLX		R1
	POP		{PC}
	
	
	ENDP
	
	
	
	
	END
