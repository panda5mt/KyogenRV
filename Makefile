SBT = sbt
TARGET = fpga/chisel_generated
INCLUDE=src/sw/
ASM_TARGET = test
ASM_DIR = src/sw

include  src/sw/common.mk

# Generate Verilog code
hdl:
	$(SBT) 'runMain core.kyogenrv --target-dir $(TARGET)'

test:
	$(SBT) 'runMain core.Test'

clean:
	rm -rf $(TARGET)/*.json $(TARGET)/*.fir $(TARGET)/*.v $(ASM_DIR)/$(ASM_TARGET).o $(ASM_DIR)/$(ASM_TARGET).bin $(ASM_DIR)/$(ASM_TARGET).hex

