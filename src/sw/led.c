void put32(unsigned int, unsigned int);
unsigned int get32(unsigned int);
unsigned int get_timel(void);
unsigned int get_timeh(void);
void dummy (void);

#define GPIO_BASE       0x8000
#define XTAL_FREQ_KHZ   70000 // 70000kHz = 70MHz

// wait msec counter
void wait_ms(unsigned int msec) {
    volatile unsigned int oldtime, comp;
    comp = XTAL_FREQ_KHZ * msec;
    oldtime = get_timel();
    while((get_timel()-oldtime) < comp);
 }

// main function
int main(int argc, char *argv[]) {

    while (1) {
        wait_ms(500);
        put32(GPIO_BASE, 0x55);
        wait_ms(500);
        put32(GPIO_BASE, 0xAA);
    }
    return 0;
}