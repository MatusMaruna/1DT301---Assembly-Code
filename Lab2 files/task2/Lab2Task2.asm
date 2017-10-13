;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2015-09-03
; Author:
; Matus Maruna
; John Charo
;
; Lab number: 2
; Title: Dice roll 
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Program will roll a dice when the button is pressed 
;
; Input ports: PORTD for switches
;
; Output ports: PORTB for LEDS
;
; Subroutines:  "listen_switch" listens for a switch press branching to "roll_dice" 
;               "roll_dice" cycles through values and listens for the switch release
;               "value" outputs the value of the dice when switch is released
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program:
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"
;inilizing output 
ldi r16, 0xFF
out DDRB, r16
ldi r18, 0x00
out DDRC, r18
ldi r16, 0xFF
out PORTB, r16

ldi r16, 0x00
ldi r17, 0b11111110
ldi r18, 0x00

ldi r20, HIGH(RAMEND) ; R20 = high part of RAMEND address 
out SPH,R20 ; SPH = high part of RAMEND address
ldi R20, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R20 ; SPL = low part of RAMEND address
; listening loop for a switch 
listen_switch: 
in r18, PINC
cp r18,r17
breq roll_dice
rjmp listen_switch
; subroutine that outputs the value
value:
out portB, r16
call delay
rjmp listen_switch

delay: 
; Generated by delay loop calculator
; at http://www.bretmulvey.com/avrdelay.html
;
; Delay 500 000 cycles
; 500ms at 1.0 MHz
	push r18
    ldi  r18, 3
    ldi  r19, 138
    ldi  r20, 86
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1
	pop r18

ret



; delay that cycles through the values and branches when button is no longer being pressed
roll_dice: 

ldi r16, 0b00010001
in r18, PINC ;checking if the switch is still being pressed
cp r18,r17
brne value

ldi r16, 0b00101001
in r18, PINC
cp r18,r17
brne value

ldi r16, 0b00111001
in r18, PINC
cp r18,r17
brne value

ldi r16, 0b10101011
in r18, PINC
cp r18,r17
brne value

ldi r16, 0b10111011
in r18, PINC
cp r18,r17
brne value

ldi r16, 0b11101111
in r18, PINC
cp r18,r17
brne value
rjmp roll_dice 