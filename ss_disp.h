#ifndef __SS_DISP_H
#define __SS_DISP_H

class ss_disp: public disp {
public:
	void begin();
	void segments(uint8_t);

protected:
	void set_led(uint8_t, bool);
};

#endif
