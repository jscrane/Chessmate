#include <Arduino.h>
#include <serial_kbd.h>
#include "keypad.h"

void ser_keypad::poll_keyboard() {

	if (!_kbd.available())
		return;

	_r0 = _r1 = 0x7f;

	switch (_kbd.read()) {
	case '1':
	case 'a':
		_r1 &= ~a1_bit;
		break;
	case '2':
	case 'b':
		_r1 &= ~b2_bit;
		break;
	case '3':
	case 'c':
		_r1 &= ~c3_bit;
		break;
	case '4':
	case 'd':
		_r1 &= ~d4_bit;
		break;
	case '5':
	case 'e':
		_r1 &= ~e5_bit;
		break;
	case '6':
	case 'f':
		_r1 &= ~f6_bit;
		break;
	case '7':
	case 'g':
		_r0 &= ~g7_bit;
		break;
	case '8':
	case 'h':
		_r0 &= ~h8_bit;
		break;
	case 0x0b:
		_r0 &= ~clr_bit;
		break;
	case 0x0d:
		_r0 &= ~ent_bit;
		break;
	}
}

uint8_t ser_keypad::row0() {

	poll_keyboard();
	return _r0;
}

uint8_t ser_keypad::row1() {

	poll_keyboard();
	return _r1;
}

void ser_keypad::reset() {

	_kbd.reset();
	_r0 = _r1 = 0x7f;
}
