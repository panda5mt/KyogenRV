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

    while(1){
        for(int i=0;i<4;i++) {
            wait_ms(100);
            put32(PIO_0_BASE, 0x55);
            wait_ms(100);
            put32(PIO_0_BASE, 0xAA);
        }
    uart_puts("UART test...\r\n");
    }
    return 0;
}
