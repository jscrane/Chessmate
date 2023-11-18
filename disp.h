#ifndef __DISP_H
#define __DISP_H

class disp: public Display {
public:
	disp() {}
	void begin();

	// 7-segment display 
	// digits: l-r == 0-3
	// segments: a-g == 0-6
	void digit(uint8_t d) { selected = d; }
	void segments(uint8_t);

	// leds
	void chessmate_loses(bool on) { drawLed(0, on); }
	void check(bool on) { drawLed(1, on); }
	void white(bool on) { drawLed(2, on); drawLed(3, !on); }

private:
	void drawLed(uint8_t, bool);

	uint8_t selected;
	uint8_t seg_state[4];
	bool led_state[4];
};

#endif
