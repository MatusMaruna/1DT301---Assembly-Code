;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-05
; Author:
; Student Matus Maruna  
; Student John Charo
;
; Lab number: 1
; Title: Connecting switches with corresponding LEDs
;
; Hardware: STK600, CPU ATmega2560
;
; Function: The program turns on the LED when the corresponding switch below it is pressed on
;
; Input ports: Port A is connected to switches 
;
; Output ports: Port B is connected to the LEDs on the board 
;
; Subroutines: switch_press is a loop that listens for a switch on the board being pressed
; Included files: m2560def.inc
;
; Other information: None. 
;
; Changes in program: None. 
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
 
.include "m2560def.inc"
ldi r16, 0xFF

out 0x04, r16 ; setting portB as ouput 

ldi r16, 0x00

out 0x07, r16 ; setting portC as input 

ldi r16, 0xFF

out 0x05, r16 ; setting values to be output from portB to portC through r16


switch_press:  ; loop to listen to the switches 

in r16, 0x06  ; load in r16 the value from portC

out 0x05, r16 ; output the value of r16 to portB

rjmp switch_press 
