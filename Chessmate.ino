#include <setjmp.h>

#include <r65emu.h>
#include <r6502.h>
#include <line.h>

#include "disp.h"
#include "ccmk2.h"
#include "openings.h"
#include "riot.h"
#include "io.h"
#include "config.h"

#if defined(PS2_SERIAL_KBD)
ps2_serial_kbd kbd;

#elif defined(HW_SERIAL_KBD)
hw_serial_kbd kbd(Serial);

#else
#error "No keyboard defined!"
#endif

Line irq;
prom game(ccmk2, sizeof(ccmk2));
prom opens(openings, sizeof(openings));
r6502 cpu(memory);
ram<256> zpage, stack;
io io(irq, kbd);

void reset() {
	hardware_reset();
	io.reset();
}

jmp_buf jb;

#if defined(CPU_DEBUG)
bool cpu_debug = CPU_DEBUG;
#endif

void function_key(uint8_t fn) {
	switch(fn) {
	case 1:
                reset();
                longjmp(jb, 1);
		break;
#if defined(CPU_DEBUG)
	case 10:
		cpu_debug = !cpu_debug;
		break;
#endif
        }
}

void setup() {

#if defined(DEBUGGING) || defined(CPU_DEBUG)
        Serial.begin(TERMINAL_SPEED);
#endif

	hardware_init(cpu);

	memory.put(zpage, 0x0000);
	memory.put(stack, 0x0100);
	memory.put(io, 0x8b00);
	memory.put(opens, 0x8c00);
	memory.put(game, 0xf000);

	kbd.register_fnkey_handler(function_key);

	reset();
}

void loop() {

	if (!cpu.halted()) {
#if defined(CPU_DEBUG)
                if (cpu_debug) {
                        char buf[256];
                        Serial.println(cpu.status(buf, sizeof(buf)));
                        cpu.run(1);
                } else
                        cpu.run(CPU_INSTRUCTIONS);
#else
                cpu.run(CPU_INSTRUCTIONS);
#endif
		io.tick();
		if (irq) {
			irq.clear();
			cpu.raise(0);
		}
	}
}
