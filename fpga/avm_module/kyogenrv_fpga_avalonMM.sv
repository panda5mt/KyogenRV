
module kyogenrv_fpga_avalonMM (

	input       		clock,
	input				reset,
		// instruction memory IF
	output				r_imem_data_req,
	output  [31:0]		imem_addr,
	input				r_imem_data_ack,
	input	[31:0]		r_imem_data,
	
	output				w_imem_data_req,
	//output	[31:0]	w_imem_addr,
	//input	      		w_imem_data_ack,
	output	[31:0]		w_imem_data,
	output	[3:0]		w_imem_data_byteenable,
	input				imem_waitrequest,

	// data memory IF
	output      		r_dmem_data_req,
	output 	[31:0]		dmem_addr,
	input		      	r_dmem_data_ack,
	input	[31:0]		r_dmem_data,
	
	output	      		w_dmem_data_req,
	//output	[31:0]	w_dmem_addr,
	//input		      	w_dmem_data_ack,
	output	[31:0]		w_dmem_data,
	output	[3:0] 		w_dmem_data_byteenable,
	input				dmem_waitrequest,
	
	output	[31:0]		ex_pc_addr

);

logic	waitrequest;
//logic	waitreqdata;

assign	waitrequest = (r_imem_data_req & imem_waitrequest) | ((r_dmem_data_req | w_dmem_data_req) & dmem_waitrequest);
//assign	waitreqdata = ((r_dmem_data_req | w_dmem_data_req) & dmem_waitrequest);
	
	



KyogenRVCpu krv(

  /*input        */ .clock						(clock),
  /*input        */ .reset						(reset),
  /*output       */ .io_r_imem_dat_req			(r_imem_data_req),
  /*output [31:0]*/ .io_imem_add_addr			(imem_addr),
  /*input        */ .io_r_imem_dat_ack			(r_imem_data_ack),
  /*input  [31:0]*/ .io_r_imem_dat_data			(r_imem_data),
  
  /*output       */ .io_w_imem_dat_req			(w_imem_data_req),
  /*input        */ .io_w_imem_dat_ack			(1'b0),
  /*output [31:0]*/ .io_w_imem_dat_data			(w_imem_data),
  /*output [3:0] */ .io_w_imem_dat_byteenable	(w_imem_data_byteenable),
  
  /*output       */ .io_r_dmem_dat_req			(r_dmem_data_req),
  /*output [31:0]*/ .io_dmem_add_addr			(dmem_addr),
  /*input        */ .io_r_dmem_dat_ack			(r_dmem_data_ack),
  /*input  [31:0]*/ .io_r_dmem_dat_data			(r_dmem_data),
  
  /*output       */ .io_w_dmem_dat_req			(w_dmem_data_req),
  /*input        */ .io_w_dmem_dat_ack			(1'b1),
  /*output [31:0]*/ .io_w_dmem_dat_data			(w_dmem_data),
  /*output [3:0] */ .io_w_dmem_dat_byteenable	(w_dmem_data_byteenable),
  
  // debug system
  
  /*input        */ .io_sw_halt						(1'b0),
  /*output [31:0]*/ .io_sw_r_add						(),
  /*output [31:0]*/ .io_sw_r_dat						(),
  /*input  [31:0]*/ .io_sw_w_add						(1'b0),
  /*input  [31:0]*/ .io_sw_w_dat						(1'b0),
  /*input  [31:0]*/ .io_sw_g_add						(1'b0),
  /*output [31:0]*/ .io_sw_g_dat						(1'b0),
  /*output [31:0]*/ .io_sw_r_pc						(),
  /*input  [31:0]*/ .io_sw_w_pc						(),
  /*output [31:0]*/ .io_sw_r_ex_raddr1				(),
  /*output [31:0]*/ .io_sw_r_ex_raddr2				(),
  /*output [31:0]*/ .io_sw_r_ex_rs1					(),
  /*output [31:0]*/ .io_sw_r_ex_rs2					(),
  /*output [31:0]*/ .io_sw_r_ex_imm					(),
  /*output [31:0]*/ .io_sw_r_mem_alu_out			(),
  /*output [31:0]*/ .io_sw_r_wb_alu_out			(),
  /*output [31:0]*/ .io_sw_r_wb_rf_wdata			(),
  /*output [31:0]*/ .io_sw_r_wb_rf_waddr			(),
  /*output [31:0]*/ .io_sw_r_stall_sig				(),
  /*input        */ .io_sw_w_interrupt_sig		(1'b0),
					.io_sw_w_waitrequest_sig	(waitrequest)
);

endmodule: kyogenrv_fpga_avalonMM
