void put32(unsigned int, unsigned int);
unsigned int get32(unsigned int);
unsigned int get_timel(void);
unsigned int get_timeh(void);

void dummy (void);

#define GPIO_BASE         0x8000


int main(int argc, char *argv[]) {
    volatile int oldtime;
    while (1) {
        oldtime = get_timel();
        while((get_timel()-oldtime) < 0x2160000);
        put32(GPIO_BASE, 0x55);
        oldtime = get_timel();
        while((get_timel()-oldtime) < 0x2160000);
        put32(GPIO_BASE, 0xAA);
    }
    return 0;
}