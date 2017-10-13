;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2015-09-28
; Author:
; Matus Maruna
; John Charo 
;
; Lab number: 1
; Title: Serial Communication with LEDs
;
; Hardware: STK600, CPU ATmega2560
;
; Function: LEDs will display the binary equivilent of the letter or number written on a computer that is connected to the
;           board. 
;
; Input ports: Serial communication port to PC
;
; Output ports:PORTB to LEDs
;
; Subroutines: getchar will constantly cycle checking if a new character has been recieved. 
;              it will save the character and then output it to the LEDs in "output".
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

.org 0x72 
start: 
ldi temp, 0x55
out DDRB, temp 
ldi temp, 0x55
out portb, temp 

ldi temp, 12
sts UBRR1L, temp 

ldi temp, (1<<TXEN1) | (1<<RXEN1) 
sts UCSR1B, temp 

;this loop will check wether a character has been recieved. 
getchar: 
lds temp, UCSR1A
sbrs temp, RXC1
rjmp getchar
lds char, UDR1
rjmp output 
; This loop will display the character on the board. 
output: 
com char
out portB, char
com char
rjmp getchar
