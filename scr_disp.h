#ifndef __SCR_DISP_H
#define __SCR_DISP_H

class scr_disp: public disp, public Display {
public:
	void begin();
	void segments(uint8_t);

private:
	void set_led(uint8_t, bool);

	uint8_t seg_state[4];
	bool led_state[4];
};

#endif
