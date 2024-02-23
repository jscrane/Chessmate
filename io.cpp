#include <Arduino.h>
#include <memory.h>
#include <line.h>
#include <display.h>
#include <hardware.h>

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

const uint8_t ps2_1 = 0x16;
const uint8_t ps2_2 = 0x1e;
const uint8_t ps2_3 = 0x26;
const uint8_t ps2_4 = 0x25;
const uint8_t ps2_5 = 0x2e;
const uint8_t ps2_6 = 0x36;
const uint8_t ps2_7 = 0x3d;
const uint8_t ps2_8 = 0x3e;
const uint8_t ps2_bs = 0x66;
const uint8_t ps2_enter = 0x5a;
const uint8_t ps2_a = 0x1c;
const uint8_t ps2_b = 0x32;
const uint8_t ps2_c = 0x21;
const uint8_t ps2_d = 0x23;
const uint8_t ps2_e = 0x24;
const uint8_t ps2_f = 0x2b;
const uint8_t ps2_g = 0x34;
const uint8_t ps2_h = 0x33;

void io::reset() {
	d.begin();
#if defined(PWM_SOUND)
	pinMode(PWM_SOUND, OUTPUT);
#endif
}

void io::down(uint8_t key) {
	row0 = row1 = 0x7f;
}

void io::up(uint8_t key) {
	switch (key) {
	case ps2_1:
	case ps2_a:
		row1 &= ~a1_bit;
		break;
	case ps2_2:
	case ps2_b:
		row1 &= ~b2_bit;
		break;
	case ps2_3:
	case ps2_c:
		row1 &= ~c3_bit;
		break;
	case ps2_4:
	case ps2_d:
		row1 &= ~d4_bit;
		break;
	case ps2_5:
	case ps2_e:
		row1 &= ~e5_bit;
		break;
	case ps2_6:
	case ps2_f:
		row1 &= ~f6_bit;
		break;
	case ps2_7:
	case ps2_g:
		row0 &= ~g7_bit;
		break;
	case ps2_8:
	case ps2_h:
		row0 &= ~h8_bit;
		break;
	case ps2_bs:
		row0 &= ~clr_bit;
		break;
	case ps2_enter:
		row0 &= ~ent_bit;
		break;
	}
}

void io::write_porta(uint8_t b) {

	d.segments(b & 0x7f);
	d.chessmate_loses(b & 0x80);

	RIOT::write_porta(b);
}

void io::write_portb(uint8_t b) {

	uint8_t line = (b & 0x07);
	if (line < 4)
		d.digit(line);
	else if (line == 4)
		RIOT::write_porta_in(row1, 0xff);
	else if (line == 5)
		RIOT::write_porta_in(row0, 0xff);
#if defined(PWM_SOUND)
	else
		digitalWrite(PWM_SOUND, line == 7);
#endif

	d.check(b & 0x08);
	d.white(b & 0x10);

	RIOT::write_portb(b);
}
