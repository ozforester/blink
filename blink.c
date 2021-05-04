/*
Copyright (c) 2021 ozforester. All rights reserved.
Use of this source code is goverened by a MIT license
that can be found in the LICENSE file.
*/

/*
 ATmega8 @4MHz internal osc. (H:D9, L:23)
 LED blinks on timer0 ovf
*/

#include <avr/io.h>
#include <avr/interrupt.h>

uint8_t counter = 5; // 8-O suddenly a counter

ISR (TIMER0_OVF_vect){ // on each timer0 overflow
  if( counter ) counter--; // either 5 times 65 ms. appx. decrements
  else { counter = 5; PORTB ^= (1 << PB0); } // or flops a led state
}

int main(){
  DDRB = (1 << PB0); // sets B0 as output
  TCCR0 = (1<<CS02) | (1<<CS00); // sets prescaler to 1024
  TIMSK = (1 << TOIE0); // enables timer0 overflow isr event
  sei(); // and does it globally too
  while(1); // just exhausts universe
}
