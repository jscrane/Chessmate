#include <r65emu.h>
#include <r6502.h>

#include "disp.h"
#include "keypad.h"
#include "ccmk2.h"
#include "riot.h"
#include "io.h"
#include "config.h"

#if defined(SS_DISPLAY)
ss_disp display;
#else
scr_disp display;
#endif

#if defined(PB_KEYPAD)
pb_keypad keypad;

#else
#if defined(PS2_SERIAL_KBD)
ps2_serial_kbd kbd;

#elif defined(HW_SERIAL_KBD)
hw_serial_kbd kbd(Serial);

#else
#error "No keyboard defined!"
#endif
ser_keypad keypad(kbd);
#endif

prom game(ccmk2, sizeof(ccmk2));
Memory memory;
r6502 cpu(memory);
ram<256> zpage, stack;
io io(keypad, display);

void reset() {
	hardware_reset();
	io.reset();
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

	io.riot.register_irq_handler([](bool irq) { if (irq) cpu.raise(0); });

	memory.put(zpage, 0x0000);
	memory.put(stack, 0x0100);
	memory.put(io, 0x8b00);
	memory.put(game, 0xf000);

#if !defined(PB_KEYPAD)
	kbd.register_fnkey_handler(function_key);
#endif

	reset();
}

void loop() {

	hardware_run();
}
