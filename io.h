#ifndef __IO_H
#define __IO_H

class io: public Memory::Device, public RIOT {
public:
	io(Line &irq, serial_kbd &kbd, disp &d): Memory::Device(Memory::page_size), _kbd(kbd), _disp(d) {
		RIOT::register_irq(irq);
	}

	void reset();

	virtual void operator=(uint8_t b) { RIOT::write(_acc, b); }
	virtual operator uint8_t() { return RIOT::read(_acc); }

	virtual void write_porta(uint8_t);
	virtual void write_portb(uint8_t);

private:
	serial_kbd &_kbd;

	disp &_disp;

	void key_press(uint8_t);

	uint8_t row0, row1;
};

#endif
