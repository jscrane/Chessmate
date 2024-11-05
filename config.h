#ifndef __CONFIG_H
#define __CONFIG_H

#define CPU_INSTRUCTIONS	1000

#define BG_COLOUR	BLACK
#define FG_COLOUR	RED
#define ORIENT		portrait
#define DISPLAY_X	180
#define DISPLAY_Y	200

#if !defined(SCR_DISPLAY) && !defined(SS_DISPLAY)
//#define SCR_DISPLAY
#define SS_DISPLAY
#endif

#endif
