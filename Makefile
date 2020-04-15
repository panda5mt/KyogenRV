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
