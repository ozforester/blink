# blink
You probably know that "blink" for mc people means the same as "Hello world!" for others.<br>

blink.c - my attempt to use atmega8 avr-gcc and c language to blink a led.<br>
blink.S - my attempt to use atmega8 avr-gcc and assembly to blink.<br>
Makefile - to do my work more easily.<br>

If you prefer a console commands:<br>

C source:<br>

avr-gcc -Wall -Os -mmcu=atmega8 -DF_CPU=4000000L -o blink blink.c<br>
avr-objcopy -O ihex blink blink.hex<br>
avrdude -c usbasp -p m8 -B 1 -U flash:w:blink.hex<br>

Assembly source:<br>

avr-gcc -Os -Wall -mmcu=atmega8 blink.S -o blink<br>
avr-objcopy -O ihex blink blink.hex<br>
avrdude -p atmega8 -c usbasp -B 1 -U flash:w:blink.hex<br>


So that's it.<br>

![screenshot](BLINK.JPG)
