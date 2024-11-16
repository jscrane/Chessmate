t ?= esp8266

TERMINAL_SPEED := 115200
#CPPFLAGS = -Wall -DNO_STORAGE -DNO_SPIRAM -DUSE_OWN_KBD -DPS2_SERIAL_KBD=\"UK\"
CPPFLAGS = -Wall -DNO_STORAGE -DNO_SPIRAM -DUSE_OWN_KBD -DHW_SERIAL_KBD
CPPFLAGS += -DDEBUGGING -DCPU_DEBUG=false -DTERMINAL_SPEED=$(TERMINAL_SPEED)
LIBRARIES = SPI PS2KeyAdvanced PS2KeyMap SimpleTimer

ifeq ($t, tivac)
BOARD := EK-LM4F120XL
CPPFLAGS += -DHARDWARE_H=\"hw/stellarpad-example.h\"
LIBRARIES += UTFT
endif

ifeq ($t, esp8266)
BOARD := d1_mini
BAUD := 921600
XTAL := 80
F_CPU := 80
EESZ := 4M
CPPFLAGS += -DUSER_SETUP_LOADED -DILI9341_DRIVER -DTFT_CS=PIN_D8 -DTFT_DC=PIN_D1 \
	-DTFT_RST=-1 -DSPI_FREQUENCY=40000000 -DLOAD_GLCD -DHARDWARE_H=\"hw/esp8bit.h\"
LIBRARIES += TFT_eSPI
endif

ifeq ($t, esp32)
UPLOADSPEED := 921600

ifeq ($b, lilygo)
BOARD := ttgo-t7-v14-mini32
SERIAL_PORT := /dev/ttyACM0
CPPFLAGS += -DHARDWARE_H=\"hw/ttgo-t7-v14-mini32.h\"
LIBRARIES += FabGL WiFi

else
BOARD := lolin32
CPPFLAGS += -DUSER_SETUP_LOADED -DILI9341_DRIVER -DTFT_CS=5 -DTFT_DC=2 \
	-DTFT_RST=-1 -DSPI_FREQUENCY=40000000 -DLOAD_GLCD -DHARDWARE_H=\"hw/esp32-example.h\"
LIBRARIES += TFT_eSPI
endif
endif

include $t.mk
