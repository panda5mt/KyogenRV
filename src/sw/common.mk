AS = riscv64-unknown-elf-as
OBJCOPY = riscv64-unknown-elf-objcopy


asm: $(ASM_DIR)/$(ASM_TARGET).hex 

$(ASM_DIR)/$(ASM_TARGET).hex: $(ASM_DIR)/$(ASM_TARGET).bin
	od -An -v -tx4 -w4 $< >> $@

$(ASM_DIR)/$(ASM_TARGET).bin: $(ASM_DIR)/$(ASM_TARGET).o
	$(OBJCOPY) --gap-fill 0 -O binary $< $@
	
$(ASM_DIR)/$(ASM_TARGET).o: $(ASM_DIR)/$(ASM_TARGET).s
	$(AS) -o $@ -c $<
