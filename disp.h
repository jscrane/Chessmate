#pragma once

class disp {
public:
	virtual void begin() { selected = 0; }

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

class scr_disp: public disp {
public:
	void begin();
	void segments(uint8_t);

private:
	void set_led(uint8_t, bool);

	uint8_t seg_state[4];
	bool led_state[4];
};

class ss_disp: public disp {
public:
	void begin();
	void segments(uint8_t);

protected:
	void set_led(uint8_t, bool);
};
