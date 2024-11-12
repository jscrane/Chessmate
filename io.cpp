#include <Arduino.h>
#include <memory.h>
#include <line.h>
#include <display.h>
#include <hardware.h>
#include <serial_kbd.h>

#include "keypad.h"
#include "disp.h"
#include "riot.h"
#include "io.h"

void io::reset() {
	_d.begin();
	_k.reset();
#if defined(PWM_SOUND)
	pinMode(PWM_SOUND, OUTPUT);
#endif
}

void io::write_porta(uint8_t b) {

	_d.segments(b & 0x7f);
	_d.chessmate_loses(b & 0x80);
}

void io::write_portb(uint8_t b) {

	uint8_t line = (b & 0x07);
	if (line < 4)
		_d.digit(line);
	else if (line == 4)
		key_handler(_k.row1());
	else if (line == 5)
		key_handler(_k.row0());
#if defined(PWM_SOUND)
	else
		digitalWrite(PWM_SOUND, line == 7);
#endif

	_d.check(b & 0x08);
	_d.white(b & 0x10);
}
