#include <Arduino.h>

#include <machine.h>
#include <memory.h>
#include <display.h>
#include <hardware.h>
#include <serial_kbd.h>

#include "openings.h"
#include "keypad.h"
#include "disp.h"
#include "riot.h"
#include "io.h"

io::io(keypad &k, disp &d):
	Memory::Device(5 * Memory::page_size), _k(k), _d(d)
{
	riot.register_porta_write_handler([this](uint8_t b) { on_write_porta(b); });
	riot.register_portb_write_handler([this](uint8_t b) { on_write_portb(b); });
	riot.register_rom_read_handler([](Memory::address a) { return pgm_read_byte(openings + a); });

	register_key_handler([this](uint8_t b) { riot.write_porta_in(b, 0xff); });
}

void io::reset() {

	riot.reset();
	_d.begin();
	_k.reset();
#if defined(PWM_SOUND)
	pinMode(PWM_SOUND, OUTPUT);
#endif
}

void io::on_write_porta(uint8_t b) {

	_d.segments(b & 0x7f);
	_d.chessmate_loses(b & 0x80);
}

void io::on_write_portb(uint8_t b) {

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
