#pragma once

// pushbutton keypad matrix
// see schematic: http://retro.hansotten.nl/6502-sbc/6530-6532/chessmate/#specs
class keypad: public serial_kbd {
public:
	int read();
	bool available();
	void reset();
};
