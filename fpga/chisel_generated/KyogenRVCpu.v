module IDModule(
  input  [31:0] io_imem,
  output [31:0] io_inst_bits,
  output [4:0]  io_inst_rd,
  output [4:0]  io_inst_rs1,
  output [4:0]  io_inst_rs2,
  output [11:0] io_inst_csr
);
  assign io_inst_bits = io_imem; // @[control.scala 45:23 control.scala 46:21]
  assign io_inst_rd = io_imem[11:7]; // @[control.scala 39:24]
  assign io_inst_rs1 = io_imem[19:15]; // @[control.scala 40:24]
  assign io_inst_rs2 = io_imem[24:20]; // @[control.scala 41:24]
  assign io_inst_csr = io_imem[31:20]; // @[control.scala 42:24]
endmodule
module CSR(
  input         clock,
  input         reset,
  input  [31:0] io_addr,
  input  [31:0] io_in,
  output [31:0] io_out,
  input  [31:0] io_cmd,
  input  [31:0] io_rs1_addr,
  input         io_legal,
  input         io_interrupt_sig,
  input  [31:0] io_pc,
  input         io_pc_invalid,
  input         io_j_check,
  input         io_b_check,
  input         io_stall,
  output        io_expt,
  output [31:0] io_evec,
  output [31:0] io_epc,
  input  [31:0] io_inst,
  input  [1:0]  io_mem_wr,
  input  [2:0]  io_mask_type,
  input  [31:0] io_alu_op1,
  input  [31:0] io_alu_op2
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] _T = io_out | io_in; // @[csr.scala 168:22]
  wire [31:0] _T_1 = ~io_in; // @[csr.scala 169:34]
  wire [31:0] _T_2 = io_out & _T_1; // @[csr.scala 169:31]
  wire [31:0] _T_4 = 32'h1 == io_cmd ? io_in : 32'h0; // @[Mux.scala 80:57]
  wire [31:0] _T_6 = 32'h2 == io_cmd ? _T : _T_4; // @[Mux.scala 80:57]
  wire [31:0] wdata = 32'h3 == io_cmd ? _T_2 : _T_6; // @[Mux.scala 80:57]
  wire [31:0] alu_calc_addr = io_alu_op1 + io_alu_op2; // @[csr.scala 173:41]
  reg [31:0] time_; // @[csr.scala 176:31]
  reg [31:0] timeh; // @[csr.scala 177:31]
  reg [31:0] cycle; // @[csr.scala 178:31]
  reg [31:0] cycleh; // @[csr.scala 179:31]
  reg [31:0] instret; // @[csr.scala 180:31]
  reg [31:0] instreth; // @[csr.scala 181:31]
  reg [1:0] PRV1; // @[csr.scala 190:29]
  reg  IE; // @[csr.scala 193:29]
  reg  IE1; // @[csr.scala 194:29]
  wire [31:0] mstatus = {22'h0,3'h0,1'h0,PRV1,IE1,2'h3,IE}; // @[Cat.scala 29:58]
  reg [31:0] mtvec; // @[csr.scala 209:31]
  reg  MTIP; // @[csr.scala 213:27]
  reg  MEIE; // @[csr.scala 217:27]
  reg  MTIE; // @[csr.scala 218:27]
  reg  MEIP; // @[csr.scala 222:27]
  reg  MSIP; // @[csr.scala 223:27]
  reg  MSIE; // @[csr.scala 226:27]
  wire [31:0] mip = {20'h0,MEIP,2'h0,1'h0,MTIP,1'h0,2'h0,MSIP,3'h0}; // @[Cat.scala 29:58]
  wire [31:0] mie = {20'h0,MEIE,2'h0,1'h0,MTIE,1'h0,2'h0,MSIE,3'h0}; // @[Cat.scala 29:58]
  reg [31:0] mscratch; // @[csr.scala 233:29]
  reg [31:0] mepc; // @[csr.scala 235:29]
  reg [31:0] mcause; // @[csr.scala 236:29]
  reg [31:0] mtval; // @[csr.scala 242:33]
  reg [31:0] valid_pc; // @[csr.scala 245:31]
  wire [31:0] _io_out_T = io_addr & 32'hfff; // @[Lookup.scala 31:38]
  wire  _io_out_T_1 = 32'hc00 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_3 = 32'hc01 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_5 = 32'hc02 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_7 = 32'hc80 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_9 = 32'hc81 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_11 = 32'hc82 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_13 = 32'h900 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_15 = 32'h180 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_17 = 32'h901 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_19 = 32'h902 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_21 = 32'h980 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_23 = 32'h981 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_25 = 32'h982 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_27 = 32'hf00 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_29 = 32'hf13 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_31 = 32'hf14 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_33 = 32'h305 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_35 = 32'h302 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_37 = 32'h304 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_39 = 32'h321 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_41 = 32'h701 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_43 = 32'h741 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_45 = 32'h340 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_47 = 32'h341 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_49 = 32'h342 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_51 = 32'h344 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_53 = 32'h300 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_55 = 32'h301 == _io_out_T; // @[Lookup.scala 31:38]
  wire  _io_out_T_57 = 32'h343 == _io_out_T; // @[Lookup.scala 31:38]
  wire [31:0] _io_out_T_58 = _io_out_T_57 ? mtval : 32'h0; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_59 = _io_out_T_55 ? 32'h40000000 : _io_out_T_58; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_60 = _io_out_T_53 ? mstatus : _io_out_T_59; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_61 = _io_out_T_51 ? mip : _io_out_T_60; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_62 = _io_out_T_49 ? mcause : _io_out_T_61; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_63 = _io_out_T_47 ? mepc : _io_out_T_62; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_64 = _io_out_T_45 ? mscratch : _io_out_T_63; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_65 = _io_out_T_43 ? timeh : _io_out_T_64; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_66 = _io_out_T_41 ? time_ : _io_out_T_65; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_67 = _io_out_T_39 ? 32'h0 : _io_out_T_66; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_68 = _io_out_T_37 ? mie : _io_out_T_67; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_69 = _io_out_T_35 ? 32'h0 : _io_out_T_68; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_70 = _io_out_T_33 ? mtvec : _io_out_T_69; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_71 = _io_out_T_31 ? 32'h0 : _io_out_T_70; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_72 = _io_out_T_29 ? 32'h0 : _io_out_T_71; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_73 = _io_out_T_27 ? 32'h100100 : _io_out_T_72; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_74 = _io_out_T_25 ? instreth : _io_out_T_73; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_75 = _io_out_T_23 ? timeh : _io_out_T_74; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_76 = _io_out_T_21 ? cycleh : _io_out_T_75; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_77 = _io_out_T_19 ? instret : _io_out_T_76; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_78 = _io_out_T_17 ? time_ : _io_out_T_77; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_79 = _io_out_T_15 ? 32'h0 : _io_out_T_78; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_80 = _io_out_T_13 ? cycle : _io_out_T_79; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_81 = _io_out_T_11 ? instreth : _io_out_T_80; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_82 = _io_out_T_9 ? timeh : _io_out_T_81; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_83 = _io_out_T_7 ? cycleh : _io_out_T_82; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_84 = _io_out_T_5 ? instret : _io_out_T_83; // @[Lookup.scala 33:37]
  wire [31:0] _io_out_T_85 = _io_out_T_3 ? time_ : _io_out_T_84; // @[Lookup.scala 33:37]
  wire [31:0] _time_T_1 = time_ + 32'h1; // @[csr.scala 282:16]
  wire [31:0] _timeh_T_1 = timeh + 32'h1; // @[csr.scala 283:36]
  wire [31:0] _GEN_0 = &time_ ? _timeh_T_1 : timeh; // @[csr.scala 283:19 csr.scala 283:27 csr.scala 177:31]
  wire [31:0] _cycle_T_1 = cycle + 32'h1; // @[csr.scala 284:18]
  wire [31:0] _cycleh_T_1 = cycleh + 32'h1; // @[csr.scala 285:39]
  wire [31:0] _GEN_1 = &cycle ? _cycleh_T_1 : cycleh; // @[csr.scala 285:20 csr.scala 285:29 csr.scala 179:31]
  wire  privInst = io_cmd == 32'h4; // @[csr.scala 291:35]
  wire  isExtInt = MEIP & MEIE; // @[csr.scala 293:33]
  wire  _T_16 = ~io_addr[8]; // @[csr.scala 294:56]
  wire  isEcall = privInst & ~io_addr[0] & ~io_addr[8]; // @[csr.scala 294:53]
  wire  isEbreak = privInst & io_addr[0] & _T_16; // @[csr.scala 295:53]
  wire  wen = io_cmd == 32'h1 | io_cmd[1] & |io_rs1_addr; // @[csr.scala 296:47]
  wire  _T_26 = ~io_pc_invalid; // @[csr.scala 299:41]
  wire  isIllegal = ~io_legal & ~io_pc_invalid; // @[csr.scala 299:38]
  reg [31:0] pre_mepc; // @[csr.scala 302:37]
  reg [31:0] pre_calc_addr; // @[csr.scala 304:37]
  wire  iaddrInvalid_b = |io_pc[1:0]; // @[csr.scala 313:41]
  wire  _T_30 = |alu_calc_addr[1:0]; // @[csr.scala 314:63]
  wire  iaddrInvalid_j = io_j_check & |alu_calc_addr[1:0]; // @[csr.scala 314:41]
  wire  _T_31 = io_mem_wr == 2'h1; // @[csr.scala 316:16]
  wire  _T_32 = io_mask_type == 3'h3; // @[csr.scala 316:42]
  wire  _T_33 = io_mem_wr == 2'h1 & io_mask_type == 3'h3; // @[csr.scala 316:26]
  wire  _T_37 = io_mask_type == 3'h2; // @[csr.scala 317:42]
  wire  _T_38 = _T_31 & io_mask_type == 3'h2; // @[csr.scala 317:26]
  wire  _T_42 = _T_31 & io_mask_type == 3'h6; // @[csr.scala 318:26]
  wire  _T_45 = _T_38 ? alu_calc_addr[0] : _T_42 & alu_calc_addr[0]; // @[Mux.scala 98:16]
  wire  laddrInvalid = _T_33 ? _T_30 : _T_45; // @[Mux.scala 98:16]
  wire  _T_46 = io_mem_wr == 2'h2; // @[csr.scala 321:16]
  wire  _T_48 = io_mem_wr == 2'h2 & _T_32; // @[csr.scala 321:26]
  wire  _T_53 = _T_46 & _T_37; // @[csr.scala 322:26]
  wire  saddrInvalid = _T_48 ? _T_30 : _T_53 & alu_calc_addr[0]; // @[Mux.scala 98:16]
  wire  _T_61 = ~io_stall; // @[csr.scala 325:96]
  wire  isInstRet = io_inst != 32'h13 & (~io_expt | isEcall | isEbreak) & ~io_stall; // @[csr.scala 325:93]
  wire [31:0] _instret_T_1 = instret + 32'h1; // @[csr.scala 326:40]
  wire [31:0] _GEN_5 = isInstRet ? _instret_T_1 : instret; // @[csr.scala 326:19 csr.scala 326:29 csr.scala 180:31]
  wire [31:0] _instreth_T_1 = instreth + 32'h1; // @[csr.scala 327:58]
  wire [31:0] _GEN_6 = isInstRet & &instret ? _instreth_T_1 : instreth; // @[csr.scala 327:35 csr.scala 327:46 csr.scala 181:31]
  wire [31:0] _valid_pc_T_1 = {io_pc[31:2], 2'h0}; // @[csr.scala 336:28]
  wire [31:0] _mtval_T_1 = {alu_calc_addr[31:1], 1'h0}; // @[csr.scala 353:40]
  wire [31:0] _mtval_T_3 = _mtval_T_1 + 32'h2; // @[csr.scala 353:55]
  wire [31:0] _GEN_8 = alu_calc_addr[0] & ~alu_calc_addr[1] ? _mtval_T_3 : _mtval_T_1; // @[csr.scala 352:53 csr.scala 353:17 csr.scala 355:17]
  wire [31:0] _GEN_10 = iaddrInvalid_j ? _GEN_8 : io_inst; // @[csr.scala 350:34 csr.scala 359:15]
  wire [31:0] _GEN_12 = laddrInvalid | saddrInvalid ? alu_calc_addr : _GEN_10; // @[csr.scala 347:47 csr.scala 349:15]
  wire [31:0] _GEN_13 = iaddrInvalid_b ? pre_mepc : io_pc; // @[csr.scala 344:34 csr.scala 345:14]
  wire [31:0] _GEN_14 = iaddrInvalid_b ? pre_calc_addr : _GEN_12; // @[csr.scala 344:34 csr.scala 346:15]
  wire [31:0] _GEN_15 = isExtInt ? valid_pc : _GEN_13; // @[csr.scala 341:21 csr.scala 342:14]
  wire [2:0] _mcause_T_6 = saddrInvalid ? 3'h6 : 3'h0; // @[csr.scala 367:22]
  wire [2:0] _mcause_T_7 = laddrInvalid ? 3'h4 : _mcause_T_6; // @[csr.scala 366:20]
  wire [2:0] _mcause_T_8 = isIllegal ? 3'h2 : _mcause_T_7; // @[csr.scala 365:18]
  wire [2:0] _mcause_T_9 = iaddrInvalid_j | iaddrInvalid_b ? 3'h0 : _mcause_T_8; // @[csr.scala 364:16]
  wire [2:0] _mcause_T_10 = isEbreak ? 3'h3 : _mcause_T_9; // @[csr.scala 363:14]
  wire [31:0] _mepc_T = {{2'd0}, wdata[31:2]}; // @[csr.scala 406:23]
  wire [33:0] _GEN_236 = {_mepc_T, 2'h0}; // @[csr.scala 406:30]
  wire [34:0] _mepc_T_1 = {{1'd0}, _GEN_236}; // @[csr.scala 406:30]
  wire [31:0] _mcause_T_13 = wdata & 32'h8000000f; // @[csr.scala 409:25]
  wire [31:0] _GEN_17 = io_addr == 32'h982 ? wdata : _GEN_6; // @[csr.scala 435:49 csr.scala 436:18]
  wire [31:0] _GEN_18 = io_addr == 32'h981 ? wdata : _GEN_0; // @[csr.scala 432:46 csr.scala 433:15]
  wire [31:0] _GEN_19 = io_addr == 32'h981 ? _GEN_6 : _GEN_17; // @[csr.scala 432:46]
  wire [31:0] _GEN_20 = io_addr == 32'h980 ? wdata : _GEN_1; // @[csr.scala 429:47 csr.scala 430:16]
  wire [31:0] _GEN_21 = io_addr == 32'h980 ? _GEN_0 : _GEN_18; // @[csr.scala 429:47]
  wire [31:0] _GEN_22 = io_addr == 32'h980 ? _GEN_6 : _GEN_19; // @[csr.scala 429:47]
  wire [31:0] _GEN_23 = io_addr == 32'h902 ? wdata : _GEN_5; // @[csr.scala 426:48 csr.scala 427:17]
  wire [31:0] _GEN_24 = io_addr == 32'h902 ? _GEN_1 : _GEN_20; // @[csr.scala 426:48]
  wire [31:0] _GEN_25 = io_addr == 32'h902 ? _GEN_0 : _GEN_21; // @[csr.scala 426:48]
  wire [31:0] _GEN_26 = io_addr == 32'h902 ? _GEN_6 : _GEN_22; // @[csr.scala 426:48]
  wire [31:0] _GEN_27 = io_addr == 32'h901 ? wdata : _time_T_1; // @[csr.scala 423:45 csr.scala 424:14 csr.scala 282:8]
  wire [31:0] _GEN_28 = io_addr == 32'h901 ? _GEN_5 : _GEN_23; // @[csr.scala 423:45]
  wire [31:0] _GEN_29 = io_addr == 32'h901 ? _GEN_1 : _GEN_24; // @[csr.scala 423:45]
  wire [31:0] _GEN_30 = io_addr == 32'h901 ? _GEN_0 : _GEN_25; // @[csr.scala 423:45]
  wire [31:0] _GEN_31 = io_addr == 32'h901 ? _GEN_6 : _GEN_26; // @[csr.scala 423:45]
  wire [31:0] _GEN_32 = io_addr == 32'h900 ? wdata : _cycle_T_1; // @[csr.scala 420:46 csr.scala 421:15 csr.scala 284:9]
  wire [31:0] _GEN_33 = io_addr == 32'h900 ? _time_T_1 : _GEN_27; // @[csr.scala 420:46 csr.scala 282:8]
  wire [31:0] _GEN_34 = io_addr == 32'h900 ? _GEN_5 : _GEN_28; // @[csr.scala 420:46]
  wire [31:0] _GEN_35 = io_addr == 32'h900 ? _GEN_1 : _GEN_29; // @[csr.scala 420:46]
  wire [31:0] _GEN_36 = io_addr == 32'h900 ? _GEN_0 : _GEN_30; // @[csr.scala 420:46]
  wire [31:0] _GEN_37 = io_addr == 32'h900 ? _GEN_6 : _GEN_31; // @[csr.scala 420:46]
  wire [31:0] _GEN_39 = io_addr == 32'h781 ? _cycle_T_1 : _GEN_32; // @[csr.scala 417:49 csr.scala 284:9]
  wire [31:0] _GEN_40 = io_addr == 32'h781 ? _time_T_1 : _GEN_33; // @[csr.scala 417:49 csr.scala 282:8]
  wire [31:0] _GEN_41 = io_addr == 32'h781 ? _GEN_5 : _GEN_34; // @[csr.scala 417:49]
  wire [31:0] _GEN_42 = io_addr == 32'h781 ? _GEN_1 : _GEN_35; // @[csr.scala 417:49]
  wire [31:0] _GEN_43 = io_addr == 32'h781 ? _GEN_0 : _GEN_36; // @[csr.scala 417:49]
  wire [31:0] _GEN_44 = io_addr == 32'h781 ? _GEN_6 : _GEN_37; // @[csr.scala 417:49]
  wire [31:0] _GEN_47 = io_addr == 32'h780 ? _cycle_T_1 : _GEN_39; // @[csr.scala 414:47 csr.scala 284:9]
  wire [31:0] _GEN_48 = io_addr == 32'h780 ? _time_T_1 : _GEN_40; // @[csr.scala 414:47 csr.scala 282:8]
  wire [31:0] _GEN_49 = io_addr == 32'h780 ? _GEN_5 : _GEN_41; // @[csr.scala 414:47]
  wire [31:0] _GEN_50 = io_addr == 32'h780 ? _GEN_1 : _GEN_42; // @[csr.scala 414:47]
  wire [31:0] _GEN_51 = io_addr == 32'h780 ? _GEN_0 : _GEN_43; // @[csr.scala 414:47]
  wire [31:0] _GEN_52 = io_addr == 32'h780 ? _GEN_6 : _GEN_44; // @[csr.scala 414:47]
  wire [31:0] _GEN_53 = io_addr == 32'h342 ? _mcause_T_13 : mcause; // @[csr.scala 408:46 csr.scala 409:16 csr.scala 236:29]
  wire [31:0] _GEN_56 = io_addr == 32'h342 ? _cycle_T_1 : _GEN_47; // @[csr.scala 408:46 csr.scala 284:9]
  wire [31:0] _GEN_57 = io_addr == 32'h342 ? _time_T_1 : _GEN_48; // @[csr.scala 408:46 csr.scala 282:8]
  wire [31:0] _GEN_58 = io_addr == 32'h342 ? _GEN_5 : _GEN_49; // @[csr.scala 408:46]
  wire [31:0] _GEN_59 = io_addr == 32'h342 ? _GEN_1 : _GEN_50; // @[csr.scala 408:46]
  wire [31:0] _GEN_60 = io_addr == 32'h342 ? _GEN_0 : _GEN_51; // @[csr.scala 408:46]
  wire [31:0] _GEN_61 = io_addr == 32'h342 ? _GEN_6 : _GEN_52; // @[csr.scala 408:46]
  wire [34:0] _GEN_62 = io_addr == 32'h341 ? _mepc_T_1 : {{3'd0}, mepc}; // @[csr.scala 405:44 csr.scala 406:14 csr.scala 235:29]
  wire [31:0] _GEN_63 = io_addr == 32'h341 ? mcause : _GEN_53; // @[csr.scala 405:44 csr.scala 236:29]
  wire [31:0] _GEN_66 = io_addr == 32'h341 ? _cycle_T_1 : _GEN_56; // @[csr.scala 405:44 csr.scala 284:9]
  wire [31:0] _GEN_67 = io_addr == 32'h341 ? _time_T_1 : _GEN_57; // @[csr.scala 405:44 csr.scala 282:8]
  wire [31:0] _GEN_68 = io_addr == 32'h341 ? _GEN_5 : _GEN_58; // @[csr.scala 405:44]
  wire [31:0] _GEN_69 = io_addr == 32'h341 ? _GEN_1 : _GEN_59; // @[csr.scala 405:44]
  wire [31:0] _GEN_70 = io_addr == 32'h341 ? _GEN_0 : _GEN_60; // @[csr.scala 405:44]
  wire [31:0] _GEN_71 = io_addr == 32'h341 ? _GEN_6 : _GEN_61; // @[csr.scala 405:44]
  wire [31:0] _GEN_72 = io_addr == 32'h340 ? wdata : mscratch; // @[csr.scala 402:48 csr.scala 403:18 csr.scala 233:29]
  wire [34:0] _GEN_73 = io_addr == 32'h340 ? {{3'd0}, mepc} : _GEN_62; // @[csr.scala 402:48 csr.scala 235:29]
  wire [31:0] _GEN_74 = io_addr == 32'h340 ? mcause : _GEN_63; // @[csr.scala 402:48 csr.scala 236:29]
  wire [31:0] _GEN_77 = io_addr == 32'h340 ? _cycle_T_1 : _GEN_66; // @[csr.scala 402:48 csr.scala 284:9]
  wire [31:0] _GEN_78 = io_addr == 32'h340 ? _time_T_1 : _GEN_67; // @[csr.scala 402:48 csr.scala 282:8]
  wire [31:0] _GEN_79 = io_addr == 32'h340 ? _GEN_5 : _GEN_68; // @[csr.scala 402:48]
  wire [31:0] _GEN_80 = io_addr == 32'h340 ? _GEN_1 : _GEN_69; // @[csr.scala 402:48]
  wire [31:0] _GEN_81 = io_addr == 32'h340 ? _GEN_0 : _GEN_70; // @[csr.scala 402:48]
  wire [31:0] _GEN_82 = io_addr == 32'h340 ? _GEN_6 : _GEN_71; // @[csr.scala 402:48]
  wire [31:0] _GEN_83 = io_addr == 32'h305 ? wdata : mtvec; // @[csr.scala 399:45 csr.scala 400:15 csr.scala 209:31]
  wire [31:0] _GEN_84 = io_addr == 32'h305 ? mscratch : _GEN_72; // @[csr.scala 399:45 csr.scala 233:29]
  wire [34:0] _GEN_85 = io_addr == 32'h305 ? {{3'd0}, mepc} : _GEN_73; // @[csr.scala 399:45 csr.scala 235:29]
  wire [31:0] _GEN_86 = io_addr == 32'h305 ? mcause : _GEN_74; // @[csr.scala 399:45 csr.scala 236:29]
  wire [31:0] _GEN_89 = io_addr == 32'h305 ? _cycle_T_1 : _GEN_77; // @[csr.scala 399:45 csr.scala 284:9]
  wire [31:0] _GEN_90 = io_addr == 32'h305 ? _time_T_1 : _GEN_78; // @[csr.scala 399:45 csr.scala 282:8]
  wire [31:0] _GEN_91 = io_addr == 32'h305 ? _GEN_5 : _GEN_79; // @[csr.scala 399:45]
  wire [31:0] _GEN_92 = io_addr == 32'h305 ? _GEN_1 : _GEN_80; // @[csr.scala 399:45]
  wire [31:0] _GEN_93 = io_addr == 32'h305 ? _GEN_0 : _GEN_81; // @[csr.scala 399:45]
  wire [31:0] _GEN_94 = io_addr == 32'h305 ? _GEN_6 : _GEN_82; // @[csr.scala 399:45]
  wire [31:0] _GEN_95 = io_addr == 32'h741 ? wdata : _GEN_93; // @[csr.scala 392:46 csr.scala 393:15]
  wire [31:0] _GEN_96 = io_addr == 32'h741 ? mtvec : _GEN_83; // @[csr.scala 392:46 csr.scala 209:31]
  wire [31:0] _GEN_97 = io_addr == 32'h741 ? mscratch : _GEN_84; // @[csr.scala 392:46 csr.scala 233:29]
  wire [34:0] _GEN_98 = io_addr == 32'h741 ? {{3'd0}, mepc} : _GEN_85; // @[csr.scala 392:46 csr.scala 235:29]
  wire [31:0] _GEN_99 = io_addr == 32'h741 ? mcause : _GEN_86; // @[csr.scala 392:46 csr.scala 236:29]
  wire [31:0] _GEN_102 = io_addr == 32'h741 ? _cycle_T_1 : _GEN_89; // @[csr.scala 392:46 csr.scala 284:9]
  wire [31:0] _GEN_103 = io_addr == 32'h741 ? _time_T_1 : _GEN_90; // @[csr.scala 392:46 csr.scala 282:8]
  wire [31:0] _GEN_104 = io_addr == 32'h741 ? _GEN_5 : _GEN_91; // @[csr.scala 392:46]
  wire [31:0] _GEN_105 = io_addr == 32'h741 ? _GEN_1 : _GEN_92; // @[csr.scala 392:46]
  wire [31:0] _GEN_106 = io_addr == 32'h741 ? _GEN_6 : _GEN_94; // @[csr.scala 392:46]
  wire [31:0] _GEN_107 = io_addr == 32'h701 ? wdata : _GEN_103; // @[csr.scala 389:46 csr.scala 390:14]
  wire [31:0] _GEN_108 = io_addr == 32'h701 ? _GEN_0 : _GEN_95; // @[csr.scala 389:46]
  wire [31:0] _GEN_109 = io_addr == 32'h701 ? mtvec : _GEN_96; // @[csr.scala 389:46 csr.scala 209:31]
  wire [31:0] _GEN_110 = io_addr == 32'h701 ? mscratch : _GEN_97; // @[csr.scala 389:46 csr.scala 233:29]
  wire [34:0] _GEN_111 = io_addr == 32'h701 ? {{3'd0}, mepc} : _GEN_98; // @[csr.scala 389:46 csr.scala 235:29]
  wire [31:0] _GEN_112 = io_addr == 32'h701 ? mcause : _GEN_99; // @[csr.scala 389:46 csr.scala 236:29]
  wire [31:0] _GEN_115 = io_addr == 32'h701 ? _cycle_T_1 : _GEN_102; // @[csr.scala 389:46 csr.scala 284:9]
  wire [31:0] _GEN_116 = io_addr == 32'h701 ? _GEN_5 : _GEN_104; // @[csr.scala 389:46]
  wire [31:0] _GEN_117 = io_addr == 32'h701 ? _GEN_1 : _GEN_105; // @[csr.scala 389:46]
  wire [31:0] _GEN_118 = io_addr == 32'h701 ? _GEN_6 : _GEN_106; // @[csr.scala 389:46]
  wire  _GEN_119 = io_addr == 32'h304 ? wdata[11] : MEIE; // @[csr.scala 385:44 csr.scala 386:14 csr.scala 217:27]
  wire  _GEN_120 = io_addr == 32'h304 ? wdata[7] : MTIE; // @[csr.scala 385:44 csr.scala 387:14 csr.scala 218:27]
  wire  _GEN_121 = io_addr == 32'h304 ? wdata[3] : MSIE; // @[csr.scala 385:44 csr.scala 388:14 csr.scala 226:27]
  wire [31:0] _GEN_122 = io_addr == 32'h304 ? _time_T_1 : _GEN_107; // @[csr.scala 385:44 csr.scala 282:8]
  wire [31:0] _GEN_123 = io_addr == 32'h304 ? _GEN_0 : _GEN_108; // @[csr.scala 385:44]
  wire [31:0] _GEN_124 = io_addr == 32'h304 ? mtvec : _GEN_109; // @[csr.scala 385:44 csr.scala 209:31]
  wire [31:0] _GEN_125 = io_addr == 32'h304 ? mscratch : _GEN_110; // @[csr.scala 385:44 csr.scala 233:29]
  wire [34:0] _GEN_126 = io_addr == 32'h304 ? {{3'd0}, mepc} : _GEN_111; // @[csr.scala 385:44 csr.scala 235:29]
  wire [31:0] _GEN_127 = io_addr == 32'h304 ? mcause : _GEN_112; // @[csr.scala 385:44 csr.scala 236:29]
  wire [31:0] _GEN_130 = io_addr == 32'h304 ? _cycle_T_1 : _GEN_115; // @[csr.scala 385:44 csr.scala 284:9]
  wire [31:0] _GEN_131 = io_addr == 32'h304 ? _GEN_5 : _GEN_116; // @[csr.scala 385:44]
  wire [31:0] _GEN_132 = io_addr == 32'h304 ? _GEN_1 : _GEN_117; // @[csr.scala 385:44]
  wire [31:0] _GEN_133 = io_addr == 32'h304 ? _GEN_6 : _GEN_118; // @[csr.scala 385:44]
  wire  _GEN_134 = io_addr == 32'h344 ? wdata[7] : MTIP; // @[csr.scala 382:44 csr.scala 383:14 csr.scala 213:27]
  wire  _GEN_135 = io_addr == 32'h344 ? wdata[3] : MSIP; // @[csr.scala 382:44 csr.scala 384:14 csr.scala 223:27]
  wire  _GEN_136 = io_addr == 32'h344 ? MEIE : _GEN_119; // @[csr.scala 382:44 csr.scala 217:27]
  wire  _GEN_137 = io_addr == 32'h344 ? MTIE : _GEN_120; // @[csr.scala 382:44 csr.scala 218:27]
  wire  _GEN_138 = io_addr == 32'h344 ? MSIE : _GEN_121; // @[csr.scala 382:44 csr.scala 226:27]
  wire [31:0] _GEN_139 = io_addr == 32'h344 ? _time_T_1 : _GEN_122; // @[csr.scala 382:44 csr.scala 282:8]
  wire [31:0] _GEN_140 = io_addr == 32'h344 ? _GEN_0 : _GEN_123; // @[csr.scala 382:44]
  wire [31:0] _GEN_141 = io_addr == 32'h344 ? mtvec : _GEN_124; // @[csr.scala 382:44 csr.scala 209:31]
  wire [31:0] _GEN_142 = io_addr == 32'h344 ? mscratch : _GEN_125; // @[csr.scala 382:44 csr.scala 233:29]
  wire [34:0] _GEN_143 = io_addr == 32'h344 ? {{3'd0}, mepc} : _GEN_126; // @[csr.scala 382:44 csr.scala 235:29]
  wire [31:0] _GEN_144 = io_addr == 32'h344 ? mcause : _GEN_127; // @[csr.scala 382:44 csr.scala 236:29]
  wire [31:0] _GEN_147 = io_addr == 32'h344 ? _cycle_T_1 : _GEN_130; // @[csr.scala 382:44 csr.scala 284:9]
  wire [31:0] _GEN_148 = io_addr == 32'h344 ? _GEN_5 : _GEN_131; // @[csr.scala 382:44]
  wire [31:0] _GEN_149 = io_addr == 32'h344 ? _GEN_1 : _GEN_132; // @[csr.scala 382:44]
  wire [31:0] _GEN_150 = io_addr == 32'h344 ? _GEN_6 : _GEN_133; // @[csr.scala 382:44]
  wire [1:0] _GEN_151 = io_addr == 32'h300 ? wdata[5:4] : PRV1; // @[csr.scala 377:42 csr.scala 378:14 csr.scala 190:29]
  wire  _GEN_152 = io_addr == 32'h300 ? wdata[3] : IE1; // @[csr.scala 377:42 csr.scala 379:13 csr.scala 194:29]
  wire  _GEN_153 = io_addr == 32'h300 ? wdata[0] : IE; // @[csr.scala 377:42 csr.scala 381:12 csr.scala 193:29]
  wire  _GEN_154 = io_addr == 32'h300 ? MTIP : _GEN_134; // @[csr.scala 377:42 csr.scala 213:27]
  wire  _GEN_155 = io_addr == 32'h300 ? MSIP : _GEN_135; // @[csr.scala 377:42 csr.scala 223:27]
  wire  _GEN_156 = io_addr == 32'h300 ? MEIE : _GEN_136; // @[csr.scala 377:42 csr.scala 217:27]
  wire  _GEN_157 = io_addr == 32'h300 ? MTIE : _GEN_137; // @[csr.scala 377:42 csr.scala 218:27]
  wire  _GEN_158 = io_addr == 32'h300 ? MSIE : _GEN_138; // @[csr.scala 377:42 csr.scala 226:27]
  wire [31:0] _GEN_159 = io_addr == 32'h300 ? _time_T_1 : _GEN_139; // @[csr.scala 377:42 csr.scala 282:8]
  wire [31:0] _GEN_160 = io_addr == 32'h300 ? _GEN_0 : _GEN_140; // @[csr.scala 377:42]
  wire [31:0] _GEN_161 = io_addr == 32'h300 ? mtvec : _GEN_141; // @[csr.scala 377:42 csr.scala 209:31]
  wire [34:0] _GEN_163 = io_addr == 32'h300 ? {{3'd0}, mepc} : _GEN_143; // @[csr.scala 377:42 csr.scala 235:29]
  wire [31:0] _GEN_167 = io_addr == 32'h300 ? _cycle_T_1 : _GEN_147; // @[csr.scala 377:42 csr.scala 284:9]
  wire [31:0] _GEN_168 = io_addr == 32'h300 ? _GEN_5 : _GEN_148; // @[csr.scala 377:42]
  wire [31:0] _GEN_169 = io_addr == 32'h300 ? _GEN_1 : _GEN_149; // @[csr.scala 377:42]
  wire [31:0] _GEN_170 = io_addr == 32'h300 ? _GEN_6 : _GEN_150; // @[csr.scala 377:42]
  wire [34:0] _GEN_183 = wen ? _GEN_163 : {{3'd0}, mepc}; // @[csr.scala 376:21 csr.scala 235:29]
  wire [34:0] _GEN_191 = io_expt ? {{3'd0}, _GEN_15} : _GEN_183; // @[csr.scala 340:19]
  wire [34:0] _GEN_213 = _T_61 ? _GEN_191 : {{3'd0}, mepc}; // @[csr.scala 339:19 csr.scala 235:29]
  assign io_out = _io_out_T_1 ? cycle : _io_out_T_85; // @[Lookup.scala 33:37]
  assign io_expt = isEcall | isEbreak | isIllegal | isExtInt | iaddrInvalid_j | iaddrInvalid_b | laddrInvalid |
    saddrInvalid; // @[csr.scala 330:111]
  assign io_evec = mtvec; // @[csr.scala 331:11]
  assign io_epc = mepc; // @[csr.scala 333:10]
  always @(posedge clock) begin
    if (reset) begin // @[csr.scala 176:31]
      time_ <= 32'h0; // @[csr.scala 176:31]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        time_ <= _time_T_1; // @[csr.scala 282:8]
      end else if (wen) begin // @[csr.scala 376:21]
        time_ <= _GEN_159;
      end else begin
        time_ <= _time_T_1; // @[csr.scala 282:8]
      end
    end else begin
      time_ <= _time_T_1; // @[csr.scala 282:8]
    end
    if (reset) begin // @[csr.scala 177:31]
      timeh <= 32'h0; // @[csr.scala 177:31]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        timeh <= _GEN_0;
      end else if (wen) begin // @[csr.scala 376:21]
        timeh <= _GEN_160;
      end else begin
        timeh <= _GEN_0;
      end
    end else begin
      timeh <= _GEN_0;
    end
    if (reset) begin // @[csr.scala 178:31]
      cycle <= 32'h0; // @[csr.scala 178:31]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        cycle <= _cycle_T_1; // @[csr.scala 284:9]
      end else if (wen) begin // @[csr.scala 376:21]
        cycle <= _GEN_167;
      end else begin
        cycle <= _cycle_T_1; // @[csr.scala 284:9]
      end
    end else begin
      cycle <= _cycle_T_1; // @[csr.scala 284:9]
    end
    if (reset) begin // @[csr.scala 179:31]
      cycleh <= 32'h0; // @[csr.scala 179:31]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        cycleh <= _GEN_1;
      end else if (wen) begin // @[csr.scala 376:21]
        cycleh <= _GEN_169;
      end else begin
        cycleh <= _GEN_1;
      end
    end else begin
      cycleh <= _GEN_1;
    end
    if (reset) begin // @[csr.scala 180:31]
      instret <= 32'h0; // @[csr.scala 180:31]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        instret <= _GEN_5;
      end else if (wen) begin // @[csr.scala 376:21]
        instret <= _GEN_168;
      end else begin
        instret <= _GEN_5;
      end
    end else begin
      instret <= _GEN_5;
    end
    if (reset) begin // @[csr.scala 181:31]
      instreth <= 32'h0; // @[csr.scala 181:31]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        instreth <= _GEN_6;
      end else if (wen) begin // @[csr.scala 376:21]
        instreth <= _GEN_170;
      end else begin
        instreth <= _GEN_6;
      end
    end else begin
      instreth <= _GEN_6;
    end
    if (reset) begin // @[csr.scala 190:29]
      PRV1 <= 2'h3; // @[csr.scala 190:29]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        PRV1 <= 2'h3; // @[csr.scala 372:12]
      end else if (wen) begin // @[csr.scala 376:21]
        PRV1 <= _GEN_151;
      end
    end
    if (reset) begin // @[csr.scala 193:29]
      IE <= 1'h0; // @[csr.scala 193:29]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        IE <= 1'h0; // @[csr.scala 371:10]
      end else if (wen) begin // @[csr.scala 376:21]
        IE <= _GEN_153;
      end
    end
    if (reset) begin // @[csr.scala 194:29]
      IE1 <= 1'h0; // @[csr.scala 194:29]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        IE1 <= IE; // @[csr.scala 373:11]
      end else if (wen) begin // @[csr.scala 376:21]
        IE1 <= _GEN_152;
      end
    end
    if (reset) begin // @[csr.scala 209:31]
      mtvec <= 32'h1c0; // @[csr.scala 209:31]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          mtvec <= _GEN_161;
        end
      end
    end
    if (reset) begin // @[csr.scala 213:27]
      MTIP <= 1'h0; // @[csr.scala 213:27]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          MTIP <= _GEN_154;
        end
      end
    end
    if (reset) begin // @[csr.scala 217:27]
      MEIE <= 1'h0; // @[csr.scala 217:27]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          MEIE <= _GEN_156;
        end
      end
    end
    if (reset) begin // @[csr.scala 218:27]
      MTIE <= 1'h0; // @[csr.scala 218:27]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          MTIE <= _GEN_157;
        end
      end
    end
    if (reset) begin // @[csr.scala 222:27]
      MEIP <= 1'h0; // @[csr.scala 222:27]
    end else begin
      MEIP <= io_interrupt_sig; // @[csr.scala 287:8]
    end
    if (reset) begin // @[csr.scala 223:27]
      MSIP <= 1'h0; // @[csr.scala 223:27]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          MSIP <= _GEN_155;
        end
      end
    end
    if (reset) begin // @[csr.scala 226:27]
      MSIE <= 1'h0; // @[csr.scala 226:27]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          MSIE <= _GEN_158;
        end
      end
    end
    if (_T_61) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          if (!(io_addr == 32'h300)) begin // @[csr.scala 377:42]
            mscratch <= _GEN_142;
          end
        end
      end
    end
    mepc <= _GEN_213[31:0];
    if (_T_61) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        if (isEcall) begin // @[csr.scala 361:20]
          mcause <= 32'hb;
        end else if (isExtInt) begin // @[csr.scala 362:12]
          mcause <= 32'h8000000b;
        end else begin
          mcause <= {{29'd0}, _mcause_T_10};
        end
      end else if (wen) begin // @[csr.scala 376:21]
        if (!(io_addr == 32'h300)) begin // @[csr.scala 377:42]
          mcause <= _GEN_144;
        end
      end
    end
    if (reset) begin // @[csr.scala 242:33]
      mtval <= 32'h13; // @[csr.scala 242:33]
    end else if (_T_61) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        if (isExtInt) begin // @[csr.scala 341:21]
          mtval <= io_inst; // @[csr.scala 343:15]
        end else begin
          mtval <= _GEN_14;
        end
      end
    end
    if (reset) begin // @[csr.scala 245:31]
      valid_pc <= 32'h0; // @[csr.scala 245:31]
    end else if (_T_26) begin // @[csr.scala 335:24]
      valid_pc <= _valid_pc_T_1; // @[csr.scala 336:14]
    end
    if (reset) begin // @[csr.scala 302:37]
      pre_mepc <= 32'h0; // @[csr.scala 302:37]
    end else if (io_b_check | io_j_check) begin // @[csr.scala 306:33]
      pre_mepc <= io_pc; // @[csr.scala 307:15]
    end
    if (reset) begin // @[csr.scala 304:37]
      pre_calc_addr <= 32'h0; // @[csr.scala 304:37]
    end else if (io_b_check | io_j_check) begin // @[csr.scala 306:33]
      pre_calc_addr <= alu_calc_addr; // @[csr.scala 309:19]
    end
  end
// Register and memory initialization
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
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
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
  time_ = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  timeh = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  cycle = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  cycleh = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  instret = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  instreth = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  PRV1 = _RAND_6[1:0];
  _RAND_7 = {1{`RANDOM}};
  IE = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  IE1 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  mtvec = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  MTIP = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  MEIE = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  MTIE = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  MEIP = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  MSIP = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  MSIE = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  mscratch = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  mepc = _RAND_17[31:0];
  _RAND_18 = {1{`RANDOM}};
  mcause = _RAND_18[31:0];
  _RAND_19 = {1{`RANDOM}};
  mtval = _RAND_19[31:0];
  _RAND_20 = {1{`RANDOM}};
  valid_pc = _RAND_20[31:0];
  _RAND_21 = {1{`RANDOM}};
  pre_mepc = _RAND_21[31:0];
  _RAND_22 = {1{`RANDOM}};
  pre_calc_addr = _RAND_22[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ALU(
  input  [31:0] io_op1,
  input  [31:0] io_op2,
  input  [3:0]  io_alu_op,
  output [31:0] io_out,
  output        io_cmp_out
);
  wire [31:0] _T_1 = ~io_op2; // @[ALU.scala 50:47]
  wire [31:0] op2_inv = io_alu_op[3] ? _T_1 : io_op2; // @[ALU.scala 50:28]
  wire [31:0] _T_3 = io_op1 + op2_inv; // @[ALU.scala 51:28]
  wire [31:0] _GEN_0 = {{31'd0}, io_alu_op[3]}; // @[ALU.scala 51:38]
  wire [31:0] sum = _T_3 + _GEN_0; // @[ALU.scala 51:38]
  wire [4:0] shamt = io_op2[4:0]; // @[ALU.scala 52:29]
  wire  _T_8 = io_alu_op == 4'hb | io_alu_op == 4'h5; // @[ALU.scala 53:48]
  wire [31:0] _T_12 = {{16'd0}, io_op1[31:16]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_14 = {io_op1[15:0], 16'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_16 = _T_14 & 32'hffff0000; // @[Bitwise.scala 103:75]
  wire [31:0] _T_17 = _T_12 | _T_16; // @[Bitwise.scala 103:39]
  wire [31:0] _GEN_1 = {{8'd0}, _T_17[31:8]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_22 = _GEN_1 & 32'hff00ff; // @[Bitwise.scala 103:31]
  wire [31:0] _T_24 = {_T_17[23:0], 8'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_26 = _T_24 & 32'hff00ff00; // @[Bitwise.scala 103:75]
  wire [31:0] _T_27 = _T_22 | _T_26; // @[Bitwise.scala 103:39]
  wire [31:0] _GEN_2 = {{4'd0}, _T_27[31:4]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_32 = _GEN_2 & 32'hf0f0f0f; // @[Bitwise.scala 103:31]
  wire [31:0] _T_34 = {_T_27[27:0], 4'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_36 = _T_34 & 32'hf0f0f0f0; // @[Bitwise.scala 103:75]
  wire [31:0] _T_37 = _T_32 | _T_36; // @[Bitwise.scala 103:39]
  wire [31:0] _GEN_3 = {{2'd0}, _T_37[31:2]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_42 = _GEN_3 & 32'h33333333; // @[Bitwise.scala 103:31]
  wire [31:0] _T_44 = {_T_37[29:0], 2'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_46 = _T_44 & 32'hcccccccc; // @[Bitwise.scala 103:75]
  wire [31:0] _T_47 = _T_42 | _T_46; // @[Bitwise.scala 103:39]
  wire [31:0] _GEN_4 = {{1'd0}, _T_47[31:1]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_52 = _GEN_4 & 32'h55555555; // @[Bitwise.scala 103:31]
  wire [31:0] _T_54 = {_T_47[30:0], 1'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_56 = _T_54 & 32'haaaaaaaa; // @[Bitwise.scala 103:75]
  wire [31:0] _T_57 = _T_52 | _T_56; // @[Bitwise.scala 103:39]
  wire [31:0] shin = io_alu_op == 4'hb | io_alu_op == 4'h5 ? io_op1 : _T_57; // @[ALU.scala 53:25]
  wire  right = io_alu_op[3] & shin[31]; // @[ALU.scala 54:47]
  wire [32:0] _T_61 = {right,shin}; // @[ALU.scala 54:65]
  wire [32:0] _T_62 = $signed(_T_61) >>> shamt; // @[ALU.scala 54:72]
  wire [31:0] shift_r = _T_62[31:0]; // @[ALU.scala 54:81]
  wire [31:0] _T_66 = {{16'd0}, shift_r[31:16]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_68 = {shift_r[15:0], 16'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_70 = _T_68 & 32'hffff0000; // @[Bitwise.scala 103:75]
  wire [31:0] _T_71 = _T_66 | _T_70; // @[Bitwise.scala 103:39]
  wire [31:0] _GEN_5 = {{8'd0}, _T_71[31:8]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_76 = _GEN_5 & 32'hff00ff; // @[Bitwise.scala 103:31]
  wire [31:0] _T_78 = {_T_71[23:0], 8'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_80 = _T_78 & 32'hff00ff00; // @[Bitwise.scala 103:75]
  wire [31:0] _T_81 = _T_76 | _T_80; // @[Bitwise.scala 103:39]
  wire [31:0] _GEN_6 = {{4'd0}, _T_81[31:4]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_86 = _GEN_6 & 32'hf0f0f0f; // @[Bitwise.scala 103:31]
  wire [31:0] _T_88 = {_T_81[27:0], 4'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_90 = _T_88 & 32'hf0f0f0f0; // @[Bitwise.scala 103:75]
  wire [31:0] _T_91 = _T_86 | _T_90; // @[Bitwise.scala 103:39]
  wire [31:0] _GEN_7 = {{2'd0}, _T_91[31:2]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_96 = _GEN_7 & 32'h33333333; // @[Bitwise.scala 103:31]
  wire [31:0] _T_98 = {_T_91[29:0], 2'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_100 = _T_98 & 32'hcccccccc; // @[Bitwise.scala 103:75]
  wire [31:0] _T_101 = _T_96 | _T_100; // @[Bitwise.scala 103:39]
  wire [31:0] _GEN_8 = {{1'd0}, _T_101[31:1]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_106 = _GEN_8 & 32'h55555555; // @[Bitwise.scala 103:31]
  wire [31:0] _T_108 = {_T_101[30:0], 1'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_110 = _T_108 & 32'haaaaaaaa; // @[Bitwise.scala 103:75]
  wire [31:0] shift_l = _T_106 | _T_110; // @[Bitwise.scala 103:39]
  wire  _T_115 = io_alu_op >= 4'he; // @[ALU.scala 29:37]
  wire  _T_118 = _T_115 ? io_op2[31] : io_op1[31]; // @[ALU.scala 56:64]
  wire  slt = io_op1[31] == io_op2[31] ? sum[31] : _T_118; // @[ALU.scala 56:24]
  wire  _T_121 = ~io_alu_op[3]; // @[ALU.scala 32:35]
  wire [31:0] _T_122 = io_op1 ^ io_op2; // @[ALU.scala 58:73]
  wire  _T_124 = _T_121 ? _T_122 == 32'h0 : slt; // @[ALU.scala 58:44]
  wire  cmp = io_alu_op[0] ^ _T_124; // @[ALU.scala 58:39]
  wire [31:0] _T_136 = io_op1 & io_op2; // @[ALU.scala 65:43]
  wire [31:0] _T_138 = io_op1 | io_op2; // @[ALU.scala 66:43]
  wire [31:0] _T_142 = io_alu_op == 4'h8 ? io_op1 : io_op2; // @[ALU.scala 68:12]
  wire [31:0] _T_143 = io_alu_op == 4'h4 ? _T_122 : _T_142; // @[ALU.scala 67:12]
  wire [31:0] _T_144 = io_alu_op == 4'h6 ? _T_138 : _T_143; // @[ALU.scala 66:12]
  wire [31:0] _T_145 = io_alu_op == 4'h7 ? _T_136 : _T_144; // @[ALU.scala 65:12]
  wire [31:0] _T_146 = io_alu_op == 4'h1 ? shift_l : _T_145; // @[ALU.scala 64:12]
  wire [31:0] _T_147 = _T_8 ? shift_r : _T_146; // @[ALU.scala 63:12]
  wire [31:0] _T_148 = io_alu_op == 4'hc | io_alu_op == 4'he ? {{31'd0}, cmp} : _T_147; // @[ALU.scala 62:12]
  assign io_out = io_alu_op == 4'h0 | io_alu_op == 4'ha ? sum : _T_148; // @[ALU.scala 61:12]
  assign io_cmp_out = io_alu_op[0] ^ _T_124; // @[ALU.scala 58:39]
endmodule
module KyogenRVCpu(
  input         clock,
  input         reset,
  output [31:0] io_imem_add_addr,
  output        io_r_imem_dat_req,
  input         io_r_imem_dat_ack,
  input  [31:0] io_r_imem_dat_data,
  output        io_w_imem_dat_req,
  input         io_w_imem_dat_ack,
  output [31:0] io_w_imem_dat_data,
  output [3:0]  io_w_imem_dat_byteenable,
  output [31:0] io_dmem_add_addr,
  output        io_r_dmem_dat_req,
  input         io_r_dmem_dat_ack,
  input  [31:0] io_r_dmem_dat_data,
  output        io_w_dmem_dat_req,
  input         io_w_dmem_dat_ack,
  output [31:0] io_w_dmem_dat_data,
  output [3:0]  io_w_dmem_dat_byteenable,
  input         io_sw_halt,
  output [31:0] io_sw_r_add,
  output [31:0] io_sw_r_dat,
  input  [31:0] io_sw_w_add,
  input  [31:0] io_sw_w_dat,
  input  [31:0] io_sw_g_add,
  output [31:0] io_sw_g_dat,
  output [31:0] io_sw_r_pc,
  input  [31:0] io_sw_w_pc,
  output [31:0] io_sw_r_ex_raddr1,
  output [31:0] io_sw_r_ex_raddr2,
  output [31:0] io_sw_r_ex_rs1,
  output [31:0] io_sw_r_ex_rs2,
  output [31:0] io_sw_r_ex_imm,
  output [31:0] io_sw_r_mem_alu_out,
  output [31:0] io_sw_r_wb_alu_out,
  output [31:0] io_sw_r_wb_rf_wdata,
  output [31:0] io_sw_r_wb_rf_waddr,
  output [31:0] io_sw_r_stall_sig,
  input         io_sw_w_interrupt_sig,
  input         io_sw_w_waitrequest_sig,
  input         io_sw_w_datawaitreq_sig
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
  reg [31:0] _RAND_46;
  reg [31:0] _RAND_47;
  reg [31:0] _RAND_48;
  reg [31:0] _RAND_49;
  reg [31:0] _RAND_50;
  reg [31:0] _RAND_51;
  reg [31:0] _RAND_52;
  reg [31:0] _RAND_53;
  reg [31:0] _RAND_54;
  reg [31:0] _RAND_55;
  reg [31:0] _RAND_56;
  reg [31:0] _RAND_57;
  reg [31:0] _RAND_58;
  reg [31:0] _RAND_59;
  reg [31:0] _RAND_60;
  reg [31:0] _RAND_61;
  reg [31:0] _RAND_62;
  reg [31:0] _RAND_63;
  reg [31:0] _RAND_64;
  reg [31:0] _RAND_65;
  reg [31:0] _RAND_66;
  reg [31:0] _RAND_67;
  reg [31:0] _RAND_68;
  reg [31:0] _RAND_69;
  reg [31:0] _RAND_70;
  reg [31:0] _RAND_71;
  reg [31:0] _RAND_72;
  reg [31:0] _RAND_73;
  reg [31:0] _RAND_74;
  reg [31:0] _RAND_75;
  reg [31:0] _RAND_76;
  reg [31:0] _RAND_77;
  reg [31:0] _RAND_78;
  reg [31:0] _RAND_79;
  reg [31:0] _RAND_80;
  reg [31:0] _RAND_81;
  reg [31:0] _RAND_82;
  reg [31:0] _RAND_83;
  reg [31:0] _RAND_84;
  reg [31:0] _RAND_85;
  reg [31:0] _RAND_86;
  reg [31:0] _RAND_87;
  reg [31:0] _RAND_88;
  reg [31:0] _RAND_89;
  reg [31:0] _RAND_90;
  reg [31:0] _RAND_91;
  reg [31:0] _RAND_92;
  reg [31:0] _RAND_93;
  reg [31:0] _RAND_94;
  reg [31:0] _RAND_95;
  reg [31:0] _RAND_96;
  reg [31:0] _RAND_97;
  reg [31:0] _RAND_98;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] idm_io_imem; // @[core.scala 177:31]
  wire [31:0] idm_io_inst_bits; // @[core.scala 177:31]
  wire [4:0] idm_io_inst_rd; // @[core.scala 177:31]
  wire [4:0] idm_io_inst_rs1; // @[core.scala 177:31]
  wire [4:0] idm_io_inst_rs2; // @[core.scala 177:31]
  wire [11:0] idm_io_inst_csr; // @[core.scala 177:31]
  wire  csr_clock; // @[core.scala 204:26]
  wire  csr_reset; // @[core.scala 204:26]
  wire [31:0] csr_io_addr; // @[core.scala 204:26]
  wire [31:0] csr_io_in; // @[core.scala 204:26]
  wire [31:0] csr_io_out; // @[core.scala 204:26]
  wire [31:0] csr_io_cmd; // @[core.scala 204:26]
  wire [31:0] csr_io_rs1_addr; // @[core.scala 204:26]
  wire  csr_io_legal; // @[core.scala 204:26]
  wire  csr_io_interrupt_sig; // @[core.scala 204:26]
  wire [31:0] csr_io_pc; // @[core.scala 204:26]
  wire  csr_io_pc_invalid; // @[core.scala 204:26]
  wire  csr_io_j_check; // @[core.scala 204:26]
  wire  csr_io_b_check; // @[core.scala 204:26]
  wire  csr_io_stall; // @[core.scala 204:26]
  wire  csr_io_expt; // @[core.scala 204:26]
  wire [31:0] csr_io_evec; // @[core.scala 204:26]
  wire [31:0] csr_io_epc; // @[core.scala 204:26]
  wire [31:0] csr_io_inst; // @[core.scala 204:26]
  wire [1:0] csr_io_mem_wr; // @[core.scala 204:26]
  wire [2:0] csr_io_mask_type; // @[core.scala 204:26]
  wire [31:0] csr_io_alu_op1; // @[core.scala 204:26]
  wire [31:0] csr_io_alu_op2; // @[core.scala 204:26]
  wire [31:0] alu_io_op1; // @[core.scala 252:26]
  wire [31:0] alu_io_op2; // @[core.scala 252:26]
  wire [3:0] alu_io_alu_op; // @[core.scala 252:26]
  wire [31:0] alu_io_out; // @[core.scala 252:26]
  wire  alu_io_cmp_out; // @[core.scala 252:26]
  reg [31:0] if_pc; // @[core.scala 33:30]
  reg [31:0] if_npc; // @[core.scala 34:31]
  reg [31:0] id_inst; // @[core.scala 37:32]
  reg [31:0] id_pc; // @[core.scala 38:30]
  reg [31:0] id_npc; // @[core.scala 39:31]
  reg [31:0] ex_pc; // @[core.scala 43:30]
  reg [31:0] ex_npc; // @[core.scala 44:31]
  reg [31:0] ex_inst; // @[core.scala 45:32]
  reg  ex_ctrl_legal; // @[core.scala 46:39]
  reg [3:0] ex_ctrl_br_type; // @[core.scala 46:39]
  reg [1:0] ex_ctrl_alu_op1; // @[core.scala 46:39]
  reg [1:0] ex_ctrl_alu_op2; // @[core.scala 46:39]
  reg [2:0] ex_ctrl_imm_type; // @[core.scala 46:39]
  reg [3:0] ex_ctrl_alu_func; // @[core.scala 46:39]
  reg [1:0] ex_ctrl_wb_sel; // @[core.scala 46:39]
  reg  ex_ctrl_rf_wen; // @[core.scala 46:39]
  reg  ex_ctrl_mem_en; // @[core.scala 46:39]
  reg [1:0] ex_ctrl_mem_wr; // @[core.scala 46:39]
  reg [2:0] ex_ctrl_mask_type; // @[core.scala 46:39]
  reg [2:0] ex_ctrl_csr_cmd; // @[core.scala 46:39]
  reg [4:0] ex_reg_raddr_0; // @[core.scala 47:42]
  reg [4:0] ex_reg_raddr_1; // @[core.scala 47:42]
  reg [4:0] ex_reg_waddr; // @[core.scala 48:37]
  reg [31:0] ex_rs_0; // @[core.scala 49:35]
  reg [31:0] ex_rs_1; // @[core.scala 49:35]
  reg [31:0] ex_csr_addr; // @[core.scala 50:36]
  reg [31:0] ex_csr_cmd; // @[core.scala 51:35]
  reg  ex_b_check; // @[core.scala 52:35]
  reg  ex_j_check; // @[core.scala 53:35]
  reg [31:0] mem_pc; // @[core.scala 56:31]
  reg [31:0] mem_npc; // @[core.scala 57:32]
  reg [3:0] mem_ctrl_br_type; // @[core.scala 58:40]
  reg [1:0] mem_ctrl_wb_sel; // @[core.scala 58:40]
  reg  mem_ctrl_rf_wen; // @[core.scala 58:40]
  reg  mem_ctrl_mem_en; // @[core.scala 58:40]
  reg [1:0] mem_ctrl_mem_wr; // @[core.scala 58:40]
  reg [2:0] mem_ctrl_mask_type; // @[core.scala 58:40]
  reg [2:0] mem_ctrl_csr_cmd; // @[core.scala 58:40]
  reg [31:0] mem_imm; // @[core.scala 59:32]
  reg [4:0] mem_reg_waddr; // @[core.scala 60:38]
  reg [31:0] mem_rs_1; // @[core.scala 61:36]
  reg [31:0] mem_alu_out; // @[core.scala 62:36]
  reg  mem_alu_cmp_out; // @[core.scala 63:40]
  reg [31:0] mem_csr_data; // @[core.scala 65:37]
  reg [31:0] wb_npc; // @[core.scala 68:31]
  reg [1:0] wb_ctrl_wb_sel; // @[core.scala 69:39]
  reg  wb_ctrl_rf_wen; // @[core.scala 69:39]
  reg  wb_ctrl_mem_en; // @[core.scala 69:39]
  reg [1:0] wb_ctrl_mem_wr; // @[core.scala 69:39]
  reg [2:0] wb_ctrl_mask_type; // @[core.scala 69:39]
  reg [2:0] wb_ctrl_csr_cmd; // @[core.scala 69:39]
  reg [4:0] rf_waddr; // @[core.scala 70:37]
  reg [31:0] wb_alu_out; // @[core.scala 71:35]
  reg [31:0] wb_csr_data; // @[core.scala 74:36]
  reg [31:0] pc_cntr; // @[core.scala 86:32]
  wire [31:0] npc = pc_cntr + 32'h4; // @[core.scala 87:29]
  reg  w_req; // @[core.scala 94:30]
  reg [31:0] w_addr; // @[core.scala 96:31]
  reg [31:0] w_data; // @[core.scala 97:31]
  reg  imem_read_sig; // @[core.scala 103:38]
  reg [3:0] delay_stall; // @[core.scala 108:36]
  wire  _T_1768 = delay_stall != 4'h7; // @[core.scala 110:26]
  wire [3:0] _delay_stall_T_1 = delay_stall + 4'h1; // @[core.scala 111:40]
  reg  valid_imem; // @[core.scala 118:35]
  wire  waitrequest = io_sw_w_waitrequest_sig | io_sw_w_datawaitreq_sig; // @[core.scala 121:39]
  wire  _stall_T_3 = mem_ctrl_mem_wr == 2'h1; // @[core.scala 208:25]
  wire  _stall_T_5 = mem_ctrl_mem_wr == 2'h1 | ex_ctrl_mem_wr == 2'h1; // @[core.scala 208:36]
  wire  _stall_T_6 = (ex_reg_waddr == idm_io_inst_rs1 | ex_reg_waddr == idm_io_inst_rs2) & _stall_T_5; // @[core.scala 207:74]
  wire  _inst_kill_branch_T_1 = mem_ctrl_br_type > 4'h3 & mem_alu_cmp_out; // @[core.scala 419:33]
  wire  _inst_kill_branch_T_2 = mem_ctrl_br_type == 4'h2; // @[core.scala 420:27]
  wire  _inst_kill_branch_T_3 = mem_ctrl_br_type > 4'h3 & mem_alu_cmp_out | _inst_kill_branch_T_2; // @[core.scala 419:53]
  wire  _inst_kill_branch_T_4 = mem_ctrl_br_type == 4'h1; // @[core.scala 421:27]
  wire  _inst_kill_branch_T_5 = _inst_kill_branch_T_3 | _inst_kill_branch_T_4; // @[core.scala 420:38]
  wire  _inst_kill_branch_T_6 = mem_ctrl_br_type == 4'h3; // @[core.scala 422:27]
  wire  inst_kill_branch = _inst_kill_branch_T_5 | _inst_kill_branch_T_6; // @[core.scala 421:37]
  wire  inst_kill = inst_kill_branch | csr_io_expt; // @[core.scala 424:36]
  wire  _stall_T_7 = ~inst_kill; // @[core.scala 208:71]
  wire  _stall_T_13 = idm_io_inst_rs1 != 5'h0 & idm_io_inst_rs1 == rf_waddr & _stall_T_7; // @[core.scala 209:57]
  wire  _stall_T_14 = _stall_T_6 & ~inst_kill | _stall_T_13; // @[core.scala 208:84]
  wire  _stall_T_19 = idm_io_inst_rs2 != 5'h0 & idm_io_inst_rs2 == rf_waddr & _stall_T_7; // @[core.scala 210:57]
  wire  _stall_T_20 = _stall_T_14 | _stall_T_19; // @[core.scala 209:73]
  wire  stall = _stall_T_20 | _T_1768; // @[core.scala 210:73]
  wire  _T_1769 = ~stall; // @[core.scala 125:10]
  wire  _T_1772 = ~waitrequest; // @[core.scala 125:34]
  wire  _T_1773 = ~stall & _stall_T_7 & ~waitrequest; // @[core.scala 125:31]
  reg  io_r_imem_dat_req_REG; // @[core.scala 128:37]
  wire  _T_1775 = inst_kill & _T_1772; // @[core.scala 130:26]
  reg  io_r_imem_dat_req_REG_1; // @[core.scala 133:37]
  reg [31:0] id_inst_temp; // @[core.scala 142:37]
  reg [31:0] id_pc_temp; // @[core.scala 143:35]
  reg [31:0] id_npc_temp; // @[core.scala 144:36]
  wire  _T_1782 = _T_1769 & _T_1772; // @[core.scala 151:23]
  wire [31:0] _GEN_10 = _T_1769 & ~valid_imem & _stall_T_7 & _T_1772 ? id_pc_temp : id_pc; // @[core.scala 163:69 core.scala 164:15 core.scala 172:15]
  wire [31:0] _GEN_11 = _T_1769 & ~valid_imem & _stall_T_7 & _T_1772 ? id_npc_temp : id_npc; // @[core.scala 163:69 core.scala 165:16 core.scala 173:16]
  wire [31:0] _GEN_12 = _T_1769 & ~valid_imem & _stall_T_7 & _T_1772 ? id_inst_temp : id_inst; // @[core.scala 163:69 core.scala 166:17 core.scala 174:17]
  wire [31:0] _GEN_13 = _T_1769 & ~valid_imem & _stall_T_7 & _T_1772 ? 32'h0 : id_pc_temp; // @[core.scala 163:69 core.scala 168:20 core.scala 143:35]
  wire [31:0] _GEN_14 = _T_1769 & ~valid_imem & _stall_T_7 & _T_1772 ? 32'h4 : id_npc_temp; // @[core.scala 163:69 core.scala 169:21 core.scala 144:36]
  wire [31:0] _GEN_15 = _T_1769 & ~valid_imem & _stall_T_7 & _T_1772 ? 32'h13 : id_inst_temp; // @[core.scala 163:69 core.scala 170:22 core.scala 142:37]
  wire [31:0] _T_1795 = idm_io_inst_bits & 32'h7f; // @[control.scala 192:55]
  wire  _T_1796 = 32'h37 == _T_1795; // @[control.scala 192:55]
  wire  _T_1798 = 32'h17 == _T_1795; // @[control.scala 192:55]
  wire  _T_1800 = 32'h6f == _T_1795; // @[control.scala 192:55]
  wire [31:0] _T_1801 = idm_io_inst_bits & 32'h707f; // @[control.scala 192:55]
  wire  _T_1802 = 32'h67 == _T_1801; // @[control.scala 192:55]
  wire  _T_1804 = 32'h63 == _T_1801; // @[control.scala 192:55]
  wire  _T_1806 = 32'h1063 == _T_1801; // @[control.scala 192:55]
  wire  _T_1808 = 32'h4063 == _T_1801; // @[control.scala 192:55]
  wire  _T_1810 = 32'h5063 == _T_1801; // @[control.scala 192:55]
  wire  _T_1812 = 32'h6063 == _T_1801; // @[control.scala 192:55]
  wire  _T_1814 = 32'h7063 == _T_1801; // @[control.scala 192:55]
  wire  _T_1816 = 32'h3 == _T_1801; // @[control.scala 192:55]
  wire  _T_1818 = 32'h1003 == _T_1801; // @[control.scala 192:55]
  wire  _T_1820 = 32'h2003 == _T_1801; // @[control.scala 192:55]
  wire  _T_1822 = 32'h4003 == _T_1801; // @[control.scala 192:55]
  wire  _T_1824 = 32'h5003 == _T_1801; // @[control.scala 192:55]
  wire  _T_1826 = 32'h23 == _T_1801; // @[control.scala 192:55]
  wire  _T_1828 = 32'h1023 == _T_1801; // @[control.scala 192:55]
  wire  _T_1830 = 32'h2023 == _T_1801; // @[control.scala 192:55]
  wire  _T_1832 = 32'h13 == _T_1801; // @[control.scala 192:55]
  wire  _T_1834 = 32'h2013 == _T_1801; // @[control.scala 192:55]
  wire  _T_1836 = 32'h3013 == _T_1801; // @[control.scala 192:55]
  wire  _T_1838 = 32'h4013 == _T_1801; // @[control.scala 192:55]
  wire  _T_1840 = 32'h6013 == _T_1801; // @[control.scala 192:55]
  wire  _T_1842 = 32'h7013 == _T_1801; // @[control.scala 192:55]
  wire [31:0] _T_1843 = idm_io_inst_bits & 32'hfe00707f; // @[control.scala 192:55]
  wire  _T_1844 = 32'h1013 == _T_1843; // @[control.scala 192:55]
  wire [31:0] _T_1845 = idm_io_inst_bits & 32'hfc00707f; // @[control.scala 192:55]
  wire  _T_1846 = 32'h5013 == _T_1845; // @[control.scala 192:55]
  wire  _T_1848 = 32'h40005013 == _T_1845; // @[control.scala 192:55]
  wire  _T_1850 = 32'h33 == _T_1843; // @[control.scala 192:55]
  wire  _T_1852 = 32'h40000033 == _T_1843; // @[control.scala 192:55]
  wire  _T_1854 = 32'h1033 == _T_1843; // @[control.scala 192:55]
  wire  _T_1856 = 32'h2033 == _T_1843; // @[control.scala 192:55]
  wire  _T_1858 = 32'h3033 == _T_1843; // @[control.scala 192:55]
  wire  _T_1860 = 32'h4033 == _T_1843; // @[control.scala 192:55]
  wire  _T_1862 = 32'h5033 == _T_1843; // @[control.scala 192:55]
  wire  _T_1864 = 32'h40005033 == _T_1843; // @[control.scala 192:55]
  wire  _T_1866 = 32'h6033 == _T_1843; // @[control.scala 192:55]
  wire  _T_1868 = 32'h7033 == _T_1843; // @[control.scala 192:55]
  wire  _T_1870 = 32'h5073 == _T_1801; // @[control.scala 192:55]
  wire  _T_1872 = 32'h6073 == _T_1801; // @[control.scala 192:55]
  wire  _T_1874 = 32'h7073 == _T_1801; // @[control.scala 192:55]
  wire  _T_1876 = 32'h1073 == _T_1801; // @[control.scala 192:55]
  wire  _T_1878 = 32'h2073 == _T_1801; // @[control.scala 192:55]
  wire  _T_1880 = 32'h3073 == _T_1801; // @[control.scala 192:55]
  wire [31:0] _T_1881 = idm_io_inst_bits; // @[control.scala 192:55]
  wire  _T_1882 = 32'h73 == _T_1881; // @[control.scala 192:55]
  wire  _T_1884 = 32'h30200073 == _T_1881; // @[control.scala 192:55]
  wire  _T_1886 = 32'h10000073 == _T_1881; // @[control.scala 192:55]
  wire  _T_1888 = 32'h100073 == _T_1881; // @[control.scala 192:55]
  wire  _T_1890 = 32'h100f == _T_1801; // @[control.scala 192:55]
  wire  _T_1892 = 32'hf == _T_1801; // @[control.scala 192:55]
  wire  _T_1923 = _T_1832 | (_T_1834 | (_T_1836 | (_T_1838 | (_T_1840 | (_T_1842 | (_T_1844 | (_T_1846 | (_T_1848 | (
    _T_1850 | (_T_1852 | (_T_1854 | (_T_1856 | (_T_1858 | (_T_1860 | (_T_1862 | (_T_1864 | (_T_1866 | (_T_1868 | (
    _T_1870 | (_T_1872 | (_T_1874 | (_T_1876 | (_T_1878 | (_T_1880 | (_T_1882 | (_T_1884 | (_T_1886 | (_T_1888 | (
    _T_1890 | _T_1892))))))))))))))))))))))))))))); // @[Mux.scala 98:16]
  wire  id_ctrl_legal = _T_1796 | (_T_1798 | (_T_1800 | (_T_1802 | (_T_1804 | (_T_1806 | (_T_1808 | (_T_1810 | (_T_1812
     | (_T_1814 | (_T_1816 | (_T_1818 | (_T_1820 | (_T_1822 | (_T_1824 | (_T_1826 | (_T_1828 | (_T_1830 | _T_1923)))))))
    )))))))))); // @[Mux.scala 98:16]
  wire [1:0] _T_2044 = _T_1884 ? 2'h3 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_2045 = _T_1882 ? 2'h0 : _T_2044; // @[Mux.scala 98:16]
  wire [1:0] _T_2046 = _T_1880 ? 2'h0 : _T_2045; // @[Mux.scala 98:16]
  wire [1:0] _T_2047 = _T_1878 ? 2'h0 : _T_2046; // @[Mux.scala 98:16]
  wire [1:0] _T_2048 = _T_1876 ? 2'h0 : _T_2047; // @[Mux.scala 98:16]
  wire [1:0] _T_2049 = _T_1874 ? 2'h0 : _T_2048; // @[Mux.scala 98:16]
  wire [1:0] _T_2050 = _T_1872 ? 2'h0 : _T_2049; // @[Mux.scala 98:16]
  wire [1:0] _T_2051 = _T_1870 ? 2'h0 : _T_2050; // @[Mux.scala 98:16]
  wire [1:0] _T_2052 = _T_1868 ? 2'h0 : _T_2051; // @[Mux.scala 98:16]
  wire [1:0] _T_2053 = _T_1866 ? 2'h0 : _T_2052; // @[Mux.scala 98:16]
  wire [1:0] _T_2054 = _T_1864 ? 2'h0 : _T_2053; // @[Mux.scala 98:16]
  wire [1:0] _T_2055 = _T_1862 ? 2'h0 : _T_2054; // @[Mux.scala 98:16]
  wire [1:0] _T_2056 = _T_1860 ? 2'h0 : _T_2055; // @[Mux.scala 98:16]
  wire [1:0] _T_2057 = _T_1858 ? 2'h0 : _T_2056; // @[Mux.scala 98:16]
  wire [1:0] _T_2058 = _T_1856 ? 2'h0 : _T_2057; // @[Mux.scala 98:16]
  wire [1:0] _T_2059 = _T_1854 ? 2'h0 : _T_2058; // @[Mux.scala 98:16]
  wire [1:0] _T_2060 = _T_1852 ? 2'h0 : _T_2059; // @[Mux.scala 98:16]
  wire [1:0] _T_2061 = _T_1850 ? 2'h0 : _T_2060; // @[Mux.scala 98:16]
  wire [1:0] _T_2062 = _T_1848 ? 2'h0 : _T_2061; // @[Mux.scala 98:16]
  wire [1:0] _T_2063 = _T_1846 ? 2'h0 : _T_2062; // @[Mux.scala 98:16]
  wire [1:0] _T_2064 = _T_1844 ? 2'h0 : _T_2063; // @[Mux.scala 98:16]
  wire [1:0] _T_2065 = _T_1842 ? 2'h0 : _T_2064; // @[Mux.scala 98:16]
  wire [1:0] _T_2066 = _T_1840 ? 2'h0 : _T_2065; // @[Mux.scala 98:16]
  wire [1:0] _T_2067 = _T_1838 ? 2'h0 : _T_2066; // @[Mux.scala 98:16]
  wire [1:0] _T_2068 = _T_1836 ? 2'h0 : _T_2067; // @[Mux.scala 98:16]
  wire [1:0] _T_2069 = _T_1834 ? 2'h0 : _T_2068; // @[Mux.scala 98:16]
  wire [1:0] _T_2070 = _T_1832 ? 2'h0 : _T_2069; // @[Mux.scala 98:16]
  wire [1:0] _T_2071 = _T_1830 ? 2'h0 : _T_2070; // @[Mux.scala 98:16]
  wire [1:0] _T_2072 = _T_1828 ? 2'h0 : _T_2071; // @[Mux.scala 98:16]
  wire [1:0] _T_2073 = _T_1826 ? 2'h0 : _T_2072; // @[Mux.scala 98:16]
  wire [1:0] _T_2074 = _T_1824 ? 2'h0 : _T_2073; // @[Mux.scala 98:16]
  wire [1:0] _T_2075 = _T_1822 ? 2'h0 : _T_2074; // @[Mux.scala 98:16]
  wire [1:0] _T_2076 = _T_1820 ? 2'h0 : _T_2075; // @[Mux.scala 98:16]
  wire [1:0] _T_2077 = _T_1818 ? 2'h0 : _T_2076; // @[Mux.scala 98:16]
  wire [1:0] _T_2078 = _T_1816 ? 2'h0 : _T_2077; // @[Mux.scala 98:16]
  wire [2:0] _T_2079 = _T_1814 ? 3'h7 : {{1'd0}, _T_2078}; // @[Mux.scala 98:16]
  wire [3:0] _T_2080 = _T_1812 ? 4'h9 : {{1'd0}, _T_2079}; // @[Mux.scala 98:16]
  wire [3:0] _T_2081 = _T_1810 ? 4'h6 : _T_2080; // @[Mux.scala 98:16]
  wire [3:0] _T_2082 = _T_1808 ? 4'h8 : _T_2081; // @[Mux.scala 98:16]
  wire [3:0] _T_2083 = _T_1806 ? 4'h4 : _T_2082; // @[Mux.scala 98:16]
  wire [3:0] _T_2084 = _T_1804 ? 4'h5 : _T_2083; // @[Mux.scala 98:16]
  wire [3:0] _T_2085 = _T_1802 ? 4'h2 : _T_2084; // @[Mux.scala 98:16]
  wire [3:0] _T_2086 = _T_1800 ? 4'h1 : _T_2085; // @[Mux.scala 98:16]
  wire [3:0] _T_2087 = _T_1798 ? 4'h0 : _T_2086; // @[Mux.scala 98:16]
  wire [3:0] id_ctrl_br_type = _T_1796 ? 4'h0 : _T_2087; // @[Mux.scala 98:16]
  wire  _T_2196 = _T_1874 ? 1'h0 : _T_1876 | (_T_1878 | _T_1880); // @[Mux.scala 98:16]
  wire  _T_2197 = _T_1872 ? 1'h0 : _T_2196; // @[Mux.scala 98:16]
  wire  _T_2198 = _T_1870 ? 1'h0 : _T_2197; // @[Mux.scala 98:16]
  wire  _T_2228 = _T_1810 | (_T_1812 | (_T_1814 | (_T_1816 | (_T_1818 | (_T_1820 | (_T_1822 | (_T_1824 | (_T_1826 | (
    _T_1828 | (_T_1830 | (_T_1832 | (_T_1834 | (_T_1836 | (_T_1838 | (_T_1840 | (_T_1842 | (_T_1844 | (_T_1846 | (
    _T_1848 | (_T_1850 | (_T_1852 | (_T_1854 | (_T_1856 | (_T_1858 | (_T_1860 | (_T_1862 | (_T_1864 | (_T_1866 | (
    _T_1868 | _T_2198))))))))))))))))))))))))))))); // @[Mux.scala 98:16]
  wire  _T_2232 = _T_1802 | (_T_1804 | (_T_1806 | (_T_1808 | _T_2228))); // @[Mux.scala 98:16]
  wire [1:0] _T_2233 = _T_1800 ? 2'h2 : {{1'd0}, _T_2232}; // @[Mux.scala 98:16]
  wire [1:0] _T_2343 = _T_1874 ? 2'h2 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_2344 = _T_1872 ? 2'h2 : _T_2343; // @[Mux.scala 98:16]
  wire [1:0] _T_2345 = _T_1870 ? 2'h2 : _T_2344; // @[Mux.scala 98:16]
  wire [1:0] _T_2346 = _T_1868 ? 2'h1 : _T_2345; // @[Mux.scala 98:16]
  wire [1:0] _T_2347 = _T_1866 ? 2'h1 : _T_2346; // @[Mux.scala 98:16]
  wire [1:0] _T_2348 = _T_1864 ? 2'h1 : _T_2347; // @[Mux.scala 98:16]
  wire [1:0] _T_2349 = _T_1862 ? 2'h1 : _T_2348; // @[Mux.scala 98:16]
  wire [1:0] _T_2350 = _T_1860 ? 2'h1 : _T_2349; // @[Mux.scala 98:16]
  wire [1:0] _T_2351 = _T_1858 ? 2'h1 : _T_2350; // @[Mux.scala 98:16]
  wire [1:0] _T_2352 = _T_1856 ? 2'h1 : _T_2351; // @[Mux.scala 98:16]
  wire [1:0] _T_2353 = _T_1854 ? 2'h1 : _T_2352; // @[Mux.scala 98:16]
  wire [1:0] _T_2354 = _T_1852 ? 2'h1 : _T_2353; // @[Mux.scala 98:16]
  wire [1:0] _T_2355 = _T_1850 ? 2'h1 : _T_2354; // @[Mux.scala 98:16]
  wire [1:0] _T_2356 = _T_1848 ? 2'h2 : _T_2355; // @[Mux.scala 98:16]
  wire [1:0] _T_2357 = _T_1846 ? 2'h2 : _T_2356; // @[Mux.scala 98:16]
  wire [1:0] _T_2358 = _T_1844 ? 2'h2 : _T_2357; // @[Mux.scala 98:16]
  wire [1:0] _T_2359 = _T_1842 ? 2'h2 : _T_2358; // @[Mux.scala 98:16]
  wire [1:0] _T_2360 = _T_1840 ? 2'h2 : _T_2359; // @[Mux.scala 98:16]
  wire [1:0] _T_2361 = _T_1838 ? 2'h2 : _T_2360; // @[Mux.scala 98:16]
  wire [1:0] _T_2362 = _T_1836 ? 2'h2 : _T_2361; // @[Mux.scala 98:16]
  wire [1:0] _T_2363 = _T_1834 ? 2'h2 : _T_2362; // @[Mux.scala 98:16]
  wire [1:0] _T_2364 = _T_1832 ? 2'h2 : _T_2363; // @[Mux.scala 98:16]
  wire [1:0] _T_2365 = _T_1830 ? 2'h2 : _T_2364; // @[Mux.scala 98:16]
  wire [1:0] _T_2366 = _T_1828 ? 2'h2 : _T_2365; // @[Mux.scala 98:16]
  wire [1:0] _T_2367 = _T_1826 ? 2'h2 : _T_2366; // @[Mux.scala 98:16]
  wire [1:0] _T_2368 = _T_1824 ? 2'h2 : _T_2367; // @[Mux.scala 98:16]
  wire [1:0] _T_2369 = _T_1822 ? 2'h2 : _T_2368; // @[Mux.scala 98:16]
  wire [1:0] _T_2370 = _T_1820 ? 2'h2 : _T_2369; // @[Mux.scala 98:16]
  wire [1:0] _T_2371 = _T_1818 ? 2'h2 : _T_2370; // @[Mux.scala 98:16]
  wire [1:0] _T_2372 = _T_1816 ? 2'h2 : _T_2371; // @[Mux.scala 98:16]
  wire [1:0] _T_2373 = _T_1814 ? 2'h1 : _T_2372; // @[Mux.scala 98:16]
  wire [1:0] _T_2374 = _T_1812 ? 2'h1 : _T_2373; // @[Mux.scala 98:16]
  wire [1:0] _T_2375 = _T_1810 ? 2'h1 : _T_2374; // @[Mux.scala 98:16]
  wire [1:0] _T_2376 = _T_1808 ? 2'h1 : _T_2375; // @[Mux.scala 98:16]
  wire [1:0] _T_2377 = _T_1806 ? 2'h1 : _T_2376; // @[Mux.scala 98:16]
  wire [1:0] _T_2378 = _T_1804 ? 2'h1 : _T_2377; // @[Mux.scala 98:16]
  wire [1:0] _T_2379 = _T_1802 ? 2'h2 : _T_2378; // @[Mux.scala 98:16]
  wire [1:0] _T_2380 = _T_1800 ? 2'h2 : _T_2379; // @[Mux.scala 98:16]
  wire [2:0] _T_2490 = _T_1874 ? 3'h5 : 3'h0; // @[Mux.scala 98:16]
  wire [2:0] _T_2491 = _T_1872 ? 3'h5 : _T_2490; // @[Mux.scala 98:16]
  wire [2:0] _T_2492 = _T_1870 ? 3'h5 : _T_2491; // @[Mux.scala 98:16]
  wire [2:0] _T_2493 = _T_1868 ? 3'h0 : _T_2492; // @[Mux.scala 98:16]
  wire [2:0] _T_2494 = _T_1866 ? 3'h0 : _T_2493; // @[Mux.scala 98:16]
  wire [2:0] _T_2495 = _T_1864 ? 3'h0 : _T_2494; // @[Mux.scala 98:16]
  wire [2:0] _T_2496 = _T_1862 ? 3'h0 : _T_2495; // @[Mux.scala 98:16]
  wire [2:0] _T_2497 = _T_1860 ? 3'h0 : _T_2496; // @[Mux.scala 98:16]
  wire [2:0] _T_2498 = _T_1858 ? 3'h0 : _T_2497; // @[Mux.scala 98:16]
  wire [2:0] _T_2499 = _T_1856 ? 3'h0 : _T_2498; // @[Mux.scala 98:16]
  wire [2:0] _T_2500 = _T_1854 ? 3'h0 : _T_2499; // @[Mux.scala 98:16]
  wire [2:0] _T_2501 = _T_1852 ? 3'h0 : _T_2500; // @[Mux.scala 98:16]
  wire [2:0] _T_2502 = _T_1850 ? 3'h0 : _T_2501; // @[Mux.scala 98:16]
  wire [2:0] _T_2503 = _T_1848 ? 3'h0 : _T_2502; // @[Mux.scala 98:16]
  wire [2:0] _T_2504 = _T_1846 ? 3'h0 : _T_2503; // @[Mux.scala 98:16]
  wire [2:0] _T_2505 = _T_1844 ? 3'h0 : _T_2504; // @[Mux.scala 98:16]
  wire [2:0] _T_2506 = _T_1842 ? 3'h0 : _T_2505; // @[Mux.scala 98:16]
  wire [2:0] _T_2507 = _T_1840 ? 3'h0 : _T_2506; // @[Mux.scala 98:16]
  wire [2:0] _T_2508 = _T_1838 ? 3'h0 : _T_2507; // @[Mux.scala 98:16]
  wire [2:0] _T_2509 = _T_1836 ? 3'h0 : _T_2508; // @[Mux.scala 98:16]
  wire [2:0] _T_2510 = _T_1834 ? 3'h0 : _T_2509; // @[Mux.scala 98:16]
  wire [2:0] _T_2511 = _T_1832 ? 3'h0 : _T_2510; // @[Mux.scala 98:16]
  wire [2:0] _T_2512 = _T_1830 ? 3'h1 : _T_2511; // @[Mux.scala 98:16]
  wire [2:0] _T_2513 = _T_1828 ? 3'h1 : _T_2512; // @[Mux.scala 98:16]
  wire [2:0] _T_2514 = _T_1826 ? 3'h1 : _T_2513; // @[Mux.scala 98:16]
  wire [2:0] _T_2515 = _T_1824 ? 3'h0 : _T_2514; // @[Mux.scala 98:16]
  wire [2:0] _T_2516 = _T_1822 ? 3'h0 : _T_2515; // @[Mux.scala 98:16]
  wire [2:0] _T_2517 = _T_1820 ? 3'h0 : _T_2516; // @[Mux.scala 98:16]
  wire [2:0] _T_2518 = _T_1818 ? 3'h0 : _T_2517; // @[Mux.scala 98:16]
  wire [2:0] _T_2519 = _T_1816 ? 3'h0 : _T_2518; // @[Mux.scala 98:16]
  wire [2:0] _T_2520 = _T_1814 ? 3'h2 : _T_2519; // @[Mux.scala 98:16]
  wire [2:0] _T_2521 = _T_1812 ? 3'h2 : _T_2520; // @[Mux.scala 98:16]
  wire [2:0] _T_2522 = _T_1810 ? 3'h2 : _T_2521; // @[Mux.scala 98:16]
  wire [2:0] _T_2523 = _T_1808 ? 3'h2 : _T_2522; // @[Mux.scala 98:16]
  wire [2:0] _T_2524 = _T_1806 ? 3'h2 : _T_2523; // @[Mux.scala 98:16]
  wire [2:0] _T_2525 = _T_1804 ? 3'h2 : _T_2524; // @[Mux.scala 98:16]
  wire [2:0] _T_2526 = _T_1802 ? 3'h0 : _T_2525; // @[Mux.scala 98:16]
  wire [2:0] _T_2527 = _T_1800 ? 3'h4 : _T_2526; // @[Mux.scala 98:16]
  wire [3:0] _T_2634 = _T_1880 ? 4'h8 : 4'h0; // @[Mux.scala 98:16]
  wire [3:0] _T_2635 = _T_1878 ? 4'h8 : _T_2634; // @[Mux.scala 98:16]
  wire [3:0] _T_2636 = _T_1876 ? 4'h8 : _T_2635; // @[Mux.scala 98:16]
  wire [3:0] _T_2637 = _T_1874 ? 4'h0 : _T_2636; // @[Mux.scala 98:16]
  wire [3:0] _T_2638 = _T_1872 ? 4'h0 : _T_2637; // @[Mux.scala 98:16]
  wire [3:0] _T_2639 = _T_1870 ? 4'h0 : _T_2638; // @[Mux.scala 98:16]
  wire [3:0] _T_2640 = _T_1868 ? 4'h7 : _T_2639; // @[Mux.scala 98:16]
  wire [3:0] _T_2641 = _T_1866 ? 4'h6 : _T_2640; // @[Mux.scala 98:16]
  wire [3:0] _T_2642 = _T_1864 ? 4'hb : _T_2641; // @[Mux.scala 98:16]
  wire [3:0] _T_2643 = _T_1862 ? 4'h5 : _T_2642; // @[Mux.scala 98:16]
  wire [3:0] _T_2644 = _T_1860 ? 4'h4 : _T_2643; // @[Mux.scala 98:16]
  wire [3:0] _T_2645 = _T_1858 ? 4'he : _T_2644; // @[Mux.scala 98:16]
  wire [3:0] _T_2646 = _T_1856 ? 4'hc : _T_2645; // @[Mux.scala 98:16]
  wire [3:0] _T_2647 = _T_1854 ? 4'h1 : _T_2646; // @[Mux.scala 98:16]
  wire [3:0] _T_2648 = _T_1852 ? 4'ha : _T_2647; // @[Mux.scala 98:16]
  wire [3:0] _T_2649 = _T_1850 ? 4'h0 : _T_2648; // @[Mux.scala 98:16]
  wire [3:0] _T_2650 = _T_1848 ? 4'hb : _T_2649; // @[Mux.scala 98:16]
  wire [3:0] _T_2651 = _T_1846 ? 4'h5 : _T_2650; // @[Mux.scala 98:16]
  wire [3:0] _T_2652 = _T_1844 ? 4'h1 : _T_2651; // @[Mux.scala 98:16]
  wire [3:0] _T_2653 = _T_1842 ? 4'h7 : _T_2652; // @[Mux.scala 98:16]
  wire [3:0] _T_2654 = _T_1840 ? 4'h6 : _T_2653; // @[Mux.scala 98:16]
  wire [3:0] _T_2655 = _T_1838 ? 4'h4 : _T_2654; // @[Mux.scala 98:16]
  wire [3:0] _T_2656 = _T_1836 ? 4'he : _T_2655; // @[Mux.scala 98:16]
  wire [3:0] _T_2657 = _T_1834 ? 4'hc : _T_2656; // @[Mux.scala 98:16]
  wire [3:0] _T_2658 = _T_1832 ? 4'h0 : _T_2657; // @[Mux.scala 98:16]
  wire [3:0] _T_2659 = _T_1830 ? 4'h0 : _T_2658; // @[Mux.scala 98:16]
  wire [3:0] _T_2660 = _T_1828 ? 4'h0 : _T_2659; // @[Mux.scala 98:16]
  wire [3:0] _T_2661 = _T_1826 ? 4'h0 : _T_2660; // @[Mux.scala 98:16]
  wire [3:0] _T_2662 = _T_1824 ? 4'h0 : _T_2661; // @[Mux.scala 98:16]
  wire [3:0] _T_2663 = _T_1822 ? 4'h0 : _T_2662; // @[Mux.scala 98:16]
  wire [3:0] _T_2664 = _T_1820 ? 4'h0 : _T_2663; // @[Mux.scala 98:16]
  wire [3:0] _T_2665 = _T_1818 ? 4'h0 : _T_2664; // @[Mux.scala 98:16]
  wire [3:0] _T_2666 = _T_1816 ? 4'h0 : _T_2665; // @[Mux.scala 98:16]
  wire [3:0] _T_2667 = _T_1814 ? 4'hf : _T_2666; // @[Mux.scala 98:16]
  wire [3:0] _T_2668 = _T_1812 ? 4'he : _T_2667; // @[Mux.scala 98:16]
  wire [3:0] _T_2669 = _T_1810 ? 4'hd : _T_2668; // @[Mux.scala 98:16]
  wire [3:0] _T_2670 = _T_1808 ? 4'hc : _T_2669; // @[Mux.scala 98:16]
  wire [3:0] _T_2671 = _T_1806 ? 4'h3 : _T_2670; // @[Mux.scala 98:16]
  wire [3:0] _T_2672 = _T_1804 ? 4'h2 : _T_2671; // @[Mux.scala 98:16]
  wire [3:0] _T_2673 = _T_1802 ? 4'h0 : _T_2672; // @[Mux.scala 98:16]
  wire [3:0] _T_2674 = _T_1800 ? 4'h0 : _T_2673; // @[Mux.scala 98:16]
  wire [1:0] _T_2778 = _T_1886 ? 2'h3 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_2779 = _T_1884 ? 2'h0 : _T_2778; // @[Mux.scala 98:16]
  wire [1:0] _T_2780 = _T_1882 ? 2'h0 : _T_2779; // @[Mux.scala 98:16]
  wire [1:0] _T_2781 = _T_1880 ? 2'h3 : _T_2780; // @[Mux.scala 98:16]
  wire [1:0] _T_2782 = _T_1878 ? 2'h3 : _T_2781; // @[Mux.scala 98:16]
  wire [1:0] _T_2783 = _T_1876 ? 2'h3 : _T_2782; // @[Mux.scala 98:16]
  wire [1:0] _T_2784 = _T_1874 ? 2'h3 : _T_2783; // @[Mux.scala 98:16]
  wire [1:0] _T_2785 = _T_1872 ? 2'h3 : _T_2784; // @[Mux.scala 98:16]
  wire [1:0] _T_2786 = _T_1870 ? 2'h3 : _T_2785; // @[Mux.scala 98:16]
  wire [1:0] _T_2787 = _T_1868 ? 2'h1 : _T_2786; // @[Mux.scala 98:16]
  wire [1:0] _T_2788 = _T_1866 ? 2'h1 : _T_2787; // @[Mux.scala 98:16]
  wire [1:0] _T_2789 = _T_1864 ? 2'h1 : _T_2788; // @[Mux.scala 98:16]
  wire [1:0] _T_2790 = _T_1862 ? 2'h1 : _T_2789; // @[Mux.scala 98:16]
  wire [1:0] _T_2791 = _T_1860 ? 2'h1 : _T_2790; // @[Mux.scala 98:16]
  wire [1:0] _T_2792 = _T_1858 ? 2'h1 : _T_2791; // @[Mux.scala 98:16]
  wire [1:0] _T_2793 = _T_1856 ? 2'h1 : _T_2792; // @[Mux.scala 98:16]
  wire [1:0] _T_2794 = _T_1854 ? 2'h1 : _T_2793; // @[Mux.scala 98:16]
  wire [1:0] _T_2795 = _T_1852 ? 2'h1 : _T_2794; // @[Mux.scala 98:16]
  wire [1:0] _T_2796 = _T_1850 ? 2'h1 : _T_2795; // @[Mux.scala 98:16]
  wire [1:0] _T_2797 = _T_1848 ? 2'h1 : _T_2796; // @[Mux.scala 98:16]
  wire [1:0] _T_2798 = _T_1846 ? 2'h1 : _T_2797; // @[Mux.scala 98:16]
  wire [1:0] _T_2799 = _T_1844 ? 2'h1 : _T_2798; // @[Mux.scala 98:16]
  wire [1:0] _T_2800 = _T_1842 ? 2'h1 : _T_2799; // @[Mux.scala 98:16]
  wire [1:0] _T_2801 = _T_1840 ? 2'h1 : _T_2800; // @[Mux.scala 98:16]
  wire [1:0] _T_2802 = _T_1838 ? 2'h1 : _T_2801; // @[Mux.scala 98:16]
  wire [1:0] _T_2803 = _T_1836 ? 2'h1 : _T_2802; // @[Mux.scala 98:16]
  wire [1:0] _T_2804 = _T_1834 ? 2'h1 : _T_2803; // @[Mux.scala 98:16]
  wire [1:0] _T_2805 = _T_1832 ? 2'h1 : _T_2804; // @[Mux.scala 98:16]
  wire [1:0] _T_2806 = _T_1830 ? 2'h0 : _T_2805; // @[Mux.scala 98:16]
  wire [1:0] _T_2807 = _T_1828 ? 2'h0 : _T_2806; // @[Mux.scala 98:16]
  wire [1:0] _T_2808 = _T_1826 ? 2'h0 : _T_2807; // @[Mux.scala 98:16]
  wire [1:0] _T_2809 = _T_1824 ? 2'h2 : _T_2808; // @[Mux.scala 98:16]
  wire [1:0] _T_2810 = _T_1822 ? 2'h2 : _T_2809; // @[Mux.scala 98:16]
  wire [1:0] _T_2811 = _T_1820 ? 2'h2 : _T_2810; // @[Mux.scala 98:16]
  wire [1:0] _T_2812 = _T_1818 ? 2'h2 : _T_2811; // @[Mux.scala 98:16]
  wire [1:0] _T_2813 = _T_1816 ? 2'h2 : _T_2812; // @[Mux.scala 98:16]
  wire [1:0] _T_2814 = _T_1814 ? 2'h0 : _T_2813; // @[Mux.scala 98:16]
  wire [1:0] _T_2815 = _T_1812 ? 2'h0 : _T_2814; // @[Mux.scala 98:16]
  wire [1:0] _T_2816 = _T_1810 ? 2'h0 : _T_2815; // @[Mux.scala 98:16]
  wire [1:0] _T_2817 = _T_1808 ? 2'h0 : _T_2816; // @[Mux.scala 98:16]
  wire [1:0] _T_2818 = _T_1806 ? 2'h0 : _T_2817; // @[Mux.scala 98:16]
  wire [1:0] _T_2819 = _T_1804 ? 2'h0 : _T_2818; // @[Mux.scala 98:16]
  wire [1:0] _T_2820 = _T_1802 ? 2'h0 : _T_2819; // @[Mux.scala 98:16]
  wire [1:0] _T_2821 = _T_1800 ? 2'h0 : _T_2820; // @[Mux.scala 98:16]
  wire  _T_2953 = _T_1830 ? 1'h0 : _T_1832 | (_T_1834 | (_T_1836 | (_T_1838 | (_T_1840 | (_T_1842 | (_T_1844 | (_T_1846
     | (_T_1848 | (_T_1850 | (_T_1852 | (_T_1854 | (_T_1856 | (_T_1858 | (_T_1860 | (_T_1862 | (_T_1864 | (_T_1866 | (
    _T_1868 | (_T_1870 | (_T_1872 | (_T_1874 | (_T_1876 | (_T_1878 | _T_1880))))))))))))))))))))))); // @[Mux.scala 98:16]
  wire  _T_2954 = _T_1828 ? 1'h0 : _T_2953; // @[Mux.scala 98:16]
  wire  _T_2955 = _T_1826 ? 1'h0 : _T_2954; // @[Mux.scala 98:16]
  wire  _T_2961 = _T_1814 ? 1'h0 : _T_1816 | (_T_1818 | (_T_1820 | (_T_1822 | (_T_1824 | _T_2955)))); // @[Mux.scala 98:16]
  wire  _T_2962 = _T_1812 ? 1'h0 : _T_2961; // @[Mux.scala 98:16]
  wire  _T_2963 = _T_1810 ? 1'h0 : _T_2962; // @[Mux.scala 98:16]
  wire  _T_2964 = _T_1808 ? 1'h0 : _T_2963; // @[Mux.scala 98:16]
  wire  _T_2965 = _T_1806 ? 1'h0 : _T_2964; // @[Mux.scala 98:16]
  wire  _T_2966 = _T_1804 ? 1'h0 : _T_2965; // @[Mux.scala 98:16]
  wire  id_ctrl_rf_wen = _T_1796 | (_T_1798 | (_T_1800 | (_T_1802 | _T_2966))); // @[Mux.scala 98:16]
  wire  _T_3070 = _T_1890 ? 1'h0 : _T_1892; // @[Mux.scala 98:16]
  wire  _T_3071 = _T_1888 ? 1'h0 : _T_3070; // @[Mux.scala 98:16]
  wire  _T_3072 = _T_1886 ? 1'h0 : _T_3071; // @[Mux.scala 98:16]
  wire  _T_3073 = _T_1884 ? 1'h0 : _T_3072; // @[Mux.scala 98:16]
  wire  _T_3074 = _T_1882 ? 1'h0 : _T_3073; // @[Mux.scala 98:16]
  wire  _T_3075 = _T_1880 ? 1'h0 : _T_3074; // @[Mux.scala 98:16]
  wire  _T_3076 = _T_1878 ? 1'h0 : _T_3075; // @[Mux.scala 98:16]
  wire  _T_3077 = _T_1876 ? 1'h0 : _T_3076; // @[Mux.scala 98:16]
  wire  _T_3078 = _T_1874 ? 1'h0 : _T_3077; // @[Mux.scala 98:16]
  wire  _T_3079 = _T_1872 ? 1'h0 : _T_3078; // @[Mux.scala 98:16]
  wire  _T_3080 = _T_1870 ? 1'h0 : _T_3079; // @[Mux.scala 98:16]
  wire  _T_3081 = _T_1868 ? 1'h0 : _T_3080; // @[Mux.scala 98:16]
  wire  _T_3082 = _T_1866 ? 1'h0 : _T_3081; // @[Mux.scala 98:16]
  wire  _T_3083 = _T_1864 ? 1'h0 : _T_3082; // @[Mux.scala 98:16]
  wire  _T_3084 = _T_1862 ? 1'h0 : _T_3083; // @[Mux.scala 98:16]
  wire  _T_3085 = _T_1860 ? 1'h0 : _T_3084; // @[Mux.scala 98:16]
  wire  _T_3086 = _T_1858 ? 1'h0 : _T_3085; // @[Mux.scala 98:16]
  wire  _T_3087 = _T_1856 ? 1'h0 : _T_3086; // @[Mux.scala 98:16]
  wire  _T_3088 = _T_1854 ? 1'h0 : _T_3087; // @[Mux.scala 98:16]
  wire  _T_3089 = _T_1852 ? 1'h0 : _T_3088; // @[Mux.scala 98:16]
  wire  _T_3090 = _T_1850 ? 1'h0 : _T_3089; // @[Mux.scala 98:16]
  wire  _T_3091 = _T_1848 ? 1'h0 : _T_3090; // @[Mux.scala 98:16]
  wire  _T_3092 = _T_1846 ? 1'h0 : _T_3091; // @[Mux.scala 98:16]
  wire  _T_3093 = _T_1844 ? 1'h0 : _T_3092; // @[Mux.scala 98:16]
  wire  _T_3094 = _T_1842 ? 1'h0 : _T_3093; // @[Mux.scala 98:16]
  wire  _T_3095 = _T_1840 ? 1'h0 : _T_3094; // @[Mux.scala 98:16]
  wire  _T_3096 = _T_1838 ? 1'h0 : _T_3095; // @[Mux.scala 98:16]
  wire  _T_3097 = _T_1836 ? 1'h0 : _T_3096; // @[Mux.scala 98:16]
  wire  _T_3098 = _T_1834 ? 1'h0 : _T_3097; // @[Mux.scala 98:16]
  wire  _T_3099 = _T_1832 ? 1'h0 : _T_3098; // @[Mux.scala 98:16]
  wire  _T_3108 = _T_1814 ? 1'h0 : _T_1816 | (_T_1818 | (_T_1820 | (_T_1822 | (_T_1824 | (_T_1826 | (_T_1828 | (_T_1830
     | _T_3099))))))); // @[Mux.scala 98:16]
  wire  _T_3109 = _T_1812 ? 1'h0 : _T_3108; // @[Mux.scala 98:16]
  wire  _T_3110 = _T_1810 ? 1'h0 : _T_3109; // @[Mux.scala 98:16]
  wire  _T_3111 = _T_1808 ? 1'h0 : _T_3110; // @[Mux.scala 98:16]
  wire  _T_3112 = _T_1806 ? 1'h0 : _T_3111; // @[Mux.scala 98:16]
  wire  _T_3113 = _T_1804 ? 1'h0 : _T_3112; // @[Mux.scala 98:16]
  wire  _T_3114 = _T_1802 ? 1'h0 : _T_3113; // @[Mux.scala 98:16]
  wire  _T_3115 = _T_1800 ? 1'h0 : _T_3114; // @[Mux.scala 98:16]
  wire [1:0] _T_3247 = _T_1830 ? 2'h2 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_3248 = _T_1828 ? 2'h2 : _T_3247; // @[Mux.scala 98:16]
  wire [1:0] _T_3249 = _T_1826 ? 2'h2 : _T_3248; // @[Mux.scala 98:16]
  wire [1:0] _T_3250 = _T_1824 ? 2'h1 : _T_3249; // @[Mux.scala 98:16]
  wire [1:0] _T_3251 = _T_1822 ? 2'h1 : _T_3250; // @[Mux.scala 98:16]
  wire [1:0] _T_3252 = _T_1820 ? 2'h1 : _T_3251; // @[Mux.scala 98:16]
  wire [1:0] _T_3253 = _T_1818 ? 2'h1 : _T_3252; // @[Mux.scala 98:16]
  wire [1:0] _T_3254 = _T_1816 ? 2'h1 : _T_3253; // @[Mux.scala 98:16]
  wire [1:0] _T_3255 = _T_1814 ? 2'h0 : _T_3254; // @[Mux.scala 98:16]
  wire [1:0] _T_3256 = _T_1812 ? 2'h0 : _T_3255; // @[Mux.scala 98:16]
  wire [1:0] _T_3257 = _T_1810 ? 2'h0 : _T_3256; // @[Mux.scala 98:16]
  wire [1:0] _T_3258 = _T_1808 ? 2'h0 : _T_3257; // @[Mux.scala 98:16]
  wire [1:0] _T_3259 = _T_1806 ? 2'h0 : _T_3258; // @[Mux.scala 98:16]
  wire [1:0] _T_3260 = _T_1804 ? 2'h0 : _T_3259; // @[Mux.scala 98:16]
  wire [1:0] _T_3261 = _T_1802 ? 2'h0 : _T_3260; // @[Mux.scala 98:16]
  wire [1:0] _T_3262 = _T_1800 ? 2'h0 : _T_3261; // @[Mux.scala 98:16]
  wire [1:0] _T_3394 = _T_1830 ? 2'h3 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_3395 = _T_1828 ? 2'h2 : _T_3394; // @[Mux.scala 98:16]
  wire [1:0] _T_3396 = _T_1826 ? 2'h1 : _T_3395; // @[Mux.scala 98:16]
  wire [2:0] _T_3397 = _T_1824 ? 3'h6 : {{1'd0}, _T_3396}; // @[Mux.scala 98:16]
  wire [2:0] _T_3398 = _T_1822 ? 3'h5 : _T_3397; // @[Mux.scala 98:16]
  wire [2:0] _T_3399 = _T_1820 ? 3'h3 : _T_3398; // @[Mux.scala 98:16]
  wire [2:0] _T_3400 = _T_1818 ? 3'h2 : _T_3399; // @[Mux.scala 98:16]
  wire [2:0] _T_3401 = _T_1816 ? 3'h1 : _T_3400; // @[Mux.scala 98:16]
  wire [2:0] _T_3402 = _T_1814 ? 3'h0 : _T_3401; // @[Mux.scala 98:16]
  wire [2:0] _T_3403 = _T_1812 ? 3'h0 : _T_3402; // @[Mux.scala 98:16]
  wire [2:0] _T_3404 = _T_1810 ? 3'h0 : _T_3403; // @[Mux.scala 98:16]
  wire [2:0] _T_3405 = _T_1808 ? 3'h0 : _T_3404; // @[Mux.scala 98:16]
  wire [2:0] _T_3406 = _T_1806 ? 3'h0 : _T_3405; // @[Mux.scala 98:16]
  wire [2:0] _T_3407 = _T_1804 ? 3'h0 : _T_3406; // @[Mux.scala 98:16]
  wire [2:0] _T_3408 = _T_1802 ? 3'h0 : _T_3407; // @[Mux.scala 98:16]
  wire [2:0] _T_3409 = _T_1800 ? 3'h0 : _T_3408; // @[Mux.scala 98:16]
  wire [2:0] _T_3512 = _T_1888 ? 3'h4 : 3'h0; // @[Mux.scala 98:16]
  wire [2:0] _T_3513 = _T_1886 ? 3'h4 : _T_3512; // @[Mux.scala 98:16]
  wire [2:0] _T_3514 = _T_1884 ? 3'h4 : _T_3513; // @[Mux.scala 98:16]
  wire [2:0] _T_3515 = _T_1882 ? 3'h4 : _T_3514; // @[Mux.scala 98:16]
  wire [2:0] _T_3516 = _T_1880 ? 3'h3 : _T_3515; // @[Mux.scala 98:16]
  wire [2:0] _T_3517 = _T_1878 ? 3'h2 : _T_3516; // @[Mux.scala 98:16]
  wire [2:0] _T_3518 = _T_1876 ? 3'h1 : _T_3517; // @[Mux.scala 98:16]
  wire [2:0] _T_3519 = _T_1874 ? 3'h3 : _T_3518; // @[Mux.scala 98:16]
  wire [2:0] _T_3520 = _T_1872 ? 3'h2 : _T_3519; // @[Mux.scala 98:16]
  wire [2:0] _T_3521 = _T_1870 ? 3'h1 : _T_3520; // @[Mux.scala 98:16]
  wire [2:0] _T_3522 = _T_1868 ? 3'h0 : _T_3521; // @[Mux.scala 98:16]
  wire [2:0] _T_3523 = _T_1866 ? 3'h0 : _T_3522; // @[Mux.scala 98:16]
  wire [2:0] _T_3524 = _T_1864 ? 3'h0 : _T_3523; // @[Mux.scala 98:16]
  wire [2:0] _T_3525 = _T_1862 ? 3'h0 : _T_3524; // @[Mux.scala 98:16]
  wire [2:0] _T_3526 = _T_1860 ? 3'h0 : _T_3525; // @[Mux.scala 98:16]
  wire [2:0] _T_3527 = _T_1858 ? 3'h0 : _T_3526; // @[Mux.scala 98:16]
  wire [2:0] _T_3528 = _T_1856 ? 3'h0 : _T_3527; // @[Mux.scala 98:16]
  wire [2:0] _T_3529 = _T_1854 ? 3'h0 : _T_3528; // @[Mux.scala 98:16]
  wire [2:0] _T_3530 = _T_1852 ? 3'h0 : _T_3529; // @[Mux.scala 98:16]
  wire [2:0] _T_3531 = _T_1850 ? 3'h0 : _T_3530; // @[Mux.scala 98:16]
  wire [2:0] _T_3532 = _T_1848 ? 3'h0 : _T_3531; // @[Mux.scala 98:16]
  wire [2:0] _T_3533 = _T_1846 ? 3'h0 : _T_3532; // @[Mux.scala 98:16]
  wire [2:0] _T_3534 = _T_1844 ? 3'h0 : _T_3533; // @[Mux.scala 98:16]
  wire [2:0] _T_3535 = _T_1842 ? 3'h0 : _T_3534; // @[Mux.scala 98:16]
  wire [2:0] _T_3536 = _T_1840 ? 3'h0 : _T_3535; // @[Mux.scala 98:16]
  wire [2:0] _T_3537 = _T_1838 ? 3'h0 : _T_3536; // @[Mux.scala 98:16]
  wire [2:0] _T_3538 = _T_1836 ? 3'h0 : _T_3537; // @[Mux.scala 98:16]
  wire [2:0] _T_3539 = _T_1834 ? 3'h0 : _T_3538; // @[Mux.scala 98:16]
  wire [2:0] _T_3540 = _T_1832 ? 3'h0 : _T_3539; // @[Mux.scala 98:16]
  wire [2:0] _T_3541 = _T_1830 ? 3'h0 : _T_3540; // @[Mux.scala 98:16]
  wire [2:0] _T_3542 = _T_1828 ? 3'h0 : _T_3541; // @[Mux.scala 98:16]
  wire [2:0] _T_3543 = _T_1826 ? 3'h0 : _T_3542; // @[Mux.scala 98:16]
  wire [2:0] _T_3544 = _T_1824 ? 3'h0 : _T_3543; // @[Mux.scala 98:16]
  wire [2:0] _T_3545 = _T_1822 ? 3'h0 : _T_3544; // @[Mux.scala 98:16]
  wire [2:0] _T_3546 = _T_1820 ? 3'h0 : _T_3545; // @[Mux.scala 98:16]
  wire [2:0] _T_3547 = _T_1818 ? 3'h0 : _T_3546; // @[Mux.scala 98:16]
  wire [2:0] _T_3548 = _T_1816 ? 3'h0 : _T_3547; // @[Mux.scala 98:16]
  wire [2:0] _T_3549 = _T_1814 ? 3'h0 : _T_3548; // @[Mux.scala 98:16]
  wire [2:0] _T_3550 = _T_1812 ? 3'h0 : _T_3549; // @[Mux.scala 98:16]
  wire [2:0] _T_3551 = _T_1810 ? 3'h0 : _T_3550; // @[Mux.scala 98:16]
  wire [2:0] _T_3552 = _T_1808 ? 3'h0 : _T_3551; // @[Mux.scala 98:16]
  wire [2:0] _T_3553 = _T_1806 ? 3'h0 : _T_3552; // @[Mux.scala 98:16]
  wire [2:0] _T_3554 = _T_1804 ? 3'h0 : _T_3553; // @[Mux.scala 98:16]
  wire [2:0] _T_3555 = _T_1802 ? 3'h0 : _T_3554; // @[Mux.scala 98:16]
  wire [2:0] _T_3556 = _T_1800 ? 3'h0 : _T_3555; // @[Mux.scala 98:16]
  wire [2:0] _T_3557 = _T_1798 ? 3'h0 : _T_3556; // @[Mux.scala 98:16]
  wire [2:0] id_ctrl_csr_cmd = _T_1796 ? 3'h0 : _T_3557; // @[Mux.scala 98:16]
  reg [31:0] rv32i_reg_0; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_1; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_2; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_3; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_4; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_5; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_6; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_7; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_8; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_9; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_10; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_11; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_12; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_13; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_14; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_15; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_16; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_17; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_18; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_19; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_20; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_21; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_22; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_23; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_24; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_25; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_26; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_27; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_28; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_29; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_30; // @[core.scala 192:39]
  reg [31:0] rv32i_reg_31; // @[core.scala 192:39]
  wire [31:0] _GEN_35 = 5'h1 == idm_io_inst_rs1 ? rv32i_reg_1 : rv32i_reg_0; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_36 = 5'h2 == idm_io_inst_rs1 ? rv32i_reg_2 : _GEN_35; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_37 = 5'h3 == idm_io_inst_rs1 ? rv32i_reg_3 : _GEN_36; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_38 = 5'h4 == idm_io_inst_rs1 ? rv32i_reg_4 : _GEN_37; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_39 = 5'h5 == idm_io_inst_rs1 ? rv32i_reg_5 : _GEN_38; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_40 = 5'h6 == idm_io_inst_rs1 ? rv32i_reg_6 : _GEN_39; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_41 = 5'h7 == idm_io_inst_rs1 ? rv32i_reg_7 : _GEN_40; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_42 = 5'h8 == idm_io_inst_rs1 ? rv32i_reg_8 : _GEN_41; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_43 = 5'h9 == idm_io_inst_rs1 ? rv32i_reg_9 : _GEN_42; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_44 = 5'ha == idm_io_inst_rs1 ? rv32i_reg_10 : _GEN_43; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_45 = 5'hb == idm_io_inst_rs1 ? rv32i_reg_11 : _GEN_44; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_46 = 5'hc == idm_io_inst_rs1 ? rv32i_reg_12 : _GEN_45; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_47 = 5'hd == idm_io_inst_rs1 ? rv32i_reg_13 : _GEN_46; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_48 = 5'he == idm_io_inst_rs1 ? rv32i_reg_14 : _GEN_47; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_49 = 5'hf == idm_io_inst_rs1 ? rv32i_reg_15 : _GEN_48; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_50 = 5'h10 == idm_io_inst_rs1 ? rv32i_reg_16 : _GEN_49; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_51 = 5'h11 == idm_io_inst_rs1 ? rv32i_reg_17 : _GEN_50; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_52 = 5'h12 == idm_io_inst_rs1 ? rv32i_reg_18 : _GEN_51; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_53 = 5'h13 == idm_io_inst_rs1 ? rv32i_reg_19 : _GEN_52; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_54 = 5'h14 == idm_io_inst_rs1 ? rv32i_reg_20 : _GEN_53; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_55 = 5'h15 == idm_io_inst_rs1 ? rv32i_reg_21 : _GEN_54; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_56 = 5'h16 == idm_io_inst_rs1 ? rv32i_reg_22 : _GEN_55; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_57 = 5'h17 == idm_io_inst_rs1 ? rv32i_reg_23 : _GEN_56; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_58 = 5'h18 == idm_io_inst_rs1 ? rv32i_reg_24 : _GEN_57; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_59 = 5'h19 == idm_io_inst_rs1 ? rv32i_reg_25 : _GEN_58; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_60 = 5'h1a == idm_io_inst_rs1 ? rv32i_reg_26 : _GEN_59; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_61 = 5'h1b == idm_io_inst_rs1 ? rv32i_reg_27 : _GEN_60; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_62 = 5'h1c == idm_io_inst_rs1 ? rv32i_reg_28 : _GEN_61; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_63 = 5'h1d == idm_io_inst_rs1 ? rv32i_reg_29 : _GEN_62; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_64 = 5'h1e == idm_io_inst_rs1 ? rv32i_reg_30 : _GEN_63; // @[core.scala 193:27 core.scala 193:27]
  wire [31:0] _GEN_67 = 5'h1 == idm_io_inst_rs2 ? rv32i_reg_1 : rv32i_reg_0; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_68 = 5'h2 == idm_io_inst_rs2 ? rv32i_reg_2 : _GEN_67; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_69 = 5'h3 == idm_io_inst_rs2 ? rv32i_reg_3 : _GEN_68; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_70 = 5'h4 == idm_io_inst_rs2 ? rv32i_reg_4 : _GEN_69; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_71 = 5'h5 == idm_io_inst_rs2 ? rv32i_reg_5 : _GEN_70; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_72 = 5'h6 == idm_io_inst_rs2 ? rv32i_reg_6 : _GEN_71; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_73 = 5'h7 == idm_io_inst_rs2 ? rv32i_reg_7 : _GEN_72; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_74 = 5'h8 == idm_io_inst_rs2 ? rv32i_reg_8 : _GEN_73; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_75 = 5'h9 == idm_io_inst_rs2 ? rv32i_reg_9 : _GEN_74; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_76 = 5'ha == idm_io_inst_rs2 ? rv32i_reg_10 : _GEN_75; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_77 = 5'hb == idm_io_inst_rs2 ? rv32i_reg_11 : _GEN_76; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_78 = 5'hc == idm_io_inst_rs2 ? rv32i_reg_12 : _GEN_77; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_79 = 5'hd == idm_io_inst_rs2 ? rv32i_reg_13 : _GEN_78; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_80 = 5'he == idm_io_inst_rs2 ? rv32i_reg_14 : _GEN_79; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_81 = 5'hf == idm_io_inst_rs2 ? rv32i_reg_15 : _GEN_80; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_82 = 5'h10 == idm_io_inst_rs2 ? rv32i_reg_16 : _GEN_81; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_83 = 5'h11 == idm_io_inst_rs2 ? rv32i_reg_17 : _GEN_82; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_84 = 5'h12 == idm_io_inst_rs2 ? rv32i_reg_18 : _GEN_83; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_85 = 5'h13 == idm_io_inst_rs2 ? rv32i_reg_19 : _GEN_84; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_86 = 5'h14 == idm_io_inst_rs2 ? rv32i_reg_20 : _GEN_85; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_87 = 5'h15 == idm_io_inst_rs2 ? rv32i_reg_21 : _GEN_86; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_88 = 5'h16 == idm_io_inst_rs2 ? rv32i_reg_22 : _GEN_87; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_89 = 5'h17 == idm_io_inst_rs2 ? rv32i_reg_23 : _GEN_88; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_90 = 5'h18 == idm_io_inst_rs2 ? rv32i_reg_24 : _GEN_89; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_91 = 5'h19 == idm_io_inst_rs2 ? rv32i_reg_25 : _GEN_90; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_92 = 5'h1a == idm_io_inst_rs2 ? rv32i_reg_26 : _GEN_91; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_93 = 5'h1b == idm_io_inst_rs2 ? rv32i_reg_27 : _GEN_92; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_94 = 5'h1c == idm_io_inst_rs2 ? rv32i_reg_28 : _GEN_93; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_95 = 5'h1d == idm_io_inst_rs2 ? rv32i_reg_29 : _GEN_94; // @[core.scala 194:27 core.scala 194:27]
  wire [31:0] _GEN_96 = 5'h1e == idm_io_inst_rs2 ? rv32i_reg_30 : _GEN_95; // @[core.scala 194:27 core.scala 194:27]
  reg  interrupt_sig; // @[core.scala 201:38]
  wire  _GEN_104 = (stall | inst_kill) & _T_1772 | ex_ctrl_rf_wen; // @[core.scala 232:54 core.scala 235:17 core.scala 46:39]
  wire  _GEN_111 = (stall | inst_kill) & _T_1772 | ex_ctrl_legal; // @[core.scala 232:54 core.scala 235:17 core.scala 46:39]
  wire  _GEN_128 = _T_1773 ? id_ctrl_rf_wen : _GEN_104; // @[core.scala 218:48 core.scala 221:17]
  wire  _GEN_135 = _T_1773 ? id_ctrl_legal : _GEN_111; // @[core.scala 218:48 core.scala 221:17]
  wire  _T_3570 = ex_ctrl_imm_type == 3'h5; // @[control.scala 198:28]
  wire  _T_3572 = ex_inst[31]; // @[control.scala 198:53]
  wire  _T_3573 = ex_ctrl_imm_type == 3'h5 ? $signed(1'sh0) : $signed(_T_3572); // @[control.scala 198:23]
  wire  _T_3574 = ex_ctrl_imm_type == 3'h3; // @[control.scala 199:30]
  wire [10:0] _T_3576 = ex_inst[30:20]; // @[control.scala 199:53]
  wire [7:0] _T_3582 = ex_inst[19:12]; // @[control.scala 200:76]
  wire  _T_3586 = _T_3574 | _T_3570; // @[control.scala 201:37]
  wire  _T_3589 = ex_inst[20]; // @[control.scala 202:41]
  wire  _T_3590 = ex_ctrl_imm_type == 3'h2; // @[control.scala 203:25]
  wire  _T_3592 = ex_inst[7]; // @[control.scala 203:44]
  wire  _T_3593 = ex_ctrl_imm_type == 3'h2 ? $signed(_T_3592) : $signed(_T_3573); // @[control.scala 203:20]
  wire  _T_3594 = ex_ctrl_imm_type == 3'h4 ? $signed(_T_3589) : $signed(_T_3593); // @[control.scala 202:16]
  wire [5:0] left_right_right = _T_3586 ? 6'h0 : ex_inst[30:25]; // @[control.scala 204:24]
  wire  _T_3601 = ex_ctrl_imm_type == 3'h1; // @[control.scala 206:21]
  wire [3:0] _T_3608 = _T_3570 ? ex_inst[19:16] : ex_inst[24:21]; // @[control.scala 207:20]
  wire [3:0] _T_3609 = ex_ctrl_imm_type == 3'h1 | _T_3590 ? ex_inst[11:8] : _T_3608; // @[control.scala 206:16]
  wire [3:0] left_right_left = _T_3574 ? 4'h0 : _T_3609; // @[control.scala 205:23]
  wire  _T_3616 = _T_3570 & ex_inst[15]; // @[control.scala 210:20]
  wire  _T_3617 = ex_ctrl_imm_type == 3'h0 ? ex_inst[20] : _T_3616; // @[control.scala 209:16]
  wire  left_left = _T_3601 ? ex_inst[7] : _T_3617; // @[control.scala 208:21]
  wire  right_left_left = _T_3574 | _T_3570 ? $signed(1'sh0) : $signed(_T_3594); // @[Cat.scala 29:58]
  wire [7:0] right_left_right = ex_ctrl_imm_type != 3'h3 & ex_ctrl_imm_type != 3'h4 ? $signed({8{_T_3573}}) : $signed(
    _T_3582); // @[Cat.scala 29:58]
  wire [10:0] right_right_left = ex_ctrl_imm_type == 3'h3 ? $signed(_T_3576) : $signed({11{_T_3573}}); // @[Cat.scala 29:58]
  wire  right_right_right = ex_ctrl_imm_type == 3'h5 ? $signed(1'sh0) : $signed(_T_3572); // @[Cat.scala 29:58]
  wire [31:0] ex_imm = {right_right_right,right_right_left,right_left_right,right_left_left,left_right_right,
    left_right_left,left_left}; // @[control.scala 212:57]
  wire  _ex_reg_rs1_bypass_T = ex_reg_raddr_0 != 5'h0; // @[core.scala 255:26]
  wire  _ex_reg_rs1_bypass_T_1 = ex_reg_raddr_0 == mem_reg_waddr; // @[core.scala 255:53]
  wire  _ex_reg_rs1_bypass_T_2 = ex_reg_raddr_0 != 5'h0 & ex_reg_raddr_0 == mem_reg_waddr; // @[core.scala 255:34]
  wire  _ex_reg_rs1_bypass_T_3 = mem_ctrl_csr_cmd != 3'h0; // @[core.scala 255:91]
  wire  _ex_reg_rs1_bypass_T_4 = ex_reg_raddr_0 != 5'h0 & ex_reg_raddr_0 == mem_reg_waddr & mem_ctrl_csr_cmd != 3'h0; // @[core.scala 255:71]
  wire  _ex_reg_rs1_bypass_T_9 = _ex_reg_rs1_bypass_T_2 & mem_ctrl_rf_wen; // @[core.scala 256:71]
  wire  _ex_reg_rs1_bypass_T_11 = ex_reg_raddr_0 == rf_waddr; // @[core.scala 257:53]
  wire  _ex_reg_rs1_bypass_T_12 = _ex_reg_rs1_bypass_T & ex_reg_raddr_0 == rf_waddr; // @[core.scala 257:34]
  wire  _ex_reg_rs1_bypass_T_14 = _ex_reg_rs1_bypass_T & ex_reg_raddr_0 == rf_waddr & wb_ctrl_rf_wen; // @[core.scala 257:70]
  wire  _ex_reg_rs1_bypass_T_17 = wb_ctrl_csr_cmd == 3'h0; // @[core.scala 257:145]
  wire  _ex_reg_rs1_bypass_T_18 = _ex_reg_rs1_bypass_T & ex_reg_raddr_0 == rf_waddr & wb_ctrl_rf_wen & wb_ctrl_mem_en &
    wb_ctrl_csr_cmd == 3'h0; // @[core.scala 257:126]
  wire  _ex_reg_rs1_bypass_T_24 = ~wb_ctrl_mem_en; // @[core.scala 258:116]
  wire  _ex_reg_rs1_bypass_T_27 = _ex_reg_rs1_bypass_T_14 & ~wb_ctrl_mem_en & _ex_reg_rs1_bypass_T_17; // @[core.scala 258:126]
  wire  _ex_reg_rs1_bypass_T_31 = ~ex_ctrl_rf_wen; // @[core.scala 259:88]
  wire  _ex_reg_rs1_bypass_T_34 = _ex_reg_rs1_bypass_T_12 & ~ex_ctrl_rf_wen & ex_ctrl_mem_en; // @[core.scala 259:98]
  wire  _ex_reg_rs1_bypass_T_40 = wb_ctrl_csr_cmd != 3'h0; // @[core.scala 260:117]
  wire  _ex_reg_rs1_bypass_T_41 = _ex_reg_rs1_bypass_T_14 & wb_ctrl_csr_cmd != 3'h0; // @[core.scala 260:98]
  wire [31:0] _ex_reg_rs1_bypass_T_42 = _ex_reg_rs1_bypass_T_41 ? wb_csr_data : ex_rs_0; // @[Mux.scala 98:16]
  wire [31:0] _ex_reg_rs1_bypass_T_43 = _ex_reg_rs1_bypass_T_34 ? wb_alu_out : _ex_reg_rs1_bypass_T_42; // @[Mux.scala 98:16]
  wire [31:0] _ex_reg_rs1_bypass_T_44 = _ex_reg_rs1_bypass_T_27 ? wb_alu_out : _ex_reg_rs1_bypass_T_43; // @[Mux.scala 98:16]
  wire [31:0] _ex_reg_rs1_bypass_T_45 = _ex_reg_rs1_bypass_T_18 ? io_r_dmem_dat_data : _ex_reg_rs1_bypass_T_44; // @[Mux.scala 98:16]
  wire [31:0] _ex_reg_rs1_bypass_T_46 = _ex_reg_rs1_bypass_T_9 ? mem_alu_out : _ex_reg_rs1_bypass_T_45; // @[Mux.scala 98:16]
  wire [31:0] ex_reg_rs1_bypass = _ex_reg_rs1_bypass_T_4 ? mem_csr_data : _ex_reg_rs1_bypass_T_46; // @[Mux.scala 98:16]
  wire  _ex_reg_rs2_bypass_T = ex_reg_raddr_1 != 5'h0; // @[core.scala 263:26]
  wire  _ex_reg_rs2_bypass_T_2 = ex_reg_raddr_1 != 5'h0 & ex_reg_raddr_1 == mem_reg_waddr; // @[core.scala 263:34]
  wire  _ex_reg_rs2_bypass_T_4 = ex_reg_raddr_1 != 5'h0 & ex_reg_raddr_1 == mem_reg_waddr & _ex_reg_rs1_bypass_T_3; // @[core.scala 263:71]
  wire  _ex_reg_rs2_bypass_T_9 = _ex_reg_rs2_bypass_T_2 & mem_ctrl_rf_wen; // @[core.scala 264:71]
  wire  _ex_reg_rs2_bypass_T_12 = _ex_reg_rs2_bypass_T & ex_reg_raddr_1 == rf_waddr; // @[core.scala 265:34]
  wire  _ex_reg_rs2_bypass_T_14 = _ex_reg_rs2_bypass_T & ex_reg_raddr_1 == rf_waddr & wb_ctrl_rf_wen; // @[core.scala 265:70]
  wire  _ex_reg_rs2_bypass_T_18 = _ex_reg_rs2_bypass_T & ex_reg_raddr_1 == rf_waddr & wb_ctrl_rf_wen & wb_ctrl_mem_en &
    _ex_reg_rs1_bypass_T_17; // @[core.scala 265:126]
  wire  _ex_reg_rs2_bypass_T_27 = _ex_reg_rs2_bypass_T_14 & _ex_reg_rs1_bypass_T_24 & _ex_reg_rs1_bypass_T_17; // @[core.scala 266:126]
  wire  _ex_reg_rs2_bypass_T_34 = _ex_reg_rs2_bypass_T_12 & _ex_reg_rs1_bypass_T_31 & ex_ctrl_mem_en; // @[core.scala 267:98]
  wire  _ex_reg_rs2_bypass_T_41 = _ex_reg_rs2_bypass_T_14 & _ex_reg_rs1_bypass_T_40; // @[core.scala 268:98]
  wire [31:0] _ex_reg_rs2_bypass_T_42 = _ex_reg_rs2_bypass_T_41 ? wb_csr_data : ex_rs_1; // @[Mux.scala 98:16]
  wire [31:0] _ex_reg_rs2_bypass_T_43 = _ex_reg_rs2_bypass_T_34 ? wb_alu_out : _ex_reg_rs2_bypass_T_42; // @[Mux.scala 98:16]
  wire [31:0] _ex_reg_rs2_bypass_T_44 = _ex_reg_rs2_bypass_T_27 ? wb_alu_out : _ex_reg_rs2_bypass_T_43; // @[Mux.scala 98:16]
  wire [31:0] _ex_reg_rs2_bypass_T_45 = _ex_reg_rs2_bypass_T_18 ? io_r_dmem_dat_data : _ex_reg_rs2_bypass_T_44; // @[Mux.scala 98:16]
  wire [31:0] _ex_reg_rs2_bypass_T_46 = _ex_reg_rs2_bypass_T_9 ? mem_alu_out : _ex_reg_rs2_bypass_T_45; // @[Mux.scala 98:16]
  wire [31:0] ex_reg_rs2_bypass = _ex_reg_rs2_bypass_T_4 ? mem_csr_data : _ex_reg_rs2_bypass_T_46; // @[Mux.scala 98:16]
  wire  _ex_op1_T = ex_ctrl_alu_op1 == 2'h1; // @[core.scala 273:26]
  wire  _ex_op1_T_1 = ex_ctrl_alu_op1 == 2'h2; // @[core.scala 274:26]
  wire [31:0] _ex_op1_T_4 = _ex_op1_T_1 ? ex_pc : 32'h0; // @[Mux.scala 98:16]
  wire  _ex_op2_T = ex_ctrl_alu_op2 == 2'h1; // @[core.scala 279:26]
  wire  _ex_op2_T_1 = ex_ctrl_alu_op2 == 2'h2; // @[core.scala 280:26]
  wire [31:0] _ex_op2_T_2 = {right_right_right,right_right_left,right_left_right,right_left_left,left_right_right,
    left_right_left,left_left}; // @[core.scala 280:49]
  wire [31:0] _ex_op2_T_5 = _ex_op2_T_1 ? _ex_op2_T_2 : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _T_3623 = _ex_reg_rs1_bypass_T_3 ? mem_csr_data : mem_alu_out; // @[core.scala 292:51]
  wire [31:0] _T_3626 = _ex_reg_rs1_bypass_T_40 ? wb_csr_data : wb_alu_out; // @[core.scala 293:54]
  wire [31:0] _T_3627 = _ex_reg_rs1_bypass_T_11 ? _T_3626 : ex_reg_rs1_bypass; // @[core.scala 293:16]
  wire [31:0] _T_3628 = _ex_reg_rs1_bypass_T_1 ? _T_3623 : _T_3627; // @[core.scala 292:12]
  wire  _GEN_152 = _T_1775 | mem_ctrl_rf_wen; // @[core.scala 340:43 core.scala 343:18 core.scala 58:40]
  wire  _GEN_174 = _stall_T_7 & _T_1772 ? ex_ctrl_rf_wen : _GEN_152; // @[core.scala 327:38 core.scala 330:18]
  wire  _T_3634 = ~io_sw_halt; // @[core.scala 357:21]
  wire  _io_w_dmem_dat_req_T = mem_ctrl_mem_wr == 2'h2; // @[core.scala 360:47]
  wire  _T_3638 = 2'h0 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire  _T_3639 = 2'h1 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [39:0] _GEN_386 = {mem_rs_1, 8'h0}; // @[core.scala 387:53]
  wire [46:0] _io_w_dmem_dat_data_T = {{7'd0}, _GEN_386}; // @[core.scala 387:53]
  wire  _T_3640 = 2'h2 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [47:0] _GEN_387 = {mem_rs_1, 16'h0}; // @[core.scala 391:53]
  wire [62:0] _io_w_dmem_dat_data_T_1 = {{15'd0}, _GEN_387}; // @[core.scala 391:53]
  wire  _T_3641 = 2'h3 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [55:0] _GEN_388 = {mem_rs_1, 24'h0}; // @[core.scala 395:53]
  wire [62:0] _io_w_dmem_dat_data_T_2 = {{7'd0}, _GEN_388}; // @[core.scala 395:53]
  wire [62:0] _GEN_195 = _T_3641 ? _io_w_dmem_dat_data_T_2 : {{31'd0}, io_sw_w_dat}; // @[Conditional.scala 39:67 core.scala 395:40]
  wire [3:0] _GEN_196 = _T_3640 ? 4'h4 : 4'h8; // @[Conditional.scala 39:67 core.scala 390:46]
  wire [62:0] _GEN_197 = _T_3640 ? _io_w_dmem_dat_data_T_1 : _GEN_195; // @[Conditional.scala 39:67 core.scala 391:40]
  wire [3:0] _GEN_198 = _T_3639 ? 4'h2 : _GEN_196; // @[Conditional.scala 39:67 core.scala 386:46]
  wire [62:0] _GEN_199 = _T_3639 ? {{16'd0}, _io_w_dmem_dat_data_T} : _GEN_197; // @[Conditional.scala 39:67 core.scala 387:40]
  wire [3:0] _GEN_200 = _T_3638 ? 4'h1 : _GEN_198; // @[Conditional.scala 40:58 core.scala 382:46]
  wire [62:0] _GEN_201 = _T_3638 ? {{31'd0}, mem_rs_1} : _GEN_199; // @[Conditional.scala 40:58 core.scala 383:40]
  wire [62:0] _GEN_203 = _T_3640 ? _io_w_dmem_dat_data_T_1 : {{31'd0}, io_sw_w_dat}; // @[Conditional.scala 39:67 core.scala 406:40]
  wire [3:0] _GEN_204 = _T_3638 ? 4'h3 : 4'hc; // @[Conditional.scala 40:58 core.scala 401:46]
  wire [62:0] _GEN_205 = _T_3638 ? {{31'd0}, mem_rs_1} : _GEN_203; // @[Conditional.scala 40:58 core.scala 402:40]
  wire [3:0] _GEN_206 = mem_ctrl_mask_type == 3'h2 ? _GEN_204 : 4'hf; // @[core.scala 398:49 core.scala 410:38]
  wire [62:0] _GEN_207 = mem_ctrl_mask_type == 3'h2 ? _GEN_205 : {{31'd0}, mem_rs_1}; // @[core.scala 398:49 core.scala 411:32]
  wire [3:0] _GEN_208 = mem_ctrl_mask_type == 3'h1 ? _GEN_200 : _GEN_206; // @[core.scala 379:43]
  wire [62:0] _GEN_209 = mem_ctrl_mask_type == 3'h1 ? _GEN_201 : _GEN_207; // @[core.scala 379:43]
  wire [62:0] _GEN_211 = _io_w_dmem_dat_req_T ? _GEN_209 : {{31'd0}, io_sw_w_dat}; // @[core.scala 378:37]
  wire  _GEN_217 = _T_1772 ? mem_ctrl_rf_wen : wb_ctrl_rf_wen; // @[core.scala 428:24 core.scala 430:17 core.scala 69:39]
  wire  _T_3650 = 2'h0 == wb_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [23:0] dmem_data_right = io_r_dmem_dat_data[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] dmem_data_left = io_r_dmem_dat_data[7:0]; // @[core.scala 444:89]
  wire [31:0] _dmem_data_T_2 = {dmem_data_right,dmem_data_left}; // @[Cat.scala 29:58]
  wire  _T_3651 = 2'h1 == wb_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [23:0] dmem_data_right_1 = io_r_dmem_dat_data[15] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] dmem_data_left_1 = io_r_dmem_dat_data[15:8]; // @[core.scala 447:90]
  wire [31:0] _dmem_data_T_5 = {dmem_data_right_1,dmem_data_left_1}; // @[Cat.scala 29:58]
  wire  _T_3652 = 2'h2 == wb_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [23:0] dmem_data_right_2 = io_r_dmem_dat_data[23] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] dmem_data_left_2 = io_r_dmem_dat_data[23:16]; // @[core.scala 450:90]
  wire [31:0] _dmem_data_T_8 = {dmem_data_right_2,dmem_data_left_2}; // @[Cat.scala 29:58]
  wire [23:0] dmem_data_right_3 = io_r_dmem_dat_data[31] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] dmem_data_left_3 = io_r_dmem_dat_data[31:24]; // @[core.scala 453:90]
  wire [31:0] _dmem_data_T_11 = {dmem_data_right_3,dmem_data_left_3}; // @[Cat.scala 29:58]
  wire [31:0] _GEN_231 = _T_3652 ? _dmem_data_T_8 : _dmem_data_T_11; // @[Conditional.scala 39:67 core.scala 450:31]
  wire [31:0] _GEN_232 = _T_3651 ? _dmem_data_T_5 : _GEN_231; // @[Conditional.scala 39:67 core.scala 447:31]
  wire [31:0] _GEN_233 = _T_3650 ? _dmem_data_T_2 : _GEN_232; // @[Conditional.scala 40:58 core.scala 444:31]
  wire [31:0] _dmem_data_T_12 = {24'h0,dmem_data_left}; // @[Cat.scala 29:58]
  wire [31:0] _dmem_data_T_13 = {24'h0,dmem_data_left_1}; // @[Cat.scala 29:58]
  wire [31:0] _dmem_data_T_14 = {24'h0,dmem_data_left_2}; // @[Cat.scala 29:58]
  wire [31:0] _dmem_data_T_15 = {24'h0,dmem_data_left_3}; // @[Cat.scala 29:58]
  wire [31:0] _GEN_235 = _T_3652 ? _dmem_data_T_14 : _dmem_data_T_15; // @[Conditional.scala 39:67 core.scala 465:31]
  wire [31:0] _GEN_236 = _T_3651 ? _dmem_data_T_13 : _GEN_235; // @[Conditional.scala 39:67 core.scala 462:31]
  wire [31:0] _GEN_237 = _T_3650 ? _dmem_data_T_12 : _GEN_236; // @[Conditional.scala 40:58 core.scala 459:31]
  wire [15:0] dmem_data_right_4 = io_r_dmem_dat_data[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 72:12]
  wire [15:0] dmem_data_left_8 = io_r_dmem_dat_data[15:0]; // @[core.scala 474:90]
  wire [31:0] _dmem_data_T_18 = {dmem_data_right_4,dmem_data_left_8}; // @[Cat.scala 29:58]
  wire [15:0] dmem_data_right_5 = io_r_dmem_dat_data[31] ? 16'hffff : 16'h0; // @[Bitwise.scala 72:12]
  wire [15:0] dmem_data_left_9 = io_r_dmem_dat_data[31:16]; // @[core.scala 477:90]
  wire [31:0] _dmem_data_T_21 = {dmem_data_right_5,dmem_data_left_9}; // @[Cat.scala 29:58]
  wire [31:0] _GEN_240 = _T_3652 ? _dmem_data_T_21 : 32'h0; // @[Conditional.scala 39:67 core.scala 477:31]
  wire [31:0] _GEN_241 = _T_3650 ? _dmem_data_T_18 : _GEN_240; // @[Conditional.scala 40:58 core.scala 474:31]
  wire [31:0] _dmem_data_T_22 = {16'h0,dmem_data_left_8}; // @[Cat.scala 29:58]
  wire [31:0] _dmem_data_T_23 = {16'h0,dmem_data_left_9}; // @[Cat.scala 29:58]
  wire [31:0] _GEN_244 = _T_3652 ? _dmem_data_T_23 : 32'h0; // @[Conditional.scala 39:67 core.scala 493:31]
  wire [31:0] _GEN_245 = _T_3650 ? _dmem_data_T_22 : _GEN_244; // @[Conditional.scala 40:58 core.scala 490:31]
  wire [31:0] _GEN_246 = wb_ctrl_mask_type == 3'h6 ? _GEN_245 : io_r_dmem_dat_data; // @[core.scala 487:49 core.scala 504:23]
  wire [31:0] _GEN_247 = wb_ctrl_mask_type == 3'h2 ? _GEN_241 : _GEN_246; // @[core.scala 471:48]
  wire [31:0] _GEN_248 = wb_ctrl_mask_type == 3'h5 ? _GEN_237 : _GEN_247; // @[core.scala 456:49]
  wire [31:0] _GEN_249 = wb_ctrl_mask_type == 3'h1 ? _GEN_233 : _GEN_248; // @[core.scala 441:42]
  wire [31:0] dmem_data = wb_ctrl_mem_wr == 2'h1 ? _GEN_249 : io_r_dmem_dat_data; // @[core.scala 440:36 core.scala 507:19]
  wire  _T_3672 = wb_ctrl_wb_sel == 2'h1; // @[core.scala 513:25]
  wire  _T_3673 = wb_ctrl_wb_sel == 2'h0; // @[core.scala 514:25]
  wire  _T_3674 = wb_ctrl_wb_sel == 2'h3; // @[core.scala 515:25]
  wire  _T_3675 = wb_ctrl_wb_sel == 2'h2; // @[core.scala 516:25]
  wire [31:0] _T_3676 = _T_3675 ? dmem_data : wb_alu_out; // @[Mux.scala 98:16]
  wire [31:0] _T_3677 = _T_3674 ? wb_csr_data : _T_3676; // @[Mux.scala 98:16]
  wire [31:0] _T_3678 = _T_3673 ? wb_npc : _T_3677; // @[Mux.scala 98:16]
  wire [31:0] rf_wdata = _T_3672 ? wb_alu_out : _T_3678; // @[Mux.scala 98:16]
  wire [31:0] _pc_cntr_T_5 = mem_pc + mem_imm; // @[core.scala 539:81]
  wire [31:0] _pc_cntr_T_8 = _inst_kill_branch_T_2 ? mem_alu_out : npc; // @[core.scala 541:36]
  wire [31:0] _pc_cntr_T_9 = _inst_kill_branch_T_4 ? mem_alu_out : _pc_cntr_T_8; // @[core.scala 540:32]
  wire [31:0] _pc_cntr_T_10 = _inst_kill_branch_T_1 ? _pc_cntr_T_5 : _pc_cntr_T_9; // @[core.scala 539:28]
  wire [31:0] _pc_cntr_T_11 = _inst_kill_branch_T_6 ? csr_io_epc : _pc_cntr_T_10; // @[core.scala 538:24]
  wire  _GEN_348 = _T_3634 ? 1'h0 : 1'h1; // @[core.scala 534:38 core.scala 535:19 core.scala 548:19]
  wire [31:0] _GEN_354 = 5'h1 == io_sw_g_add[4:0] ? rv32i_reg_1 : rv32i_reg_0; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_355 = 5'h2 == io_sw_g_add[4:0] ? rv32i_reg_2 : _GEN_354; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_356 = 5'h3 == io_sw_g_add[4:0] ? rv32i_reg_3 : _GEN_355; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_357 = 5'h4 == io_sw_g_add[4:0] ? rv32i_reg_4 : _GEN_356; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_358 = 5'h5 == io_sw_g_add[4:0] ? rv32i_reg_5 : _GEN_357; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_359 = 5'h6 == io_sw_g_add[4:0] ? rv32i_reg_6 : _GEN_358; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_360 = 5'h7 == io_sw_g_add[4:0] ? rv32i_reg_7 : _GEN_359; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_361 = 5'h8 == io_sw_g_add[4:0] ? rv32i_reg_8 : _GEN_360; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_362 = 5'h9 == io_sw_g_add[4:0] ? rv32i_reg_9 : _GEN_361; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_363 = 5'ha == io_sw_g_add[4:0] ? rv32i_reg_10 : _GEN_362; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_364 = 5'hb == io_sw_g_add[4:0] ? rv32i_reg_11 : _GEN_363; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_365 = 5'hc == io_sw_g_add[4:0] ? rv32i_reg_12 : _GEN_364; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_366 = 5'hd == io_sw_g_add[4:0] ? rv32i_reg_13 : _GEN_365; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_367 = 5'he == io_sw_g_add[4:0] ? rv32i_reg_14 : _GEN_366; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_368 = 5'hf == io_sw_g_add[4:0] ? rv32i_reg_15 : _GEN_367; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_369 = 5'h10 == io_sw_g_add[4:0] ? rv32i_reg_16 : _GEN_368; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_370 = 5'h11 == io_sw_g_add[4:0] ? rv32i_reg_17 : _GEN_369; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_371 = 5'h12 == io_sw_g_add[4:0] ? rv32i_reg_18 : _GEN_370; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_372 = 5'h13 == io_sw_g_add[4:0] ? rv32i_reg_19 : _GEN_371; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_373 = 5'h14 == io_sw_g_add[4:0] ? rv32i_reg_20 : _GEN_372; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_374 = 5'h15 == io_sw_g_add[4:0] ? rv32i_reg_21 : _GEN_373; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_375 = 5'h16 == io_sw_g_add[4:0] ? rv32i_reg_22 : _GEN_374; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_376 = 5'h17 == io_sw_g_add[4:0] ? rv32i_reg_23 : _GEN_375; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_377 = 5'h18 == io_sw_g_add[4:0] ? rv32i_reg_24 : _GEN_376; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_378 = 5'h19 == io_sw_g_add[4:0] ? rv32i_reg_25 : _GEN_377; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_379 = 5'h1a == io_sw_g_add[4:0] ? rv32i_reg_26 : _GEN_378; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_380 = 5'h1b == io_sw_g_add[4:0] ? rv32i_reg_27 : _GEN_379; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_381 = 5'h1c == io_sw_g_add[4:0] ? rv32i_reg_28 : _GEN_380; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_382 = 5'h1d == io_sw_g_add[4:0] ? rv32i_reg_29 : _GEN_381; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_383 = 5'h1e == io_sw_g_add[4:0] ? rv32i_reg_30 : _GEN_382; // @[core.scala 576:21 core.scala 576:21]
  wire [31:0] _GEN_384 = 5'h1f == io_sw_g_add[4:0] ? rv32i_reg_31 : _GEN_383; // @[core.scala 576:21 core.scala 576:21]
  IDModule idm ( // @[core.scala 177:31]
    .io_imem(idm_io_imem),
    .io_inst_bits(idm_io_inst_bits),
    .io_inst_rd(idm_io_inst_rd),
    .io_inst_rs1(idm_io_inst_rs1),
    .io_inst_rs2(idm_io_inst_rs2),
    .io_inst_csr(idm_io_inst_csr)
  );
  CSR csr ( // @[core.scala 204:26]
    .clock(csr_clock),
    .reset(csr_reset),
    .io_addr(csr_io_addr),
    .io_in(csr_io_in),
    .io_out(csr_io_out),
    .io_cmd(csr_io_cmd),
    .io_rs1_addr(csr_io_rs1_addr),
    .io_legal(csr_io_legal),
    .io_interrupt_sig(csr_io_interrupt_sig),
    .io_pc(csr_io_pc),
    .io_pc_invalid(csr_io_pc_invalid),
    .io_j_check(csr_io_j_check),
    .io_b_check(csr_io_b_check),
    .io_stall(csr_io_stall),
    .io_expt(csr_io_expt),
    .io_evec(csr_io_evec),
    .io_epc(csr_io_epc),
    .io_inst(csr_io_inst),
    .io_mem_wr(csr_io_mem_wr),
    .io_mask_type(csr_io_mask_type),
    .io_alu_op1(csr_io_alu_op1),
    .io_alu_op2(csr_io_alu_op2)
  );
  ALU alu ( // @[core.scala 252:26]
    .io_op1(alu_io_op1),
    .io_op2(alu_io_op2),
    .io_alu_op(alu_io_alu_op),
    .io_out(alu_io_out),
    .io_cmp_out(alu_io_cmp_out)
  );
  assign io_imem_add_addr = w_req ? w_addr : pc_cntr; // @[core.scala 559:16 core.scala 560:29 core.scala 562:26]
  assign io_r_imem_dat_req = ~stall & _stall_T_7 & ~waitrequest ? io_r_imem_dat_req_REG : io_r_imem_dat_req_REG_1; // @[core.scala 125:48 core.scala 128:27]
  assign io_w_imem_dat_req = w_req; // @[core.scala 567:26]
  assign io_w_imem_dat_data = w_data; // @[core.scala 566:26]
  assign io_w_imem_dat_byteenable = 4'hf; // @[core.scala 568:30]
  assign io_dmem_add_addr = ~io_sw_halt ? mem_alu_out : io_sw_w_add; // @[core.scala 357:34 core.scala 359:26 core.scala 366:26]
  assign io_r_dmem_dat_req = ~io_sw_halt & _stall_T_3; // @[core.scala 357:34 core.scala 362:27 core.scala 371:27]
  assign io_w_dmem_dat_req = ~io_sw_halt ? mem_ctrl_mem_wr == 2'h2 : 1'h1; // @[core.scala 357:34 core.scala 360:27 core.scala 368:27]
  assign io_w_dmem_dat_data = _GEN_211[31:0];
  assign io_w_dmem_dat_byteenable = _io_w_dmem_dat_req_T ? _GEN_208 : 4'hf; // @[core.scala 378:37 core.scala 414:34]
  assign io_sw_r_add = pc_cntr; // @[core.scala 554:18]
  assign io_sw_r_dat = id_inst; // @[core.scala 553:18]
  assign io_sw_g_dat = io_sw_halt ? _GEN_384 : 32'h0; // @[core.scala 575:33 core.scala 576:21 core.scala 578:21]
  assign io_sw_r_pc = id_pc; // @[core.scala 555:18]
  assign io_sw_r_ex_raddr1 = {{27'd0}, ex_reg_raddr_0}; // @[core.scala 319:23]
  assign io_sw_r_ex_raddr2 = {{27'd0}, ex_reg_raddr_1}; // @[core.scala 320:23]
  assign io_sw_r_ex_rs1 = _ex_reg_rs1_bypass_T_4 ? mem_csr_data : _ex_reg_rs1_bypass_T_46; // @[Mux.scala 98:16]
  assign io_sw_r_ex_rs2 = _ex_reg_rs2_bypass_T_4 ? mem_csr_data : _ex_reg_rs2_bypass_T_46; // @[Mux.scala 98:16]
  assign io_sw_r_ex_imm = {right_right_right,right_right_left,right_left_right,right_left_left,left_right_right,
    left_right_left,left_left}; // @[core.scala 323:30]
  assign io_sw_r_mem_alu_out = mem_alu_out; // @[core.scala 354:25]
  assign io_sw_r_wb_alu_out = wb_alu_out; // @[core.scala 526:28]
  assign io_sw_r_wb_rf_wdata = _T_3672 ? wb_alu_out : _T_3678; // @[Mux.scala 98:16]
  assign io_sw_r_wb_rf_waddr = {{27'd0}, rf_waddr}; // @[core.scala 527:29]
  assign io_sw_r_stall_sig = {{31'd0}, stall}; // @[core.scala 210:73]
  assign idm_io_imem = id_inst; // @[core.scala 178:17]
  assign csr_clock = clock;
  assign csr_reset = reset;
  assign csr_io_addr = ex_csr_addr; // @[core.scala 301:17]
  assign csr_io_in = _T_3570 ? _ex_op2_T_2 : _T_3628; // @[core.scala 291:27]
  assign csr_io_cmd = ex_csr_cmd; // @[core.scala 302:16]
  assign csr_io_rs1_addr = {{27'd0}, ex_inst[19:15]}; // @[core.scala 310:31]
  assign csr_io_legal = ex_ctrl_legal; // @[core.scala 309:36]
  assign csr_io_interrupt_sig = interrupt_sig; // @[core.scala 315:26]
  assign csr_io_pc = ex_pc; // @[core.scala 300:15]
  assign csr_io_pc_invalid = inst_kill_branch | ex_pc == 32'h0; // @[core.scala 198:45]
  assign csr_io_j_check = ex_j_check; // @[core.scala 313:20]
  assign csr_io_b_check = ex_b_check; // @[core.scala 314:20]
  assign csr_io_stall = _stall_T_20 | _T_1768; // @[core.scala 210:73]
  assign csr_io_inst = ex_inst; // @[core.scala 304:17]
  assign csr_io_mem_wr = ex_ctrl_mem_wr; // @[core.scala 305:19]
  assign csr_io_mask_type = ex_ctrl_mask_type; // @[core.scala 306:22]
  assign csr_io_alu_op1 = _ex_op1_T ? ex_reg_rs1_bypass : _ex_op1_T_4; // @[Mux.scala 98:16]
  assign csr_io_alu_op2 = _ex_op2_T ? ex_reg_rs2_bypass : _ex_op2_T_5; // @[Mux.scala 98:16]
  assign alu_io_op1 = _ex_op1_T ? ex_reg_rs1_bypass : _ex_op1_T_4; // @[Mux.scala 98:16]
  assign alu_io_op2 = _ex_op2_T ? ex_reg_rs2_bypass : _ex_op2_T_5; // @[Mux.scala 98:16]
  assign alu_io_alu_op = ex_ctrl_alu_func; // @[core.scala 286:19]
  always @(posedge clock) begin
    if (reset) begin // @[core.scala 33:30]
      if_pc <= 32'h0; // @[core.scala 33:30]
    end else if (~stall & _stall_T_7 & ~waitrequest) begin // @[core.scala 125:48]
      if_pc <= pc_cntr; // @[core.scala 126:15]
    end else if (inst_kill & _T_1772) begin // @[core.scala 130:43]
      if_pc <= 32'h0; // @[core.scala 131:15]
    end
    if (reset) begin // @[core.scala 34:31]
      if_npc <= 32'h4; // @[core.scala 34:31]
    end else if (~stall & _stall_T_7 & ~waitrequest) begin // @[core.scala 125:48]
      if_npc <= npc; // @[core.scala 127:16]
    end else if (inst_kill & _T_1772) begin // @[core.scala 130:43]
      if_npc <= 32'h4; // @[core.scala 132:16]
    end
    if (reset) begin // @[core.scala 37:32]
      id_inst <= 32'h13; // @[core.scala 37:32]
    end else if (!((stall | waitrequest) & _stall_T_7 & valid_imem)) begin // @[core.scala 147:62]
      if (_T_1769 & _T_1772 & _stall_T_7 & valid_imem) begin // @[core.scala 151:68]
        id_inst <= io_r_imem_dat_data; // @[core.scala 154:17]
      end else if (_T_1775) begin // @[core.scala 155:43]
        id_inst <= 32'h13; // @[core.scala 158:17]
      end else begin
        id_inst <= _GEN_12;
      end
    end
    if (reset) begin // @[core.scala 38:30]
      id_pc <= 32'h0; // @[core.scala 38:30]
    end else if (!((stall | waitrequest) & _stall_T_7 & valid_imem)) begin // @[core.scala 147:62]
      if (_T_1769 & _T_1772 & _stall_T_7 & valid_imem) begin // @[core.scala 151:68]
        id_pc <= if_pc; // @[core.scala 152:15]
      end else if (_T_1775) begin // @[core.scala 155:43]
        id_pc <= 32'h0; // @[core.scala 156:15]
      end else begin
        id_pc <= _GEN_10;
      end
    end
    if (reset) begin // @[core.scala 39:31]
      id_npc <= 32'h4; // @[core.scala 39:31]
    end else if (!((stall | waitrequest) & _stall_T_7 & valid_imem)) begin // @[core.scala 147:62]
      if (_T_1769 & _T_1772 & _stall_T_7 & valid_imem) begin // @[core.scala 151:68]
        id_npc <= if_npc; // @[core.scala 153:16]
      end else if (_T_1775) begin // @[core.scala 155:43]
        id_npc <= 32'h4; // @[core.scala 157:16]
      end else begin
        id_npc <= _GEN_11;
      end
    end
    if (reset) begin // @[core.scala 43:30]
      ex_pc <= 32'h0; // @[core.scala 43:30]
    end else if (_T_1773) begin // @[core.scala 218:48]
      ex_pc <= id_pc; // @[core.scala 219:15]
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_pc <= 32'h0; // @[core.scala 233:15]
    end
    if (reset) begin // @[core.scala 44:31]
      ex_npc <= 32'h4; // @[core.scala 44:31]
    end else if (_T_1773) begin // @[core.scala 218:48]
      ex_npc <= id_npc; // @[core.scala 220:16]
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_npc <= 32'h4; // @[core.scala 234:16]
    end
    if (reset) begin // @[core.scala 45:32]
      ex_inst <= 32'h13; // @[core.scala 45:32]
    end else if (_T_1773) begin // @[core.scala 218:48]
      ex_inst <= id_inst; // @[core.scala 222:17]
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_inst <= 32'h13; // @[core.scala 236:17]
    end
    ex_ctrl_legal <= reset | _GEN_135; // @[core.scala 46:39 core.scala 46:39]
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_br_type <= 4'h0; // @[core.scala 46:39]
    end else if (_T_1773) begin // @[core.scala 218:48]
      if (_T_1796) begin // @[Mux.scala 98:16]
        ex_ctrl_br_type <= 4'h0;
      end else if (_T_1798) begin // @[Mux.scala 98:16]
        ex_ctrl_br_type <= 4'h0;
      end else begin
        ex_ctrl_br_type <= _T_2086;
      end
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_ctrl_br_type <= 4'h0; // @[core.scala 235:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_alu_op1 <= 2'h1; // @[core.scala 46:39]
    end else if (_T_1773) begin // @[core.scala 218:48]
      if (_T_1796) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_op1 <= 2'h0;
      end else if (_T_1798) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_op1 <= 2'h2;
      end else begin
        ex_ctrl_alu_op1 <= _T_2233;
      end
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_ctrl_alu_op1 <= 2'h1; // @[core.scala 235:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_alu_op2 <= 2'h2; // @[core.scala 46:39]
    end else if (_T_1773) begin // @[core.scala 218:48]
      if (_T_1796) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1798) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_op2 <= 2'h2;
      end else begin
        ex_ctrl_alu_op2 <= _T_2380;
      end
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_ctrl_alu_op2 <= 2'h2; // @[core.scala 235:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_imm_type <= 3'h0; // @[core.scala 46:39]
    end else if (_T_1773) begin // @[core.scala 218:48]
      if (_T_1796) begin // @[Mux.scala 98:16]
        ex_ctrl_imm_type <= 3'h3;
      end else if (_T_1798) begin // @[Mux.scala 98:16]
        ex_ctrl_imm_type <= 3'h3;
      end else begin
        ex_ctrl_imm_type <= _T_2527;
      end
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_ctrl_imm_type <= 3'h0; // @[core.scala 235:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_alu_func <= 4'h0; // @[core.scala 46:39]
    end else if (_T_1773) begin // @[core.scala 218:48]
      if (_T_1796) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_func <= 4'h9;
      end else if (_T_1798) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_func <= 4'h0;
      end else begin
        ex_ctrl_alu_func <= _T_2674;
      end
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_ctrl_alu_func <= 4'h0; // @[core.scala 235:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_wb_sel <= 2'h1; // @[core.scala 46:39]
    end else if (_T_1773) begin // @[core.scala 218:48]
      if (_T_1796) begin // @[Mux.scala 98:16]
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1798) begin // @[Mux.scala 98:16]
        ex_ctrl_wb_sel <= 2'h1;
      end else begin
        ex_ctrl_wb_sel <= _T_2821;
      end
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_ctrl_wb_sel <= 2'h1; // @[core.scala 235:17]
    end
    ex_ctrl_rf_wen <= reset | _GEN_128; // @[core.scala 46:39 core.scala 46:39]
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_mem_en <= 1'h0; // @[core.scala 46:39]
    end else if (_T_1773) begin // @[core.scala 218:48]
      if (_T_1796) begin // @[Mux.scala 98:16]
        ex_ctrl_mem_en <= 1'h0;
      end else if (_T_1798) begin // @[Mux.scala 98:16]
        ex_ctrl_mem_en <= 1'h0;
      end else begin
        ex_ctrl_mem_en <= _T_3115;
      end
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_ctrl_mem_en <= 1'h0; // @[core.scala 235:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_mem_wr <= 2'h0; // @[core.scala 46:39]
    end else if (_T_1773) begin // @[core.scala 218:48]
      if (_T_1796) begin // @[Mux.scala 98:16]
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1798) begin // @[Mux.scala 98:16]
        ex_ctrl_mem_wr <= 2'h0;
      end else begin
        ex_ctrl_mem_wr <= _T_3262;
      end
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_ctrl_mem_wr <= 2'h0; // @[core.scala 235:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_mask_type <= 3'h0; // @[core.scala 46:39]
    end else if (_T_1773) begin // @[core.scala 218:48]
      if (_T_1796) begin // @[Mux.scala 98:16]
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1798) begin // @[Mux.scala 98:16]
        ex_ctrl_mask_type <= 3'h0;
      end else begin
        ex_ctrl_mask_type <= _T_3409;
      end
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_ctrl_mask_type <= 3'h0; // @[core.scala 235:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_csr_cmd <= 3'h0; // @[core.scala 46:39]
    end else if (_T_1773) begin // @[core.scala 218:48]
      if (_T_1796) begin // @[Mux.scala 98:16]
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1798) begin // @[Mux.scala 98:16]
        ex_ctrl_csr_cmd <= 3'h0;
      end else begin
        ex_ctrl_csr_cmd <= _T_3556;
      end
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_ctrl_csr_cmd <= 3'h0; // @[core.scala 235:17]
    end
    if (reset) begin // @[core.scala 47:42]
      ex_reg_raddr_0 <= 5'h0; // @[core.scala 47:42]
    end else if (_T_1773) begin // @[core.scala 218:48]
      ex_reg_raddr_0 <= idm_io_inst_rs1; // @[core.scala 223:25]
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_reg_raddr_0 <= 5'h0; // @[core.scala 237:22]
    end
    if (reset) begin // @[core.scala 47:42]
      ex_reg_raddr_1 <= 5'h0; // @[core.scala 47:42]
    end else if (_T_1773) begin // @[core.scala 218:48]
      ex_reg_raddr_1 <= idm_io_inst_rs2; // @[core.scala 224:25]
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_reg_raddr_1 <= 5'h0; // @[core.scala 237:22]
    end
    if (reset) begin // @[core.scala 48:37]
      ex_reg_waddr <= 5'h0; // @[core.scala 48:37]
    end else if (_T_1773) begin // @[core.scala 218:48]
      ex_reg_waddr <= idm_io_inst_rd; // @[core.scala 225:22]
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_reg_waddr <= 5'h0; // @[core.scala 238:22]
    end
    if (reset) begin // @[core.scala 49:35]
      ex_rs_0 <= 32'h0; // @[core.scala 49:35]
    end else if (_T_1773) begin // @[core.scala 218:48]
      if (idm_io_inst_rs1 == 5'h0) begin // @[core.scala 193:27]
        ex_rs_0 <= 32'h0;
      end else if (5'h1f == idm_io_inst_rs1) begin // @[core.scala 193:27]
        ex_rs_0 <= rv32i_reg_31; // @[core.scala 193:27]
      end else begin
        ex_rs_0 <= _GEN_64;
      end
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_rs_0 <= 32'h0; // @[core.scala 239:15]
    end
    if (reset) begin // @[core.scala 49:35]
      ex_rs_1 <= 32'h0; // @[core.scala 49:35]
    end else if (_T_1773) begin // @[core.scala 218:48]
      if (idm_io_inst_rs2 == 5'h0) begin // @[core.scala 194:27]
        ex_rs_1 <= 32'h0;
      end else if (5'h1f == idm_io_inst_rs2) begin // @[core.scala 194:27]
        ex_rs_1 <= rv32i_reg_31; // @[core.scala 194:27]
      end else begin
        ex_rs_1 <= _GEN_96;
      end
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_rs_1 <= 32'h0; // @[core.scala 239:15]
    end
    if (reset) begin // @[core.scala 50:36]
      ex_csr_addr <= 32'h0; // @[core.scala 50:36]
    end else if (_T_1773) begin // @[core.scala 218:48]
      ex_csr_addr <= {{20'd0}, idm_io_inst_csr}; // @[core.scala 228:21]
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_csr_addr <= 32'h0; // @[core.scala 240:21]
    end
    if (reset) begin // @[core.scala 51:35]
      ex_csr_cmd <= 32'h0; // @[core.scala 51:35]
    end else if (_T_1773) begin // @[core.scala 218:48]
      ex_csr_cmd <= {{29'd0}, id_ctrl_csr_cmd}; // @[core.scala 229:20]
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_csr_cmd <= 32'h0; // @[core.scala 241:20]
    end
    if (reset) begin // @[core.scala 52:35]
      ex_b_check <= 1'h0; // @[core.scala 52:35]
    end else if (_T_1773) begin // @[core.scala 218:48]
      ex_b_check <= id_ctrl_br_type > 4'h3; // @[core.scala 231:20]
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_b_check <= 1'h0; // @[core.scala 243:20]
    end
    if (reset) begin // @[core.scala 53:35]
      ex_j_check <= 1'h0; // @[core.scala 53:35]
    end else if (_T_1773) begin // @[core.scala 218:48]
      ex_j_check <= id_ctrl_br_type == 4'h1 | id_ctrl_br_type == 4'h2; // @[core.scala 230:20]
    end else if ((stall | inst_kill) & _T_1772) begin // @[core.scala 232:54]
      ex_j_check <= 1'h0; // @[core.scala 242:20]
    end
    if (reset) begin // @[core.scala 56:31]
      mem_pc <= 32'h0; // @[core.scala 56:31]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_pc <= ex_pc; // @[core.scala 328:16]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_pc <= 32'h0; // @[core.scala 341:16]
    end
    if (reset) begin // @[core.scala 57:32]
      mem_npc <= 32'h4; // @[core.scala 57:32]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_npc <= ex_npc; // @[core.scala 329:17]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_npc <= 32'h4; // @[core.scala 342:17]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_br_type <= 4'h0; // @[core.scala 58:40]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_ctrl_br_type <= ex_ctrl_br_type; // @[core.scala 330:18]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_ctrl_br_type <= 4'h0; // @[core.scala 343:18]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_wb_sel <= 2'h1; // @[core.scala 58:40]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_ctrl_wb_sel <= ex_ctrl_wb_sel; // @[core.scala 330:18]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_ctrl_wb_sel <= 2'h1; // @[core.scala 343:18]
    end
    mem_ctrl_rf_wen <= reset | _GEN_174; // @[core.scala 58:40 core.scala 58:40]
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_mem_en <= 1'h0; // @[core.scala 58:40]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_ctrl_mem_en <= ex_ctrl_mem_en; // @[core.scala 330:18]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_ctrl_mem_en <= 1'h0; // @[core.scala 343:18]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_mem_wr <= 2'h0; // @[core.scala 58:40]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_ctrl_mem_wr <= ex_ctrl_mem_wr; // @[core.scala 330:18]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_ctrl_mem_wr <= 2'h0; // @[core.scala 343:18]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_mask_type <= 3'h0; // @[core.scala 58:40]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_ctrl_mask_type <= ex_ctrl_mask_type; // @[core.scala 330:18]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_ctrl_mask_type <= 3'h0; // @[core.scala 343:18]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_csr_cmd <= 3'h0; // @[core.scala 58:40]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_ctrl_csr_cmd <= ex_ctrl_csr_cmd; // @[core.scala 330:18]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_ctrl_csr_cmd <= 3'h0; // @[core.scala 343:18]
    end
    if (reset) begin // @[core.scala 59:32]
      mem_imm <= 32'sh0; // @[core.scala 59:32]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_imm <= ex_imm; // @[core.scala 332:17]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_imm <= 32'sh0; // @[core.scala 345:17]
    end
    if (reset) begin // @[core.scala 60:38]
      mem_reg_waddr <= 5'h0; // @[core.scala 60:38]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_reg_waddr <= ex_reg_waddr; // @[core.scala 331:23]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_reg_waddr <= 5'h0; // @[core.scala 344:23]
    end
    if (reset) begin // @[core.scala 61:36]
      mem_rs_1 <= 32'h0; // @[core.scala 61:36]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      if (_ex_reg_rs2_bypass_T_4) begin // @[Mux.scala 98:16]
        mem_rs_1 <= mem_csr_data;
      end else if (_ex_reg_rs2_bypass_T_9) begin // @[Mux.scala 98:16]
        mem_rs_1 <= mem_alu_out;
      end else begin
        mem_rs_1 <= _ex_reg_rs2_bypass_T_45;
      end
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_rs_1 <= 32'h0; // @[core.scala 346:16]
    end
    if (reset) begin // @[core.scala 62:36]
      mem_alu_out <= 32'h0; // @[core.scala 62:36]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_alu_out <= alu_io_out; // @[core.scala 335:21]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_alu_out <= 32'h0; // @[core.scala 347:21]
    end
    if (reset) begin // @[core.scala 63:40]
      mem_alu_cmp_out <= 1'h0; // @[core.scala 63:40]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_alu_cmp_out <= alu_io_cmp_out; // @[core.scala 336:25]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_alu_cmp_out <= 1'h0; // @[core.scala 348:25]
    end
    if (reset) begin // @[core.scala 65:37]
      mem_csr_data <= 32'h0; // @[core.scala 65:37]
    end else if (_stall_T_7 & _T_1772) begin // @[core.scala 327:38]
      mem_csr_data <= csr_io_out; // @[core.scala 338:22]
    end else if (_T_1775) begin // @[core.scala 340:43]
      mem_csr_data <= 32'h0; // @[core.scala 350:22]
    end
    if (reset) begin // @[core.scala 68:31]
      wb_npc <= 32'h4; // @[core.scala 68:31]
    end else if (_T_1772) begin // @[core.scala 428:24]
      wb_npc <= mem_npc; // @[core.scala 429:16]
    end
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_wb_sel <= 2'h1; // @[core.scala 69:39]
    end else if (_T_1772) begin // @[core.scala 428:24]
      wb_ctrl_wb_sel <= mem_ctrl_wb_sel; // @[core.scala 430:17]
    end
    wb_ctrl_rf_wen <= reset | _GEN_217; // @[core.scala 69:39 core.scala 69:39]
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_mem_en <= 1'h0; // @[core.scala 69:39]
    end else if (_T_1772) begin // @[core.scala 428:24]
      wb_ctrl_mem_en <= mem_ctrl_mem_en; // @[core.scala 430:17]
    end
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_mem_wr <= 2'h0; // @[core.scala 69:39]
    end else if (_T_1772) begin // @[core.scala 428:24]
      wb_ctrl_mem_wr <= mem_ctrl_mem_wr; // @[core.scala 430:17]
    end
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_mask_type <= 3'h0; // @[core.scala 69:39]
    end else if (_T_1772) begin // @[core.scala 428:24]
      wb_ctrl_mask_type <= mem_ctrl_mask_type; // @[core.scala 430:17]
    end
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_csr_cmd <= 3'h0; // @[core.scala 69:39]
    end else if (_T_1772) begin // @[core.scala 428:24]
      wb_ctrl_csr_cmd <= mem_ctrl_csr_cmd; // @[core.scala 430:17]
    end
    if (reset) begin // @[core.scala 70:37]
      rf_waddr <= 5'h0; // @[core.scala 70:37]
    end else if (_T_1772) begin // @[core.scala 428:24]
      rf_waddr <= mem_reg_waddr; // @[core.scala 431:22]
    end
    if (reset) begin // @[core.scala 71:35]
      wb_alu_out <= 32'h0; // @[core.scala 71:35]
    end else if (_T_1772) begin // @[core.scala 428:24]
      wb_alu_out <= mem_alu_out; // @[core.scala 432:20]
    end
    if (reset) begin // @[core.scala 74:36]
      wb_csr_data <= 32'h0; // @[core.scala 74:36]
    end else if (_T_1772) begin // @[core.scala 428:24]
      wb_csr_data <= mem_csr_data; // @[core.scala 435:21]
    end
    if (reset) begin // @[core.scala 86:32]
      pc_cntr <= 32'h0; // @[core.scala 86:32]
    end else if (_T_3634) begin // @[core.scala 534:38]
      if (_T_1782) begin // @[core.scala 536:42]
        if (csr_io_expt) begin // @[core.scala 537:31]
          pc_cntr <= csr_io_evec;
        end else begin
          pc_cntr <= _pc_cntr_T_11;
        end
      end
    end else begin
      pc_cntr <= io_sw_w_pc; // @[core.scala 549:21]
    end
    w_req <= reset | _GEN_348; // @[core.scala 94:30 core.scala 94:30]
    if (reset) begin // @[core.scala 96:31]
      w_addr <= 32'h0; // @[core.scala 96:31]
    end else if (!(_T_3634)) begin // @[core.scala 534:38]
      w_addr <= io_sw_w_add; // @[core.scala 546:20]
    end
    if (reset) begin // @[core.scala 97:31]
      w_data <= 32'h0; // @[core.scala 97:31]
    end else if (!(_T_3634)) begin // @[core.scala 534:38]
      w_data <= io_sw_w_dat; // @[core.scala 547:20]
    end
    if (reset) begin // @[core.scala 103:38]
      imem_read_sig <= 1'h0; // @[core.scala 103:38]
    end else begin
      imem_read_sig <= ~io_w_imem_dat_req; // @[core.scala 103:38]
    end
    if (reset) begin // @[core.scala 108:36]
      delay_stall <= 4'h0; // @[core.scala 108:36]
    end else if (imem_read_sig) begin // @[core.scala 109:36]
      if (delay_stall != 4'h7) begin // @[core.scala 110:35]
        delay_stall <= _delay_stall_T_1; // @[core.scala 111:25]
      end
    end else begin
      delay_stall <= 4'h0; // @[core.scala 114:21]
    end
    valid_imem <= reset | _T_1773; // @[core.scala 118:35 core.scala 118:35]
    io_r_imem_dat_req_REG <= imem_read_sig; // @[core.scala 128:37]
    io_r_imem_dat_req_REG_1 <= imem_read_sig; // @[core.scala 133:37]
    if (reset) begin // @[core.scala 142:37]
      id_inst_temp <= 32'h13; // @[core.scala 142:37]
    end else if ((stall | waitrequest) & _stall_T_7 & valid_imem) begin // @[core.scala 147:62]
      id_inst_temp <= io_r_imem_dat_data; // @[core.scala 150:22]
    end else if (!(_T_1769 & _T_1772 & _stall_T_7 & valid_imem)) begin // @[core.scala 151:68]
      if (_T_1775) begin // @[core.scala 155:43]
        id_inst_temp <= 32'h13; // @[core.scala 162:22]
      end else begin
        id_inst_temp <= _GEN_15;
      end
    end
    if (reset) begin // @[core.scala 143:35]
      id_pc_temp <= 32'h0; // @[core.scala 143:35]
    end else if ((stall | waitrequest) & _stall_T_7 & valid_imem) begin // @[core.scala 147:62]
      id_pc_temp <= if_pc; // @[core.scala 148:20]
    end else if (!(_T_1769 & _T_1772 & _stall_T_7 & valid_imem)) begin // @[core.scala 151:68]
      if (_T_1775) begin // @[core.scala 155:43]
        id_pc_temp <= 32'h0; // @[core.scala 160:20]
      end else begin
        id_pc_temp <= _GEN_13;
      end
    end
    if (reset) begin // @[core.scala 144:36]
      id_npc_temp <= 32'h4; // @[core.scala 144:36]
    end else if ((stall | waitrequest) & _stall_T_7 & valid_imem) begin // @[core.scala 147:62]
      id_npc_temp <= if_npc; // @[core.scala 149:21]
    end else if (!(_T_1769 & _T_1772 & _stall_T_7 & valid_imem)) begin // @[core.scala 151:68]
      if (_T_1775) begin // @[core.scala 155:43]
        id_npc_temp <= 32'h4; // @[core.scala 161:21]
      end else begin
        id_npc_temp <= _GEN_14;
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_0 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h0 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_0 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_1 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h1 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_1 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_2 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h2 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_2 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_3 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h3 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_3 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_4 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h4 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_4 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_5 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h5 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_5 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_6 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h6 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_6 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_7 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h7 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_7 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_8 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h8 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_8 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_9 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h9 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_9 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_10 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'ha == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_10 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_11 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'hb == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_11 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_12 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'hc == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_12 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_13 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'hd == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_13 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_14 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'he == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_14 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_15 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'hf == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_15 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_16 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h10 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_16 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_17 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h11 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_17 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_18 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h12 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_18 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_19 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h13 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_19 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_20 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h14 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_20 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_21 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h15 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_21 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_22 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h16 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_22 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_23 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h17 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_23 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_24 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h18 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_24 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_25 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h19 == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_25 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_26 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h1a == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_26 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_27 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h1b == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_27 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_28 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h1c == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_28 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_29 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h1d == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_29 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_30 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h1e == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_30 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 192:39]
      rv32i_reg_31 <= 32'h0; // @[core.scala 192:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 519:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 520:53]
        if (5'h1f == rf_waddr) begin // @[core.scala 521:37]
          rv32i_reg_31 <= rf_wdata; // @[core.scala 521:37]
        end
      end
    end
    if (reset) begin // @[core.scala 201:38]
      interrupt_sig <= 1'h0; // @[core.scala 201:38]
    end else begin
      interrupt_sig <= io_sw_w_interrupt_sig; // @[core.scala 202:19]
    end
  end
// Register and memory initialization
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
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
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
  if_pc = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  if_npc = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  id_inst = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  id_pc = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  id_npc = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  ex_pc = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  ex_npc = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  ex_inst = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  ex_ctrl_legal = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  ex_ctrl_br_type = _RAND_9[3:0];
  _RAND_10 = {1{`RANDOM}};
  ex_ctrl_alu_op1 = _RAND_10[1:0];
  _RAND_11 = {1{`RANDOM}};
  ex_ctrl_alu_op2 = _RAND_11[1:0];
  _RAND_12 = {1{`RANDOM}};
  ex_ctrl_imm_type = _RAND_12[2:0];
  _RAND_13 = {1{`RANDOM}};
  ex_ctrl_alu_func = _RAND_13[3:0];
  _RAND_14 = {1{`RANDOM}};
  ex_ctrl_wb_sel = _RAND_14[1:0];
  _RAND_15 = {1{`RANDOM}};
  ex_ctrl_rf_wen = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  ex_ctrl_mem_en = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  ex_ctrl_mem_wr = _RAND_17[1:0];
  _RAND_18 = {1{`RANDOM}};
  ex_ctrl_mask_type = _RAND_18[2:0];
  _RAND_19 = {1{`RANDOM}};
  ex_ctrl_csr_cmd = _RAND_19[2:0];
  _RAND_20 = {1{`RANDOM}};
  ex_reg_raddr_0 = _RAND_20[4:0];
  _RAND_21 = {1{`RANDOM}};
  ex_reg_raddr_1 = _RAND_21[4:0];
  _RAND_22 = {1{`RANDOM}};
  ex_reg_waddr = _RAND_22[4:0];
  _RAND_23 = {1{`RANDOM}};
  ex_rs_0 = _RAND_23[31:0];
  _RAND_24 = {1{`RANDOM}};
  ex_rs_1 = _RAND_24[31:0];
  _RAND_25 = {1{`RANDOM}};
  ex_csr_addr = _RAND_25[31:0];
  _RAND_26 = {1{`RANDOM}};
  ex_csr_cmd = _RAND_26[31:0];
  _RAND_27 = {1{`RANDOM}};
  ex_b_check = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  ex_j_check = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  mem_pc = _RAND_29[31:0];
  _RAND_30 = {1{`RANDOM}};
  mem_npc = _RAND_30[31:0];
  _RAND_31 = {1{`RANDOM}};
  mem_ctrl_br_type = _RAND_31[3:0];
  _RAND_32 = {1{`RANDOM}};
  mem_ctrl_wb_sel = _RAND_32[1:0];
  _RAND_33 = {1{`RANDOM}};
  mem_ctrl_rf_wen = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  mem_ctrl_mem_en = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  mem_ctrl_mem_wr = _RAND_35[1:0];
  _RAND_36 = {1{`RANDOM}};
  mem_ctrl_mask_type = _RAND_36[2:0];
  _RAND_37 = {1{`RANDOM}};
  mem_ctrl_csr_cmd = _RAND_37[2:0];
  _RAND_38 = {1{`RANDOM}};
  mem_imm = _RAND_38[31:0];
  _RAND_39 = {1{`RANDOM}};
  mem_reg_waddr = _RAND_39[4:0];
  _RAND_40 = {1{`RANDOM}};
  mem_rs_1 = _RAND_40[31:0];
  _RAND_41 = {1{`RANDOM}};
  mem_alu_out = _RAND_41[31:0];
  _RAND_42 = {1{`RANDOM}};
  mem_alu_cmp_out = _RAND_42[0:0];
  _RAND_43 = {1{`RANDOM}};
  mem_csr_data = _RAND_43[31:0];
  _RAND_44 = {1{`RANDOM}};
  wb_npc = _RAND_44[31:0];
  _RAND_45 = {1{`RANDOM}};
  wb_ctrl_wb_sel = _RAND_45[1:0];
  _RAND_46 = {1{`RANDOM}};
  wb_ctrl_rf_wen = _RAND_46[0:0];
  _RAND_47 = {1{`RANDOM}};
  wb_ctrl_mem_en = _RAND_47[0:0];
  _RAND_48 = {1{`RANDOM}};
  wb_ctrl_mem_wr = _RAND_48[1:0];
  _RAND_49 = {1{`RANDOM}};
  wb_ctrl_mask_type = _RAND_49[2:0];
  _RAND_50 = {1{`RANDOM}};
  wb_ctrl_csr_cmd = _RAND_50[2:0];
  _RAND_51 = {1{`RANDOM}};
  rf_waddr = _RAND_51[4:0];
  _RAND_52 = {1{`RANDOM}};
  wb_alu_out = _RAND_52[31:0];
  _RAND_53 = {1{`RANDOM}};
  wb_csr_data = _RAND_53[31:0];
  _RAND_54 = {1{`RANDOM}};
  pc_cntr = _RAND_54[31:0];
  _RAND_55 = {1{`RANDOM}};
  w_req = _RAND_55[0:0];
  _RAND_56 = {1{`RANDOM}};
  w_addr = _RAND_56[31:0];
  _RAND_57 = {1{`RANDOM}};
  w_data = _RAND_57[31:0];
  _RAND_58 = {1{`RANDOM}};
  imem_read_sig = _RAND_58[0:0];
  _RAND_59 = {1{`RANDOM}};
  delay_stall = _RAND_59[3:0];
  _RAND_60 = {1{`RANDOM}};
  valid_imem = _RAND_60[0:0];
  _RAND_61 = {1{`RANDOM}};
  io_r_imem_dat_req_REG = _RAND_61[0:0];
  _RAND_62 = {1{`RANDOM}};
  io_r_imem_dat_req_REG_1 = _RAND_62[0:0];
  _RAND_63 = {1{`RANDOM}};
  id_inst_temp = _RAND_63[31:0];
  _RAND_64 = {1{`RANDOM}};
  id_pc_temp = _RAND_64[31:0];
  _RAND_65 = {1{`RANDOM}};
  id_npc_temp = _RAND_65[31:0];
  _RAND_66 = {1{`RANDOM}};
  rv32i_reg_0 = _RAND_66[31:0];
  _RAND_67 = {1{`RANDOM}};
  rv32i_reg_1 = _RAND_67[31:0];
  _RAND_68 = {1{`RANDOM}};
  rv32i_reg_2 = _RAND_68[31:0];
  _RAND_69 = {1{`RANDOM}};
  rv32i_reg_3 = _RAND_69[31:0];
  _RAND_70 = {1{`RANDOM}};
  rv32i_reg_4 = _RAND_70[31:0];
  _RAND_71 = {1{`RANDOM}};
  rv32i_reg_5 = _RAND_71[31:0];
  _RAND_72 = {1{`RANDOM}};
  rv32i_reg_6 = _RAND_72[31:0];
  _RAND_73 = {1{`RANDOM}};
  rv32i_reg_7 = _RAND_73[31:0];
  _RAND_74 = {1{`RANDOM}};
  rv32i_reg_8 = _RAND_74[31:0];
  _RAND_75 = {1{`RANDOM}};
  rv32i_reg_9 = _RAND_75[31:0];
  _RAND_76 = {1{`RANDOM}};
  rv32i_reg_10 = _RAND_76[31:0];
  _RAND_77 = {1{`RANDOM}};
  rv32i_reg_11 = _RAND_77[31:0];
  _RAND_78 = {1{`RANDOM}};
  rv32i_reg_12 = _RAND_78[31:0];
  _RAND_79 = {1{`RANDOM}};
  rv32i_reg_13 = _RAND_79[31:0];
  _RAND_80 = {1{`RANDOM}};
  rv32i_reg_14 = _RAND_80[31:0];
  _RAND_81 = {1{`RANDOM}};
  rv32i_reg_15 = _RAND_81[31:0];
  _RAND_82 = {1{`RANDOM}};
  rv32i_reg_16 = _RAND_82[31:0];
  _RAND_83 = {1{`RANDOM}};
  rv32i_reg_17 = _RAND_83[31:0];
  _RAND_84 = {1{`RANDOM}};
  rv32i_reg_18 = _RAND_84[31:0];
  _RAND_85 = {1{`RANDOM}};
  rv32i_reg_19 = _RAND_85[31:0];
  _RAND_86 = {1{`RANDOM}};
  rv32i_reg_20 = _RAND_86[31:0];
  _RAND_87 = {1{`RANDOM}};
  rv32i_reg_21 = _RAND_87[31:0];
  _RAND_88 = {1{`RANDOM}};
  rv32i_reg_22 = _RAND_88[31:0];
  _RAND_89 = {1{`RANDOM}};
  rv32i_reg_23 = _RAND_89[31:0];
  _RAND_90 = {1{`RANDOM}};
  rv32i_reg_24 = _RAND_90[31:0];
  _RAND_91 = {1{`RANDOM}};
  rv32i_reg_25 = _RAND_91[31:0];
  _RAND_92 = {1{`RANDOM}};
  rv32i_reg_26 = _RAND_92[31:0];
  _RAND_93 = {1{`RANDOM}};
  rv32i_reg_27 = _RAND_93[31:0];
  _RAND_94 = {1{`RANDOM}};
  rv32i_reg_28 = _RAND_94[31:0];
  _RAND_95 = {1{`RANDOM}};
  rv32i_reg_29 = _RAND_95[31:0];
  _RAND_96 = {1{`RANDOM}};
  rv32i_reg_30 = _RAND_96[31:0];
  _RAND_97 = {1{`RANDOM}};
  rv32i_reg_31 = _RAND_97[31:0];
  _RAND_98 = {1{`RANDOM}};
  interrupt_sig = _RAND_98[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule