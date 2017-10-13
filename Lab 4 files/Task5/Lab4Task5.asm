;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2015-09-28
; Author:
; Matus Maruna
; John Charo 
;
; Lab number: 4
; Title: Serial Communication with echo using interrupts 
;
; Hardware: STK600, CPU ATmega2560
;
; Function: The function of this program is to display input recieved through serial communication using LEDs and
;           return the input to the console. Using interrupts. 
;
; Input ports: Serial communication, connected to the computer
; Output ports: PORTB is used to ouput to the LEDs
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"
.def temp = r16
.def char = r17


.org 0x00
rjmp start

.org URXC1addr
rjmp readchar


.org 0x72
start: 
ldi temp, LOW(RAMEND)
out SPL, temp 
ldi temp, HIGH(RAMEND)
out SPH, temp 

ldi temp, 0xFF
out DDRB, temp 
ldi temp, 0x55
out PORTB, temp 
; Setting up the interrupt, found in lecture notes. 
ldi temp, 12
sts UBRR1L, temp 
ldi temp, 0b10011000
sts UCSR1B, temp 
sei 

loop: 
nop 
rjmp loop

readchar : 
lds r20, UCSR1A
lds char, UDR1

output: 
com char
out PORTB, char
com char 

echo: 
lds r20, UCSR1A
sts UDR1, char
reti 
