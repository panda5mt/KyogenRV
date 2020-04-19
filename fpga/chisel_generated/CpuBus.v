module Cpu(
  input         clock,
  input         reset,
  output [31:0] io_r_ach_addr,
  input         io_r_dch_ack,
  input  [31:0] io_r_dch_data,
  output        io_w_ach_req,
  output [31:0] io_w_ach_addr,
  output [31:0] io_w_dch_data,
  input         io_sw_halt,
  input         io_sw_rw,
  output [31:0] io_sw_addr,
  output [31:0] io_sw_data,
  input  [31:0] io_sw_wData,
  input  [31:0] io_sw_wAddr
);
  reg [31:0] r_addr; // @[core.scala 44:26]
  reg [31:0] _RAND_0;
  reg [31:0] r_data; // @[core.scala 45:26]
  reg [31:0] _RAND_1;
  reg  r_ack; // @[core.scala 48:26]
  reg [31:0] _RAND_2;
  reg  w_req; // @[core.scala 50:26]
  reg [31:0] _RAND_3;
  reg [31:0] w_addr; // @[core.scala 52:26]
  reg [31:0] _RAND_4;
  reg [31:0] w_data; // @[core.scala 53:26]
  reg [31:0] _RAND_5;
  wire  _T; // @[core.scala 55:22]
  wire [31:0] _T_3; // @[core.scala 57:30]
  wire  _GEN_3; // @[core.scala 60:34]
  assign _T = ~io_sw_halt; // @[core.scala 55:22]
  assign _T_3 = r_addr + 32'h4; // @[core.scala 57:30]
  assign _GEN_3 = io_sw_rw | w_req; // @[core.scala 60:34]
  assign io_r_ach_addr = r_addr; // @[core.scala 72:21]
  assign io_w_ach_req = w_req; // @[core.scala 78:21]
  assign io_w_ach_addr = w_addr; // @[core.scala 76:21]
  assign io_w_dch_data = w_data; // @[core.scala 77:21]
  assign io_sw_addr = r_addr; // @[core.scala 70:21]
  assign io_sw_data = r_data; // @[core.scala 69:21]
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
    end else if (io_sw_rw) begin
      r_addr <= 32'h0;
    end
    if (reset) begin
      r_data <= 32'h0;
    end else begin
      r_data <= io_r_dch_data;
    end
    if (reset) begin
      r_ack <= 1'h0;
    end else begin
      r_ack <= io_r_dch_ack;
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
        w_addr <= io_sw_wAddr;
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
module IMem(
  input         clock,
  input         reset,
  input  [31:0] io_r_ach_addr,
  output        io_r_dch_ack,
  output [31:0] io_r_dch_data,
  input         io_w_ach_req,
  input  [31:0] io_w_ach_addr,
  input  [31:0] io_w_dch_data
);
  reg [31:0] mem [0:10485759]; // @[imem.scala 13:30]
  reg [31:0] _RAND_0;
  wire [31:0] mem__T_1_data; // @[imem.scala 13:30]
  wire [23:0] mem__T_1_addr; // @[imem.scala 13:30]
  reg [31:0] _RAND_1;
  wire [31:0] mem__T_4_data; // @[imem.scala 13:30]
  wire [23:0] mem__T_4_addr; // @[imem.scala 13:30]
  wire  mem__T_4_mask; // @[imem.scala 13:30]
  wire  mem__T_4_en; // @[imem.scala 13:30]
  reg  mem__T_1_en_pipe_0;
  reg [31:0] _RAND_2;
  reg [23:0] mem__T_1_addr_pipe_0;
  reg [31:0] _RAND_3;
  reg  i_ack; // @[imem.scala 15:26]
  reg [31:0] _RAND_4;
  reg  i_req; // @[imem.scala 16:26]
  reg [31:0] _RAND_5;
  assign mem__T_1_addr = mem__T_1_addr_pipe_0;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign mem__T_1_data = mem[mem__T_1_addr]; // @[imem.scala 13:30]
  `else
  assign mem__T_1_data = mem__T_1_addr >= 24'ha00000 ? _RAND_1[31:0] : mem[mem__T_1_addr]; // @[imem.scala 13:30]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign mem__T_4_data = io_w_dch_data;
  assign mem__T_4_addr = io_w_ach_addr[23:0];
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
  for (initvar = 0; initvar < 10485760; initvar = initvar+1)
    mem[initvar] = _RAND_0[31:0];
  `endif // RANDOMIZE_MEM_INIT
  _RAND_1 = {1{`RANDOM}};
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  mem__T_1_en_pipe_0 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  mem__T_1_addr_pipe_0 = _RAND_3[23:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  i_ack = _RAND_4[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  i_req = _RAND_5[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(mem__T_4_en & mem__T_4_mask) begin
      mem[mem__T_4_addr] <= mem__T_4_data; // @[imem.scala 13:30]
    end
    mem__T_1_en_pipe_0 <= 1'h1;
    mem__T_1_addr_pipe_0 <= io_r_ach_addr[23:0];
    i_ack <= reset | i_req;
    if (reset) begin
      i_req <= 1'h0;
    end else begin
      i_req <= 1'h1;
    end
  end
endmodule
module CpuBus(
  input         clock,
  input         reset,
  input         io_sw_halt,
  input         io_sw_rw,
  output [31:0] io_sw_addr,
  output [31:0] io_sw_data,
  input  [31:0] io_sw_wData,
  input  [31:0] io_sw_wAddr
);
  wire  cpu_clock; // @[core.scala 102:25]
  wire  cpu_reset; // @[core.scala 102:25]
  wire [31:0] cpu_io_r_ach_addr; // @[core.scala 102:25]
  wire  cpu_io_r_dch_ack; // @[core.scala 102:25]
  wire [31:0] cpu_io_r_dch_data; // @[core.scala 102:25]
  wire  cpu_io_w_ach_req; // @[core.scala 102:25]
  wire [31:0] cpu_io_w_ach_addr; // @[core.scala 102:25]
  wire [31:0] cpu_io_w_dch_data; // @[core.scala 102:25]
  wire  cpu_io_sw_halt; // @[core.scala 102:25]
  wire  cpu_io_sw_rw; // @[core.scala 102:25]
  wire [31:0] cpu_io_sw_addr; // @[core.scala 102:25]
  wire [31:0] cpu_io_sw_data; // @[core.scala 102:25]
  wire [31:0] cpu_io_sw_wData; // @[core.scala 102:25]
  wire [31:0] cpu_io_sw_wAddr; // @[core.scala 102:25]
  wire  memory_clock; // @[core.scala 103:25]
  wire  memory_reset; // @[core.scala 103:25]
  wire [31:0] memory_io_r_ach_addr; // @[core.scala 103:25]
  wire  memory_io_r_dch_ack; // @[core.scala 103:25]
  wire [31:0] memory_io_r_dch_data; // @[core.scala 103:25]
  wire  memory_io_w_ach_req; // @[core.scala 103:25]
  wire [31:0] memory_io_w_ach_addr; // @[core.scala 103:25]
  wire [31:0] memory_io_w_dch_data; // @[core.scala 103:25]
  reg  sw_halt; // @[core.scala 94:30]
  reg [31:0] _RAND_0;
  reg [31:0] sw_data; // @[core.scala 95:30]
  reg [31:0] _RAND_1;
  reg [31:0] sw_addr; // @[core.scala 96:30]
  reg [31:0] _RAND_2;
  reg  sw_rw; // @[core.scala 97:30]
  reg [31:0] _RAND_3;
  reg [31:0] sw_wdata; // @[core.scala 98:30]
  reg [31:0] _RAND_4;
  reg [31:0] sw_waddr; // @[core.scala 99:30]
  reg [31:0] _RAND_5;
  Cpu cpu ( // @[core.scala 102:25]
    .clock(cpu_clock),
    .reset(cpu_reset),
    .io_r_ach_addr(cpu_io_r_ach_addr),
    .io_r_dch_ack(cpu_io_r_dch_ack),
    .io_r_dch_data(cpu_io_r_dch_data),
    .io_w_ach_req(cpu_io_w_ach_req),
    .io_w_ach_addr(cpu_io_w_ach_addr),
    .io_w_dch_data(cpu_io_w_dch_data),
    .io_sw_halt(cpu_io_sw_halt),
    .io_sw_rw(cpu_io_sw_rw),
    .io_sw_addr(cpu_io_sw_addr),
    .io_sw_data(cpu_io_sw_data),
    .io_sw_wData(cpu_io_sw_wData),
    .io_sw_wAddr(cpu_io_sw_wAddr)
  );
  IMem memory ( // @[core.scala 103:25]
    .clock(memory_clock),
    .reset(memory_reset),
    .io_r_ach_addr(memory_io_r_ach_addr),
    .io_r_dch_ack(memory_io_r_dch_ack),
    .io_r_dch_data(memory_io_r_dch_data),
    .io_w_ach_req(memory_io_w_ach_req),
    .io_w_ach_addr(memory_io_w_ach_addr),
    .io_w_dch_data(memory_io_w_dch_data)
  );
  assign io_sw_addr = sw_addr; // @[core.scala 119:21]
  assign io_sw_data = sw_data; // @[core.scala 113:17]
  assign cpu_clock = clock;
  assign cpu_reset = reset;
  assign cpu_io_r_dch_ack = memory_io_r_dch_ack; // @[core.scala 125:25]
  assign cpu_io_r_dch_data = memory_io_r_dch_data; // @[core.scala 124:25]
  assign cpu_io_sw_halt = sw_halt; // @[core.scala 114:21]
  assign cpu_io_sw_rw = sw_rw; // @[core.scala 115:21]
  assign cpu_io_sw_wData = sw_wdata; // @[core.scala 116:21]
  assign cpu_io_sw_wAddr = sw_waddr; // @[core.scala 117:21]
  assign memory_clock = clock;
  assign memory_reset = reset;
  assign memory_io_r_ach_addr = cpu_io_r_ach_addr; // @[core.scala 123:26]
  assign memory_io_w_ach_req = cpu_io_w_ach_req; // @[core.scala 128:29]
  assign memory_io_w_ach_addr = cpu_io_w_ach_addr; // @[core.scala 129:29]
  assign memory_io_w_dch_data = cpu_io_w_dch_data; // @[core.scala 130:29]
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
  sw_halt = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  sw_data = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  sw_addr = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  sw_rw = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  sw_wdata = _RAND_4[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  sw_waddr = _RAND_5[31:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    sw_halt <= reset | io_sw_halt;
    if (reset) begin
      sw_data <= 32'h0;
    end else begin
      sw_data <= cpu_io_sw_data;
    end
    if (reset) begin
      sw_addr <= 32'h0;
    end else begin
      sw_addr <= cpu_io_sw_addr;
    end
    if (reset) begin
      sw_rw <= 1'h0;
    end else begin
      sw_rw <= io_sw_rw;
    end
    if (reset) begin
      sw_wdata <= 32'h0;
    end else begin
      sw_wdata <= io_sw_wData;
    end
    if (reset) begin
      sw_waddr <= 32'h0;
    end else begin
      sw_waddr <= io_sw_wAddr;
    end
  end
endmodule
