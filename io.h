#pragma once

class io {
public:
	io(RIOT &, keypad &, disp &);

	void reset();

	// callbacks
	void on_write_porta(uint8_t);
	void on_write_portb(uint8_t);

	// callout
	void register_key_handler(std::function<void(uint8_t)> fn) {
		key_handler = fn;
	}

private:
	RIOT &_riot;

	keypad &_k;

	disp &_d;

	std::function<void(uint8_t)> key_handler;
};
