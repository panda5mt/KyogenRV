SBT = sbt
TARGET = fpga/chisel_generated

#all:
#	$(clean)
#	$(hdl)

# Generate Verilog code
hdl:
	$(SBT) 'runMain core.kyogenrv --target-dir $(TARGET)'

test:
	$(SBT) 'runMain core.Test'

clean:
	rm -rf $(TARGET)/*.json $(TARGET)/*.fir $(TARGET)/*.v



build:

$(ASM_TARGET).hex : $(ASM_TARGET).bin
	od -tx4 -v -w4 -Ax $^ | sed 's/^/0x/g' | gawk -F ' ' '{printf "@%08x %s\n", rshift(strtonum($$1), 2), $$2}' > $@

$(ASM_TARGET).bin : $(ASM_TARGET).elf
	riscv64-unknown-elf-objcopy --gap-fill 0 -O binary $^ $@

$(ASM_TARGET).elf : $(ASM_TARGET).s
	riscv64-unknown-elf-as $^ -o $@