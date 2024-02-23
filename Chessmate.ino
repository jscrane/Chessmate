#include <r65emu.h>
#include <r6502.h>
#include <line.h>

#include "disp.h"
#include "ccmk2.h"
#include "openings.h"
#include "riot.h"
#include "io.h"
#include "config.h"

Line irq;
prom game(ccmk2, sizeof(ccmk2));
prom opens(openings, sizeof(openings));
r6502 cpu(memory);
ram<256> zpage, stack;
io io(irq);

void reset() {

	hardware_reset();
	io.reset();
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
	reset();
}

void loop() {

#if defined(CPU_DEBUG)
        static bool cpu_debug = CPU_DEBUG;
#endif

	if (ps2.available()) {
		unsigned scan = ps2.read2();
		byte key = scan & 0xff;
		if (is_down(scan))
			io.down(key);
		else
			switch (key) {
			case PS2_F1:
				reset();
				break;
#if defined(CPU_DEBUG)
			case PS2_F10:
				cpu_debug = !cpu_debug;
				break;
#endif
			default:
				io.up(key);
			}
	} else if (!cpu.halted()) {
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
