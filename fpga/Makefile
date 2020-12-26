RISCVGNU = riscv32-unknown-elf

AOPS = -march=rv32i -mabi=ilp32
COPS = -march=rv32i -mabi=ilp32 -Wall -O0
#-g  -nostdlib -nostartfiles -ffreestanding
#COPS = -march=rv32imac -Wall -O2  -nostdlib -nostartfiles -ffreestanding

all : blinker.hex

clean :
	rm -f *.elf
	rm -f *.bin
	rm -f *.hex
	rm -f *.list

utils.o : utils.S
	$(RISCVGNU)-as $(AOPS) utils.S -o utils.o

led.o : led.c
	$(RISCVGNU)-gcc $(COPS) -c led.c -o led.o

blinker.elf : linker.ld utils.o led.o
	$(RISCVGNU)-ld utils.o led.o -T linker.ld -o blinker.elf

blinker.bin: blinker.elf
	$(RISCVGNU)-objcopy --gap-fill 0 -O binary blinker.elf blinker.bin


blinker.hex: blinker.bin
ifeq  ($(shell uname),Darwin)
	god -An -v -tx4 -w4 blinker.bin > blinker.hex
else
	od -An -v -tx4 -w4 blinker.bin > blinker.hex
endif