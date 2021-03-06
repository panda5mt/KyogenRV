RISCVGNU = riscv32-unknown-elf

MEMMAP = $(ASM_DIR)/linker.ld
AOPS = --warn -march=rv32i -mabi=ilp32
COPS = -Wall -march=rv32i -mabi=ilp32 -O2 -nostartfiles -ffreestanding
COPS2 = -Wall -march=rv32i -mabi=ilp32 -O2 -nostartfiles -ffreestanding -Xlinker -T -Xlinker $(MEMMAP)

c_all : c_reverse $(ASM_DIR)/blinker.hex


c_clean :
	rm -f $(ASM_DIR)/*.elf
	rm -f $(ASM_DIR)/*.bin
	rm -f $(ASM_DIR)/*.list
	rm -f $(ASM_DIR)/*.o
#	rm -f $(ASM_DIR)/*.hex

c_reverse : $(ASM_DIR)/blinker.elf
	$(RISCVGNU)-objdump -d $(ASM_DIR)/blinker.elf > $(ASM_DIR)/blinker.dump

$(ASM_DIR)/utils.o : $(ASM_DIR)/utils.S
	$(RISCVGNU)-as $(AOPS) $(ASM_DIR)/utils.S -o $(ASM_DIR)/utils.o

$(ASM_DIR)/main.o : $(ASM_DIR)/main.c
	$(RISCVGNU)-gcc $(COPS) -c $(ASM_DIR)/main.c -o $(ASM_DIR)/main.o
	$(RISCVGNU)-gcc $(COPS) -c $(ASM_DIR)/krv_utils.c -o $(ASM_DIR)/krv_utils.o
	$(RISCVGNU)-gcc $(COPS) -c $(ASM_DIR)/xprintf.c -o $(ASM_DIR)/xprintf.o
	$(RISCVGNU)-gcc $(COPS) -c $(ASM_DIR)/qsys_i2c.c -o $(ASM_DIR)/qsys_i2c.o
	$(RISCVGNU)-gcc $(COPS) -c $(ASM_DIR)/VL53L1X.c -o $(ASM_DIR)/VL53L1X.o

$(ASM_DIR)/blinker.elf : $(ASM_DIR)/VL53L1X.o $(ASM_DIR)/linker.ld $(ASM_DIR)/utils.o $(ASM_DIR)/main.o
	$(RISCVGNU)-gcc $(COPS2) $(ASM_DIR)/utils.o $(ASM_DIR)/xprintf.o $(ASM_DIR)/krv_utils.o $(ASM_DIR)/qsys_i2c.o $(ASM_DIR)/VL53L1X.o $(ASM_DIR)/main.o -lgcc -o $(ASM_DIR)/blinker.elf
#	$(RISCVGNU)-gcc $(COPS2)  $(ASM_DIR)/utils.o $(ASM_DIR)/xprintf.o $(ASM_DIR)/krv_utils.o $(ASM_DIR)/main.o -lgcc -o $(ASM_DIR)/blinker.elf

$(ASM_DIR)/blinker.bin: $(ASM_DIR)/blinker.elf
	$(RISCVGNU)-objcopy --gap-fill 0 -O binary $(ASM_DIR)/blinker.elf $(ASM_DIR)/blinker.bin


$(ASM_DIR)/blinker.hex: $(ASM_DIR)/blinker.bin
ifeq  ($(shell uname),Darwin)
	god -An -v -tx4 -w4 $(ASM_DIR)/blinker.bin > $(ASM_DIR)/blinker.hex
else
	od -An -v -tx4 -w4 $(ASM_DIR)/blinker.bin > $(ASM_DIR)/blinker.hex
endif