#include <stdio.h>
#include <stdint.h>
#include "xprintf.h"
#include "krv_utils.h"


// exception
void __expr(void) {
    xprintf("program exception....\r\n");
    xprintf("cpu stop.\r\n");
    while(1);
}

// wait msec counter
void wait_ms(uint64_t msec) {
    volatile uint64_t oldtime, nowtime;
    volatile uint64_t comp;

    comp = XTAL_FREQ_KHZ * msec;
    oldtime = (((uint64_t)get_timeh() * 4294967296UL) + (uint64_t)get_timel());

    while(1) {
        nowtime = (((uint64_t)get_timeh() * 4294967296UL) + (uint64_t)get_timel());
        if((nowtime-oldtime) > comp) break;
    }
}
// get machine time (uint:msec)

uint64_t get_time_ms(void) {
    uint64_t i;
    i = (((uint64_t)get_timeh() * 4294967296) + (uint64_t)get_timel()) / (XTAL_FREQ_KHZ);
    return i;
}

// xprintf companion
void uart_putc(char ch) {
    volatile uint32_t status;

    while(1){
        status = get32(UART_0_BASE + 8) & 0x20;
        if (status > 0) break;
    }
    put32(UART_0_BASE + 4, ch);
    return;
}

