#include <stdint.h>
#include "qsys_mem_map.h"

void put32(uint32_t, uint32_t);
uint32_t get32(uint32_t);
uint32_t get_timel(void);
uint32_t get_timeh(void);
void dummy (void);

#define XTAL_FREQ_KHZ   70000 // 70000kHz = 70MHz

// wait msec counter
void wait_ms(uint64_t msec) {
    volatile uint64_t oldtime;
    volatile uint64_t comp;
    comp = XTAL_FREQ_KHZ * msec;
    oldtime = get_timel();
    while((get_timel()-oldtime) < comp);
}

// main function
int main(int argc, char *argv[]) {

    while (1) {
        wait_ms(500);
        put32(PIO_0_BASE, 0x55);
        wait_ms(500);
        put32(PIO_0_BASE, 0xAA);
    }
    return 0;
}
