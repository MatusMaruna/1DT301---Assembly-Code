;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2015-09-03
; Author:
; Matus Maruna
; John Charo 
; 
;
; Lab number: 2
; Title: Ring counter and Johnson counter 
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Switch between ring counter and johnson counter
;
; Input ports: PORT C is used for the switches
; Output ports: PORT B is used for the LEDS
;
; Subroutines: "ring_counter" encompasses the whole ring counter program.
;              "johnson" encompasses the whole of johnson counter program.
; 				"ring" recieved a minor change that listens for button press and branches to "johnson" 
; 				"johnson_counter" and "back_loop" recieved a minor change that listens for button press and branches to "ring_counter"
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: None
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


.include "m2560def.inc"
ring_counter: 
call DELAY
ldi r16, 0xFF
out 0x04, r16
ldi r26, 0xFF
out 0x05, r26
ldi r26, 0x00
out 0x07, r26

ldi r17, 0b10000000
ldi r16, 0b01111111
ldi r19, 0b00000001
ldi r25, 0b01111111


ldi r20, HIGH(RAMEND) ; R20 = high part of RAMEND address 
out SPH,R20 ; SPH = high part of RAMEND address
ldi R20, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R20 ; SPL = low part of RAMEND address

load:
mov r16,r17 ;move value of r17 to r16
com r16  ;inverse the value of r16 from 01111111 to 1000000
push r16 ; push the value of r16 to the bottom of the stack 
lsr r17  ; move the 1 in r17 to the right by pushing in a 0 
cp r17,r19 ; compare r17 to r19 so it knows when to stop 
breq first ; branch to first when r17 is equal to r19 
rjmp load ; loop back if not 

first: 
mov r16,r17 ;loop that will produce the last value of to be pushed into the stack and the first value to be output 
com r16
push r16
rjmp ring

ring:
ldi r21, 0b11111111 ; HERE we check wether or not the button was pressed down 
in r26, PINC
cp r26,r21
brne johnson ; if the button was pressed then branch into johnson
pop r16 ; pop a value out of the stack and into r16
out PORTB,r16 ; output the value of r16 to portB
cp r16,r25 ; compare r16 to r25 or the last value to be output 
breq reset ; if last value is reached branched to reset 
call DELAY ; if last value is not reached jump to superdelay
rjmp ring

reset: 
ldi r17, 0b10000000 ; resets r17 and r16 to their original values so that the loop can be called again 
ldi r16, 0b01111111
call DELAY
rjmp load


johnson: 
call DELAY
; initilizing the stack, copy pasted from the assignment question
ldi R20, HIGH(RAMEND) ; R20 = high part of RAMEND address
out SPH,R20 ; SPH = high part of RAMEND address
ldi R20, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R20 ; SPL = low part of RAMEND address
;Loading needed values into registers
ldi r16, 0b11111111
ldi r17, 0b00000000

;Ring loop that lights LEDS from 0 to 7 
johnson_counter:
ldi r21, 0b11111111 ; HERE we check wether or not the button was pressed
in r26, PINC
cp r26,r21
brne ring_counter ; if the button was pressed we branch into ring_counter
push r16 ; push the value to stack, saving it for later
cp r16,r17 ; compare r16 to the last value being output which is in r17
BREQ backward ; branch if equal to backward subroutine 
lsl r16 ; pushing in 0 from the right shifting the bits 1 place to the left and removing leftmost bit. 
out portB,r16 ; outputting the value to portB 
call DELAY
rjmp johnson_counter

back_loop: 
ldi r21, 0b11111111 ; HERE we check wether or not the button was pressed
in r26, PINC
cp r26,r21
brne johnson_counter ; if the button was pressed we branch into ring_counter
ldi r19, 0 ; loading a value to reset superdelay_back
cp r16,r20 ; compare r16 to last value to be output and branch if its the last value 
BREQ forward ; 
pop r16 ; pop a value from stack to r16, values previously saved in the front ring loop 
out portB,r16 ; output the value into portB 
call DELAY
rjmp back_loop

backward: ; subroutine that switches and loads the values needed for the loop to go backwards from 7 to 0 
out portB, r16
ldi r16,0b00000000
rjmp back_loop

forward: ; subroutine that switches and loads the values needed for the loop to go forward from 0 to 7 
out portB, r16
ldi r16,0b11111111
rjmp johnson_counter



DELAY:
; Generated by delay loop calculator
; at http://www.bretmulvey.com/avrdelay.html
;
; Delay 500 000 cycles
; 500ms at 1.0 MHz
	push r18
	push r19
	push r20
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
	pop r20
	pop r19
	pop r18
ret
