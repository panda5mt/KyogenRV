module Cpu(
  input         clock,
  input         reset,
  output        io_ach_req,
  output [31:0] io_ach_addr,
  input         io_dch_ack,
  input  [31:0] io_dch_data,
  input         io_sw_halt,
  output        io_sw_rw
);
  reg [31:0] i_addr; // @[core.scala 35:26]
  reg [31:0] _RAND_0;
  wire  _T; // @[core.scala 40:22]
  wire [31:0] _T_2; // @[core.scala 42:30]
  assign _T = ~io_sw_halt; // @[core.scala 40:22]
  assign _T_2 = i_addr + 32'h4; // @[core.scala 42:30]
  assign io_ach_req = 1'h1; // @[core.scala 47:17]
  assign io_ach_addr = i_addr; // @[core.scala 46:17]
  assign io_sw_rw = 1'h0; // @[core.scala 45:17]
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
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      i_addr <= 32'h0;
    end else if (_T) begin
      i_addr <= _T_2;
    end
  end
endmodule
