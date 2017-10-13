;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2015-09-03
; Author:
;	Matus Maruna
; 	John Charo 
; Lab number: 2
; Title: Button press counter 
;
; Hardware: STK600, CPU ATmega2560
;
; Function: A counter that will count the amount of changes in position 
;           of a button. 
;
; Input ports: PORT C buttons
;
; Output ports: PORTB LEDs
;
; Subroutines: "switch_press" is listening for a switch press on the board.Branching to "change_down" if
;              switch is pressed. 
;              "change_down" outputs the value and jumps to "switch_release" loop.
;              "switch_release" is listening for switch release on the board. Branching to "change_up" if 
;              switch is pressed. 
;              "change_up" outputs the value and jumps to "switch_press" loop. 
;
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"
;inilizing output 
ldi r16, 0xFF
out DDRB, r16
ldi r18, 0x00
out DDRC, r18
ldi r16, 0xFF
out PORTB, r16

;initlizing values 
ldi r16, 0 
ldi r18, 0x00
ldi r19, 0b11111110
ldi r17, 0x00
ldi r20, 0b11111111
; listening for button press
switch_press: 
in r18, PINC
cp r18, r19
breq change_down
rjmp switch_press
; output value when switch is pressed down 
change_down:
inc r17 ; increment counter
com r17 
out portB, r17
com r17
rjmp switch_release
; output value when the switch is released 
change_up:
inc r17
com r17
out portB,r17
com r17
rjmp switch_press
; listening for switch release 
switch_release:
in r18, PINC
cp r18, r20
breq change_up
rjmp switch_release
