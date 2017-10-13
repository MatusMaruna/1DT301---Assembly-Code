;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-05
; Author:
; Student Matus Maruna  
; Student John Charo 
;
; Lab number: 1
; Title: Switch 5 turns on LED0
;
; Hardware: STK600, CPU ATmega2560
;
; Function: The function of this program is to turn on the LED0 when switch 5 is pressed. All other switches are ignored
;
; Input ports: Port A is connected to switches 
;
; Output ports: Port B is connected to the LEDs on the board 
;
; Subroutines: switch_press5 is a loop that listens for a switch on the board that corresponds to switch number 5 being pressed
;              true is an outcome that turns on the first LED when the conditions inside switch_press5 are satisfied 

; Included files: m2560def.inc
;
; Other information: None. 
;
; Changes in program: None. 
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 

.include "m2560def.inc"

ldi r16, 0xFF

out 0x04, r16

ldi r16, 0x00

out 0x07, r16

ldi r16, 0xFF

out 0x05, r16

ldi r17,0b11011111 ; desired value for the switch press

ldi r18,0b11111110 ; desired value for the LED output

switch_press5: ; loop to listen to the switch press

in r16, 0x06 ; input the value from PortC which is connected to switches into r15

cp r16,r17 ; compare input with the desired input

breq true ;branch if equal to "true"

rjmp switch_press5

true: out 0x05,r18 ; output the desired output to portB

