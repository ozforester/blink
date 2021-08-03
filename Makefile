
# Copyright (c) 2021 ozforester. All rights reserved.
# Use of this source code is goverened by a MIT license
# that can be found in the LICENSE file.

TARGET	 = blink
SOURCES := $(wildcard *.c)
OBJECTS  = $(SOURCES:.c=.o)
all:
	avr-gcc -fno-stack-protector -fno-pic -std=c99 -DF_CPU=4000000L -Wall -Os -mmcu=atmega8 -o blink blink.c
	avr-objcopy -O ihex blink blink.hex
	avr-size blink.hex

asm:
	avr-gcc -fno-stack-protector -fno-pic -Wall -Os -mmcu=atmega8 -o blink blink.S
	avr-objcopy -O ihex blink blink.hex
	avr-size blink.hex

flash:
	avrdude -c usbasp -p m8 -B 2 -U flash:w:blink.hex

clean:
	rm -f $(OBJECTS) $(TARGET) $(TARGET).elf $(TARGET).hex
