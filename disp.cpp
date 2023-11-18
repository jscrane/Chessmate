#include <Arduino.h>

#include <display.h>
#include "disp.h"
#include "config.h"

static const uint16_t digx[] = { 25, 75, 125, 175 };
static const uint16_t digy = 20, digw = 30, digh = 50, segw = 5, segh = 20;

struct rect { uint8_t x, y, w, h; };

static struct rect segs[] = {
	{ segw, digy, segh, segw },
	{ segh+segw, digy+segw, segw, segh },
	{ segh+segw, digy+segw+segh+segw, segw, segh },
	{ segw, digy+2*(segw+segh), segh, segw },
	{ 0, digy+segw+segh+segw, segw, segh },
	{ 0, digy+segw, segw, segh },
	{ segw, digy+segw+segh, segh, segw },
};

static const uint8_t ledx[] = { 40, 90, 140, 190 };
static const uint8_t ledy = 100, ledr = 10;

void disp::begin() {
	Display::begin(BG_COLOUR, FG_COLOUR, ORIENT);
	clear();

	for (int i = 0; i < 4; i++) {
		drawCircle(ledx[i], ledy, ledr, FG_COLOUR);
		led_state[i] = false;
	}
}

// segments: a-g == 0-6
void disp::segments(uint8_t s) {

	uint8_t st = seg_state[selected];
	if (s == 0 || s == st)
		return;

	uint8_t dx = digx[selected];
	for (int i = 0; i < 7; i++) {
		uint8_t b = (1 << i);
		if ((s & b) != (st & b)) {
			rect &seg = segs[i];
			fillRectangle(dx+seg.x, seg.y, seg.w, seg.h, (s & b)? FG_COLOUR: BG_COLOUR);
		}

	}
	seg_state[selected] = s;
}

void disp::drawLed(uint8_t i, bool on) {

	if (led_state[i] != on) {
		fillCircle(ledx[i], ledy, ledr-1, on? FG_COLOUR: BG_COLOUR);
		led_state[i] = on;
	}
}
