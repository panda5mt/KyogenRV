#include "qsys_mem_map.h"

#define XTAL_FREQ_KHZ   70000 // 70000kHz = 70MHz

void put32(uint32_t, uint32_t);     // SW
uint32_t get32(uint32_t);           // LW
uint32_t get_timel(void);           // mtime
uint32_t get_timeh(void);           // mtimeh
void dummy (void);                  // nop

void __expr(void);          // exception
void wait_ms(uint64_t);     // wait msec counter
uint64_t get_time_ms(void); // get machine time in msec
void uart_putc(char);       // xprintf companion

