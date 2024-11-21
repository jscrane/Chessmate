#include <Arduino.h>
#include <serial_kbd.h>
#include "keypad.h"
#include "config.h"

static const uint8_t cols[] = {
	COL0_PIN,
	COL1_PIN,
	COL2_PIN,
	COL3_PIN,
	COL4_PIN,
	COL5_PIN,
	COL6_PIN,
};

uint8_t pb_keypad::row0() {

	digitalWrite(ROW1_PIN, LOW);
	digitalWrite(ROW0_PIN, HIGH);

	uint8_t cols = 0x7f;
	if (digitalRead(COL6_PIN)) cols &= ~g7_bit;
	if (digitalRead(COL5_PIN)) cols &= ~h8_bit;
	if (digitalRead(COL4_PIN)) cols &= ~clr_bit;
	if (digitalRead(COL3_PIN)) cols &= ~ent_bit;
	return cols;
}

uint8_t pb_keypad::row1() {

	digitalWrite(ROW0_PIN, LOW);
	digitalWrite(ROW0_PIN, HIGH);

	uint8_t cols = 0x7f;
	if (digitalRead(COL5_PIN)) cols &= ~a1_bit;
	if (digitalRead(COL4_PIN)) cols &= ~b2_bit;
	if (digitalRead(COL3_PIN)) cols &= ~c3_bit;
	if (digitalRead(COL2_PIN)) cols &= ~d4_bit;
	if (digitalRead(COL1_PIN)) cols &= ~e5_bit;
	if (digitalRead(COL0_PIN)) cols &= ~f6_bit;
	return cols;
}

void pb_keypad::reset() {

	pinMode(ROW0_PIN, OUTPUT);
	pinMode(ROW1_PIN, OUTPUT);

	for (unsigned i = 0; i < 7; i++)
		pinMode(cols[i], INPUT);
}
