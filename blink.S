
; Copyright (c) 2021 ozforester. All rights reserved.
; Use of this source code is goverened by a MIT license
; that can be found in the LICENSE file.

; ATmega8 @4MHz internal osc. (H:D9, L:23)
; defined LED blinks on timer0 ovf

; Когда я дочитал до конца команды ассемблера, то мысленно представил
; новый код для решения этой задачи, более простой, и более компактный
; но переделывать уже не стал. Это никогда не поздно, и не нужно.


#undef __SFR_OFFSET
#define __SFR_OFFSET 0
#define DDR DDRD
#define PORT PORTD
#define PIN PD7
#include <avr/io.h>
temp = 16			; регистр для временного хранения
cnt = 17			; регистр для счетчика

.global main			; символ
.global TIMER0_OVF_vect		; аналогично, и вспоминаем, что флаг сбросится без нас

main:
	sbi DDR, PIN		; set pin output
	sbi PORT, PIN		; set pin low
	ldi cnt, 5 		; подготавливаем счетчик ( TIM0 переполняется чеерз 65 мс., а счетчик будет 5 раз по 65)
	ldi temp, (1<<CS00)	; ставим бит пресклера CS00
        ori temp, (1<<CS02)	; и бит прескалера CS02
        out TCCR0, temp		; получим прескалер 1024 (см. даташит, 4МГц / прескалер и будут те самые 65 мс.)
	ldi temp, (1<<TOIE0)	; разрешаем прерывание
	out TIMSK, temp		; по переполнению таймера
	sei			; и разершаем прерывания вообще (тут таймер сразу побежит переполняться и дёргать TIM0_OVF)
loop:
	rjmp loop 		; ничего не делаем (или следим чтобы никто другой не сделал что-нибудь полезное, лул)
				; пока за нас работает прерывание TIMER0_OVF_vect
TIMER0_OVF_vect:
	cli			; на мгновение запрещаем прерывания
	subi cnt, 1		; уменьшаем счетчик
	brne Pass		; переход сразу на метку Pass пока он больше 0
	ldi temp, (1<<PIN)	; если 0, то подготавливаем временный регистр для ксора B0
	in   cnt, PORT		; читаем порт светодиода в регистр счетчика (который пока не при делах)
	eor  cnt, temp		; ксорим счетчик и временный (после чего результат имеем в счетчике)
	out  PORT, cnt		; пишем результат обратно в порт
        ldi  cnt, 5	        ; восстанавливаем счетчик для следующего цикла
	Pass:			; метка к которой можно перейти если надо
	sei			; разрешаем прерывания
	reti			; возвращаемся из процедуры туда, откуда пришли (loop)
