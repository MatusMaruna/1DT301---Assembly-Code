;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2015-09-28
; Author:
; Matus Maruna 
; John Charo 
;
; Lab number: 1
; Title: Serial Communication to LEDs with an Echo 
;
; Hardware: STK600, CPU ATmega2560
;
; Function: The function of this program is to return the character that has been typed in to the console and 
;           recieved by the board. 
;
; Input ports: Serial communication Port 
;
; Output ports: Port B is connected to LEDs.
;
; Subroutines: Same as task 3. Echo will return the saved char back to the comptuer console
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

;This subroutine checks wether a character has been recieved and saves it. 
getchar: 
lds temp, UCSR1A
sbrs temp, RXC1
rjmp getchar
lds char, UDR1
rjmp output 
; This subroutine outputs the character to the LEDs 
output: 
com char
out portB, char
com char
rjmp echo 
;this subroutine returns the input character back to the console. 
echo: 
lds temp, UCSR1A
sbrs temp, UDRE1
rjmp echo 
sts UDR1, char
rjmp getchar 
