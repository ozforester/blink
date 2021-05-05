
; Copyright (c) 2021 ozforester. All rights reserved.
; Use of this source code is goverened by a MIT license
; that can be found in the LICENSE file.

; ATmega8 @4MHz internal osc. (H:D9, L:23)
; LED blinks on timer0 ovf

; хотим человеческие названия регистров и нулевой офсет
#include <avr/io.h>
#undef __SFR_OFFSET
#define __SFR_OFFSET 0
; выбираем регистры для счетчика и временного хранения
#define temp r16
#define cnt  r17
; количество переполнений таймера до опрокидывания порта светодиода
#define times 5
.global main			; символ
.global TIMER0_OVF_vect		; аналогично, и вспоминаем, что флаг сбросится без нас

main:
	sbi DDRB, 0x00		; B0 output
	sbi PORTB, 0x00		; B0 low
	ldi cnt, times 		; подготавливаем счетчик ( TIM0 переполняется чеерз 65 мс., а счетчик будет 5 раз по 65)
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
	ldi temp, 1		; если 0, то подготавливаем временный регистр для ксора B0
	in   cnt, PORTB		; читаем порт светодиода в регистр счетчика (который пока не при делах)
	eor  cnt, temp		; ксорим счетчик и временный (после чего результат имеем в счетчике)
	out  PORTB, cnt		; пишем результат обратно в порт
        ldi  cnt, times	        ; загружаем счетчик для следующего цикла
	Pass:			; метка к которой можно перейти если надо
	sei			; разрешаем прерывания
	reti			; возвращаемся из процедуры туда, откуда пришли (loop)
