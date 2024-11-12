#include <r65emu.h>
#include <r6502.h>

#include "disp.h"
#include "scr_disp.h"
#include "ss_disp.h"
#include "keypad.h"
#include "ccmk2.h"
#include "openings.h"
#include "riot.h"
#include "io.h"
#include "config.h"

#if defined(PS2_SERIAL_KBD)
ps2_serial_kbd kbd;

#elif defined(HW_SERIAL_KBD)
hw_serial_kbd kbd(Serial);

#elif defined(KEYPAD_KBD)
keypad kbd;

#else
#error "No keyboard defined!"
#endif

#if defined(SCR_DISPLAY)
scr_disp display;

#elif defined(SS_DISPLAY)
ss_disp display;

#else
#error "No display defined!"
#endif

prom game(ccmk2, sizeof(ccmk2));
prom opens(openings, sizeof(openings));
Memory memory;
r6502 cpu(memory);
ram<256> zpage, stack;
io io(kbd, display);
RIOT riot;

void reset() {
	hardware_reset();
	io.reset();
	riot.reset();
}

void function_key(uint8_t fn) {
	switch(fn) {
	case 1:
                reset();
		break;
	case 10:
		hardware_debug_cpu();
		break;
        }
}

void setup() {

	hardware_init(cpu);

	riot.register_irq_handler([](bool irq) { if (irq) cpu.raise(0); });

	riot.register_porta_write_handler([](uint8_t b) { io.write_porta(b); });
	riot.register_portb_write_handler([](uint8_t b) { io.write_portb(b); });

	io.register_keyboard_handler([](uint8_t b) { riot.write_porta_in(b, 0xff); });

	memory.put(zpage, 0x0000);
	memory.put(stack, 0x0100);
	memory.put(riot, 0x8b00);
	memory.put(opens, 0x8c00);
	memory.put(game, 0xf000);

	kbd.register_fnkey_handler(function_key);

	reset();
}

void loop() {

	if (hardware_run())
		riot.tick();
}
