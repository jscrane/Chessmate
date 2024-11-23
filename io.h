#pragma once

class io: public Memory::Device {
public:
	io(keypad &, disp &);

	RIOT riot;

	virtual void operator=(uint8_t b) { riot.write(_acc, b); }
	virtual operator uint8_t() { return riot.read(_acc); }

	void reset();

	// callbacks
	void on_write_porta(uint8_t);
	void on_write_portb(uint8_t);

	// callout
	void register_key_handler(std::function<void(uint8_t)> fn) {
		key_handler = fn;
	}

private:
	keypad &_k;

	disp &_d;

	std::function<void(uint8_t)> key_handler;
};
