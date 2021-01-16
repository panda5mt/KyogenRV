void put32(unsigned int, unsigned int);
void dummy (void);

#define GPIO_BASE         0x8000

int main(int argc, char *argv[])
{
    unsigned int rx;

    while (1) {
     put32(GPIO_BASE, 0xAA);
        for (rx = 0; rx < 600000; rx++) dummy();
        put32(GPIO_BASE, 0x55);
        for (rx = 0; rx < 600000; rx++) dummy();
        put32(GPIO_BASE, 0xAA);
    }
    return 0;
}