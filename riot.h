#ifndef __RIOT_H
#define __RIOT_H

class Line;

// 6530 RIOT
// https://github.com/mamedev/mame/blob/master/src/devices/machine/mos6530.cpp

class RIOT {
public:
	RIOT(): outb(0), inb(0xff), outa(0), ina(0xff), ddrb(0), ddra(0),
		ie_timer(false), irq_timer(false), ie_edge(false), irq_edge(false), pa7(1), pa7_dir(0),
		timer_running(false), prescaler(0)
       	{
	}

	virtual void reset() {
		inb = ina = 0xff;
		outb = outa = ddrb = ddra = 0;
		ie_timer = irq_timer = ie_edge = irq_edge = false;
		pa7_dir = 0;

		update_porta();
		update_portb();
		update_irq();
		edge_detect();
	}

	const uint8_t IRQ_EDGE = 0x40;
	const uint8_t IRQ_TIMER = 0x80;

	void tick();
	void register_irq(Line &line) { irq = &line; }

	void write_porta_in(uint8_t, uint8_t);
	void write_portb_in(uint8_t, uint8_t);
	void write_edge(uint8_t, uint8_t);

	void write(Memory::address, uint8_t);
	uint8_t read(Memory::address);

protected:
	virtual void update_porta() {}
	virtual void update_portb() {}

	uint8_t read_porta() { return (outa & ddra) | (ina & ~ddra); }
	uint8_t read_ddra() { return ddra; }
	uint8_t read_portb() { return (outb & ddrb) | (inb & ~ddrb); }
	uint8_t read_ddrb() { return ddrb; }
	uint8_t read_irq();
	uint8_t read_timer();

	virtual void write_porta(uint8_t);
	void write_ddra(uint8_t);
	virtual void write_portb(uint8_t);
	void write_ddrb(uint8_t);
	void write_timer(Memory::address, uint8_t);

private:
	void update_irq();
	void edge_detect();

	uint8_t outb, inb, outa, ina, ddrb, ddra;
	bool ie_timer, irq_timer, ie_edge, irq_edge;
	int pa7, pa7_dir;
	bool timer_running;
	uint32_t target_time;
	uint8_t prescaler;

	Line *irq;

	uint8_t ram[128];
};

#endif
