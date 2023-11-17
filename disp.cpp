#include <Arduino.h>

#include <display.h>
#include "disp.h"
#include "config.h"

void disp::begin() {
	Display::begin(BG_COLOUR, FG_COLOUR, ORIENT);
	clear();
	chessmate_loses(false);
}

static const uint16_t digx[] = { 25, 75, 125, 175 };
static const uint16_t digy = 20, digw = 30, digh = 50, segw = 5, segh = 20;

// digits: l-r == 0-3
void disp::digit(uint8_t d) {
	selected = d;
}

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

// segments: a-g == 0-6
void disp::segments(uint8_t s) {

	uint8_t st = state[selected];
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
	state[selected] = s;
}

static const uint8_t ledx[] = { 40, 90, 140, 190 };
const uint8_t ledy = 100, ledr = 10;

void disp::drawLed(uint8_t x, bool on) {
	if (on)
		fillCircle(x, ledy, ledr);
	else {
		drawCircle(x, ledy, ledr, FG_COLOUR);
		fillCircle(x, ledy, ledr-1, BG_COLOUR);
	}
}

void disp::chessmate_loses(bool on) {
	drawLed(ledx[0], on);
}

void disp::check(bool on) {
	drawLed(ledx[1], on);
}

void disp::white(bool on) {
	drawLed(ledx[2], on);
	drawLed(ledx[3], !on);
}
