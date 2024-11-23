#include <Arduino.h>
#include <serial_kbd.h>
#include "keypad.h"
#include "config.h"

#define DEBOUNCE_MS	200

static const uint8_t cols[] = {
	COL0_PIN,
	COL1_PIN,
	COL2_PIN,
	COL3_PIN,
	COL4_PIN,
	COL5_PIN,
};

uint8_t pb_keypad::row0() {

	uint8_t cols = 0x7f;
	uint32_t now = millis();
	if (now - _last0 < DEBOUNCE_MS)
		return cols;

	_last0 = now;
	digitalWrite(ROW0_PIN, LOW);
	if (!digitalRead(COL0_PIN)) cols &= ~g7_bit;
	if (!digitalRead(COL3_PIN)) cols &= ~ent_bit;
	if (!digitalRead(COL4_PIN)) cols &= ~clr_bit;
	if (!digitalRead(COL5_PIN)) cols &= ~h8_bit;
	digitalWrite(ROW0_PIN, HIGH);
	return cols;
}

uint8_t pb_keypad::row1() {

	uint8_t cols = 0x7f;
	uint32_t now = millis();
	if (now - _last1 < DEBOUNCE_MS)
		return cols;

	_last1 = now;
	digitalWrite(ROW1_PIN, LOW);
	if (!digitalRead(COL0_PIN)) cols &= ~f6_bit;
	if (!digitalRead(COL1_PIN)) cols &= ~e5_bit;
	if (!digitalRead(COL2_PIN)) cols &= ~d4_bit;
	if (!digitalRead(COL3_PIN)) cols &= ~c3_bit;
	if (!digitalRead(COL4_PIN)) cols &= ~b2_bit;
	if (!digitalRead(COL5_PIN)) cols &= ~a1_bit;
	digitalWrite(ROW1_PIN, HIGH);
	return cols;
}

void pb_keypad::reset() {

	for (unsigned i = 0; i < 6; i++)
		pinMode(cols[i], INPUT_PULLUP);

	pinMode(ROW0_PIN, OUTPUT);
	digitalWrite(ROW0_PIN, HIGH);
	pinMode(ROW1_PIN, OUTPUT);
	digitalWrite(ROW1_PIN, HIGH);

	_last0 = _last1 = millis();
}
