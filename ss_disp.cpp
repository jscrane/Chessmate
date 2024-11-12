#include <Arduino.h>
#include "disp.h"
#include "config.h"

static const uint8_t digits[] = {
	DIG1_PIN,
	DIG2_PIN,
	DIG3_PIN,
	DIG4_PIN,
};

static const uint8_t leds[] = {
	LED1_PIN,
	LED2_PIN,
	LED3_PIN,
	LED4_PIN,
};

static const uint8_t segs[] = {
	SEGA_PIN,
	SEGB_PIN,
	SEGC_PIN,
	SEGD_PIN,
	SEGE_PIN,
	SEGF_PIN,
	SEGG_PIN,
};

void ss_disp::begin() {

	disp::begin();

	for (unsigned i = 0; i < 4; i++) {
		pinMode(digits[i], OUTPUT);
		pinMode(leds[i], OUTPUT);
	}

	for (unsigned i = 0; i < 7; i++)
		pinMode(segs[i], OUTPUT);
}

void ss_disp::segments(uint8_t digit) {

	for (unsigned i = 0; i < 4; i++)
		digitalWrite(digits[i], selected == i);

	for (unsigned i = 0; i < 7; i++)
		digitalWrite(segs[i], digit & (1 << i));
}

void ss_disp::set_led(uint8_t led, bool on) {
	digitalWrite(leds[led], on);
}
