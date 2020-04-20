module Cpu(
  input         clock,
  input         reset,
  output [31:0] io_r_ach_addr,
  input         io_r_dch_ack,
  output [31:0] io_w_ach_addr,
  output [31:0] io_w_dch_data,
  input         io_sw_halt,
  input  [31:0] io_sw_wData,
  input  [31:0] io_sw_wAddr
);
  reg [31:0] r_addr; // @[core.scala 67:26]
  reg [31:0] _RAND_0;
  reg  r_ack; // @[core.scala 71:26]
  reg [31:0] _RAND_1;
  reg [31:0] w_addr; // @[core.scala 75:26]
  reg [31:0] _RAND_2;
  reg [31:0] w_data; // @[core.scala 76:26]
  reg [31:0] _RAND_3;
  wire  _T; // @[core.scala 78:22]
  wire [31:0] _T_3; // @[core.scala 80:30]
  assign _T = ~io_sw_halt; // @[core.scala 78:22]
  assign _T_3 = r_addr + 32'h4; // @[core.scala 80:30]
  assign io_r_ach_addr = r_addr; // @[core.scala 95:21]
  assign io_w_ach_addr = w_addr; // @[core.scala 99:21]
  assign io_w_dch_data = w_data; // @[core.scala 100:21]
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
  r_ack = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  w_addr = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  w_data = _RAND_3[31:0];
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
    end else begin
      r_addr <= 32'h0;
    end
    if (reset) begin
      r_ack <= 1'h0;
    end else begin
      r_ack <= io_r_dch_ack;
    end
    if (reset) begin
      w_addr <= 32'h0;
    end else if (!(_T)) begin
      w_addr <= io_sw_wAddr;
    end
    if (reset) begin
      w_data <= 32'h0;
    end else if (!(_T)) begin
      w_data <= io_sw_wData;
    end
  end
