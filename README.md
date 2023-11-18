# Commodore CHESSmate

An emulation of the [Commodore CHESSmate](https://commodore.international/2022/03/26/the-history-of-the-commodore-chessmate/)
based on information from [Hans Otten](http://retro.hansotten.nl/6502-sbc/6530-6532/chessmate/).

Inspired by an article on [Hackaday](https://hackaday.com/2023/11/14/the-quaint-history-of-the-commodore-chessmate/)!

<img src="docs/e2e4.png" width="235" height="350"/>

## Software

### Common
- [6502 Emulation](https://github.com/jscrane/r65emu) library
- Arduino IDE or [uC-Makefile](https://github.com/jscrane/uC-Makefile)

Please [configure](https://github.com/jscrane/r65emu#configuration-for-arduino) the Emulation library for your hardware.

### ESP8266
- [ESP8266 Arduino core](https://github.com/esp8266/Arduino.git)
- [TFT_eSPI](https://github.com/Bodmer/TFT_eSPI) library

Please [configure](https://github.com/Bodmer/TFT_eSPI/blob/master/User_Setup_Select.h) TFT_eSPI for your hardware.

### ESP32
- [ESP32 Arduino core](https://github.com/espressif/arduino-esp32)
- [FabGL](https://github.com/fdivitto/FabGL)

## Hardware

### Common
- A PS/2 keyboard

### ESP8266
- A board, e.g., [WeMOS](https://www.wemos.cc/en/latest/d1/d1_mini.html)
- A display supported by TFT_eSPI, e.g., ILI9341

### ESP32
- A board, e.g., [LilyGO TTGO](https://www.tinytronics.nl/shop/en/development-boards/microcontroller-boards/with-wi-fi/lilygo-ttgo-vga32-esp32)
