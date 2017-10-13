;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2015-09-03
; Author:
; Matus Maruna
; John Charo 
;
; Lab number: 4
; Title: Variable duty cycle 
;
; Hardware: STK600, CPU ATmega2560
;
; Function: This program 
;
; Input ports: Port D is connected to switches
;
; Output ports:  Port B is connected to LEDs
;
; Subroutines: "down" increments duty cycle, "up" decrements duty cycle. "countercheck" resets the counter counting up to the custom duty cycle var
;              "flash" changes the LED to off. "Display" pushes values to portB for LED flashes. "Branchaway" is used to branch to return interrupt. 
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<< <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"
.ORG 0x0000
; setting up labels for values and registers 
.def var = r24
.def counter = r22
.equ upperbound = 20
.equ lowerbound = 0 
.def countvariable =r16
.def temp = r21
rjmp start

.ORG OVF0addr
rjmp timer0_int

.org INT0addr
rjmp down 

.org INT1addr
rjmp up 

.ORG 0x72
start:
ldi var, 10
ldi r17, 0
ldi r18, 0 
ldi r22, 0 
; creating a stack 
ldi r20, HIGH(RAMEND)
out SPH, r20
ldi r20, low(RAMEND)
out SPL, r20
; setting portB as output
ldi r16, 0x01
out DDRB,r16
ldi r17, 0x00
out portB, r17
ldi r21, 0x00
out DDRD, r21
; setting trigger for interrupts
ldi r16,0b00000011
out EIMSK, r16
ldi r16,0b00001010
sts EICRA, r16
; setting up the timer, found in the course presentation 
ldi temp, 0b101
out TCCR0B, temp
ldi temp,(1<<TOIE0)
sts TIMSK0, temp 
ldi temp,206
out TCNT0,temp
sei 

loop: 
nop 
rjmp loop

timer0_int:
push temp 
in temp,SREG
push temp
ldi temp, 206
out TCNT0,temp
inc counter
; is counter lower than duty cycle variable 
cp  var,counter
brlt flash 
ldi r16, 0
countercheck: 
cpi counter,20
breq end
display:
out portB, r16 
pop temp
out SREG, temp 
pop temp 
reti

flash: 
ldi r16, 1
rjmp countercheck

end: 
ldi counter, 0 
rjmp display
; increment the duty cycle 
down: 
cpi var, upperbound
brge branchaway
inc var
reti 
; decrement the duty cycle 
up: 
cpi var, lowerbound
brlt branchaway
dec var 
reti 

branchaway: 
reti 
