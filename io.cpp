#include <Arduino.h>
#include <memory.h>
#include <line.h>
#include <display.h>
#include <hardware.h>
#include <serial_kbd.h>

#include "disp.h"
#include "riot.h"
#include "io.h"

// keys selected by line = 4 (i.e., !line-5)
const uint8_t g7_bit = 1 << 6;
const uint8_t ent_bit = 1 << 3;
const uint8_t clr_bit = 1 << 4;
const uint8_t h8_bit = 1 << 5;

// keys selected by line = 5 (i.e., !line-4)
const uint8_t f6_bit = 1 << 0;
const uint8_t e5_bit = 1 << 1;
const uint8_t d4_bit = 1 << 2;
const uint8_t c3_bit = 1 << 3;
const uint8_t b2_bit = 1 << 4;
const uint8_t a1_bit = 1 << 5;

void io::reset() {
	_disp.begin();
	_kbd.reset();
#if defined(PWM_SOUND)
	pinMode(PWM_SOUND, OUTPUT);
#endif
}

void io::key_press(uint8_t key) {

	row0 = row1 = 0x7f;

	switch (key) {
	case '1':
	case 'a':
		row1 &= ~a1_bit;
		break;
	case '2':
	case 'b':
		row1 &= ~b2_bit;
		break;
	case '3':
	case 'c':
		row1 &= ~c3_bit;
		break;
	case '4':
	case 'd':
		row1 &= ~d4_bit;
		break;
	case '5':
	case 'e':
		row1 &= ~e5_bit;
		break;
	case '6':
	case 'f':
		row1 &= ~f6_bit;
		break;
	case '7':
	case 'g':
		row0 &= ~g7_bit;
		break;
	case '8':
	case 'h':
		row0 &= ~h8_bit;
		break;
	case 0x0b:
		row0 &= ~clr_bit;
		break;
	case 0x0d:
		row0 &= ~ent_bit;
		break;
	}
}

void io::write_porta(uint8_t b) {

	_disp.segments(b & 0x7f);
	_disp.chessmate_loses(b & 0x80);
}

void io::write_portb(uint8_t b) {

	if (_kbd.available())
		key_press(_kbd.read());

	uint8_t line = (b & 0x07);
	if (line < 4)
		_disp.digit(line);
	else if (line == 4)
		keyboard_handler(row1);
	else if (line == 5)
		keyboard_handler(row0);
#if defined(PWM_SOUND)
	else
		digitalWrite(PWM_SOUND, line == 7);
#endif

	_disp.check(b & 0x08);
	_disp.white(b & 0x10);
}
