#include <stdio.h>
#include <stdint.h>
#include "krv_utils.h"
#include "xprintf.h"
#include "qsys_i2c.h"

#ifdef SDRAM_0_BASE
int sdram_test(void) {
    uint32_t   data,length;

    length = SDRAM_0_END - SDRAM_0_BASE;

    xprintf("SDRAM write start\r\n");
    for (int k = 0 ; k < length ; k = k + 4) {
        put32(SDRAM_0_BASE + k, k);
    }

    xprintf("SDRAM read start\r\n");
    for (int k = 0 ; k < length ; k = k + 4) {
        data = get32(SDRAM_0_BASE + k);
        if(data != k) {
            xprintf("error fount at 0x%x: expecting %d but got %d\r\n",k,k,data);
            return -1;
        }
    }
    return 0;
}
#endif //SDRAM_0_BASE

// main function
int main(int argc, char *argv[]) {
    uint64_t i;
    xdev_out(&uart_putc);       // override xprintf
#ifdef I2C_0_BASE
    xprintf("I2C OK...\r\n");
#endif
#ifdef SDRAM_0_BASE
    if(0 == sdram_test()) {
        xprintf("SDRAM r/w test OK!\r\n");
    } else {
        xprintf("SDRAM r/w test fail......\r\n");
    }
#endif //SDRAM_0_BASE
    xprintf("KyogenRV (RV32I) Start...\r\n");

    while(1){
        wait_ms(500);
        put32(PIO_0_BASE, 0x55);
        wait_ms(500);
        put32(PIO_0_BASE, 0xAA);

        i = get_time_ms() / 1000;
        xprintf("machine time = %llu second\r\n",i);
    }
    return 0;
}
