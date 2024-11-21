#pragma once

// pushbutton keypad matrix
// see schematic: http://retro.hansotten.nl/6502-sbc/6530-6532/chessmate/#specs

// keys selected by row-0
const uint8_t g7_bit = 1 << 6;
const uint8_t ent_bit = 1 << 3;
const uint8_t clr_bit = 1 << 4;
const uint8_t h8_bit = 1 << 5;

// keys selected by row-1
const uint8_t f6_bit = 1 << 0;
const uint8_t e5_bit = 1 << 1;
const uint8_t d4_bit = 1 << 2;
const uint8_t c3_bit = 1 << 3;
const uint8_t b2_bit = 1 << 4;
const uint8_t a1_bit = 1 << 5;

class keypad {
public:
	virtual uint8_t row0() =0;
	virtual uint8_t row1() =0;
	virtual void reset() =0;
};

class ser_keypad: public keypad {
public:
	ser_keypad(serial_kbd &kbd): _kbd(kbd) {}

	uint8_t row0();
	uint8_t row1();
	void reset();

private:
	void poll_keyboard();

	serial_kbd &_kbd;
	uint8_t _r0, _r1;
};

class pb_keypad: public keypad {
public:
	uint8_t row0();
	uint8_t row1();
	void reset();
};
