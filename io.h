#ifndef __IO_H
#define __IO_H

class serial_kbd;

class io {
public:
	io(serial_kbd &kbd): _kbd(kbd) {}

	void reset();

	// callbacks
	void write_porta(uint8_t);
	void write_portb(uint8_t);

	// callout
	void register_keyboard_handler(std::function<void(uint8_t)> fn) {
		keyboard_handler = fn;
	}

	disp d;

private:
	serial_kbd &_kbd;

	void key_press(uint8_t);

	uint8_t row0, row1;

	std::function<void(uint8_t)> keyboard_handler;
};

#endif
