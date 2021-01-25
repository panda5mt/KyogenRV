module kyogenrv_fpga_top (

	input       		CY10_CLK_24M ,
	input					reset,
	output	[7:0] 	pio,
	output				uart_tx,
	input					uart_rx,
	
	output               [11:0]     DRAM_ADDR,
	output                [1:0]     DRAM_BA,
	output                          DRAM_CAS_N,
	output                          DRAM_CKE,
	output                          DRAM_CLK,
	output                          DRAM_CS_N,
	inout                [15:0]     DRAM_DQ,
	output                          DRAM_LDQM,
	output                          DRAM_RAS_N,
	output                          DRAM_UDQM,
	output                          DRAM_WE_N

);

// reset and clocking logic
logic					pll_locked;
logic					clk_riscv;
//logic					clk_qsys_sdram;
//logic					clk_qsys;
logic					rst_in;
logic		[2:1] 	rst_in_d;
logic					rst_n;
logic					pwrup_rst_n;
logic		[31:0]	ex_inst;



assign pwrup_rst_n 	= pll_locked;
assign rst_in 			= reset & pwrup_rst_n;


always_ff @(posedge clk_riscv, negedge rst_in)
begin
    if (~rst_in)    rst_in_d <= '0;
    else            rst_in_d <= {rst_in_d[1], rst_in};

end

assign rst_n = rst_in_d[2];
	
pll pll0(
	.inclk0			(CY10_CLK_24M),
	.c0				(clk_riscv),
	.c1				(DRAM_CLK),
//	.c2				(clk_qsys_sdram),
	.locked        (pll_locked)
);
	
	
	
	
// avalon-MM module	
 kyogenrv_fpga u0 (
		.clk_clk                          (clk_riscv),                          // 
		.pio_0_external_connection_export (pio), // pio_0_external_connection.export
		.kyogenrv_0_conduit_end_readdata  (ex_inst), 
		.reset_reset_n                    (rst_n),                     //                     reset.reset_n
		.kyogenrv_0_expc_readdata         (),
		.uart_0_external_connection_rxd   (uart_rx),   // uart_0_external_connection.rxd
		.uart_0_external_connection_txd   (uart_tx),   //                           .txd
		.uart_0_irq_irq                   (),

		.new_sdram_controller_0_wire_addr                 (DRAM_ADDR              ),
		.new_sdram_controller_0_wire_ba                   (DRAM_BA                ),
		.new_sdram_controller_0_wire_cas_n                (DRAM_CAS_N             ),
		.new_sdram_controller_0_wire_cke                  (DRAM_CKE               ),

		.new_sdram_controller_0_wire_cs_n                 (DRAM_CS_N              ),
		.new_sdram_controller_0_wire_dq                   (DRAM_DQ                ),
		.new_sdram_controller_0_wire_dqm                  ({DRAM_UDQM,DRAM_LDQM}  ),
		.new_sdram_controller_0_wire_ras_n                (DRAM_RAS_N             ),
		.new_sdram_controller_0_wire_we_n                 (DRAM_WE_N              )
 );

	 
 

 
	


endmodule: kyogenrv_fpga_top
