#include <Arduino.h>
#include "disp.h"

void ss_disp::begin() {

	disp::begin();
	// FIXME: hardware dependent!
}


void ss_disp::segments(uint8_t digit) {
	// FIXME: hardware dependent!
}

void ss_disp::set_led(uint8_t led, bool on) {
	// FIXME: hardware dependent!
}
