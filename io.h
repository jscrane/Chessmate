#ifndef __IO_H
#define __IO_H

class io: public Memory::Device, public RIOT {
public:
	io(Line &irq): Memory::Device(Memory::page_size) {
		RIOT::register_irq(irq);
	}

	void reset();
	void down(uint8_t);
	void up(uint8_t);

	virtual void operator=(uint8_t b) { RIOT::write(_acc, b); }
	virtual operator uint8_t() { return RIOT::read(_acc); }

	virtual void write_porta(uint8_t);
	virtual void write_portb(uint8_t);

	disp d;

private:
	uint8_t row0, row1;
};

#endif