endmodule
module IMem(
  input         clock,
  input         reset,
  input  [31:0] io_r_ach_addr,
  output        io_r_dch_ack,
  output [31:0] io_r_dch_data,
  input  [31:0] io_w_ach_addr,
  input  [31:0] io_w_dch_data
);
  reg [31:0] mem [0:1023]; // @[imem.scala 14:22]
  reg [31:0] _RAND_0;
  wire [31:0] mem__T_1_data; // @[imem.scala 14:22]
  wire [9:0] mem__T_1_addr; // @[imem.scala 14:22]
  wire [31:0] mem__T_4_data; // @[imem.scala 14:22]
  wire [9:0] mem__T_4_addr; // @[imem.scala 14:22]
  wire  mem__T_4_mask; // @[imem.scala 14:22]
  wire  mem__T_4_en; // @[imem.scala 14:22]
  reg  i_ack; // @[imem.scala 16:26]
  reg [31:0] _RAND_1;
  reg  i_req; // @[imem.scala 17:26]
  reg [31:0] _RAND_2;
  assign mem__T_1_addr = io_r_ach_addr[9:0];
  assign mem__T_1_data = mem[mem__T_1_addr]; // @[imem.scala 14:22]
  assign mem__T_4_data = io_w_dch_data;
  assign mem__T_4_addr = io_w_ach_addr[9:0];
  assign mem__T_4_mask = 1'h1;
  assign mem__T_4_en = 1'h1;
  assign io_r_dch_ack = i_ack; // @[imem.scala 26:21]
  assign io_r_dch_data = mem__T_1_data; // @[imem.scala 24:21]
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
  for (initvar = 0; initvar < 1024; initvar = initvar+1)
    mem[initvar] = _RAND_0[31:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  i_ack = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  i_req = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(mem__T_4_en & mem__T_4_mask) begin
      mem[mem__T_4_addr] <= mem__T_4_data; // @[imem.scala 14:22]
    end
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
  output [31:0] io_sw_addr,
  output [31:0] io_sw_data,
  input  [31:0] io_sw_wData,
  input  [31:0] io_sw_wAddr
);
  wire  cpu_clock; // @[core.scala 125:25]
  wire  cpu_reset; // @[core.scala 125:25]
  wire [31:0] cpu_io_r_ach_addr; // @[core.scala 125:25]
  wire  cpu_io_r_dch_ack; // @[core.scala 125:25]
  wire [31:0] cpu_io_w_ach_addr; // @[core.scala 125:25]
  wire [31:0] cpu_io_w_dch_data; // @[core.scala 125:25]
  wire  cpu_io_sw_halt; // @[core.scala 125:25]
  wire [31:0] cpu_io_sw_wData; // @[core.scala 125:25]
  wire [31:0] cpu_io_sw_wAddr; // @[core.scala 125:25]
  wire  memory_clock; // @[core.scala 126:25]
  wire  memory_reset; // @[core.scala 126:25]
  wire [31:0] memory_io_r_ach_addr; // @[core.scala 126:25]
  wire  memory_io_r_dch_ack; // @[core.scala 126:25]
  wire [31:0] memory_io_r_dch_data; // @[core.scala 126:25]
  wire [31:0] memory_io_w_ach_addr; // @[core.scala 126:25]
  wire [31:0] memory_io_w_dch_data; // @[core.scala 126:25]
  reg  sw_halt; // @[core.scala 117:30]
  reg [31:0] _RAND_0;
  reg [31:0] sw_data; // @[core.scala 118:30]
  reg [31:0] _RAND_1;
  reg [31:0] sw_addr; // @[core.scala 119:30]
  reg [31:0] _RAND_2;
  reg [31:0] sw_wdata; // @[core.scala 121:30]
  reg [31:0] _RAND_3;
  reg [31:0] sw_waddr; // @[core.scala 122:30]
  reg [31:0] _RAND_4;
  Cpu cpu ( // @[core.scala 125:25]
    .clock(cpu_clock),
    .reset(cpu_reset),
    .io_r_ach_addr(cpu_io_r_ach_addr),
    .io_r_dch_ack(cpu_io_r_dch_ack),
    .io_w_ach_addr(cpu_io_w_ach_addr),
    .io_w_dch_data(cpu_io_w_dch_data),
    .io_sw_halt(cpu_io_sw_halt),
    .io_sw_wData(cpu_io_sw_wData),
    .io_sw_wAddr(cpu_io_sw_wAddr)
  );
  IMem memory ( // @[core.scala 126:25]
    .clock(memory_clock),
    .reset(memory_reset),
    .io_r_ach_addr(memory_io_r_ach_addr),
    .io_r_dch_ack(memory_io_r_dch_ack),
    .io_r_dch_data(memory_io_r_dch_data),
    .io_w_ach_addr(memory_io_w_ach_addr),
    .io_w_dch_data(memory_io_w_dch_data)
  );
  assign io_sw_addr = sw_addr; // @[core.scala 137:17]
  assign io_sw_data = sw_data; // @[core.scala 136:17]
  assign cpu_clock = clock;
  assign cpu_reset = reset;
  assign cpu_io_r_dch_ack = memory_io_r_dch_ack; // @[core.scala 149:29]
  assign cpu_io_sw_halt = sw_halt; // @[core.scala 139:21]
  assign cpu_io_sw_wData = sw_wdata; // @[core.scala 141:21]
  assign cpu_io_sw_wAddr = sw_waddr; // @[core.scala 142:21]
  assign memory_clock = clock;
  assign memory_reset = reset;
  assign memory_io_r_ach_addr = cpu_io_r_ach_addr; // @[core.scala 147:29]
  assign memory_io_w_ach_addr = cpu_io_w_ach_addr; // @[core.scala 153:29]
  assign memory_io_w_dch_data = cpu_io_w_dch_data; // @[core.scala 154:29]
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
  sw_wdata = _RAND_3[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  sw_waddr = _RAND_4[31:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    sw_halt <= reset | io_sw_halt;
    if (reset) begin
      sw_data <= 32'h0;
    end else begin
      sw_data <= memory_io_r_dch_data;
    end
    if (reset) begin
      sw_addr <= 32'h0;
    end else begin
      sw_addr <= memory_io_r_ach_addr;
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
