module Cpu(
  input         clock,
  input         reset,
  output        io_ach_req,
  output [31:0] io_ach_addr,
  input         io_dch_ack,
  input  [31:0] io_dch_data
);
  reg [31:0] i_addr; // @[core.scala 16:26]
  reg [31:0] _RAND_0;
  wire [31:0] _T_1; // @[core.scala 22:26]
  assign _T_1 = i_addr + 32'h4; // @[core.scala 22:26]
  assign io_ach_req = 1'h1; // @[core.scala 28:18]
  assign io_ach_addr = i_addr; // @[core.scala 27:18]
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
    end else if (io_dch_ack) begin
      i_addr <= _T_1;
    end
  end
endmodule
