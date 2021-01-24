#include <stdio.h>
#include <stdint.h>
#include "qsys_mem_map.h"
#include "xprintf.h"

void put32(uint32_t, uint32_t);
uint32_t get32(uint32_t);
uint32_t get_timel(void);
uint32_t get_timeh(void);
void dummy (void);

#define XTAL_FREQ_KHZ   70000 // 70000kHz = 70MHz

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

void uart_putc(char ch) {
    volatile uint32_t status;

    while(1){
        status = get32(UART_0_BASE + 8) & 0x20;
        if (status > 0) break;
    }
    put32(UART_0_BASE + 4, ch);
    return;
}

void uart_puts(char *ch) {
    char a;

    while(1){
        a = *ch++;
        if(a == '\0') return;
        uart_putc(a);
    }
    return;
}

// main function
int main(int argc, char *argv[]) {
    uint64_t i;
    xdev_out(&uart_putc);

    xprintf("KyogenRV (RV32I) Start...\r\n");
    while(1){
        wait_ms(500);
        put32(PIO_0_BASE, 0x55);
        wait_ms(500);
        put32(PIO_0_BASE, 0xAA);

        i = (((uint64_t)get_timeh() * 4294967296) + (uint64_t)get_timel());
        i = i / (XTAL_FREQ_KHZ * 1000);
        xprintf("machine time = %llu second\r\n",i);
    }
    return 0;
}
