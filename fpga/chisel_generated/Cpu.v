module IMem(
  input         clock,
  input  [31:0] io_r_ach_addr,
  output [31:0] io_r_dch_data
);
  reg [31:0] mem [0:255]; // @[imem.scala 13:30]
  reg [31:0] _RAND_0;
  wire [31:0] mem__T_1_data; // @[imem.scala 13:30]
  wire [7:0] mem__T_1_addr; // @[imem.scala 13:30]
  reg  mem__T_1_en_pipe_0;
  reg [31:0] _RAND_1;
  reg [7:0] mem__T_1_addr_pipe_0;
  reg [31:0] _RAND_2;
  assign mem__T_1_addr = mem__T_1_addr_pipe_0;
  assign mem__T_1_data = mem[mem__T_1_addr]; // @[imem.scala 13:30]
  assign io_r_dch_data = mem__T_1_data; // @[imem.scala 18:20]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  _RAND_0 = {1{`RANDOM}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    mem[initvar] = _RAND_0[31:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  mem__T_1_en_pipe_0 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  mem__T_1_addr_pipe_0 = _RAND_2[7:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    mem__T_1_en_pipe_0 <= 1'h1;
    mem__T_1_addr_pipe_0 <= io_r_ach_addr[7:0];
  end
endmodule
module Cpu(
  input         clock,
  input         reset,
  output        io_ach_req,
  output [31:0] io_ach_addr,
  input         io_dch_ack,
  input  [31:0] io_dch_data,
  input         io_sw_halt,
  output        io_sw_rw,
  output [31:0] io_sw_data
);
  wire  memory_clock; // @[core.scala 30:24]
  wire [31:0] memory_io_r_ach_addr; // @[core.scala 30:24]
  wire [31:0] memory_io_r_dch_data; // @[core.scala 30:24]
  reg [31:0] i_addr; // @[core.scala 35:26]
  reg [31:0] _RAND_0;
  reg [31:0] i_data; // @[core.scala 36:26]
  reg [31:0] _RAND_1;
  wire  _T; // @[core.scala 40:22]
  wire [31:0] _T_2; // @[core.scala 42:30]
  IMem memory ( // @[core.scala 30:24]
    .clock(memory_clock),
    .io_r_ach_addr(memory_io_r_ach_addr),
    .io_r_dch_data(memory_io_r_dch_data)
  );
  assign _T = ~io_sw_halt; // @[core.scala 40:22]
  assign _T_2 = i_addr + 32'h4; // @[core.scala 42:30]
  assign io_ach_req = 1'h1; // @[core.scala 49:17]
  assign io_ach_addr = i_addr; // @[core.scala 48:17]
  assign io_sw_rw = 1'h0; // @[core.scala 47:17]
  assign io_sw_data = i_data; // @[core.scala 46:17]
  assign memory_clock = clock;
  assign memory_io_r_ach_addr = io_ach_addr; // @[core.scala 53:26]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  i_addr = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  i_data = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      i_addr <= 32'h0;
    end else if (_T) begin
      i_addr <= _T_2;
    end
    if (reset) begin
      i_data <= 32'h0;
    end else begin
      i_data <= memory_io_r_dch_data;
    end
  end
endmodule
