;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-05
; Author:
; Student Matus Maruna  
; Student John Charo
;
; Lab number: 1
; Title: Lighting LED number 2 
;
; Hardware: STK600, CPU ATmega2560
;
; Function: The function of this program is that it turns on LED2 on the board 
;
; Input ports: None. The input was written in the program. 
;
; Output ports: Port B is connected to the LEDs on the board 
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: None. 
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 

.include "m2560def.inc"
ldi r16, 0xFF
out 0x04, r16 ; setting PORTB as output 

ldi r16, 0b11111011 ; loading the value to be output to PORTB in order to turn on the second LED

out 0x05, r16 ; outputting the value to PORTB 
