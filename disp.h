#ifndef __DISP_H
#define __DISP_H

class disp {
public:
	virtual void begin();

	// 7-segment display 
	// digits: l-r == 0-3
	// segments: a-g == 0-6
	void digit(uint8_t d) { selected = d; }
	virtual void segments(uint8_t) = 0;

	// leds
	void chessmate_loses(bool on) { set_led(0, on); }
	void check(bool on) { set_led(1, on); }
	void white(bool on) { set_led(2, on); set_led(3, !on); }

protected:
	virtual void set_led(uint8_t, bool) = 0;

	uint8_t selected;
};

#endif
