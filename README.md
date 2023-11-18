# Commodore CHESSmate

An emulation of the [Commodore CHESSmate](https://commodore.international/2022/03/26/the-history-of-the-commodore-chessmate/)
based on information from [Hans Otten](http://retro.hansotten.nl/6502-sbc/6530-6532/chessmate/).

Inspired by an article on [Hackaday](https://hackaday.com/2023/11/14/the-quaint-history-of-the-commodore-chessmate/)!

<img src="docs/e2e4.png" width="235" height="350"/>

## Software

- [6502 Emulation](https://github.com/jscrane/r65emu) library,
- Arduino IDE or [uC-Makefile](https://github.com/jscrane/uC-Makefile),
- [ESP8266 for Arduino](https://github.com/esp8266/Arduino.git)
- [TFT_eSPI](https://github.com/Bodmer/TFT_eSPI) library.

## Hardware

- An ESP8266 board, e.g., [WeMOS](https://www.wemos.cc/en/latest/d1/d1_mini.html),
- A display supported by TFT_eSPI, e.g., ILI9341,
- A PS/2 keyboard.

