SBT = sbt
TARGET = fpga/chisel_generated
INCLUDE=src/sw/
ASM_TARGET = test
ASM_DIR = src/sw

include  src/sw/common.mk
include  src/sw/common2.mk
.DEFAULT_GOAL := test
# Generate Verilog code
hdl:
	$(SBT) 'runMain core.kyogenrv --target-dir $(TARGET)'
test: $(ASM_DIR)/$(ASM_TARGET).hex
	$(SBT) 'runMain core.Test'
clean: c_clean
	rm -rf $(TARGET)/*.json $(TARGET)/*.fir $(TARGET)/*.v $(TARGET)/*.hex $(ASM_DIR)/$(ASM_TARGET).elf $(ASM_DIR)/$(ASM_TARGET).bin $(ASM_DIR)/*.hex $(ASM_DIR)/*.log

riscv-tests:
	python3 build_riscv_tests.py
	$(SBT) 'test:testOnly core.TestCoreAll'
tester-gen:
	python3 build_riscv_tests.py


