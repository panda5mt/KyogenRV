SBT = sbt
TARGET = fpga/chisel_generated
#all:
#	$(clean)
#	$(hdl)

# Generate Verilog code
hdl:
	$(SBT) 'runMain core.kyogenrv --target-dir $(TARGET)'

hello:
	$(SBT) 'runMain Hello'

clean:
	rm -rf $(TARGET)/*.json $(TARGET)/*.fir $(TARGET)/*.v
