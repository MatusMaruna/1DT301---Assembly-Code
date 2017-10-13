;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2015-09-03
; Author:
; Matus Maruna
; John Charo 
;
; Lab number: 3
; Title: Turning on LED usig interrupt
;
; Hardware: STK600, CPU ATmega2560
;
; Function: When switch number 1 is pressed. An interrupt is activated and all of the LEDs light up
;
; Input ports: Port D is used for switches
;
; Output ports: Port B is used for LEDs
;
; Subroutines: "start" is an initilizing subroutine. "switch_wait" is a subroutine that does nothing and loops through waiting for interrupt. 
;              "interrupt_0" is the subroutine called when the interrupt has been triggered and will light all LEDs and call a delay.
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.org 0x00
rjmp start
;adding a handler for interrupt
.org INT0addr
rjmp interrupt_0

.org 0x72

start:
; initilization
ldi r16, 0xFF
out DDRB, r16
ldi r16, 0x00
out DDRD, r16
ldi r16, 0xFF
out PORTB, r16
mov r17,r16 
ldi r20, HIGH(RAMEND) ; R20 = high part of RAMEND address 
out SPH,R20 ; SPH = high part of RAMEND address
ldi R20, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R20 ; SPL = low part of RAMEND address
; setting up the interrupt. Switch 0 for interrupt 0 on button press down
ldi r16, 0b00000001
out EIMSK, r16
ldi r16, 0b00000010
sts EICRA, r16
; enable interrupts 
sei 
; waiting loop 
switch_wait: 
nop
rjmp switch_wait
; interrupt handler subroutine
interrupt_0: 
call DELAY
com r17
out portB, r17
reti 
; delay
DELAY: 
	push r18
	push r19
    ldi  r18, 65
    ldi  r19, 239
L1: dec  r19
    brne L1
    dec  r18
    brne L1
	pop r19
	pop r18
ret
