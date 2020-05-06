module IDModule(
  input  [31:0] io_imem,
  output [31:0] io_inst_bits,
  output [4:0]  io_inst_rd,
  output [4:0]  io_inst_rs1,
  output [4:0]  io_inst_rs2
);
  assign io_inst_bits = io_imem; // @[control.scala 66:13]
  assign io_inst_rd = io_imem[11:7]; // @[control.scala 66:13]
  assign io_inst_rs1 = io_imem[19:15]; // @[control.scala 66:13]
  assign io_inst_rs2 = io_imem[24:20]; // @[control.scala 66:13]
endmodule
module ALU(
  input  [31:0] io_op1,
  input  [31:0] io_op2,
  input  [3:0]  io_alu_op,
  output [31:0] io_out
);
  wire [4:0] shamt; // @[ALU.scala 34:30]
  wire [31:0] _T_1; // @[ALU.scala 38:32]
  wire [31:0] _T_3; // @[ALU.scala 39:32]
  wire [31:0] _T_6; // @[ALU.scala 40:49]
  wire [31:0] _T_7; // @[ALU.scala 41:32]
  wire [62:0] _GEN_0; // @[ALU.scala 42:32]
  wire [62:0] _T_8; // @[ALU.scala 42:32]
  wire  _T_11; // @[ALU.scala 43:39]
  wire  _T_12; // @[ALU.scala 44:32]
  wire [31:0] _T_13; // @[ALU.scala 45:32]
  wire [31:0] _T_14; // @[ALU.scala 46:32]
  wire [31:0] _T_15; // @[ALU.scala 47:32]
  wire  _T_16; // @[Mux.scala 68:19]
  wire [31:0] _T_17; // @[Mux.scala 68:16]
  wire  _T_18; // @[Mux.scala 68:19]
  wire [31:0] _T_19; // @[Mux.scala 68:16]
  wire  _T_20; // @[Mux.scala 68:19]
  wire [31:0] _T_21; // @[Mux.scala 68:16]
  wire  _T_22; // @[Mux.scala 68:19]
  wire [31:0] _T_23; // @[Mux.scala 68:16]
  wire  _T_24; // @[Mux.scala 68:19]
  wire [31:0] _T_25; // @[Mux.scala 68:16]
  wire  _T_26; // @[Mux.scala 68:19]
  wire [31:0] _T_27; // @[Mux.scala 68:16]
  wire  _T_28; // @[Mux.scala 68:19]
  wire [62:0] _T_29; // @[Mux.scala 68:16]
  wire  _T_30; // @[Mux.scala 68:19]
  wire [62:0] _T_31; // @[Mux.scala 68:16]
  wire  _T_32; // @[Mux.scala 68:19]
  wire [62:0] _T_33; // @[Mux.scala 68:16]
  wire  _T_34; // @[Mux.scala 68:19]
  wire [62:0] _T_35; // @[Mux.scala 68:16]
  wire  _T_36; // @[Mux.scala 68:19]
  wire [62:0] _T_37; // @[Mux.scala 68:16]
  assign shamt = io_op2[4:0]; // @[ALU.scala 34:30]
  assign _T_1 = io_op1 + io_op2; // @[ALU.scala 38:32]
  assign _T_3 = io_op1 - io_op2; // @[ALU.scala 39:32]
  assign _T_6 = $signed(io_op1) >>> shamt; // @[ALU.scala 40:49]
  assign _T_7 = io_op1 >> shamt; // @[ALU.scala 41:32]
  assign _GEN_0 = {{31'd0}, io_op1}; // @[ALU.scala 42:32]
  assign _T_8 = _GEN_0 << shamt; // @[ALU.scala 42:32]
  assign _T_11 = $signed(io_op1) < $signed(io_op2); // @[ALU.scala 43:39]
  assign _T_12 = io_op1 < io_op2; // @[ALU.scala 44:32]
  assign _T_13 = io_op1 & io_op2; // @[ALU.scala 45:32]
  assign _T_14 = io_op1 | io_op2; // @[ALU.scala 46:32]
  assign _T_15 = io_op1 ^ io_op2; // @[ALU.scala 47:32]
  assign _T_16 = 4'hb == io_alu_op; // @[Mux.scala 68:19]
  assign _T_17 = _T_16 ? io_op1 : io_op2; // @[Mux.scala 68:16]
  assign _T_18 = 4'h8 == io_alu_op; // @[Mux.scala 68:19]
  assign _T_19 = _T_18 ? _T_15 : _T_17; // @[Mux.scala 68:16]
  assign _T_20 = 4'h7 == io_alu_op; // @[Mux.scala 68:19]
  assign _T_21 = _T_20 ? _T_14 : _T_19; // @[Mux.scala 68:16]
  assign _T_22 = 4'h6 == io_alu_op; // @[Mux.scala 68:19]
  assign _T_23 = _T_22 ? _T_13 : _T_21; // @[Mux.scala 68:16]
  assign _T_24 = 4'ha == io_alu_op; // @[Mux.scala 68:19]
  assign _T_25 = _T_24 ? {{31'd0}, _T_12} : _T_23; // @[Mux.scala 68:16]
  assign _T_26 = 4'h9 == io_alu_op; // @[Mux.scala 68:19]
  assign _T_27 = _T_26 ? {{31'd0}, _T_11} : _T_25; // @[Mux.scala 68:16]
  assign _T_28 = 4'h3 == io_alu_op; // @[Mux.scala 68:19]
  assign _T_29 = _T_28 ? _T_8 : {{31'd0}, _T_27}; // @[Mux.scala 68:16]
  assign _T_30 = 4'h4 == io_alu_op; // @[Mux.scala 68:19]
  assign _T_31 = _T_30 ? {{31'd0}, _T_7} : _T_29; // @[Mux.scala 68:16]
  assign _T_32 = 4'h5 == io_alu_op; // @[Mux.scala 68:19]
  assign _T_33 = _T_32 ? {{31'd0}, _T_6} : _T_31; // @[Mux.scala 68:16]
  assign _T_34 = 4'h2 == io_alu_op; // @[Mux.scala 68:19]
  assign _T_35 = _T_34 ? {{31'd0}, _T_3} : _T_33; // @[Mux.scala 68:16]
  assign _T_36 = 4'h1 == io_alu_op; // @[Mux.scala 68:19]
  assign _T_37 = _T_36 ? {{31'd0}, _T_1} : _T_35; // @[Mux.scala 68:16]
  assign io_out = _T_37[31:0]; // @[ALU.scala 50:12]
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
  output [31:0] io_sw_addr,
  output [31:0] io_sw_data,
  input  [31:0] io_sw_w_da,
  input  [31:0] io_sw_w_ad,
  input  [31:0] io_sw_g_ad,
  output [31:0] io_sw_g_da,
  output [31:0] io_sw_r_pc,
  input  [31:0] io_sw_w_pc
);
  wire [31:0] idm_io_imem; // @[core.scala 38:31]
  wire [31:0] idm_io_inst_bits; // @[core.scala 38:31]
  wire [4:0] idm_io_inst_rd; // @[core.scala 38:31]
  wire [4:0] idm_io_inst_rs1; // @[core.scala 38:31]
  wire [4:0] idm_io_inst_rs2; // @[core.scala 38:31]
  wire [31:0] alu_io_op1; // @[core.scala 71:29]
  wire [31:0] alu_io_op2; // @[core.scala 71:29]
  wire [3:0] alu_io_alu_op; // @[core.scala 71:29]
  wire [31:0] alu_io_out; // @[core.scala 71:29]
  reg [31:0] r_addr; // @[core.scala 19:31]
  reg [31:0] _RAND_0;
  reg [31:0] r_data; // @[core.scala 20:31]
  reg [31:0] _RAND_1;
  reg  r_ack; // @[core.scala 23:31]
  reg [31:0] _RAND_2;
  reg  w_req; // @[core.scala 25:31]
  reg [31:0] _RAND_3;
  reg [31:0] w_addr; // @[core.scala 27:31]
  reg [31:0] _RAND_4;
  reg [31:0] w_data; // @[core.scala 28:31]
  reg [31:0] _RAND_5;
  reg [31:0] rv32i_reg_0; // @[core.scala 32:16]
  reg [31:0] _RAND_6;
  reg [31:0] rv32i_reg_1; // @[core.scala 32:16]
  reg [31:0] _RAND_7;
  reg [31:0] rv32i_reg_2; // @[core.scala 32:16]
  reg [31:0] _RAND_8;
  reg [31:0] rv32i_reg_3; // @[core.scala 32:16]
  reg [31:0] _RAND_9;
  reg [31:0] rv32i_reg_4; // @[core.scala 32:16]
  reg [31:0] _RAND_10;
  reg [31:0] rv32i_reg_5; // @[core.scala 32:16]
  reg [31:0] _RAND_11;
  reg [31:0] rv32i_reg_6; // @[core.scala 32:16]
  reg [31:0] _RAND_12;
  reg [31:0] rv32i_reg_7; // @[core.scala 32:16]
  reg [31:0] _RAND_13;
  reg [31:0] rv32i_reg_8; // @[core.scala 32:16]
  reg [31:0] _RAND_14;
  reg [31:0] rv32i_reg_9; // @[core.scala 32:16]
  reg [31:0] _RAND_15;
  reg [31:0] rv32i_reg_10; // @[core.scala 32:16]
  reg [31:0] _RAND_16;
  reg [31:0] rv32i_reg_11; // @[core.scala 32:16]
  reg [31:0] _RAND_17;
  reg [31:0] rv32i_reg_12; // @[core.scala 32:16]
  reg [31:0] _RAND_18;
  reg [31:0] rv32i_reg_13; // @[core.scala 32:16]
  reg [31:0] _RAND_19;
  reg [31:0] rv32i_reg_14; // @[core.scala 32:16]
  reg [31:0] _RAND_20;
  reg [31:0] rv32i_reg_15; // @[core.scala 32:16]
  reg [31:0] _RAND_21;
  reg [31:0] rv32i_reg_16; // @[core.scala 32:16]
  reg [31:0] _RAND_22;
  reg [31:0] rv32i_reg_17; // @[core.scala 32:16]
  reg [31:0] _RAND_23;
  reg [31:0] rv32i_reg_18; // @[core.scala 32:16]
  reg [31:0] _RAND_24;
  reg [31:0] rv32i_reg_19; // @[core.scala 32:16]
  reg [31:0] _RAND_25;
  reg [31:0] rv32i_reg_20; // @[core.scala 32:16]
  reg [31:0] _RAND_26;
  reg [31:0] rv32i_reg_21; // @[core.scala 32:16]
  reg [31:0] _RAND_27;
  reg [31:0] rv32i_reg_22; // @[core.scala 32:16]
  reg [31:0] _RAND_28;
  reg [31:0] rv32i_reg_23; // @[core.scala 32:16]
  reg [31:0] _RAND_29;
  reg [31:0] rv32i_reg_24; // @[core.scala 32:16]
  reg [31:0] _RAND_30;
  reg [31:0] rv32i_reg_25; // @[core.scala 32:16]
  reg [31:0] _RAND_31;
  reg [31:0] rv32i_reg_26; // @[core.scala 32:16]
  reg [31:0] _RAND_32;
  reg [31:0] rv32i_reg_27; // @[core.scala 32:16]
  reg [31:0] _RAND_33;
  reg [31:0] rv32i_reg_28; // @[core.scala 32:16]
  reg [31:0] _RAND_34;
  reg [31:0] rv32i_reg_29; // @[core.scala 32:16]
  reg [31:0] _RAND_35;
  reg [31:0] rv32i_reg_30; // @[core.scala 32:16]
  reg [31:0] _RAND_36;
  reg [31:0] rv32i_reg_31; // @[core.scala 32:16]
  reg [31:0] _RAND_37;
  reg  next_inst_is_valid; // @[core.scala 35:43]
  reg [31:0] _RAND_38;
  wire  _T_3; // @[control.scala 203:53]
  wire  _T_54; // @[Cat.scala 29:58]
  wire [7:0] _T_55; // @[Cat.scala 29:58]
  wire [10:0] _T_57; // @[Cat.scala 29:58]
  wire [7:0] _T_116; // @[Cat.scala 29:58]
  wire [10:0] _T_118; // @[Cat.scala 29:58]
  wire  _T_237; // @[Cat.scala 29:58]
  wire [31:0] imm_j; // @[control.scala 217:57]
  wire  _T_298; // @[Cat.scala 29:58]
  wire [31:0] _GEN_1; // @[core.scala 45:52]
  wire [31:0] _GEN_2; // @[core.scala 45:52]
  wire [31:0] _GEN_3; // @[core.scala 45:52]
  wire [31:0] _GEN_4; // @[core.scala 45:52]
  wire [31:0] _GEN_5; // @[core.scala 45:52]
  wire [31:0] _GEN_6; // @[core.scala 45:52]
  wire [31:0] _GEN_7; // @[core.scala 45:52]
  wire [31:0] _GEN_8; // @[core.scala 45:52]
  wire [31:0] _GEN_9; // @[core.scala 45:52]
  wire [31:0] _GEN_10; // @[core.scala 45:52]
  wire [31:0] _GEN_11; // @[core.scala 45:52]
  wire [31:0] _GEN_12; // @[core.scala 45:52]
  wire [31:0] _GEN_13; // @[core.scala 45:52]
  wire [31:0] _GEN_14; // @[core.scala 45:52]
  wire [31:0] _GEN_15; // @[core.scala 45:52]
  wire [31:0] _GEN_16; // @[core.scala 45:52]
  wire [31:0] _GEN_17; // @[core.scala 45:52]
  wire [31:0] _GEN_18; // @[core.scala 45:52]
  wire [31:0] _GEN_19; // @[core.scala 45:52]
  wire [31:0] _GEN_20; // @[core.scala 45:52]
  wire [31:0] _GEN_21; // @[core.scala 45:52]
  wire [31:0] _GEN_22; // @[core.scala 45:52]
  wire [31:0] _GEN_23; // @[core.scala 45:52]
  wire [31:0] _GEN_24; // @[core.scala 45:52]
  wire [31:0] _GEN_25; // @[core.scala 45:52]
  wire [31:0] _GEN_26; // @[core.scala 45:52]
  wire [31:0] _GEN_27; // @[core.scala 45:52]
  wire [31:0] _GEN_28; // @[core.scala 45:52]
  wire [31:0] _GEN_29; // @[core.scala 45:52]
  wire [31:0] _GEN_30; // @[core.scala 45:52]
  wire [31:0] _GEN_31; // @[core.scala 45:52]
  wire [31:0] val_rs1; // @[core.scala 45:52]
  wire [31:0] _GEN_33; // @[core.scala 46:52]
  wire [31:0] _GEN_34; // @[core.scala 46:52]
  wire [31:0] _GEN_35; // @[core.scala 46:52]
  wire [31:0] _GEN_36; // @[core.scala 46:52]
  wire [31:0] _GEN_37; // @[core.scala 46:52]
  wire [31:0] _GEN_38; // @[core.scala 46:52]
  wire [31:0] _GEN_39; // @[core.scala 46:52]
  wire [31:0] _GEN_40; // @[core.scala 46:52]
  wire [31:0] _GEN_41; // @[core.scala 46:52]
  wire [31:0] _GEN_42; // @[core.scala 46:52]
  wire [31:0] _GEN_43; // @[core.scala 46:52]
  wire [31:0] _GEN_44; // @[core.scala 46:52]
  wire [31:0] _GEN_45; // @[core.scala 46:52]
  wire [31:0] _GEN_46; // @[core.scala 46:52]
  wire [31:0] _GEN_47; // @[core.scala 46:52]
  wire [31:0] _GEN_48; // @[core.scala 46:52]
  wire [31:0] _GEN_49; // @[core.scala 46:52]
  wire [31:0] _GEN_50; // @[core.scala 46:52]
  wire [31:0] _GEN_51; // @[core.scala 46:52]
  wire [31:0] _GEN_52; // @[core.scala 46:52]
  wire [31:0] _GEN_53; // @[core.scala 46:52]
  wire [31:0] _GEN_54; // @[core.scala 46:52]
  wire [31:0] _GEN_55; // @[core.scala 46:52]
  wire [31:0] _GEN_56; // @[core.scala 46:52]
  wire [31:0] _GEN_57; // @[core.scala 46:52]
  wire [31:0] _GEN_58; // @[core.scala 46:52]
  wire [31:0] _GEN_59; // @[core.scala 46:52]
  wire [31:0] _GEN_60; // @[core.scala 46:52]
  wire [31:0] _GEN_61; // @[core.scala 46:52]
  wire [31:0] _GEN_62; // @[core.scala 46:52]
  wire [31:0] _GEN_63; // @[core.scala 46:52]
  wire [31:0] val_rs2; // @[core.scala 46:52]
  wire [31:0] _T_307; // @[control.scala 197:55]
  wire  _T_308; // @[control.scala 197:55]
  wire  _T_310; // @[control.scala 197:55]
  wire  _T_312; // @[control.scala 197:55]
  wire  _T_314; // @[control.scala 197:55]
  wire  _T_316; // @[control.scala 197:55]
  wire  _T_318; // @[control.scala 197:55]
  wire  _T_320; // @[control.scala 197:55]
  wire  _T_322; // @[control.scala 197:55]
  wire [31:0] _T_323; // @[control.scala 197:55]
  wire  _T_324; // @[control.scala 197:55]
  wire  _T_326; // @[control.scala 197:55]
  wire  _T_328; // @[control.scala 197:55]
  wire  _T_330; // @[control.scala 197:55]
  wire  _T_332; // @[control.scala 197:55]
  wire  _T_334; // @[control.scala 197:55]
  wire  _T_336; // @[control.scala 197:55]
  wire  _T_338; // @[control.scala 197:55]
  wire [31:0] _T_339; // @[control.scala 197:55]
  wire  _T_340; // @[control.scala 197:55]
  wire  _T_342; // @[control.scala 197:55]
  wire  _T_344; // @[control.scala 197:55]
  wire [31:0] _T_345; // @[control.scala 197:55]
  wire  _T_346; // @[control.scala 197:55]
  wire  _T_348; // @[control.scala 197:55]
  wire  _T_350; // @[control.scala 197:55]
  wire  _T_352; // @[control.scala 197:55]
  wire  _T_354; // @[control.scala 197:55]
  wire  _T_356; // @[control.scala 197:55]
  wire  _T_358; // @[control.scala 197:55]
  wire  _T_360; // @[control.scala 197:55]
  wire  _T_362; // @[control.scala 197:55]
  wire  _T_364; // @[control.scala 197:55]
  wire  _T_366; // @[control.scala 197:55]
  wire  _T_368; // @[control.scala 197:55]
  wire  _T_370; // @[control.scala 197:55]
  wire  _T_372; // @[control.scala 197:55]
  wire  _T_374; // @[control.scala 197:55]
  wire  _T_376; // @[control.scala 197:55]
  wire  _T_378; // @[control.scala 197:55]
  wire  _T_380; // @[control.scala 197:55]
  wire  _T_382; // @[control.scala 197:55]
  wire  _T_384; // @[control.scala 197:55]
  wire  _T_386; // @[control.scala 197:55]
  wire  _T_388; // @[control.scala 197:55]
  wire  _T_390; // @[control.scala 197:55]
  wire  _T_392; // @[control.scala 197:55]
  wire [2:0] _T_552; // @[Mux.scala 87:16]
  wire [2:0] _T_553; // @[Mux.scala 87:16]
  wire [2:0] _T_554; // @[Mux.scala 87:16]
  wire [2:0] _T_555; // @[Mux.scala 87:16]
  wire [2:0] _T_556; // @[Mux.scala 87:16]
  wire [2:0] _T_557; // @[Mux.scala 87:16]
  wire [3:0] _T_558; // @[Mux.scala 87:16]
  wire [3:0] _T_559; // @[Mux.scala 87:16]
  wire [3:0] _T_560; // @[Mux.scala 87:16]
  wire [3:0] _T_561; // @[Mux.scala 87:16]
  wire [3:0] _T_562; // @[Mux.scala 87:16]
  wire [3:0] _T_563; // @[Mux.scala 87:16]
  wire [3:0] _T_564; // @[Mux.scala 87:16]
  wire [3:0] _T_565; // @[Mux.scala 87:16]
  wire [3:0] _T_566; // @[Mux.scala 87:16]
  wire [3:0] _T_567; // @[Mux.scala 87:16]
  wire [3:0] _T_568; // @[Mux.scala 87:16]
  wire [3:0] _T_569; // @[Mux.scala 87:16]
  wire [3:0] _T_570; // @[Mux.scala 87:16]
  wire [3:0] _T_571; // @[Mux.scala 87:16]
  wire [3:0] _T_572; // @[Mux.scala 87:16]
  wire [3:0] _T_573; // @[Mux.scala 87:16]
  wire [3:0] _T_574; // @[Mux.scala 87:16]
  wire [3:0] _T_575; // @[Mux.scala 87:16]
  wire [3:0] _T_576; // @[Mux.scala 87:16]
  wire [3:0] _T_577; // @[Mux.scala 87:16]
  wire [3:0] _T_578; // @[Mux.scala 87:16]
  wire [3:0] _T_579; // @[Mux.scala 87:16]
  wire [3:0] _T_580; // @[Mux.scala 87:16]
  wire [3:0] _T_581; // @[Mux.scala 87:16]
  wire [3:0] _T_582; // @[Mux.scala 87:16]
  wire [3:0] _T_583; // @[Mux.scala 87:16]
  wire [3:0] _T_584; // @[Mux.scala 87:16]
  wire [3:0] _T_585; // @[Mux.scala 87:16]
  wire [3:0] _T_586; // @[Mux.scala 87:16]
  wire [3:0] _T_587; // @[Mux.scala 87:16]
  wire [3:0] id_ctrl_br_type; // @[Mux.scala 87:16]
  wire [1:0] _T_690; // @[Mux.scala 87:16]
  wire [1:0] _T_691; // @[Mux.scala 87:16]
  wire [1:0] _T_692; // @[Mux.scala 87:16]
  wire [1:0] _T_693; // @[Mux.scala 87:16]
  wire [1:0] _T_694; // @[Mux.scala 87:16]
  wire [1:0] _T_695; // @[Mux.scala 87:16]
  wire [1:0] _T_696; // @[Mux.scala 87:16]
  wire [1:0] _T_697; // @[Mux.scala 87:16]
  wire [1:0] _T_698; // @[Mux.scala 87:16]
  wire [1:0] _T_699; // @[Mux.scala 87:16]
  wire [1:0] _T_700; // @[Mux.scala 87:16]
  wire [1:0] _T_701; // @[Mux.scala 87:16]
  wire [1:0] _T_702; // @[Mux.scala 87:16]
  wire [1:0] _T_703; // @[Mux.scala 87:16]
  wire [1:0] _T_704; // @[Mux.scala 87:16]
  wire [1:0] _T_705; // @[Mux.scala 87:16]
  wire [1:0] _T_706; // @[Mux.scala 87:16]
  wire [1:0] _T_707; // @[Mux.scala 87:16]
  wire [1:0] _T_708; // @[Mux.scala 87:16]
  wire [1:0] _T_709; // @[Mux.scala 87:16]
  wire [1:0] _T_710; // @[Mux.scala 87:16]
  wire [1:0] _T_711; // @[Mux.scala 87:16]
  wire [1:0] _T_712; // @[Mux.scala 87:16]
  wire [1:0] _T_713; // @[Mux.scala 87:16]
  wire [1:0] _T_714; // @[Mux.scala 87:16]
  wire [1:0] _T_715; // @[Mux.scala 87:16]
  wire [1:0] _T_716; // @[Mux.scala 87:16]
  wire [1:0] _T_717; // @[Mux.scala 87:16]
  wire [1:0] _T_718; // @[Mux.scala 87:16]
  wire [1:0] _T_719; // @[Mux.scala 87:16]
  wire [1:0] _T_720; // @[Mux.scala 87:16]
  wire [1:0] _T_721; // @[Mux.scala 87:16]
  wire [1:0] _T_722; // @[Mux.scala 87:16]
  wire [1:0] _T_723; // @[Mux.scala 87:16]
  wire [1:0] _T_724; // @[Mux.scala 87:16]
  wire [1:0] _T_725; // @[Mux.scala 87:16]
  wire [1:0] _T_726; // @[Mux.scala 87:16]
  wire [1:0] _T_727; // @[Mux.scala 87:16]
  wire [1:0] _T_728; // @[Mux.scala 87:16]
  wire [1:0] id_ctrl_alu_op1; // @[Mux.scala 87:16]
  wire  _T_841; // @[Mux.scala 87:16]
  wire  _T_842; // @[Mux.scala 87:16]
  wire  _T_843; // @[Mux.scala 87:16]
  wire  _T_844; // @[Mux.scala 87:16]
  wire  _T_845; // @[Mux.scala 87:16]
  wire  _T_846; // @[Mux.scala 87:16]
  wire  _T_847; // @[Mux.scala 87:16]
  wire  _T_848; // @[Mux.scala 87:16]
  wire  _T_849; // @[Mux.scala 87:16]
  wire  _T_850; // @[Mux.scala 87:16]
  wire  _T_851; // @[Mux.scala 87:16]
  wire  _T_852; // @[Mux.scala 87:16]
  wire  _T_853; // @[Mux.scala 87:16]
  wire  _T_854; // @[Mux.scala 87:16]
  wire  _T_855; // @[Mux.scala 87:16]
  wire  _T_856; // @[Mux.scala 87:16]
  wire  _T_857; // @[Mux.scala 87:16]
  wire  _T_858; // @[Mux.scala 87:16]
  wire  _T_859; // @[Mux.scala 87:16]
  wire  _T_860; // @[Mux.scala 87:16]
  wire  _T_861; // @[Mux.scala 87:16]
  wire [1:0] _T_862; // @[Mux.scala 87:16]
  wire [1:0] _T_863; // @[Mux.scala 87:16]
  wire [1:0] _T_864; // @[Mux.scala 87:16]
  wire [1:0] _T_865; // @[Mux.scala 87:16]
  wire [1:0] _T_866; // @[Mux.scala 87:16]
  wire [1:0] _T_867; // @[Mux.scala 87:16]
  wire [1:0] _T_868; // @[Mux.scala 87:16]
  wire [1:0] _T_869; // @[Mux.scala 87:16]
  wire [1:0] id_ctrl_alu_op2; // @[Mux.scala 87:16]
  wire [3:0] _T_969; // @[Mux.scala 87:16]
  wire [3:0] _T_970; // @[Mux.scala 87:16]
  wire [3:0] _T_971; // @[Mux.scala 87:16]
  wire [3:0] _T_972; // @[Mux.scala 87:16]
  wire [3:0] _T_973; // @[Mux.scala 87:16]
  wire [3:0] _T_974; // @[Mux.scala 87:16]
  wire [3:0] _T_975; // @[Mux.scala 87:16]
  wire [3:0] _T_976; // @[Mux.scala 87:16]
  wire [3:0] _T_977; // @[Mux.scala 87:16]
  wire [3:0] _T_978; // @[Mux.scala 87:16]
  wire [3:0] _T_979; // @[Mux.scala 87:16]
  wire [3:0] _T_980; // @[Mux.scala 87:16]
  wire [3:0] _T_981; // @[Mux.scala 87:16]
  wire [3:0] _T_982; // @[Mux.scala 87:16]
  wire [3:0] _T_983; // @[Mux.scala 87:16]
  wire [3:0] _T_984; // @[Mux.scala 87:16]
  wire [3:0] _T_985; // @[Mux.scala 87:16]
  wire [3:0] _T_986; // @[Mux.scala 87:16]
  wire [3:0] _T_987; // @[Mux.scala 87:16]
  wire [3:0] _T_988; // @[Mux.scala 87:16]
  wire [3:0] _T_989; // @[Mux.scala 87:16]
  wire [3:0] _T_990; // @[Mux.scala 87:16]
  wire [3:0] _T_991; // @[Mux.scala 87:16]
  wire [3:0] _T_992; // @[Mux.scala 87:16]
  wire [3:0] _T_993; // @[Mux.scala 87:16]
  wire [3:0] _T_994; // @[Mux.scala 87:16]
  wire [3:0] _T_995; // @[Mux.scala 87:16]
  wire [3:0] _T_996; // @[Mux.scala 87:16]
  wire [3:0] _T_997; // @[Mux.scala 87:16]
  wire [3:0] _T_998; // @[Mux.scala 87:16]
  wire [3:0] _T_999; // @[Mux.scala 87:16]
  wire [3:0] _T_1000; // @[Mux.scala 87:16]
  wire [3:0] _T_1001; // @[Mux.scala 87:16]
  wire [3:0] _T_1002; // @[Mux.scala 87:16]
  wire [3:0] _T_1003; // @[Mux.scala 87:16]
  wire [3:0] _T_1004; // @[Mux.scala 87:16]
  wire [3:0] _T_1005; // @[Mux.scala 87:16]
  wire [3:0] _T_1006; // @[Mux.scala 87:16]
  wire [3:0] _T_1007; // @[Mux.scala 87:16]
  wire [3:0] _T_1008; // @[Mux.scala 87:16]
  wire [3:0] _T_1009; // @[Mux.scala 87:16]
  wire [3:0] _T_1010; // @[Mux.scala 87:16]
  wire [1:0] _T_1110; // @[Mux.scala 87:16]
  wire [1:0] _T_1111; // @[Mux.scala 87:16]
  wire [1:0] _T_1112; // @[Mux.scala 87:16]
  wire [1:0] _T_1113; // @[Mux.scala 87:16]
  wire [1:0] _T_1114; // @[Mux.scala 87:16]
  wire [1:0] _T_1115; // @[Mux.scala 87:16]
  wire [1:0] _T_1116; // @[Mux.scala 87:16]
  wire [1:0] _T_1117; // @[Mux.scala 87:16]
  wire [1:0] _T_1118; // @[Mux.scala 87:16]
  wire [1:0] _T_1119; // @[Mux.scala 87:16]
  wire [1:0] _T_1120; // @[Mux.scala 87:16]
  wire [1:0] _T_1121; // @[Mux.scala 87:16]
  wire [1:0] _T_1122; // @[Mux.scala 87:16]
  wire [1:0] _T_1123; // @[Mux.scala 87:16]
  wire [1:0] _T_1124; // @[Mux.scala 87:16]
  wire [1:0] _T_1125; // @[Mux.scala 87:16]
  wire [1:0] _T_1126; // @[Mux.scala 87:16]
  wire [1:0] _T_1127; // @[Mux.scala 87:16]
  wire [1:0] _T_1128; // @[Mux.scala 87:16]
  wire [1:0] _T_1129; // @[Mux.scala 87:16]
  wire [1:0] _T_1130; // @[Mux.scala 87:16]
  wire [1:0] _T_1131; // @[Mux.scala 87:16]
  wire [1:0] _T_1132; // @[Mux.scala 87:16]
  wire [1:0] _T_1133; // @[Mux.scala 87:16]
  wire [1:0] _T_1134; // @[Mux.scala 87:16]
  wire [1:0] _T_1135; // @[Mux.scala 87:16]
  wire [1:0] _T_1136; // @[Mux.scala 87:16]
  wire [1:0] _T_1137; // @[Mux.scala 87:16]
  wire [1:0] _T_1138; // @[Mux.scala 87:16]
  wire [1:0] _T_1139; // @[Mux.scala 87:16]
  wire [1:0] _T_1140; // @[Mux.scala 87:16]
  wire [1:0] _T_1141; // @[Mux.scala 87:16]
  wire [1:0] _T_1142; // @[Mux.scala 87:16]
  wire [1:0] _T_1143; // @[Mux.scala 87:16]
  wire [1:0] _T_1144; // @[Mux.scala 87:16]
  wire [1:0] _T_1145; // @[Mux.scala 87:16]
  wire [1:0] _T_1146; // @[Mux.scala 87:16]
  wire [1:0] _T_1147; // @[Mux.scala 87:16]
  wire [1:0] _T_1148; // @[Mux.scala 87:16]
  wire [1:0] _T_1149; // @[Mux.scala 87:16]
  wire [1:0] _T_1150; // @[Mux.scala 87:16]
  wire [1:0] _T_1151; // @[Mux.scala 87:16]
  wire [1:0] id_ctrl_wb_sel; // @[Mux.scala 87:16]
  wire  _T_1252; // @[Mux.scala 87:16]
  wire  _T_1253; // @[Mux.scala 87:16]
  wire  _T_1254; // @[Mux.scala 87:16]
  wire  _T_1255; // @[Mux.scala 87:16]
  wire  _T_1256; // @[Mux.scala 87:16]
  wire  _T_1257; // @[Mux.scala 87:16]
  wire  _T_1258; // @[Mux.scala 87:16]
  wire  _T_1259; // @[Mux.scala 87:16]
  wire  _T_1260; // @[Mux.scala 87:16]
  wire  _T_1261; // @[Mux.scala 87:16]
  wire  _T_1262; // @[Mux.scala 87:16]
  wire  _T_1263; // @[Mux.scala 87:16]
  wire  _T_1264; // @[Mux.scala 87:16]
  wire  _T_1265; // @[Mux.scala 87:16]
  wire  _T_1266; // @[Mux.scala 87:16]
  wire  _T_1267; // @[Mux.scala 87:16]
  wire  _T_1268; // @[Mux.scala 87:16]
  wire  _T_1269; // @[Mux.scala 87:16]
  wire  _T_1270; // @[Mux.scala 87:16]
  wire  _T_1271; // @[Mux.scala 87:16]
  wire  _T_1272; // @[Mux.scala 87:16]
  wire  _T_1273; // @[Mux.scala 87:16]
  wire  _T_1274; // @[Mux.scala 87:16]
  wire  _T_1275; // @[Mux.scala 87:16]
  wire  _T_1276; // @[Mux.scala 87:16]
  wire  _T_1277; // @[Mux.scala 87:16]
  wire  _T_1278; // @[Mux.scala 87:16]
  wire  _T_1279; // @[Mux.scala 87:16]
  wire  _T_1280; // @[Mux.scala 87:16]
  wire  _T_1281; // @[Mux.scala 87:16]
  wire  _T_1282; // @[Mux.scala 87:16]
  wire  _T_1283; // @[Mux.scala 87:16]
  wire  _T_1284; // @[Mux.scala 87:16]
  wire  _T_1285; // @[Mux.scala 87:16]
  wire  _T_1286; // @[Mux.scala 87:16]
  wire  _T_1287; // @[Mux.scala 87:16]
  wire  _T_1288; // @[Mux.scala 87:16]
  wire  _T_1289; // @[Mux.scala 87:16]
  wire  _T_1290; // @[Mux.scala 87:16]
  wire  _T_1291; // @[Mux.scala 87:16]
  wire  _T_1292; // @[Mux.scala 87:16]
  wire  id_ctrl_rf_wen; // @[Mux.scala 87:16]
  wire [31:0] _T_1717; // @[core.scala 55:30]
  wire  _T_1718; // @[Mux.scala 68:19]
  wire  _T_1722; // @[Mux.scala 68:19]
  wire [31:0] _T_1723; // @[Mux.scala 68:16]
  wire [31:0] _T_1725; // @[core.scala 64:30]
  wire [31:0] _T_1726; // @[core.scala 65:30]
  wire  _T_1727; // @[Mux.scala 68:19]
  wire  _T_1729; // @[Mux.scala 68:19]
  wire [31:0] _T_1730; // @[Mux.scala 68:16]
  wire  _T_1731; // @[Mux.scala 68:19]
  wire [31:0] _T_1732; // @[Mux.scala 68:16]
  wire  _T_1733; // @[Mux.scala 68:19]
  wire [31:0] _T_1734; // @[Mux.scala 68:16]
  wire  _T_1736; // @[Mux.scala 68:19]
  wire  _T_1742; // @[Mux.scala 68:19]
  wire [31:0] _T_1743; // @[Mux.scala 68:16]
  wire [31:0] rd_val; // @[Mux.scala 68:16]
  wire  _T_1746; // @[core.scala 90:23]
  wire [31:0] _T_1750; // @[core.scala 100:31]
  wire  _T_1751; // @[core.scala 101:35]
  wire [31:0] _T_1753; // @[core.scala 101:55]
  wire [31:0] _T_1754; // @[core.scala 101:69]
  wire [31:0] _T_1756; // @[core.scala 101:61]
  wire  _T_1760; // @[core.scala 102:35]
  wire  _T_1769; // @[core.scala 103:35]
  wire [31:0] _T_1778; // @[core.scala 104:35]
  wire [31:0] _T_1779; // @[core.scala 104:52]
  wire  _T_1780; // @[core.scala 104:42]
  wire  _T_1789; // @[core.scala 105:35]
  wire  _T_1800; // @[core.scala 106:42]
  wire [31:0] _T_1812; // @[core.scala 107:41]
  wire [31:0] _T_1815; // @[core.scala 108:45]
  wire [31:0] _T_1817; // @[core.scala 108:37]
  wire  _T_1818; // @[Mux.scala 68:19]
  wire  _T_1820; // @[Mux.scala 68:19]
  wire  _T_1822; // @[Mux.scala 68:19]
  wire  _T_1824; // @[Mux.scala 68:19]
  wire  _T_1826; // @[Mux.scala 68:19]
  wire  _T_1828; // @[Mux.scala 68:19]
  wire  _T_1830; // @[Mux.scala 68:19]
  wire  _T_1832; // @[Mux.scala 68:19]
  wire  _T_1834; // @[Mux.scala 68:19]
  wire  _GEN_160; // @[core.scala 117:39]
  wire  _GEN_161; // @[core.scala 123:39]
  wire  _GEN_162; // @[core.scala 129:37]
  wire  _GEN_164; // @[core.scala 141:36]
  wire  _GEN_166; // @[Conditional.scala 39:67]
  wire  _GEN_167; // @[Conditional.scala 39:67]
  wire  _GEN_168; // @[Conditional.scala 39:67]
  wire  _GEN_169; // @[Conditional.scala 39:67]
  wire  _GEN_170; // @[Conditional.scala 39:67]
  wire  _GEN_171; // @[Conditional.scala 39:67]
  wire  _GEN_172; // @[Conditional.scala 39:67]
  wire  _GEN_173; // @[Conditional.scala 40:58]
  wire  _T_1851; // @[core.scala 157:22]
  wire  _GEN_174; // @[core.scala 158:31]
  wire  _GEN_177; // @[core.scala 157:34]
  wire [31:0] _GEN_183; // @[core.scala 193:16]
  wire [31:0] _GEN_184; // @[core.scala 193:16]
  wire [31:0] _GEN_185; // @[core.scala 193:16]
  wire [31:0] _GEN_186; // @[core.scala 193:16]
  wire [31:0] _GEN_187; // @[core.scala 193:16]
  wire [31:0] _GEN_188; // @[core.scala 193:16]
  wire [31:0] _GEN_189; // @[core.scala 193:16]
  wire [31:0] _GEN_190; // @[core.scala 193:16]
  wire [31:0] _GEN_191; // @[core.scala 193:16]
  wire [31:0] _GEN_192; // @[core.scala 193:16]
  wire [31:0] _GEN_193; // @[core.scala 193:16]
  wire [31:0] _GEN_194; // @[core.scala 193:16]
  wire [31:0] _GEN_195; // @[core.scala 193:16]
  wire [31:0] _GEN_196; // @[core.scala 193:16]
  wire [31:0] _GEN_197; // @[core.scala 193:16]
  wire [31:0] _GEN_198; // @[core.scala 193:16]
  wire [31:0] _GEN_199; // @[core.scala 193:16]
  wire [31:0] _GEN_200; // @[core.scala 193:16]
  wire [31:0] _GEN_201; // @[core.scala 193:16]
  wire [31:0] _GEN_202; // @[core.scala 193:16]
  wire [31:0] _GEN_203; // @[core.scala 193:16]
  wire [31:0] _GEN_204; // @[core.scala 193:16]
  wire [31:0] _GEN_205; // @[core.scala 193:16]
  wire [31:0] _GEN_206; // @[core.scala 193:16]
  wire [31:0] _GEN_207; // @[core.scala 193:16]
  wire [31:0] _GEN_208; // @[core.scala 193:16]
  wire [31:0] _GEN_209; // @[core.scala 193:16]
  wire [31:0] _GEN_210; // @[core.scala 193:16]
  wire [31:0] _GEN_211; // @[core.scala 193:16]
  wire [31:0] _GEN_212; // @[core.scala 193:16]
  IDModule idm ( // @[core.scala 38:31]
    .io_imem(idm_io_imem),
    .io_inst_bits(idm_io_inst_bits),
    .io_inst_rd(idm_io_inst_rd),
    .io_inst_rs1(idm_io_inst_rs1),
    .io_inst_rs2(idm_io_inst_rs2)
  );
  ALU alu ( // @[core.scala 71:29]
    .io_op1(alu_io_op1),
    .io_op2(alu_io_op2),
    .io_alu_op(alu_io_alu_op),
    .io_out(alu_io_out)
  );
  assign _T_3 = idm_io_inst_bits[31]; // @[control.scala 203:53]
  assign _T_54 = idm_io_inst_bits[31]; // @[Cat.scala 29:58]
  assign _T_55 = {8{_T_3}}; // @[Cat.scala 29:58]
  assign _T_57 = {11{_T_3}}; // @[Cat.scala 29:58]
  assign _T_116 = idm_io_inst_bits[19:12]; // @[Cat.scala 29:58]
  assign _T_118 = idm_io_inst_bits[30:20]; // @[Cat.scala 29:58]
  assign _T_237 = idm_io_inst_bits[20]; // @[Cat.scala 29:58]
  assign imm_j = {_T_54,_T_57,_T_116,_T_237,idm_io_inst_bits[30:25],idm_io_inst_bits[24:21],1'h0}; // @[control.scala 217:57]
  assign _T_298 = idm_io_inst_bits[7]; // @[Cat.scala 29:58]
  assign _GEN_1 = 5'h1 == idm_io_inst_rs1 ? rv32i_reg_1 : rv32i_reg_0; // @[core.scala 45:52]
  assign _GEN_2 = 5'h2 == idm_io_inst_rs1 ? rv32i_reg_2 : _GEN_1; // @[core.scala 45:52]
  assign _GEN_3 = 5'h3 == idm_io_inst_rs1 ? rv32i_reg_3 : _GEN_2; // @[core.scala 45:52]
  assign _GEN_4 = 5'h4 == idm_io_inst_rs1 ? rv32i_reg_4 : _GEN_3; // @[core.scala 45:52]
  assign _GEN_5 = 5'h5 == idm_io_inst_rs1 ? rv32i_reg_5 : _GEN_4; // @[core.scala 45:52]
  assign _GEN_6 = 5'h6 == idm_io_inst_rs1 ? rv32i_reg_6 : _GEN_5; // @[core.scala 45:52]
  assign _GEN_7 = 5'h7 == idm_io_inst_rs1 ? rv32i_reg_7 : _GEN_6; // @[core.scala 45:52]
  assign _GEN_8 = 5'h8 == idm_io_inst_rs1 ? rv32i_reg_8 : _GEN_7; // @[core.scala 45:52]
  assign _GEN_9 = 5'h9 == idm_io_inst_rs1 ? rv32i_reg_9 : _GEN_8; // @[core.scala 45:52]
  assign _GEN_10 = 5'ha == idm_io_inst_rs1 ? rv32i_reg_10 : _GEN_9; // @[core.scala 45:52]
  assign _GEN_11 = 5'hb == idm_io_inst_rs1 ? rv32i_reg_11 : _GEN_10; // @[core.scala 45:52]
  assign _GEN_12 = 5'hc == idm_io_inst_rs1 ? rv32i_reg_12 : _GEN_11; // @[core.scala 45:52]
  assign _GEN_13 = 5'hd == idm_io_inst_rs1 ? rv32i_reg_13 : _GEN_12; // @[core.scala 45:52]
  assign _GEN_14 = 5'he == idm_io_inst_rs1 ? rv32i_reg_14 : _GEN_13; // @[core.scala 45:52]
  assign _GEN_15 = 5'hf == idm_io_inst_rs1 ? rv32i_reg_15 : _GEN_14; // @[core.scala 45:52]
  assign _GEN_16 = 5'h10 == idm_io_inst_rs1 ? rv32i_reg_16 : _GEN_15; // @[core.scala 45:52]
  assign _GEN_17 = 5'h11 == idm_io_inst_rs1 ? rv32i_reg_17 : _GEN_16; // @[core.scala 45:52]
  assign _GEN_18 = 5'h12 == idm_io_inst_rs1 ? rv32i_reg_18 : _GEN_17; // @[core.scala 45:52]
  assign _GEN_19 = 5'h13 == idm_io_inst_rs1 ? rv32i_reg_19 : _GEN_18; // @[core.scala 45:52]
  assign _GEN_20 = 5'h14 == idm_io_inst_rs1 ? rv32i_reg_20 : _GEN_19; // @[core.scala 45:52]
  assign _GEN_21 = 5'h15 == idm_io_inst_rs1 ? rv32i_reg_21 : _GEN_20; // @[core.scala 45:52]
  assign _GEN_22 = 5'h16 == idm_io_inst_rs1 ? rv32i_reg_22 : _GEN_21; // @[core.scala 45:52]
  assign _GEN_23 = 5'h17 == idm_io_inst_rs1 ? rv32i_reg_23 : _GEN_22; // @[core.scala 45:52]
  assign _GEN_24 = 5'h18 == idm_io_inst_rs1 ? rv32i_reg_24 : _GEN_23; // @[core.scala 45:52]
  assign _GEN_25 = 5'h19 == idm_io_inst_rs1 ? rv32i_reg_25 : _GEN_24; // @[core.scala 45:52]
  assign _GEN_26 = 5'h1a == idm_io_inst_rs1 ? rv32i_reg_26 : _GEN_25; // @[core.scala 45:52]
  assign _GEN_27 = 5'h1b == idm_io_inst_rs1 ? rv32i_reg_27 : _GEN_26; // @[core.scala 45:52]
  assign _GEN_28 = 5'h1c == idm_io_inst_rs1 ? rv32i_reg_28 : _GEN_27; // @[core.scala 45:52]
  assign _GEN_29 = 5'h1d == idm_io_inst_rs1 ? rv32i_reg_29 : _GEN_28; // @[core.scala 45:52]
  assign _GEN_30 = 5'h1e == idm_io_inst_rs1 ? rv32i_reg_30 : _GEN_29; // @[core.scala 45:52]
  assign _GEN_31 = 5'h1f == idm_io_inst_rs1 ? rv32i_reg_31 : _GEN_30; // @[core.scala 45:52]
  assign val_rs1 = 5'h1f == idm_io_inst_rs1 ? rv32i_reg_31 : _GEN_30; // @[core.scala 45:52]
  assign _GEN_33 = 5'h1 == idm_io_inst_rs2 ? rv32i_reg_1 : rv32i_reg_0; // @[core.scala 46:52]
  assign _GEN_34 = 5'h2 == idm_io_inst_rs2 ? rv32i_reg_2 : _GEN_33; // @[core.scala 46:52]
  assign _GEN_35 = 5'h3 == idm_io_inst_rs2 ? rv32i_reg_3 : _GEN_34; // @[core.scala 46:52]
  assign _GEN_36 = 5'h4 == idm_io_inst_rs2 ? rv32i_reg_4 : _GEN_35; // @[core.scala 46:52]
  assign _GEN_37 = 5'h5 == idm_io_inst_rs2 ? rv32i_reg_5 : _GEN_36; // @[core.scala 46:52]
  assign _GEN_38 = 5'h6 == idm_io_inst_rs2 ? rv32i_reg_6 : _GEN_37; // @[core.scala 46:52]
  assign _GEN_39 = 5'h7 == idm_io_inst_rs2 ? rv32i_reg_7 : _GEN_38; // @[core.scala 46:52]
  assign _GEN_40 = 5'h8 == idm_io_inst_rs2 ? rv32i_reg_8 : _GEN_39; // @[core.scala 46:52]
  assign _GEN_41 = 5'h9 == idm_io_inst_rs2 ? rv32i_reg_9 : _GEN_40; // @[core.scala 46:52]
  assign _GEN_42 = 5'ha == idm_io_inst_rs2 ? rv32i_reg_10 : _GEN_41; // @[core.scala 46:52]
  assign _GEN_43 = 5'hb == idm_io_inst_rs2 ? rv32i_reg_11 : _GEN_42; // @[core.scala 46:52]
  assign _GEN_44 = 5'hc == idm_io_inst_rs2 ? rv32i_reg_12 : _GEN_43; // @[core.scala 46:52]
  assign _GEN_45 = 5'hd == idm_io_inst_rs2 ? rv32i_reg_13 : _GEN_44; // @[core.scala 46:52]
  assign _GEN_46 = 5'he == idm_io_inst_rs2 ? rv32i_reg_14 : _GEN_45; // @[core.scala 46:52]
  assign _GEN_47 = 5'hf == idm_io_inst_rs2 ? rv32i_reg_15 : _GEN_46; // @[core.scala 46:52]
  assign _GEN_48 = 5'h10 == idm_io_inst_rs2 ? rv32i_reg_16 : _GEN_47; // @[core.scala 46:52]
  assign _GEN_49 = 5'h11 == idm_io_inst_rs2 ? rv32i_reg_17 : _GEN_48; // @[core.scala 46:52]
  assign _GEN_50 = 5'h12 == idm_io_inst_rs2 ? rv32i_reg_18 : _GEN_49; // @[core.scala 46:52]
  assign _GEN_51 = 5'h13 == idm_io_inst_rs2 ? rv32i_reg_19 : _GEN_50; // @[core.scala 46:52]
  assign _GEN_52 = 5'h14 == idm_io_inst_rs2 ? rv32i_reg_20 : _GEN_51; // @[core.scala 46:52]
  assign _GEN_53 = 5'h15 == idm_io_inst_rs2 ? rv32i_reg_21 : _GEN_52; // @[core.scala 46:52]
  assign _GEN_54 = 5'h16 == idm_io_inst_rs2 ? rv32i_reg_22 : _GEN_53; // @[core.scala 46:52]
  assign _GEN_55 = 5'h17 == idm_io_inst_rs2 ? rv32i_reg_23 : _GEN_54; // @[core.scala 46:52]
  assign _GEN_56 = 5'h18 == idm_io_inst_rs2 ? rv32i_reg_24 : _GEN_55; // @[core.scala 46:52]
  assign _GEN_57 = 5'h19 == idm_io_inst_rs2 ? rv32i_reg_25 : _GEN_56; // @[core.scala 46:52]
  assign _GEN_58 = 5'h1a == idm_io_inst_rs2 ? rv32i_reg_26 : _GEN_57; // @[core.scala 46:52]
  assign _GEN_59 = 5'h1b == idm_io_inst_rs2 ? rv32i_reg_27 : _GEN_58; // @[core.scala 46:52]
  assign _GEN_60 = 5'h1c == idm_io_inst_rs2 ? rv32i_reg_28 : _GEN_59; // @[core.scala 46:52]
  assign _GEN_61 = 5'h1d == idm_io_inst_rs2 ? rv32i_reg_29 : _GEN_60; // @[core.scala 46:52]
  assign _GEN_62 = 5'h1e == idm_io_inst_rs2 ? rv32i_reg_30 : _GEN_61; // @[core.scala 46:52]
  assign _GEN_63 = 5'h1f == idm_io_inst_rs2 ? rv32i_reg_31 : _GEN_62; // @[core.scala 46:52]
  assign val_rs2 = 5'h1f == idm_io_inst_rs2 ? rv32i_reg_31 : _GEN_62; // @[core.scala 46:52]
  assign _T_307 = idm_io_inst_bits & 32'h707f; // @[control.scala 197:55]
  assign _T_308 = 32'h2003 == _T_307; // @[control.scala 197:55]
  assign _T_310 = 32'h3 == _T_307; // @[control.scala 197:55]
  assign _T_312 = 32'h4003 == _T_307; // @[control.scala 197:55]
  assign _T_314 = 32'h1003 == _T_307; // @[control.scala 197:55]
  assign _T_316 = 32'h5003 == _T_307; // @[control.scala 197:55]
  assign _T_318 = 32'h2023 == _T_307; // @[control.scala 197:55]
  assign _T_320 = 32'h23 == _T_307; // @[control.scala 197:55]
  assign _T_322 = 32'h1023 == _T_307; // @[control.scala 197:55]
  assign _T_323 = idm_io_inst_bits & 32'h7f; // @[control.scala 197:55]
  assign _T_324 = 32'h17 == _T_323; // @[control.scala 197:55]
  assign _T_326 = 32'h37 == _T_323; // @[control.scala 197:55]
  assign _T_328 = 32'h13 == _T_307; // @[control.scala 197:55]
  assign _T_330 = 32'h7013 == _T_307; // @[control.scala 197:55]
  assign _T_332 = 32'h6013 == _T_307; // @[control.scala 197:55]
  assign _T_334 = 32'h4013 == _T_307; // @[control.scala 197:55]
  assign _T_336 = 32'h2013 == _T_307; // @[control.scala 197:55]
  assign _T_338 = 32'h3013 == _T_307; // @[control.scala 197:55]
  assign _T_339 = idm_io_inst_bits & 32'hfc00707f; // @[control.scala 197:55]
  assign _T_340 = 32'h1013 == _T_339; // @[control.scala 197:55]
  assign _T_342 = 32'h40005013 == _T_339; // @[control.scala 197:55]
  assign _T_344 = 32'h5013 == _T_339; // @[control.scala 197:55]
  assign _T_345 = idm_io_inst_bits & 32'hfe00707f; // @[control.scala 197:55]
  assign _T_346 = 32'h1033 == _T_345; // @[control.scala 197:55]
  assign _T_348 = 32'h33 == _T_345; // @[control.scala 197:55]
  assign _T_350 = 32'h40000033 == _T_345; // @[control.scala 197:55]
  assign _T_352 = 32'h2033 == _T_345; // @[control.scala 197:55]
  assign _T_354 = 32'h3033 == _T_345; // @[control.scala 197:55]
  assign _T_356 = 32'h7033 == _T_345; // @[control.scala 197:55]
  assign _T_358 = 32'h6033 == _T_345; // @[control.scala 197:55]
  assign _T_360 = 32'h4033 == _T_345; // @[control.scala 197:55]
  assign _T_362 = 32'h40005033 == _T_345; // @[control.scala 197:55]
  assign _T_364 = 32'h5033 == _T_345; // @[control.scala 197:55]
  assign _T_366 = 32'h6f == _T_323; // @[control.scala 197:55]
  assign _T_368 = 32'h67 == _T_307; // @[control.scala 197:55]
  assign _T_370 = 32'h63 == _T_307; // @[control.scala 197:55]
  assign _T_372 = 32'h1063 == _T_307; // @[control.scala 197:55]
  assign _T_374 = 32'h5063 == _T_307; // @[control.scala 197:55]
  assign _T_376 = 32'h7063 == _T_307; // @[control.scala 197:55]
  assign _T_378 = 32'h4063 == _T_307; // @[control.scala 197:55]
  assign _T_380 = 32'h6063 == _T_307; // @[control.scala 197:55]
  assign _T_382 = 32'h5073 == _T_307; // @[control.scala 197:55]
  assign _T_384 = 32'h6073 == _T_307; // @[control.scala 197:55]
  assign _T_386 = 32'h7073 == _T_307; // @[control.scala 197:55]
  assign _T_388 = 32'h1073 == _T_307; // @[control.scala 197:55]
  assign _T_390 = 32'h2073 == _T_307; // @[control.scala 197:55]
  assign _T_392 = 32'h3073 == _T_307; // @[control.scala 197:55]
  assign _T_552 = _T_380 ? 3'h6 : 3'h0; // @[Mux.scala 87:16]
  assign _T_553 = _T_378 ? 3'h5 : _T_552; // @[Mux.scala 87:16]
  assign _T_554 = _T_376 ? 3'h4 : _T_553; // @[Mux.scala 87:16]
  assign _T_555 = _T_374 ? 3'h3 : _T_554; // @[Mux.scala 87:16]
  assign _T_556 = _T_372 ? 3'h1 : _T_555; // @[Mux.scala 87:16]
  assign _T_557 = _T_370 ? 3'h2 : _T_556; // @[Mux.scala 87:16]
  assign _T_558 = _T_368 ? 4'h8 : {{1'd0}, _T_557}; // @[Mux.scala 87:16]
  assign _T_559 = _T_366 ? 4'h7 : _T_558; // @[Mux.scala 87:16]
  assign _T_560 = _T_364 ? 4'h0 : _T_559; // @[Mux.scala 87:16]
  assign _T_561 = _T_362 ? 4'h0 : _T_560; // @[Mux.scala 87:16]
  assign _T_562 = _T_360 ? 4'h0 : _T_561; // @[Mux.scala 87:16]
  assign _T_563 = _T_358 ? 4'h0 : _T_562; // @[Mux.scala 87:16]
  assign _T_564 = _T_356 ? 4'h0 : _T_563; // @[Mux.scala 87:16]
  assign _T_565 = _T_354 ? 4'h0 : _T_564; // @[Mux.scala 87:16]
  assign _T_566 = _T_352 ? 4'h0 : _T_565; // @[Mux.scala 87:16]
  assign _T_567 = _T_350 ? 4'h0 : _T_566; // @[Mux.scala 87:16]
  assign _T_568 = _T_348 ? 4'h0 : _T_567; // @[Mux.scala 87:16]
  assign _T_569 = _T_346 ? 4'h0 : _T_568; // @[Mux.scala 87:16]
  assign _T_570 = _T_344 ? 4'h0 : _T_569; // @[Mux.scala 87:16]
  assign _T_571 = _T_342 ? 4'h0 : _T_570; // @[Mux.scala 87:16]
  assign _T_572 = _T_340 ? 4'h0 : _T_571; // @[Mux.scala 87:16]
  assign _T_573 = _T_338 ? 4'h0 : _T_572; // @[Mux.scala 87:16]
  assign _T_574 = _T_336 ? 4'h0 : _T_573; // @[Mux.scala 87:16]
  assign _T_575 = _T_334 ? 4'h0 : _T_574; // @[Mux.scala 87:16]
  assign _T_576 = _T_332 ? 4'h0 : _T_575; // @[Mux.scala 87:16]
  assign _T_577 = _T_330 ? 4'h0 : _T_576; // @[Mux.scala 87:16]
  assign _T_578 = _T_328 ? 4'h0 : _T_577; // @[Mux.scala 87:16]
  assign _T_579 = _T_326 ? 4'h0 : _T_578; // @[Mux.scala 87:16]
  assign _T_580 = _T_324 ? 4'h0 : _T_579; // @[Mux.scala 87:16]
  assign _T_581 = _T_322 ? 4'h0 : _T_580; // @[Mux.scala 87:16]
  assign _T_582 = _T_320 ? 4'h0 : _T_581; // @[Mux.scala 87:16]
  assign _T_583 = _T_318 ? 4'h0 : _T_582; // @[Mux.scala 87:16]
  assign _T_584 = _T_316 ? 4'h0 : _T_583; // @[Mux.scala 87:16]
  assign _T_585 = _T_314 ? 4'h0 : _T_584; // @[Mux.scala 87:16]
  assign _T_586 = _T_312 ? 4'h0 : _T_585; // @[Mux.scala 87:16]
  assign _T_587 = _T_310 ? 4'h0 : _T_586; // @[Mux.scala 87:16]
  assign id_ctrl_br_type = _T_308 ? 4'h0 : _T_587; // @[Mux.scala 87:16]
  assign _T_690 = _T_386 ? 2'h2 : 2'h0; // @[Mux.scala 87:16]
  assign _T_691 = _T_384 ? 2'h2 : _T_690; // @[Mux.scala 87:16]
  assign _T_692 = _T_382 ? 2'h2 : _T_691; // @[Mux.scala 87:16]
  assign _T_693 = _T_380 ? 2'h0 : _T_692; // @[Mux.scala 87:16]
  assign _T_694 = _T_378 ? 2'h0 : _T_693; // @[Mux.scala 87:16]
  assign _T_695 = _T_376 ? 2'h0 : _T_694; // @[Mux.scala 87:16]
  assign _T_696 = _T_374 ? 2'h0 : _T_695; // @[Mux.scala 87:16]
  assign _T_697 = _T_372 ? 2'h0 : _T_696; // @[Mux.scala 87:16]
  assign _T_698 = _T_370 ? 2'h0 : _T_697; // @[Mux.scala 87:16]
  assign _T_699 = _T_368 ? 2'h0 : _T_698; // @[Mux.scala 87:16]
  assign _T_700 = _T_366 ? 2'h0 : _T_699; // @[Mux.scala 87:16]
  assign _T_701 = _T_364 ? 2'h0 : _T_700; // @[Mux.scala 87:16]
  assign _T_702 = _T_362 ? 2'h0 : _T_701; // @[Mux.scala 87:16]
  assign _T_703 = _T_360 ? 2'h0 : _T_702; // @[Mux.scala 87:16]
  assign _T_704 = _T_358 ? 2'h0 : _T_703; // @[Mux.scala 87:16]
  assign _T_705 = _T_356 ? 2'h0 : _T_704; // @[Mux.scala 87:16]
  assign _T_706 = _T_354 ? 2'h0 : _T_705; // @[Mux.scala 87:16]
  assign _T_707 = _T_352 ? 2'h0 : _T_706; // @[Mux.scala 87:16]
  assign _T_708 = _T_350 ? 2'h0 : _T_707; // @[Mux.scala 87:16]
  assign _T_709 = _T_348 ? 2'h0 : _T_708; // @[Mux.scala 87:16]
  assign _T_710 = _T_346 ? 2'h0 : _T_709; // @[Mux.scala 87:16]
  assign _T_711 = _T_344 ? 2'h0 : _T_710; // @[Mux.scala 87:16]
  assign _T_712 = _T_342 ? 2'h0 : _T_711; // @[Mux.scala 87:16]
  assign _T_713 = _T_340 ? 2'h0 : _T_712; // @[Mux.scala 87:16]
  assign _T_714 = _T_338 ? 2'h0 : _T_713; // @[Mux.scala 87:16]
  assign _T_715 = _T_336 ? 2'h0 : _T_714; // @[Mux.scala 87:16]
  assign _T_716 = _T_334 ? 2'h0 : _T_715; // @[Mux.scala 87:16]
  assign _T_717 = _T_332 ? 2'h0 : _T_716; // @[Mux.scala 87:16]
  assign _T_718 = _T_330 ? 2'h0 : _T_717; // @[Mux.scala 87:16]
  assign _T_719 = _T_328 ? 2'h0 : _T_718; // @[Mux.scala 87:16]
  assign _T_720 = _T_326 ? 2'h1 : _T_719; // @[Mux.scala 87:16]
  assign _T_721 = _T_324 ? 2'h1 : _T_720; // @[Mux.scala 87:16]
  assign _T_722 = _T_322 ? 2'h0 : _T_721; // @[Mux.scala 87:16]
  assign _T_723 = _T_320 ? 2'h0 : _T_722; // @[Mux.scala 87:16]
  assign _T_724 = _T_318 ? 2'h0 : _T_723; // @[Mux.scala 87:16]
  assign _T_725 = _T_316 ? 2'h0 : _T_724; // @[Mux.scala 87:16]
  assign _T_726 = _T_314 ? 2'h0 : _T_725; // @[Mux.scala 87:16]
  assign _T_727 = _T_312 ? 2'h0 : _T_726; // @[Mux.scala 87:16]
  assign _T_728 = _T_310 ? 2'h0 : _T_727; // @[Mux.scala 87:16]
  assign id_ctrl_alu_op1 = _T_308 ? 2'h0 : _T_728; // @[Mux.scala 87:16]
  assign _T_841 = _T_366 ? 1'h0 : _T_368; // @[Mux.scala 87:16]
  assign _T_842 = _T_364 ? 1'h0 : _T_841; // @[Mux.scala 87:16]
  assign _T_843 = _T_362 ? 1'h0 : _T_842; // @[Mux.scala 87:16]
  assign _T_844 = _T_360 ? 1'h0 : _T_843; // @[Mux.scala 87:16]
  assign _T_845 = _T_358 ? 1'h0 : _T_844; // @[Mux.scala 87:16]
  assign _T_846 = _T_356 ? 1'h0 : _T_845; // @[Mux.scala 87:16]
  assign _T_847 = _T_354 ? 1'h0 : _T_846; // @[Mux.scala 87:16]
  assign _T_848 = _T_352 ? 1'h0 : _T_847; // @[Mux.scala 87:16]
  assign _T_849 = _T_350 ? 1'h0 : _T_848; // @[Mux.scala 87:16]
  assign _T_850 = _T_348 ? 1'h0 : _T_849; // @[Mux.scala 87:16]
  assign _T_851 = _T_346 ? 1'h0 : _T_850; // @[Mux.scala 87:16]
  assign _T_852 = _T_344 | _T_851; // @[Mux.scala 87:16]
  assign _T_853 = _T_342 | _T_852; // @[Mux.scala 87:16]
  assign _T_854 = _T_340 | _T_853; // @[Mux.scala 87:16]
  assign _T_855 = _T_338 | _T_854; // @[Mux.scala 87:16]
  assign _T_856 = _T_336 | _T_855; // @[Mux.scala 87:16]
  assign _T_857 = _T_334 | _T_856; // @[Mux.scala 87:16]
  assign _T_858 = _T_332 | _T_857; // @[Mux.scala 87:16]
  assign _T_859 = _T_330 | _T_858; // @[Mux.scala 87:16]
  assign _T_860 = _T_328 | _T_859; // @[Mux.scala 87:16]
  assign _T_861 = _T_326 ? 1'h0 : _T_860; // @[Mux.scala 87:16]
  assign _T_862 = _T_324 ? 2'h3 : {{1'd0}, _T_861}; // @[Mux.scala 87:16]
  assign _T_863 = _T_322 ? 2'h2 : _T_862; // @[Mux.scala 87:16]
  assign _T_864 = _T_320 ? 2'h2 : _T_863; // @[Mux.scala 87:16]
  assign _T_865 = _T_318 ? 2'h2 : _T_864; // @[Mux.scala 87:16]
  assign _T_866 = _T_316 ? 2'h1 : _T_865; // @[Mux.scala 87:16]
  assign _T_867 = _T_314 ? 2'h1 : _T_866; // @[Mux.scala 87:16]
  assign _T_868 = _T_312 ? 2'h1 : _T_867; // @[Mux.scala 87:16]
  assign _T_869 = _T_310 ? 2'h1 : _T_868; // @[Mux.scala 87:16]
  assign id_ctrl_alu_op2 = _T_308 ? 2'h1 : _T_869; // @[Mux.scala 87:16]
  assign _T_969 = _T_392 ? 4'hb : 4'h0; // @[Mux.scala 87:16]
  assign _T_970 = _T_390 ? 4'hb : _T_969; // @[Mux.scala 87:16]
  assign _T_971 = _T_388 ? 4'hb : _T_970; // @[Mux.scala 87:16]
  assign _T_972 = _T_386 ? 4'hb : _T_971; // @[Mux.scala 87:16]
  assign _T_973 = _T_384 ? 4'hb : _T_972; // @[Mux.scala 87:16]
  assign _T_974 = _T_382 ? 4'hb : _T_973; // @[Mux.scala 87:16]
  assign _T_975 = _T_380 ? 4'h0 : _T_974; // @[Mux.scala 87:16]
  assign _T_976 = _T_378 ? 4'h0 : _T_975; // @[Mux.scala 87:16]
  assign _T_977 = _T_376 ? 4'h0 : _T_976; // @[Mux.scala 87:16]
  assign _T_978 = _T_374 ? 4'h0 : _T_977; // @[Mux.scala 87:16]
  assign _T_979 = _T_372 ? 4'h0 : _T_978; // @[Mux.scala 87:16]
  assign _T_980 = _T_370 ? 4'h0 : _T_979; // @[Mux.scala 87:16]
  assign _T_981 = _T_368 ? 4'h0 : _T_980; // @[Mux.scala 87:16]
  assign _T_982 = _T_366 ? 4'h0 : _T_981; // @[Mux.scala 87:16]
  assign _T_983 = _T_364 ? 4'h4 : _T_982; // @[Mux.scala 87:16]
  assign _T_984 = _T_362 ? 4'h5 : _T_983; // @[Mux.scala 87:16]
  assign _T_985 = _T_360 ? 4'h8 : _T_984; // @[Mux.scala 87:16]
  assign _T_986 = _T_358 ? 4'h7 : _T_985; // @[Mux.scala 87:16]
  assign _T_987 = _T_356 ? 4'h6 : _T_986; // @[Mux.scala 87:16]
  assign _T_988 = _T_354 ? 4'ha : _T_987; // @[Mux.scala 87:16]
  assign _T_989 = _T_352 ? 4'h9 : _T_988; // @[Mux.scala 87:16]
  assign _T_990 = _T_350 ? 4'h2 : _T_989; // @[Mux.scala 87:16]
  assign _T_991 = _T_348 ? 4'h1 : _T_990; // @[Mux.scala 87:16]
  assign _T_992 = _T_346 ? 4'h3 : _T_991; // @[Mux.scala 87:16]
  assign _T_993 = _T_344 ? 4'h4 : _T_992; // @[Mux.scala 87:16]
  assign _T_994 = _T_342 ? 4'h5 : _T_993; // @[Mux.scala 87:16]
  assign _T_995 = _T_340 ? 4'h3 : _T_994; // @[Mux.scala 87:16]
  assign _T_996 = _T_338 ? 4'ha : _T_995; // @[Mux.scala 87:16]
  assign _T_997 = _T_336 ? 4'h9 : _T_996; // @[Mux.scala 87:16]
  assign _T_998 = _T_334 ? 4'h8 : _T_997; // @[Mux.scala 87:16]
  assign _T_999 = _T_332 ? 4'h7 : _T_998; // @[Mux.scala 87:16]
  assign _T_1000 = _T_330 ? 4'h6 : _T_999; // @[Mux.scala 87:16]
  assign _T_1001 = _T_328 ? 4'h1 : _T_1000; // @[Mux.scala 87:16]
  assign _T_1002 = _T_326 ? 4'hb : _T_1001; // @[Mux.scala 87:16]
  assign _T_1003 = _T_324 ? 4'h1 : _T_1002; // @[Mux.scala 87:16]
  assign _T_1004 = _T_322 ? 4'h1 : _T_1003; // @[Mux.scala 87:16]
  assign _T_1005 = _T_320 ? 4'h1 : _T_1004; // @[Mux.scala 87:16]
  assign _T_1006 = _T_318 ? 4'h1 : _T_1005; // @[Mux.scala 87:16]
  assign _T_1007 = _T_316 ? 4'h1 : _T_1006; // @[Mux.scala 87:16]
  assign _T_1008 = _T_314 ? 4'h1 : _T_1007; // @[Mux.scala 87:16]
  assign _T_1009 = _T_312 ? 4'h1 : _T_1008; // @[Mux.scala 87:16]
  assign _T_1010 = _T_310 ? 4'h1 : _T_1009; // @[Mux.scala 87:16]
  assign _T_1110 = _T_392 ? 2'h3 : 2'h0; // @[Mux.scala 87:16]
  assign _T_1111 = _T_390 ? 2'h3 : _T_1110; // @[Mux.scala 87:16]
  assign _T_1112 = _T_388 ? 2'h3 : _T_1111; // @[Mux.scala 87:16]
  assign _T_1113 = _T_386 ? 2'h3 : _T_1112; // @[Mux.scala 87:16]
  assign _T_1114 = _T_384 ? 2'h3 : _T_1113; // @[Mux.scala 87:16]
  assign _T_1115 = _T_382 ? 2'h3 : _T_1114; // @[Mux.scala 87:16]
  assign _T_1116 = _T_380 ? 2'h0 : _T_1115; // @[Mux.scala 87:16]
  assign _T_1117 = _T_378 ? 2'h0 : _T_1116; // @[Mux.scala 87:16]
  assign _T_1118 = _T_376 ? 2'h0 : _T_1117; // @[Mux.scala 87:16]
  assign _T_1119 = _T_374 ? 2'h0 : _T_1118; // @[Mux.scala 87:16]
  assign _T_1120 = _T_372 ? 2'h0 : _T_1119; // @[Mux.scala 87:16]
  assign _T_1121 = _T_370 ? 2'h0 : _T_1120; // @[Mux.scala 87:16]
  assign _T_1122 = _T_368 ? 2'h2 : _T_1121; // @[Mux.scala 87:16]
  assign _T_1123 = _T_366 ? 2'h2 : _T_1122; // @[Mux.scala 87:16]
  assign _T_1124 = _T_364 ? 2'h0 : _T_1123; // @[Mux.scala 87:16]
  assign _T_1125 = _T_362 ? 2'h0 : _T_1124; // @[Mux.scala 87:16]
  assign _T_1126 = _T_360 ? 2'h0 : _T_1125; // @[Mux.scala 87:16]
  assign _T_1127 = _T_358 ? 2'h0 : _T_1126; // @[Mux.scala 87:16]
  assign _T_1128 = _T_356 ? 2'h0 : _T_1127; // @[Mux.scala 87:16]
  assign _T_1129 = _T_354 ? 2'h0 : _T_1128; // @[Mux.scala 87:16]
  assign _T_1130 = _T_352 ? 2'h0 : _T_1129; // @[Mux.scala 87:16]
  assign _T_1131 = _T_350 ? 2'h0 : _T_1130; // @[Mux.scala 87:16]
  assign _T_1132 = _T_348 ? 2'h0 : _T_1131; // @[Mux.scala 87:16]
  assign _T_1133 = _T_346 ? 2'h0 : _T_1132; // @[Mux.scala 87:16]
  assign _T_1134 = _T_344 ? 2'h0 : _T_1133; // @[Mux.scala 87:16]
  assign _T_1135 = _T_342 ? 2'h0 : _T_1134; // @[Mux.scala 87:16]
  assign _T_1136 = _T_340 ? 2'h0 : _T_1135; // @[Mux.scala 87:16]
  assign _T_1137 = _T_338 ? 2'h0 : _T_1136; // @[Mux.scala 87:16]
  assign _T_1138 = _T_336 ? 2'h0 : _T_1137; // @[Mux.scala 87:16]
  assign _T_1139 = _T_334 ? 2'h0 : _T_1138; // @[Mux.scala 87:16]
  assign _T_1140 = _T_332 ? 2'h0 : _T_1139; // @[Mux.scala 87:16]
  assign _T_1141 = _T_330 ? 2'h0 : _T_1140; // @[Mux.scala 87:16]
  assign _T_1142 = _T_328 ? 2'h0 : _T_1141; // @[Mux.scala 87:16]
  assign _T_1143 = _T_326 ? 2'h0 : _T_1142; // @[Mux.scala 87:16]
  assign _T_1144 = _T_324 ? 2'h0 : _T_1143; // @[Mux.scala 87:16]
  assign _T_1145 = _T_322 ? 2'h0 : _T_1144; // @[Mux.scala 87:16]
  assign _T_1146 = _T_320 ? 2'h0 : _T_1145; // @[Mux.scala 87:16]
  assign _T_1147 = _T_318 ? 2'h0 : _T_1146; // @[Mux.scala 87:16]
  assign _T_1148 = _T_316 ? 2'h1 : _T_1147; // @[Mux.scala 87:16]
  assign _T_1149 = _T_314 ? 2'h1 : _T_1148; // @[Mux.scala 87:16]
  assign _T_1150 = _T_312 ? 2'h1 : _T_1149; // @[Mux.scala 87:16]
  assign _T_1151 = _T_310 ? 2'h1 : _T_1150; // @[Mux.scala 87:16]
  assign id_ctrl_wb_sel = _T_308 ? 2'h1 : _T_1151; // @[Mux.scala 87:16]
  assign _T_1252 = _T_390 | _T_392; // @[Mux.scala 87:16]
  assign _T_1253 = _T_388 | _T_1252; // @[Mux.scala 87:16]
  assign _T_1254 = _T_386 | _T_1253; // @[Mux.scala 87:16]
  assign _T_1255 = _T_384 | _T_1254; // @[Mux.scala 87:16]
  assign _T_1256 = _T_382 | _T_1255; // @[Mux.scala 87:16]
  assign _T_1257 = _T_380 ? 1'h0 : _T_1256; // @[Mux.scala 87:16]
  assign _T_1258 = _T_378 ? 1'h0 : _T_1257; // @[Mux.scala 87:16]
  assign _T_1259 = _T_376 ? 1'h0 : _T_1258; // @[Mux.scala 87:16]
  assign _T_1260 = _T_374 ? 1'h0 : _T_1259; // @[Mux.scala 87:16]
  assign _T_1261 = _T_372 ? 1'h0 : _T_1260; // @[Mux.scala 87:16]
  assign _T_1262 = _T_370 ? 1'h0 : _T_1261; // @[Mux.scala 87:16]
  assign _T_1263 = _T_368 | _T_1262; // @[Mux.scala 87:16]
  assign _T_1264 = _T_366 | _T_1263; // @[Mux.scala 87:16]
  assign _T_1265 = _T_364 | _T_1264; // @[Mux.scala 87:16]
  assign _T_1266 = _T_362 | _T_1265; // @[Mux.scala 87:16]
  assign _T_1267 = _T_360 | _T_1266; // @[Mux.scala 87:16]
  assign _T_1268 = _T_358 | _T_1267; // @[Mux.scala 87:16]
  assign _T_1269 = _T_356 | _T_1268; // @[Mux.scala 87:16]
  assign _T_1270 = _T_354 | _T_1269; // @[Mux.scala 87:16]
  assign _T_1271 = _T_352 | _T_1270; // @[Mux.scala 87:16]
  assign _T_1272 = _T_350 | _T_1271; // @[Mux.scala 87:16]
  assign _T_1273 = _T_348 | _T_1272; // @[Mux.scala 87:16]
  assign _T_1274 = _T_346 | _T_1273; // @[Mux.scala 87:16]
  assign _T_1275 = _T_344 | _T_1274; // @[Mux.scala 87:16]
  assign _T_1276 = _T_342 | _T_1275; // @[Mux.scala 87:16]
  assign _T_1277 = _T_340 | _T_1276; // @[Mux.scala 87:16]
  assign _T_1278 = _T_338 | _T_1277; // @[Mux.scala 87:16]
  assign _T_1279 = _T_336 | _T_1278; // @[Mux.scala 87:16]
  assign _T_1280 = _T_334 | _T_1279; // @[Mux.scala 87:16]
  assign _T_1281 = _T_332 | _T_1280; // @[Mux.scala 87:16]
  assign _T_1282 = _T_330 | _T_1281; // @[Mux.scala 87:16]
  assign _T_1283 = _T_328 | _T_1282; // @[Mux.scala 87:16]
  assign _T_1284 = _T_326 | _T_1283; // @[Mux.scala 87:16]
  assign _T_1285 = _T_324 | _T_1284; // @[Mux.scala 87:16]
  assign _T_1286 = _T_322 ? 1'h0 : _T_1285; // @[Mux.scala 87:16]
  assign _T_1287 = _T_320 ? 1'h0 : _T_1286; // @[Mux.scala 87:16]
  assign _T_1288 = _T_318 ? 1'h0 : _T_1287; // @[Mux.scala 87:16]
  assign _T_1289 = _T_316 | _T_1288; // @[Mux.scala 87:16]
  assign _T_1290 = _T_314 | _T_1289; // @[Mux.scala 87:16]
  assign _T_1291 = _T_312 | _T_1290; // @[Mux.scala 87:16]
  assign _T_1292 = _T_310 | _T_1291; // @[Mux.scala 87:16]
  assign id_ctrl_rf_wen = _T_308 | _T_1292; // @[Mux.scala 87:16]
  assign _T_1717 = {_T_54,_T_118,_T_116,1'h0,11'h0}; // @[core.scala 55:30]
  assign _T_1718 = 2'h0 == id_ctrl_alu_op1; // @[Mux.scala 68:19]
  assign _T_1722 = 2'h1 == id_ctrl_alu_op1; // @[Mux.scala 68:19]
  assign _T_1723 = _T_1722 ? _T_1717 : 32'h0; // @[Mux.scala 68:16]
  assign _T_1725 = {_T_54,_T_57,_T_55,_T_54,idm_io_inst_bits[30:25],idm_io_inst_bits[24:21],idm_io_inst_bits[20]}; // @[core.scala 64:30]
  assign _T_1726 = {_T_54,_T_57,_T_55,_T_54,idm_io_inst_bits[30:25],idm_io_inst_bits[11:8],idm_io_inst_bits[7]}; // @[core.scala 65:30]
  assign _T_1727 = 2'h0 == id_ctrl_alu_op2; // @[Mux.scala 68:19]
  assign _T_1729 = 2'h3 == id_ctrl_alu_op2; // @[Mux.scala 68:19]
  assign _T_1730 = _T_1729 ? r_addr : 32'h0; // @[Mux.scala 68:16]
  assign _T_1731 = 2'h2 == id_ctrl_alu_op2; // @[Mux.scala 68:19]
  assign _T_1732 = _T_1731 ? _T_1726 : _T_1730; // @[Mux.scala 68:16]
  assign _T_1733 = 2'h1 == id_ctrl_alu_op2; // @[Mux.scala 68:19]
  assign _T_1734 = _T_1733 ? _T_1725 : _T_1732; // @[Mux.scala 68:16]
  assign _T_1736 = 2'h0 == id_ctrl_wb_sel; // @[Mux.scala 68:19]
  assign _T_1742 = 2'h2 == id_ctrl_wb_sel; // @[Mux.scala 68:19]
  assign _T_1743 = _T_1742 ? r_addr : 32'h0; // @[Mux.scala 68:16]
  assign rd_val = _T_1736 ? alu_io_out : _T_1743; // @[Mux.scala 68:16]
  assign _T_1746 = idm_io_inst_rd != 5'h0; // @[core.scala 90:23]
  assign _T_1750 = r_addr + 32'h4; // @[core.scala 100:31]
  assign _T_1751 = $signed(val_rs1) != $signed(val_rs2); // @[core.scala 101:35]
  assign _T_1753 = r_addr - 32'h4; // @[core.scala 101:55]
  assign _T_1754 = {_T_54,_T_57,_T_55,_T_298,idm_io_inst_bits[30:25],idm_io_inst_bits[11:8],1'h0}; // @[core.scala 101:69]
  assign _T_1756 = _T_1753 + _T_1754; // @[core.scala 101:61]
  assign _T_1760 = $signed(val_rs1) == $signed(val_rs2); // @[core.scala 102:35]
  assign _T_1769 = $signed(val_rs1) > $signed(val_rs2); // @[core.scala 103:35]
  assign _T_1778 = 5'h1f == idm_io_inst_rs1 ? rv32i_reg_31 : _GEN_30; // @[core.scala 104:35]
  assign _T_1779 = 5'h1f == idm_io_inst_rs2 ? rv32i_reg_31 : _GEN_62; // @[core.scala 104:52]
  assign _T_1780 = _T_1778 > _T_1779; // @[core.scala 104:42]
  assign _T_1789 = $signed(val_rs1) < $signed(val_rs2); // @[core.scala 105:35]
  assign _T_1800 = _T_1778 < _T_1779; // @[core.scala 106:42]
  assign _T_1812 = $signed(val_rs1) + $signed(imm_j); // @[core.scala 107:41]
  assign _T_1815 = {_T_54,_T_57,_T_116,_T_237,idm_io_inst_bits[30:25],idm_io_inst_bits[24:21],1'h0}; // @[core.scala 108:45]
  assign _T_1817 = _T_1753 + _T_1815; // @[core.scala 108:37]
  assign _T_1818 = 4'h0 == id_ctrl_br_type; // @[Mux.scala 68:19]
  assign _T_1820 = 4'h7 == id_ctrl_br_type; // @[Mux.scala 68:19]
  assign _T_1822 = 4'h8 == id_ctrl_br_type; // @[Mux.scala 68:19]
  assign _T_1824 = 4'h6 == id_ctrl_br_type; // @[Mux.scala 68:19]
  assign _T_1826 = 4'h5 == id_ctrl_br_type; // @[Mux.scala 68:19]
  assign _T_1828 = 4'h4 == id_ctrl_br_type; // @[Mux.scala 68:19]
  assign _T_1830 = 4'h3 == id_ctrl_br_type; // @[Mux.scala 68:19]
  assign _T_1832 = 4'h2 == id_ctrl_br_type; // @[Mux.scala 68:19]
  assign _T_1834 = 4'h1 == id_ctrl_br_type; // @[Mux.scala 68:19]
  assign _GEN_160 = _T_1751 ? 1'h0 : 1'h1; // @[core.scala 117:39]
  assign _GEN_161 = _T_1760 ? 1'h0 : 1'h1; // @[core.scala 123:39]
  assign _GEN_162 = _T_1769 ? 1'h0 : 1'h1; // @[core.scala 129:37]
  assign _GEN_164 = _T_1789 ? 1'h0 : 1'h1; // @[core.scala 141:36]
  assign _GEN_166 = _T_1822 ? 1'h0 : 1'h1; // @[Conditional.scala 39:67]
  assign _GEN_167 = _T_1820 ? 1'h0 : _GEN_166; // @[Conditional.scala 39:67]
  assign _GEN_168 = _T_1824 ? _GEN_164 : _GEN_167; // @[Conditional.scala 39:67]
  assign _GEN_169 = _T_1826 ? _GEN_164 : _GEN_168; // @[Conditional.scala 39:67]
  assign _GEN_170 = _T_1828 ? _GEN_162 : _GEN_169; // @[Conditional.scala 39:67]
  assign _GEN_171 = _T_1830 ? _GEN_162 : _GEN_170; // @[Conditional.scala 39:67]
  assign _GEN_172 = _T_1832 ? _GEN_161 : _GEN_171; // @[Conditional.scala 39:67]
  assign _GEN_173 = _T_1834 ? _GEN_160 : _GEN_172; // @[Conditional.scala 40:58]
  assign _T_1851 = ~io_sw_halt; // @[core.scala 157:22]
  assign _GEN_174 = r_ack ? 1'h0 : w_req; // @[core.scala 158:31]
  assign _GEN_177 = _T_1851 ? _GEN_174 : 1'h1; // @[core.scala 157:34]
  assign _GEN_183 = 5'h1 == io_sw_g_ad[4:0] ? rv32i_reg_1 : rv32i_reg_0; // @[core.scala 193:16]
  assign _GEN_184 = 5'h2 == io_sw_g_ad[4:0] ? rv32i_reg_2 : _GEN_183; // @[core.scala 193:16]
  assign _GEN_185 = 5'h3 == io_sw_g_ad[4:0] ? rv32i_reg_3 : _GEN_184; // @[core.scala 193:16]
  assign _GEN_186 = 5'h4 == io_sw_g_ad[4:0] ? rv32i_reg_4 : _GEN_185; // @[core.scala 193:16]
  assign _GEN_187 = 5'h5 == io_sw_g_ad[4:0] ? rv32i_reg_5 : _GEN_186; // @[core.scala 193:16]
  assign _GEN_188 = 5'h6 == io_sw_g_ad[4:0] ? rv32i_reg_6 : _GEN_187; // @[core.scala 193:16]
  assign _GEN_189 = 5'h7 == io_sw_g_ad[4:0] ? rv32i_reg_7 : _GEN_188; // @[core.scala 193:16]
  assign _GEN_190 = 5'h8 == io_sw_g_ad[4:0] ? rv32i_reg_8 : _GEN_189; // @[core.scala 193:16]
  assign _GEN_191 = 5'h9 == io_sw_g_ad[4:0] ? rv32i_reg_9 : _GEN_190; // @[core.scala 193:16]
  assign _GEN_192 = 5'ha == io_sw_g_ad[4:0] ? rv32i_reg_10 : _GEN_191; // @[core.scala 193:16]
  assign _GEN_193 = 5'hb == io_sw_g_ad[4:0] ? rv32i_reg_11 : _GEN_192; // @[core.scala 193:16]
  assign _GEN_194 = 5'hc == io_sw_g_ad[4:0] ? rv32i_reg_12 : _GEN_193; // @[core.scala 193:16]
  assign _GEN_195 = 5'hd == io_sw_g_ad[4:0] ? rv32i_reg_13 : _GEN_194; // @[core.scala 193:16]
  assign _GEN_196 = 5'he == io_sw_g_ad[4:0] ? rv32i_reg_14 : _GEN_195; // @[core.scala 193:16]
  assign _GEN_197 = 5'hf == io_sw_g_ad[4:0] ? rv32i_reg_15 : _GEN_196; // @[core.scala 193:16]
  assign _GEN_198 = 5'h10 == io_sw_g_ad[4:0] ? rv32i_reg_16 : _GEN_197; // @[core.scala 193:16]
  assign _GEN_199 = 5'h11 == io_sw_g_ad[4:0] ? rv32i_reg_17 : _GEN_198; // @[core.scala 193:16]
  assign _GEN_200 = 5'h12 == io_sw_g_ad[4:0] ? rv32i_reg_18 : _GEN_199; // @[core.scala 193:16]
  assign _GEN_201 = 5'h13 == io_sw_g_ad[4:0] ? rv32i_reg_19 : _GEN_200; // @[core.scala 193:16]
  assign _GEN_202 = 5'h14 == io_sw_g_ad[4:0] ? rv32i_reg_20 : _GEN_201; // @[core.scala 193:16]
  assign _GEN_203 = 5'h15 == io_sw_g_ad[4:0] ? rv32i_reg_21 : _GEN_202; // @[core.scala 193:16]
  assign _GEN_204 = 5'h16 == io_sw_g_ad[4:0] ? rv32i_reg_22 : _GEN_203; // @[core.scala 193:16]
  assign _GEN_205 = 5'h17 == io_sw_g_ad[4:0] ? rv32i_reg_23 : _GEN_204; // @[core.scala 193:16]
  assign _GEN_206 = 5'h18 == io_sw_g_ad[4:0] ? rv32i_reg_24 : _GEN_205; // @[core.scala 193:16]
  assign _GEN_207 = 5'h19 == io_sw_g_ad[4:0] ? rv32i_reg_25 : _GEN_206; // @[core.scala 193:16]
  assign _GEN_208 = 5'h1a == io_sw_g_ad[4:0] ? rv32i_reg_26 : _GEN_207; // @[core.scala 193:16]
  assign _GEN_209 = 5'h1b == io_sw_g_ad[4:0] ? rv32i_reg_27 : _GEN_208; // @[core.scala 193:16]
  assign _GEN_210 = 5'h1c == io_sw_g_ad[4:0] ? rv32i_reg_28 : _GEN_209; // @[core.scala 193:16]
  assign _GEN_211 = 5'h1d == io_sw_g_ad[4:0] ? rv32i_reg_29 : _GEN_210; // @[core.scala 193:16]
  assign _GEN_212 = 5'h1e == io_sw_g_ad[4:0] ? rv32i_reg_30 : _GEN_211; // @[core.scala 193:16]
  assign io_r_ach_req = 1'h1; // @[core.scala 179:21]
  assign io_r_ach_addr = r_addr; // @[core.scala 178:21]
  assign io_w_ach_req = w_req; // @[core.scala 184:21]
  assign io_w_ach_addr = w_addr; // @[core.scala 182:21]
  assign io_w_dch_data = w_data; // @[core.scala 183:21]
  assign io_sw_addr = r_addr; // @[core.scala 175:21]
  assign io_sw_data = r_data; // @[core.scala 174:21]
  assign io_sw_g_da = 5'h1f == io_sw_g_ad[4:0] ? rv32i_reg_31 : _GEN_212; // @[core.scala 193:16]
  assign io_sw_r_pc = r_addr; // @[core.scala 176:21]
  assign idm_io_imem = next_inst_is_valid ? r_data : 32'h0; // @[core.scala 48:17]
  assign alu_io_op1 = _T_1718 ? _GEN_31 : _T_1723; // @[core.scala 73:21]
  assign alu_io_op2 = _T_1727 ? _GEN_63 : _T_1734; // @[core.scala 74:21]
  assign alu_io_alu_op = _T_308 ? 4'h1 : _T_1010; // @[core.scala 72:21]
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
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  rv32i_reg_0 = _RAND_6[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  rv32i_reg_1 = _RAND_7[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  rv32i_reg_2 = _RAND_8[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  rv32i_reg_3 = _RAND_9[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  rv32i_reg_4 = _RAND_10[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {1{`RANDOM}};
  rv32i_reg_5 = _RAND_11[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {1{`RANDOM}};
  rv32i_reg_6 = _RAND_12[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {1{`RANDOM}};
  rv32i_reg_7 = _RAND_13[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{`RANDOM}};
  rv32i_reg_8 = _RAND_14[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_15 = {1{`RANDOM}};
  rv32i_reg_9 = _RAND_15[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {1{`RANDOM}};
  rv32i_reg_10 = _RAND_16[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {1{`RANDOM}};
  rv32i_reg_11 = _RAND_17[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{`RANDOM}};
  rv32i_reg_12 = _RAND_18[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {1{`RANDOM}};
  rv32i_reg_13 = _RAND_19[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_20 = {1{`RANDOM}};
  rv32i_reg_14 = _RAND_20[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_21 = {1{`RANDOM}};
  rv32i_reg_15 = _RAND_21[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_22 = {1{`RANDOM}};
  rv32i_reg_16 = _RAND_22[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_23 = {1{`RANDOM}};
  rv32i_reg_17 = _RAND_23[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_24 = {1{`RANDOM}};
  rv32i_reg_18 = _RAND_24[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_25 = {1{`RANDOM}};
  rv32i_reg_19 = _RAND_25[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_26 = {1{`RANDOM}};
  rv32i_reg_20 = _RAND_26[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_27 = {1{`RANDOM}};
  rv32i_reg_21 = _RAND_27[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_28 = {1{`RANDOM}};
  rv32i_reg_22 = _RAND_28[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_29 = {1{`RANDOM}};
  rv32i_reg_23 = _RAND_29[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_30 = {1{`RANDOM}};
  rv32i_reg_24 = _RAND_30[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_31 = {1{`RANDOM}};
  rv32i_reg_25 = _RAND_31[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_32 = {1{`RANDOM}};
  rv32i_reg_26 = _RAND_32[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_33 = {1{`RANDOM}};
  rv32i_reg_27 = _RAND_33[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_34 = {1{`RANDOM}};
  rv32i_reg_28 = _RAND_34[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_35 = {1{`RANDOM}};
  rv32i_reg_29 = _RAND_35[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_36 = {1{`RANDOM}};
  rv32i_reg_30 = _RAND_36[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_37 = {1{`RANDOM}};
  rv32i_reg_31 = _RAND_37[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_38 = {1{`RANDOM}};
  next_inst_is_valid = _RAND_38[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      r_addr <= 32'h0;
    end else if (_T_1851) begin
      if (r_ack) begin
        if (_T_1818) begin
          r_addr <= _T_1750;
        end else if (_T_1834) begin
          if (_T_1751) begin
            r_addr <= _T_1756;
          end else begin
            r_addr <= _T_1750;
          end
        end else if (_T_1832) begin
          if (_T_1760) begin
            r_addr <= _T_1756;
          end else begin
            r_addr <= _T_1750;
          end
        end else if (_T_1830) begin
          if (_T_1769) begin
            r_addr <= _T_1756;
          end else begin
            r_addr <= _T_1750;
          end
        end else if (_T_1828) begin
          if (_T_1780) begin
            r_addr <= _T_1756;
          end else begin
            r_addr <= _T_1750;
          end
        end else if (_T_1826) begin
          if (_T_1789) begin
            r_addr <= _T_1756;
          end else begin
            r_addr <= _T_1750;
          end
        end else if (_T_1824) begin
          if (_T_1800) begin
            r_addr <= _T_1756;
          end else begin
            r_addr <= _T_1750;
          end
        end else if (_T_1822) begin
          r_addr <= _T_1812;
        end else if (_T_1820) begin
          r_addr <= _T_1817;
        end else begin
          r_addr <= 32'h0;
        end
      end else begin
        r_addr <= 32'h0;
      end
    end else begin
      r_addr <= io_sw_w_pc;
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
    w_req <= reset | _GEN_177;
    if (reset) begin
      w_addr <= 32'h0;
    end else if (!(_T_1851)) begin
      w_addr <= io_sw_w_ad;
    end
    if (reset) begin
      w_data <= 32'h0;
    end else if (!(_T_1851)) begin
      w_data <= io_sw_w_da;
    end
    if (reset) begin
      rv32i_reg_0 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h0 == idm_io_inst_rd) begin
          if (_T_1736) begin
            rv32i_reg_0 <= alu_io_out;
          end else if (_T_1742) begin
            rv32i_reg_0 <= r_addr;
          end else begin
            rv32i_reg_0 <= 32'h0;
          end
        end
      end else begin
        rv32i_reg_0 <= 32'h0;
      end
    end
    if (reset) begin
      rv32i_reg_1 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h1 == idm_io_inst_rd) begin
          if (_T_1736) begin
            rv32i_reg_1 <= alu_io_out;
          end else if (_T_1742) begin
            rv32i_reg_1 <= r_addr;
          end else begin
            rv32i_reg_1 <= 32'h0;
          end
        end
      end
    end
    if (reset) begin
      rv32i_reg_2 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h2 == idm_io_inst_rd) begin
          if (_T_1736) begin
            rv32i_reg_2 <= alu_io_out;
          end else if (_T_1742) begin
            rv32i_reg_2 <= r_addr;
          end else begin
            rv32i_reg_2 <= 32'h0;
          end
        end
      end
    end
    if (reset) begin
      rv32i_reg_3 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h3 == idm_io_inst_rd) begin
          if (_T_1736) begin
            rv32i_reg_3 <= alu_io_out;
          end else if (_T_1742) begin
            rv32i_reg_3 <= r_addr;
          end else begin
            rv32i_reg_3 <= 32'h0;
          end
        end
      end
    end
    if (reset) begin
      rv32i_reg_4 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h4 == idm_io_inst_rd) begin
          rv32i_reg_4 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_5 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h5 == idm_io_inst_rd) begin
          rv32i_reg_5 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_6 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h6 == idm_io_inst_rd) begin
          rv32i_reg_6 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_7 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h7 == idm_io_inst_rd) begin
          rv32i_reg_7 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_8 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h8 == idm_io_inst_rd) begin
          rv32i_reg_8 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_9 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h9 == idm_io_inst_rd) begin
          rv32i_reg_9 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_10 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'ha == idm_io_inst_rd) begin
          rv32i_reg_10 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_11 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'hb == idm_io_inst_rd) begin
          rv32i_reg_11 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_12 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'hc == idm_io_inst_rd) begin
          rv32i_reg_12 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_13 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'hd == idm_io_inst_rd) begin
          rv32i_reg_13 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_14 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'he == idm_io_inst_rd) begin
          rv32i_reg_14 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_15 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'hf == idm_io_inst_rd) begin
          rv32i_reg_15 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_16 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h10 == idm_io_inst_rd) begin
          rv32i_reg_16 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_17 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h11 == idm_io_inst_rd) begin
          rv32i_reg_17 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_18 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h12 == idm_io_inst_rd) begin
          rv32i_reg_18 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_19 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h13 == idm_io_inst_rd) begin
          rv32i_reg_19 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_20 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h14 == idm_io_inst_rd) begin
          rv32i_reg_20 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_21 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h15 == idm_io_inst_rd) begin
          rv32i_reg_21 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_22 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h16 == idm_io_inst_rd) begin
          rv32i_reg_22 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_23 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h17 == idm_io_inst_rd) begin
          rv32i_reg_23 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_24 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h18 == idm_io_inst_rd) begin
          rv32i_reg_24 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_25 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h19 == idm_io_inst_rd) begin
          rv32i_reg_25 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_26 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h1a == idm_io_inst_rd) begin
          rv32i_reg_26 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_27 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h1b == idm_io_inst_rd) begin
          rv32i_reg_27 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_28 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h1c == idm_io_inst_rd) begin
          rv32i_reg_28 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_29 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h1d == idm_io_inst_rd) begin
          rv32i_reg_29 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_30 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h1e == idm_io_inst_rd) begin
          rv32i_reg_30 <= rd_val;
        end
      end
    end
    if (reset) begin
      rv32i_reg_31 <= 32'h0;
    end else if (id_ctrl_rf_wen) begin
      if (_T_1746) begin
        if (5'h1f == idm_io_inst_rd) begin
          rv32i_reg_31 <= rd_val;
        end
      end
    end
    next_inst_is_valid <= reset | _GEN_173;
  end
endmodule
