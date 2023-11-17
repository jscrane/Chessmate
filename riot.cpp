#include <Arduino.h>
#include <hardware.h>
#include <memory.h>
#include <line.h>
#include "riot.h"

// registers
const uint8_t sad = 0x00;	// port a data
const uint8_t padd = 0x01;	// port a ddr
const uint8_t sbd = 0x02;	// port b data
const uint8_t pbdd = 0x03;	// port b ddr
const uint8_t clk1t = 0x04;
const uint8_t clk8t = 0x05;
const uint8_t clk64t = 0x06;
const uint8_t clkkt = 0x07;
const uint8_t clkrdi = 0x07;	// read timeout bit
const uint8_t clkrdt = 0x06;	// read timer
const uint8_t ckint = 0x0e;	// read timer interrupt
const uint8_t clkti = 0x0f;
const uint8_t rsram = 0x80;	// start of RAM

void RIOT::write_porta_in(uint8_t b, uint8_t mem_mask) {
	ina = (ina & ~mem_mask) | (b & mem_mask);
	edge_detect();
}

void RIOT::write_portb_in(uint8_t b, uint8_t mem_mask) {
	inb = (inb & ~mem_mask) | (b & mem_mask);
}

void RIOT::write_edge(uint8_t off, uint8_t data) {
	pa7_dir = (data & 0x01);
	ie_edge = bool(data & 0x02);
	update_irq();
}

void RIOT::write(Memory::address a, uint8_t b) {

	if (a >= rsram) {
		ram[a - 0x80] = b;
		return;
	}

	switch (a) {
	case sad:
		write_porta(b);
		break;
		
	case padd:
		write_ddra(b);
		break;
		
	case sbd:
		write_portb(b);
		break;
		
	case pbdd:
		write_ddrb(b);
		break;
	
	case clkti:
		write_clkti(b);
		break;

	default:
		DBG(printf("%04x %02x!\r\n", a, b));
	}
}

void RIOT::write_porta(uint8_t b) {

	outa = b;
	update_porta();
	edge_detect();
}

void RIOT::write_ddra(uint8_t b) {

	ddra = b;
	update_porta();
	edge_detect();
}

void RIOT::write_portb(uint8_t b) {

	outb = b;
	update_portb();
}

void RIOT::write_ddrb(uint8_t b) {

	ddrb = b;
	update_portb();
}

void RIOT::write_clkti(uint8_t b) {
}

void RIOT::edge_detect() {

	uint8_t data = read_porta();
	int state = (data & 0x80);

	if ((pa7 ^ state) && !(pa7_dir ^ state) && !irq_edge) {
		irq_edge = true;
		update_irq();
	}
	pa7 = state;
}

void RIOT::update_irq() {

	if (!irq) return;	// no handler

	irq->set((ie_timer && irq_timer) || (ie_edge && irq_edge));
}

uint8_t RIOT::read(Memory::address a) {

	if (a >= rsram)
		return ram[a - 0x80];

	switch (a) {
	case sad:
		return read_porta();

	case padd:
		return read_ddra();

	case sbd:
		return read_portb();

	case pbdd:
		return read_ddrb();

	case ckint:
		return read_ckint();

	default:
		DBG(printf("%04x?\r\n", a));
	}

	return 0x00;
}

uint8_t RIOT::read_ckint() {
	// FIXME
	return 0x00;
}
