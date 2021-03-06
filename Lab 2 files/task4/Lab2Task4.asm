;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-05
; Author:
; Student Matus Maruna  
; Student John Charo 
;
; Lab number: 2
; Title: Infinite Ring counter with variable delay 
;
; Hardware: STK600, CPU ATmega2560
;
; Function: The function of this program is to turn on the LEDs in sequence by their order on the board
;           otherwise refered to as a johnson counter and implement variable delay 
;
; Input ports: None. 
;
; Output ports: Port B is connected to the LEDs on the board 
;
; Subroutines: "load" is an initializing sequence that loads the values needed to be output to PortB into a stack, these values are loaded
;               in reverse order that they going to be output, it will call "first" when reaching the last value (first to be output) which is pushed in 
;               with the "first" subroutine 
;               "johnson" is a loop that outputs the values from the stack by poping them and then loading them onto PortB, it will call "reset" when done and 
;               "superdelay" inbetween outputs to put a delay on the speed that the LEDs are flashing 
;               "superdelay" is a loop containing 2 further loops inside that will count from 0 to 125000 (50*50*50) before jumping back to "johnson"
;               "reset" is called when the "johnson" subroutine reaches the last value and will reset the values so that "load" can be called again 
;               "reset_delay" is a delay made specifically for the "reset" subroutine. It is the same as the "superdelay" but when done it calls "johnson"
;               "wait_miliseconds" will run the 1ms delay r25 x r24 times  before returning to the ring counter 
;                  
; Included files: m2560def.inc
;
; Other information: None. 
;
; Changes in program: None. 
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 

.include "m2560def.inc"
;inilizing output 
ldi r16, 0xFF
out 0x04, r16
ldi r16, 0xFF
out 0x05, r16
; initlizing stack. Copy pasted from the assignment question
ldi r20, HIGH(RAMEND) ; R20 = high part of RAMEND address 
out SPH,R20 ; SPH = high part of RAMEND address
ldi R20, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R20 ; SPL = low part of RAMEND address

ldi r17, 0b10000000
ldi r16, 0b01111111
ldi r19, 0b00000001
ldi r25, 3 ; number 1, these two numbers will times each other 
ldi r24, 255 ; number 2 
ldi r26, 0b01111111
ldi r27,0 ;counter 1
ldi r29,0 ; counter 2 

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
ldi r21, 0 ; load 0 to r21 to reset the counter for the superdelay
pop r16 ; pop a value out of the stack and into r16
out PORTB,r16 ; output the value of r16 to portB
cp r16,r26 ; compare r16 to r25 or the last value to be output 
breq reset ; if last value is reached branched to reset 
call DELAY 
rjmp ring

; Generated by delay loop calculator
; at http://www.bretmulvey.com/avrdelay.html
;
; Delay 1000 cycles
; 1ms at 1.0 MHz
; This subroutine will run the delay r25 x r24 times
; the delay is 1ms long 
wait_miliseconds: 
push r18
push r19
ldi r29, 0 ; counter 2 
inc r27 ; counter 1 
cp r25,r27
brne DELAY
ldi r27,0
ret
DELAY: 
	inc r29
    ldi  r18, 2
    ldi  r19, 75
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1
cp r24,r29
brne DELAY
pop r18
pop r19
breq wait_miliseconds


reset: 

ldi r17, 0b10000000 ; resets r17 and r16 to their original values so that the loop can be called again 
ldi r16, 0b01111111
call DELAY
rjmp load
