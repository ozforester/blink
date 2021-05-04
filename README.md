# blink
You probably know that "blink" for mc people means the same as "Hello world!" for others.

blink.c - my attempt to use atmega8 avr-gcc and c language to blink a led.<br>
blink.S - my attempt to use atmega8 avr-gcc and assembly to blink.<br>
Makefile - to do my work more easily.

a command line tools usage:



; avr-gcc -Os -Wall -mmcu=atmega8 blink.S -o blink
; avr-objcopy -O ihex -R .eeprom blink blink.hex
; avrdude -p atmega8 -c usbasp -U flash:w:blink.hex


So that's it.
