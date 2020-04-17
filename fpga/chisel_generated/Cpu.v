module IMem(
  input         clock,
  input         reset,
  input         io_r_ach_req,
  input  [31:0] io_r_ach_addr,
  output        io_r_dch_ack,
  output [31:0] io_r_dch_data,
  input         io_w_ach_req,
  input  [31:0] io_w_ach_addr,
  input  [31:0] io_w_dch_data
);
  reg [31:0] mem [0:255]; // @[imem.scala 13:30]
  reg [31:0] _RAND_0;
  wire [31:0] mem__T_1_data; // @[imem.scala 13:30]
  wire [7:0] mem__T_1_addr; // @[imem.scala 13:30]
  wire [31:0] mem__T_4_data; // @[imem.scala 13:30]
  wire [7:0] mem__T_4_addr; // @[imem.scala 13:30]
  wire  mem__T_4_mask; // @[imem.scala 13:30]
  wire  mem__T_4_en; // @[imem.scala 13:30]
  reg  mem__T_1_en_pipe_0;
  reg [31:0] _RAND_1;
  reg [7:0] mem__T_1_addr_pipe_0;
  reg [31:0] _RAND_2;
  reg  i_ack; // @[imem.scala 15:26]
  reg [31:0] _RAND_3;
  reg  i_req; // @[imem.scala 16:26]
  reg [31:0] _RAND_4;
  assign mem__T_1_addr = mem__T_1_addr_pipe_0;
  assign mem__T_1_data = mem[mem__T_1_addr]; // @[imem.scala 13:30]
  assign mem__T_4_data = io_w_dch_data;
  assign mem__T_4_addr = io_w_ach_addr[7:0];
  assign mem__T_4_mask = 1'h1;
  assign mem__T_4_en = io_w_ach_req;
  assign io_r_dch_ack = i_ack; // @[imem.scala 25:21]
  assign io_r_dch_data = mem__T_1_data; // @[imem.scala 23:21]
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
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  i_ack = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  i_req = _RAND_4[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(mem__T_4_en & mem__T_4_mask) begin
      mem[mem__T_4_addr] <= mem__T_4_data; // @[imem.scala 13:30]
    end
    mem__T_1_en_pipe_0 <= 1'h1;
    mem__T_1_addr_pipe_0 <= io_r_ach_addr[7:0];
    i_ack <= reset | i_req;
    if (reset) begin
      i_req <= 1'h0;
    end else begin
      i_req <= io_r_ach_req;
    end
  end
endmodule
module Cpu(
  input         clock,
  input         reset,
  output        io_r_ach_req,
  output [31:0] io_r_ach_addr,
  input         io_r_dch_ack,
  input  [31:0] io_r_dch_data,
  output        io_w_ach_req,
  output [31:0] io_w_ach_addr,
  input         io_w_dch_ack,
  output [31:0] io_w_dch_data,
  input         io_sw_halt,
  input         io_sw_rw,
  output [31:0] io_sw_data,
  input  [31:0] io_sw_wData,
  input  [31:0] io_sw_wAddr
);
  wire  memory_clock; // @[core.scala 41:24]
  wire  memory_reset; // @[core.scala 41:24]
  wire  memory_io_r_ach_req; // @[core.scala 41:24]
  wire [31:0] memory_io_r_ach_addr; // @[core.scala 41:24]
  wire  memory_io_r_dch_ack; // @[core.scala 41:24]
  wire [31:0] memory_io_r_dch_data; // @[core.scala 41:24]
  wire  memory_io_w_ach_req; // @[core.scala 41:24]
  wire [31:0] memory_io_w_ach_addr; // @[core.scala 41:24]
  wire [31:0] memory_io_w_dch_data; // @[core.scala 41:24]
  reg [31:0] r_addr; // @[core.scala 46:26]
  reg [31:0] _RAND_0;
  reg [31:0] r_data; // @[core.scala 47:26]
  reg [31:0] _RAND_1;
  reg  r_ack; // @[core.scala 50:26]
  reg [31:0] _RAND_2;
  reg  w_req; // @[core.scala 52:26]
  reg [31:0] _RAND_3;
  reg [31:0] w_addr; // @[core.scala 54:26]
  reg [31:0] _RAND_4;
  reg [31:0] w_data; // @[core.scala 55:26]
  reg [31:0] _RAND_5;
  wire  _T; // @[core.scala 57:22]
  wire [31:0] _T_3; // @[core.scala 59:30]
  wire  _GEN_3; // @[core.scala 66:34]
  IMem memory ( // @[core.scala 41:24]
    .clock(memory_clock),
    .reset(memory_reset),
    .io_r_ach_req(memory_io_r_ach_req),
    .io_r_ach_addr(memory_io_r_ach_addr),
    .io_r_dch_ack(memory_io_r_dch_ack),
    .io_r_dch_data(memory_io_r_dch_data),
    .io_w_ach_req(memory_io_w_ach_req),
    .io_w_ach_addr(memory_io_w_ach_addr),
    .io_w_dch_data(memory_io_w_dch_data)
  );
  assign _T = ~io_sw_halt; // @[core.scala 57:22]
  assign _T_3 = r_addr + 32'h4; // @[core.scala 59:30]
  assign _GEN_3 = io_sw_rw | w_req; // @[core.scala 66:34]
  assign io_r_ach_req = 1'h1; // @[core.scala 76:19]
  assign io_r_ach_addr = r_addr; // @[core.scala 75:19]
  assign io_w_ach_req = w_req; // @[core.scala 90:18]
  assign io_w_ach_addr = w_addr; // @[core.scala 88:19]
  assign io_w_dch_data = w_data; // @[core.scala 89:19]
  assign io_sw_data = r_data; // @[core.scala 74:17]
  assign memory_clock = clock;
  assign memory_reset = reset;
  assign memory_io_r_ach_req = io_r_ach_req; // @[core.scala 82:26]
  assign memory_io_r_ach_addr = r_addr; // @[core.scala 84:26]
  assign memory_io_w_ach_req = io_w_ach_req; // @[core.scala 95:25]
  assign memory_io_w_ach_addr = io_w_ach_addr; // @[core.scala 96:26]
  assign memory_io_w_dch_data = io_w_dch_data; // @[core.scala 97:26]
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
  r_addr = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  r_data = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  r_ack = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  w_req = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  w_addr = _RAND_4[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  w_data = _RAND_5[31:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      r_addr <= 32'h0;
    end else if (_T) begin
      if (r_ack) begin
        r_addr <= _T_3;
      end
    end
    if (reset) begin
      r_data <= 32'h0;
    end else begin
      r_data <= memory_io_r_dch_data;
    end
    if (reset) begin
      r_ack <= 1'h0;
    end else begin
      r_ack <= memory_io_r_dch_ack;
    end
    if (reset) begin
      w_req <= 1'h0;
    end else if (!(_T)) begin
      w_req <= _GEN_3;
    end
    if (reset) begin
      w_addr <= 32'h0;
    end else if (!(_T)) begin
      if (io_sw_rw) begin
        w_addr <= io_sw_wData;
      end
    end
    if (reset) begin
      w_data <= 32'h0;
    end else if (!(_T)) begin
      if (io_sw_rw) begin
        w_data <= io_sw_wData;
      end
    end
  end
endmodule
