#ifndef __DISP_H
#define __DISP_H

class disp: public Display {
public:
	disp() {}
	void begin();

	// 7-segment display 
	// digits: l-r == 0-3
	// segments: a-g == 0-6
	void digit(uint8_t);
	void segments(uint8_t);

	// leds
	void chessmate_loses(bool);
	void check(bool);
	void white(bool);
	void black(bool);

private:
	void initLeds();
	void drawLed(uint8_t, bool);

	uint8_t selected;
	uint8_t seg_state[4];
	bool led_state[4];
};

#endif
