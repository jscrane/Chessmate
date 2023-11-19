# Notes

One place where the [circuit diagram](docs/chessmate_schematic.jpg) doesn't help much is the use of the RIOT timer. 
For that, the assembly-language [listing](docs/ccmk2.lst) must be consulted. The [6530 documentation](docs/6530-Commodore.pdf)
is also very helpful.

## Timer

The timer is started by a subroutine at address ```$F0A5```. This stores the value ```$F5``` in timer register ```CLKTI```.
This requests a timer interrupt in ```245 * 1024``` clock cycles  (250880 us). It initializes the players'
quarter-second counters to ```$F1``` (241).

The interrupt handler is labelled ```IRQVECTOR```, address ```$F34C```. After saving the A, X, Y registers, it starts
a new timer for ```$5D``` clocks (93 us), and polls waiting for it to expire.

The zero-page address ```$7E``` contains the current player, 0/1. This is loaded into the X register and used to update the
current player's time. Quarter-seconds are stored at ```$7A``` and ```$7B``` and minutes at ```$7C``` and ```$7D```. When the
quarter-second count reaches 0, it is restored to ```$F0``` (240) and the minute count is incremented; when it reaches 60, 
it is reset to 0.

The last thing it does before restoring registers and returning, is to request a new interrupt in ```244 * 1024``` clocks 
(249856 us).

From all this, we can calculate that the first minute of each clock takes ```245*1024 + 240*(244*1024+93)``` = 60238640 cycles. 
Subsequent minutes take ```240*(244*1024+93)``` = 59987760 cycles. A full hour then takes 3599516480 cycles or 3599.52 seconds.
(This calculation does not include the time taken by the code for the interrupt handler itself, and likely the fine-delay of 93 us was chosen
to get as close to an actual hour as possible, assuming an ideal 1MHz clock.)
