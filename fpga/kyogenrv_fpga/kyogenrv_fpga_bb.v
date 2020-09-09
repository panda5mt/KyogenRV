
module kyogenrv_fpga (
	clk_clk,
	kyogenrv_0_expc_readdata,
	pio_0_external_connection_export,
	reset_reset_n);	

	input		clk_clk;
	output	[31:0]	kyogenrv_0_expc_readdata;
	output	[31:0]	pio_0_external_connection_export;
	input		reset_reset_n;
endmodule
