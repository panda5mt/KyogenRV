void put32(unsigned int, unsigned int);
void dummy (unsigned int);

#define GPIO_BASE         0x8000

int main(int argc, char *argv[])
{
    unsigned int rx;

    while (1) {
        put32(GPIO_BASE, 0x55);
        for (rx = 0; rx < 2000000; rx++) dummy(rx);
        put32(GPIO_BASE, 0xAA);
        for (rx = 0; rx < 2000000; rx++) dummy(rx);
    }
    return 0;
}