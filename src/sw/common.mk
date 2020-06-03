AS = riscv64-unknown-elf-as
OBJCOPY = riscv64-unknown-elf-objcopy


asm: $(ASM_DIR)/$(ASM_TARGET).hex

$(ASM_DIR)/$(ASM_TARGET).hex: $(ASM_DIR)/$(ASM_TARGET).bin
ifeq  ($(shell uname),Darwin)
	god -An -v -tx4 -w4 $< > $@
else
	od -An -v -tx4 -w4 $< > $@
endif
$(ASM_DIR)/$(ASM_TARGET).bin: $(ASM_DIR)/$(ASM_TARGET).elf
	$(OBJCOPY) --gap-fill 0 -O binary $< $@

$(ASM_DIR)/$(ASM_TARGET).elf: $(ASM_DIR)/$(ASM_TARGET).s
	$(AS) -o $@ -c $<
