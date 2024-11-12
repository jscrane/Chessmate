#pragma once

class io {
public:
	io(keypad &k, disp &d): _k(k), _d(d) {}

	void reset();

	// callbacks
	void write_porta(uint8_t);
	void write_portb(uint8_t);

	// callout
	void register_key_handler(std::function<void(uint8_t)> fn) {
		key_handler = fn;
	}

private:
	keypad &_k;

	disp &_d;

	std::function<void(uint8_t)> key_handler;
};
