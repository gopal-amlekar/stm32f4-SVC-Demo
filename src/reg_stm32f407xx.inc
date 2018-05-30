
; ******* Register definitions *******

;As per STM32F407 datasheet and reference manual

RCC_AHB1ENR		EQU	0x40023830	;Clock control for AHB1 peripherals (includes GPIO)

;GPIO-D control registers
GPIOD_MODER		EQU	0x40020C00	;set GPIO pin mode as Input/Output/Analog
GPIOD_OTYPER	EQU	0x40020C04	;Set GPIO pin type as push-pull or open drain
GPIOD_OSPEEDR	EQU 0x40020C08	;Set GPIO pin switching speed
GPIOD_PUPDR		EQU	0x40020C0C	;Set GPIO pin pull-up/pull-down
GPIOD_ODR		EQU	0x40020C14	;GPIO pin output data

GPIOD_BSRR		EQU	0x40020C18

SYSTICK_CSR		EQU	0xE000E010
SYSTICK_RVR	    EQU	0xE000E014
	
	

EXTI_IMR		EQU	0x40013C00
EXTI_RTSR		EQU	0x40013C08
	
SYSCFG_EXTICR1	EQU	0x40013808		

; **************************


	END