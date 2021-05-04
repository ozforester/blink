TARGET	= blink
OBJECTS       = $(SOURCES:.c=.o)

all:
	avr-gcc -fno-stack-protector -fno-pic -std=c99 -Wall Os -mmcu=atmega8 -o blink.o blink.c
	avr-ld -o blink.elf blink.o
	avr-objcopy -j .text -j .data -O ihex blink.o blink.hex
	avr-size blink.elf

flash:
	avrdude -c usbasp -p m8 -B 1 -U flash:w:blink.hex

clean:
	rm -f $(OBJECTS) $(TARGET).elf $(TARGET).map