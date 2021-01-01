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
  wire [31:0] mstatus = {22'h0,3'h0,1'h0,PRV1,IE1,2'h3,IE}; // @[Cat.scala 30:58]
  reg [31:0] mtvec; // @[csr.scala 209:31]
  reg  MTIP; // @[csr.scala 213:27]
  reg  MEIE; // @[csr.scala 217:27]
  reg  MTIE; // @[csr.scala 218:27]
  reg  MEIP; // @[csr.scala 222:27]
  reg  MSIP; // @[csr.scala 223:27]
  reg  MSIE; // @[csr.scala 226:27]
  wire [31:0] mip = {20'h0,MEIP,2'h0,1'h0,MTIP,1'h0,2'h0,MSIP,3'h0}; // @[Cat.scala 30:58]
  wire [31:0] mie = {20'h0,MEIE,2'h0,1'h0,MTIE,1'h0,2'h0,MSIE,3'h0}; // @[Cat.scala 30:58]
  reg [31:0] mscratch; // @[csr.scala 233:29]
  reg [31:0] mepc; // @[csr.scala 235:29]
  reg [31:0] mcause; // @[csr.scala 236:29]
  reg [31:0] mtval; // @[csr.scala 242:33]
  reg [31:0] valid_pc; // @[csr.scala 245:31]
  wire [31:0] _T_9 = io_addr & 32'hfff; // @[Lookup.scala 31:38]
  wire  _T_10 = 32'hc00 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_12 = 32'hc01 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_14 = 32'hc02 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_16 = 32'hc80 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_18 = 32'hc81 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_20 = 32'hc82 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_22 = 32'h900 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_24 = 32'h180 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_26 = 32'h901 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_28 = 32'h902 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_30 = 32'h980 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_32 = 32'h981 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_34 = 32'h982 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_36 = 32'hf00 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_38 = 32'hf13 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_40 = 32'hf14 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_42 = 32'h305 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_44 = 32'h302 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_46 = 32'h304 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_48 = 32'h321 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_50 = 32'h701 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_52 = 32'h741 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_54 = 32'h340 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_56 = 32'h341 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_58 = 32'h342 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_60 = 32'h344 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_62 = 32'h300 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_64 = 32'h301 == _T_9; // @[Lookup.scala 31:38]
  wire  _T_66 = 32'h343 == _T_9; // @[Lookup.scala 31:38]
  wire [31:0] _T_67 = _T_66 ? mtval : 32'h0; // @[Lookup.scala 33:37]
  wire [31:0] _T_68 = _T_64 ? 32'h40000000 : _T_67; // @[Lookup.scala 33:37]
  wire [31:0] _T_69 = _T_62 ? mstatus : _T_68; // @[Lookup.scala 33:37]
  wire [31:0] _T_70 = _T_60 ? mip : _T_69; // @[Lookup.scala 33:37]
  wire [31:0] _T_71 = _T_58 ? mcause : _T_70; // @[Lookup.scala 33:37]
  wire [31:0] _T_72 = _T_56 ? mepc : _T_71; // @[Lookup.scala 33:37]
  wire [31:0] _T_73 = _T_54 ? mscratch : _T_72; // @[Lookup.scala 33:37]
  wire [31:0] _T_74 = _T_52 ? timeh : _T_73; // @[Lookup.scala 33:37]
  wire [31:0] _T_75 = _T_50 ? time_ : _T_74; // @[Lookup.scala 33:37]
  wire [31:0] _T_76 = _T_48 ? 32'h0 : _T_75; // @[Lookup.scala 33:37]
  wire [31:0] _T_77 = _T_46 ? mie : _T_76; // @[Lookup.scala 33:37]
  wire [31:0] _T_78 = _T_44 ? 32'h0 : _T_77; // @[Lookup.scala 33:37]
  wire [31:0] _T_79 = _T_42 ? mtvec : _T_78; // @[Lookup.scala 33:37]
  wire [31:0] _T_80 = _T_40 ? 32'h0 : _T_79; // @[Lookup.scala 33:37]
  wire [31:0] _T_81 = _T_38 ? 32'h0 : _T_80; // @[Lookup.scala 33:37]
  wire [31:0] _T_82 = _T_36 ? 32'h100100 : _T_81; // @[Lookup.scala 33:37]
  wire [31:0] _T_83 = _T_34 ? instreth : _T_82; // @[Lookup.scala 33:37]
  wire [31:0] _T_84 = _T_32 ? timeh : _T_83; // @[Lookup.scala 33:37]
  wire [31:0] _T_85 = _T_30 ? cycleh : _T_84; // @[Lookup.scala 33:37]
  wire [31:0] _T_86 = _T_28 ? instret : _T_85; // @[Lookup.scala 33:37]
  wire [31:0] _T_87 = _T_26 ? time_ : _T_86; // @[Lookup.scala 33:37]
  wire [31:0] _T_88 = _T_24 ? 32'h0 : _T_87; // @[Lookup.scala 33:37]
  wire [31:0] _T_89 = _T_22 ? cycle : _T_88; // @[Lookup.scala 33:37]
  wire [31:0] _T_90 = _T_20 ? instreth : _T_89; // @[Lookup.scala 33:37]
  wire [31:0] _T_91 = _T_18 ? timeh : _T_90; // @[Lookup.scala 33:37]
  wire [31:0] _T_92 = _T_16 ? cycleh : _T_91; // @[Lookup.scala 33:37]
  wire [31:0] _T_93 = _T_14 ? instret : _T_92; // @[Lookup.scala 33:37]
  wire [31:0] _T_94 = _T_12 ? time_ : _T_93; // @[Lookup.scala 33:37]
  wire [31:0] _T_97 = time_ + 32'h1; // @[csr.scala 282:16]
  wire [31:0] _T_100 = timeh + 32'h1; // @[csr.scala 283:36]
  wire [31:0] _GEN_0 = &time_ ? _T_100 : timeh; // @[csr.scala 283:19 csr.scala 283:27 csr.scala 177:31]
  wire [31:0] _T_102 = cycle + 32'h1; // @[csr.scala 284:18]
  wire [31:0] _T_105 = cycleh + 32'h1; // @[csr.scala 285:39]
  wire [31:0] _GEN_1 = &cycle ? _T_105 : cycleh; // @[csr.scala 285:20 csr.scala 285:29 csr.scala 179:31]
  wire  privInst = io_cmd == 32'h4; // @[csr.scala 291:35]
  wire  isExtInt = MEIP & MEIE; // @[csr.scala 293:33]
  wire  _T_111 = ~io_addr[8]; // @[csr.scala 294:56]
  wire  isEcall = privInst & ~io_addr[0] & ~io_addr[8]; // @[csr.scala 294:53]
  wire  isEbreak = privInst & io_addr[0] & _T_111; // @[csr.scala 295:53]
  wire  wen = io_cmd == 32'h1 | io_cmd[1] & |io_rs1_addr; // @[csr.scala 296:47]
  wire  _T_121 = ~io_pc_invalid; // @[csr.scala 299:41]
  wire  isIllegal = ~io_legal & ~io_pc_invalid; // @[csr.scala 299:38]
  reg [31:0] pre_mepc; // @[csr.scala 302:37]
  reg [31:0] pre_calc_addr; // @[csr.scala 304:37]
  wire  iaddrInvalid_b = |io_pc[1:0]; // @[csr.scala 313:41]
  wire  _T_125 = |alu_calc_addr[1:0]; // @[csr.scala 314:63]
  wire  iaddrInvalid_j = io_j_check & |alu_calc_addr[1:0]; // @[csr.scala 314:41]
  wire  _T_126 = io_mem_wr == 2'h1; // @[csr.scala 316:16]
  wire  _T_127 = io_mask_type == 3'h3; // @[csr.scala 316:42]
  wire  _T_128 = io_mem_wr == 2'h1 & io_mask_type == 3'h3; // @[csr.scala 316:26]
  wire  _T_132 = io_mask_type == 3'h2; // @[csr.scala 317:42]
  wire  _T_133 = _T_126 & io_mask_type == 3'h2; // @[csr.scala 317:26]
  wire  _T_137 = _T_126 & io_mask_type == 3'h6; // @[csr.scala 318:26]
  wire  _T_140 = _T_133 ? alu_calc_addr[0] : _T_137 & alu_calc_addr[0]; // @[Mux.scala 98:16]
  wire  laddrInvalid = _T_128 ? _T_125 : _T_140; // @[Mux.scala 98:16]
  wire  _T_141 = io_mem_wr == 2'h2; // @[csr.scala 321:16]
  wire  _T_143 = io_mem_wr == 2'h2 & _T_127; // @[csr.scala 321:26]
  wire  _T_148 = _T_141 & _T_132; // @[csr.scala 322:26]
  wire  saddrInvalid = _T_143 ? _T_125 : _T_148 & alu_calc_addr[0]; // @[Mux.scala 98:16]
  wire  _T_156 = ~io_stall; // @[csr.scala 325:96]
  wire  isInstRet = io_inst != 32'h13 & (~io_expt | isEcall | isEbreak) & ~io_stall; // @[csr.scala 325:93]
  wire [31:0] _T_158 = instret + 32'h1; // @[csr.scala 326:40]
  wire [31:0] _GEN_5 = isInstRet ? _T_158 : instret; // @[csr.scala 326:19 csr.scala 326:29 csr.scala 180:31]
  wire [31:0] _T_162 = instreth + 32'h1; // @[csr.scala 327:58]
  wire [31:0] _GEN_6 = isInstRet & &instret ? _T_162 : instreth; // @[csr.scala 327:35 csr.scala 327:46 csr.scala 181:31]
  wire [31:0] _T_172 = {io_pc[31:2], 2'h0}; // @[csr.scala 336:28]
  wire [31:0] _T_180 = {alu_calc_addr[31:1], 1'h0}; // @[csr.scala 353:40]
  wire [31:0] _T_182 = _T_180 + 32'h2; // @[csr.scala 353:55]
  wire [31:0] _GEN_8 = alu_calc_addr[0] & ~alu_calc_addr[1] ? _T_182 : _T_180; // @[csr.scala 352:53 csr.scala 353:17 csr.scala 355:17]
  wire [31:0] _GEN_10 = iaddrInvalid_j ? _GEN_8 : io_inst; // @[csr.scala 350:34 csr.scala 359:15]
  wire [31:0] _GEN_12 = laddrInvalid | saddrInvalid ? alu_calc_addr : _GEN_10; // @[csr.scala 347:47 csr.scala 349:15]
  wire [31:0] _GEN_13 = iaddrInvalid_b ? pre_mepc : io_pc; // @[csr.scala 344:34 csr.scala 345:14]
  wire [31:0] _GEN_14 = iaddrInvalid_b ? pre_calc_addr : _GEN_12; // @[csr.scala 344:34 csr.scala 346:15]
  wire [31:0] _GEN_15 = isExtInt ? valid_pc : _GEN_13; // @[csr.scala 341:21 csr.scala 342:14]
  wire [2:0] _T_191 = saddrInvalid ? 3'h6 : 3'h0; // @[csr.scala 367:22]
  wire [2:0] _T_192 = laddrInvalid ? 3'h4 : _T_191; // @[csr.scala 366:20]
  wire [2:0] _T_193 = isIllegal ? 3'h2 : _T_192; // @[csr.scala 365:18]
  wire [2:0] _T_194 = iaddrInvalid_j | iaddrInvalid_b ? 3'h0 : _T_193; // @[csr.scala 364:16]
  wire [2:0] _T_195 = isEbreak ? 3'h3 : _T_194; // @[csr.scala 363:14]
  wire [31:0] _T_206 = {{2'd0}, wdata[31:2]}; // @[csr.scala 406:23]
  wire [33:0] _GEN_236 = {_T_206, 2'h0}; // @[csr.scala 406:30]
  wire [34:0] _T_207 = {{1'd0}, _GEN_236}; // @[csr.scala 406:30]
  wire [31:0] _T_209 = wdata & 32'h8000000f; // @[csr.scala 409:25]
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
  wire [31:0] _GEN_27 = io_addr == 32'h901 ? wdata : _T_97; // @[csr.scala 423:45 csr.scala 424:14 csr.scala 282:8]
  wire [31:0] _GEN_28 = io_addr == 32'h901 ? _GEN_5 : _GEN_23; // @[csr.scala 423:45]
  wire [31:0] _GEN_29 = io_addr == 32'h901 ? _GEN_1 : _GEN_24; // @[csr.scala 423:45]
  wire [31:0] _GEN_30 = io_addr == 32'h901 ? _GEN_0 : _GEN_25; // @[csr.scala 423:45]
  wire [31:0] _GEN_31 = io_addr == 32'h901 ? _GEN_6 : _GEN_26; // @[csr.scala 423:45]
  wire [31:0] _GEN_32 = io_addr == 32'h900 ? wdata : _T_102; // @[csr.scala 420:46 csr.scala 421:15 csr.scala 284:9]
  wire [31:0] _GEN_33 = io_addr == 32'h900 ? _T_97 : _GEN_27; // @[csr.scala 420:46 csr.scala 282:8]
  wire [31:0] _GEN_34 = io_addr == 32'h900 ? _GEN_5 : _GEN_28; // @[csr.scala 420:46]
  wire [31:0] _GEN_35 = io_addr == 32'h900 ? _GEN_1 : _GEN_29; // @[csr.scala 420:46]
  wire [31:0] _GEN_36 = io_addr == 32'h900 ? _GEN_0 : _GEN_30; // @[csr.scala 420:46]
  wire [31:0] _GEN_37 = io_addr == 32'h900 ? _GEN_6 : _GEN_31; // @[csr.scala 420:46]
  wire [31:0] _GEN_39 = io_addr == 32'h781 ? _T_102 : _GEN_32; // @[csr.scala 417:49 csr.scala 284:9]
  wire [31:0] _GEN_40 = io_addr == 32'h781 ? _T_97 : _GEN_33; // @[csr.scala 417:49 csr.scala 282:8]
  wire [31:0] _GEN_41 = io_addr == 32'h781 ? _GEN_5 : _GEN_34; // @[csr.scala 417:49]
  wire [31:0] _GEN_42 = io_addr == 32'h781 ? _GEN_1 : _GEN_35; // @[csr.scala 417:49]
  wire [31:0] _GEN_43 = io_addr == 32'h781 ? _GEN_0 : _GEN_36; // @[csr.scala 417:49]
  wire [31:0] _GEN_44 = io_addr == 32'h781 ? _GEN_6 : _GEN_37; // @[csr.scala 417:49]
  wire [31:0] _GEN_47 = io_addr == 32'h780 ? _T_102 : _GEN_39; // @[csr.scala 414:47 csr.scala 284:9]
  wire [31:0] _GEN_48 = io_addr == 32'h780 ? _T_97 : _GEN_40; // @[csr.scala 414:47 csr.scala 282:8]
  wire [31:0] _GEN_49 = io_addr == 32'h780 ? _GEN_5 : _GEN_41; // @[csr.scala 414:47]
  wire [31:0] _GEN_50 = io_addr == 32'h780 ? _GEN_1 : _GEN_42; // @[csr.scala 414:47]
  wire [31:0] _GEN_51 = io_addr == 32'h780 ? _GEN_0 : _GEN_43; // @[csr.scala 414:47]
  wire [31:0] _GEN_52 = io_addr == 32'h780 ? _GEN_6 : _GEN_44; // @[csr.scala 414:47]
  wire [31:0] _GEN_53 = io_addr == 32'h342 ? _T_209 : mcause; // @[csr.scala 408:46 csr.scala 409:16 csr.scala 236:29]
  wire [31:0] _GEN_56 = io_addr == 32'h342 ? _T_102 : _GEN_47; // @[csr.scala 408:46 csr.scala 284:9]
  wire [31:0] _GEN_57 = io_addr == 32'h342 ? _T_97 : _GEN_48; // @[csr.scala 408:46 csr.scala 282:8]
  wire [31:0] _GEN_58 = io_addr == 32'h342 ? _GEN_5 : _GEN_49; // @[csr.scala 408:46]
  wire [31:0] _GEN_59 = io_addr == 32'h342 ? _GEN_1 : _GEN_50; // @[csr.scala 408:46]
  wire [31:0] _GEN_60 = io_addr == 32'h342 ? _GEN_0 : _GEN_51; // @[csr.scala 408:46]
  wire [31:0] _GEN_61 = io_addr == 32'h342 ? _GEN_6 : _GEN_52; // @[csr.scala 408:46]
  wire [34:0] _GEN_62 = io_addr == 32'h341 ? _T_207 : {{3'd0}, mepc}; // @[csr.scala 405:44 csr.scala 406:14 csr.scala 235:29]
  wire [31:0] _GEN_63 = io_addr == 32'h341 ? mcause : _GEN_53; // @[csr.scala 405:44 csr.scala 236:29]
  wire [31:0] _GEN_66 = io_addr == 32'h341 ? _T_102 : _GEN_56; // @[csr.scala 405:44 csr.scala 284:9]
  wire [31:0] _GEN_67 = io_addr == 32'h341 ? _T_97 : _GEN_57; // @[csr.scala 405:44 csr.scala 282:8]
  wire [31:0] _GEN_68 = io_addr == 32'h341 ? _GEN_5 : _GEN_58; // @[csr.scala 405:44]
  wire [31:0] _GEN_69 = io_addr == 32'h341 ? _GEN_1 : _GEN_59; // @[csr.scala 405:44]
  wire [31:0] _GEN_70 = io_addr == 32'h341 ? _GEN_0 : _GEN_60; // @[csr.scala 405:44]
  wire [31:0] _GEN_71 = io_addr == 32'h341 ? _GEN_6 : _GEN_61; // @[csr.scala 405:44]
  wire [31:0] _GEN_72 = io_addr == 32'h340 ? wdata : mscratch; // @[csr.scala 402:48 csr.scala 403:18 csr.scala 233:29]
  wire [34:0] _GEN_73 = io_addr == 32'h340 ? {{3'd0}, mepc} : _GEN_62; // @[csr.scala 402:48 csr.scala 235:29]
  wire [31:0] _GEN_74 = io_addr == 32'h340 ? mcause : _GEN_63; // @[csr.scala 402:48 csr.scala 236:29]
  wire [31:0] _GEN_77 = io_addr == 32'h340 ? _T_102 : _GEN_66; // @[csr.scala 402:48 csr.scala 284:9]
  wire [31:0] _GEN_78 = io_addr == 32'h340 ? _T_97 : _GEN_67; // @[csr.scala 402:48 csr.scala 282:8]
  wire [31:0] _GEN_79 = io_addr == 32'h340 ? _GEN_5 : _GEN_68; // @[csr.scala 402:48]
  wire [31:0] _GEN_80 = io_addr == 32'h340 ? _GEN_1 : _GEN_69; // @[csr.scala 402:48]
  wire [31:0] _GEN_81 = io_addr == 32'h340 ? _GEN_0 : _GEN_70; // @[csr.scala 402:48]
  wire [31:0] _GEN_82 = io_addr == 32'h340 ? _GEN_6 : _GEN_71; // @[csr.scala 402:48]
  wire [31:0] _GEN_83 = io_addr == 32'h305 ? wdata : mtvec; // @[csr.scala 399:45 csr.scala 400:15 csr.scala 209:31]
  wire [31:0] _GEN_84 = io_addr == 32'h305 ? mscratch : _GEN_72; // @[csr.scala 399:45 csr.scala 233:29]
  wire [34:0] _GEN_85 = io_addr == 32'h305 ? {{3'd0}, mepc} : _GEN_73; // @[csr.scala 399:45 csr.scala 235:29]
  wire [31:0] _GEN_86 = io_addr == 32'h305 ? mcause : _GEN_74; // @[csr.scala 399:45 csr.scala 236:29]
  wire [31:0] _GEN_89 = io_addr == 32'h305 ? _T_102 : _GEN_77; // @[csr.scala 399:45 csr.scala 284:9]
  wire [31:0] _GEN_90 = io_addr == 32'h305 ? _T_97 : _GEN_78; // @[csr.scala 399:45 csr.scala 282:8]
  wire [31:0] _GEN_91 = io_addr == 32'h305 ? _GEN_5 : _GEN_79; // @[csr.scala 399:45]
  wire [31:0] _GEN_92 = io_addr == 32'h305 ? _GEN_1 : _GEN_80; // @[csr.scala 399:45]
  wire [31:0] _GEN_93 = io_addr == 32'h305 ? _GEN_0 : _GEN_81; // @[csr.scala 399:45]
  wire [31:0] _GEN_94 = io_addr == 32'h305 ? _GEN_6 : _GEN_82; // @[csr.scala 399:45]
  wire [31:0] _GEN_95 = io_addr == 32'h741 ? wdata : _GEN_93; // @[csr.scala 392:46 csr.scala 393:15]
  wire [31:0] _GEN_96 = io_addr == 32'h741 ? mtvec : _GEN_83; // @[csr.scala 392:46 csr.scala 209:31]
  wire [31:0] _GEN_97 = io_addr == 32'h741 ? mscratch : _GEN_84; // @[csr.scala 392:46 csr.scala 233:29]
  wire [34:0] _GEN_98 = io_addr == 32'h741 ? {{3'd0}, mepc} : _GEN_85; // @[csr.scala 392:46 csr.scala 235:29]
  wire [31:0] _GEN_99 = io_addr == 32'h741 ? mcause : _GEN_86; // @[csr.scala 392:46 csr.scala 236:29]
  wire [31:0] _GEN_102 = io_addr == 32'h741 ? _T_102 : _GEN_89; // @[csr.scala 392:46 csr.scala 284:9]
  wire [31:0] _GEN_103 = io_addr == 32'h741 ? _T_97 : _GEN_90; // @[csr.scala 392:46 csr.scala 282:8]
  wire [31:0] _GEN_104 = io_addr == 32'h741 ? _GEN_5 : _GEN_91; // @[csr.scala 392:46]
  wire [31:0] _GEN_105 = io_addr == 32'h741 ? _GEN_1 : _GEN_92; // @[csr.scala 392:46]
  wire [31:0] _GEN_106 = io_addr == 32'h741 ? _GEN_6 : _GEN_94; // @[csr.scala 392:46]
  wire [31:0] _GEN_107 = io_addr == 32'h701 ? wdata : _GEN_103; // @[csr.scala 389:46 csr.scala 390:14]
  wire [31:0] _GEN_108 = io_addr == 32'h701 ? _GEN_0 : _GEN_95; // @[csr.scala 389:46]
  wire [31:0] _GEN_109 = io_addr == 32'h701 ? mtvec : _GEN_96; // @[csr.scala 389:46 csr.scala 209:31]
  wire [31:0] _GEN_110 = io_addr == 32'h701 ? mscratch : _GEN_97; // @[csr.scala 389:46 csr.scala 233:29]
  wire [34:0] _GEN_111 = io_addr == 32'h701 ? {{3'd0}, mepc} : _GEN_98; // @[csr.scala 389:46 csr.scala 235:29]
  wire [31:0] _GEN_112 = io_addr == 32'h701 ? mcause : _GEN_99; // @[csr.scala 389:46 csr.scala 236:29]
  wire [31:0] _GEN_115 = io_addr == 32'h701 ? _T_102 : _GEN_102; // @[csr.scala 389:46 csr.scala 284:9]
  wire [31:0] _GEN_116 = io_addr == 32'h701 ? _GEN_5 : _GEN_104; // @[csr.scala 389:46]
  wire [31:0] _GEN_117 = io_addr == 32'h701 ? _GEN_1 : _GEN_105; // @[csr.scala 389:46]
  wire [31:0] _GEN_118 = io_addr == 32'h701 ? _GEN_6 : _GEN_106; // @[csr.scala 389:46]
  wire  _GEN_119 = io_addr == 32'h304 ? wdata[11] : MEIE; // @[csr.scala 385:44 csr.scala 386:14 csr.scala 217:27]
  wire  _GEN_120 = io_addr == 32'h304 ? wdata[7] : MTIE; // @[csr.scala 385:44 csr.scala 387:14 csr.scala 218:27]
  wire  _GEN_121 = io_addr == 32'h304 ? wdata[3] : MSIE; // @[csr.scala 385:44 csr.scala 388:14 csr.scala 226:27]
  wire [31:0] _GEN_122 = io_addr == 32'h304 ? _T_97 : _GEN_107; // @[csr.scala 385:44 csr.scala 282:8]
  wire [31:0] _GEN_123 = io_addr == 32'h304 ? _GEN_0 : _GEN_108; // @[csr.scala 385:44]
  wire [31:0] _GEN_124 = io_addr == 32'h304 ? mtvec : _GEN_109; // @[csr.scala 385:44 csr.scala 209:31]
  wire [31:0] _GEN_125 = io_addr == 32'h304 ? mscratch : _GEN_110; // @[csr.scala 385:44 csr.scala 233:29]
  wire [34:0] _GEN_126 = io_addr == 32'h304 ? {{3'd0}, mepc} : _GEN_111; // @[csr.scala 385:44 csr.scala 235:29]
  wire [31:0] _GEN_127 = io_addr == 32'h304 ? mcause : _GEN_112; // @[csr.scala 385:44 csr.scala 236:29]
  wire [31:0] _GEN_130 = io_addr == 32'h304 ? _T_102 : _GEN_115; // @[csr.scala 385:44 csr.scala 284:9]
  wire [31:0] _GEN_131 = io_addr == 32'h304 ? _GEN_5 : _GEN_116; // @[csr.scala 385:44]
  wire [31:0] _GEN_132 = io_addr == 32'h304 ? _GEN_1 : _GEN_117; // @[csr.scala 385:44]
  wire [31:0] _GEN_133 = io_addr == 32'h304 ? _GEN_6 : _GEN_118; // @[csr.scala 385:44]
  wire  _GEN_134 = io_addr == 32'h344 ? wdata[7] : MTIP; // @[csr.scala 382:44 csr.scala 383:14 csr.scala 213:27]
  wire  _GEN_135 = io_addr == 32'h344 ? wdata[3] : MSIP; // @[csr.scala 382:44 csr.scala 384:14 csr.scala 223:27]
  wire  _GEN_136 = io_addr == 32'h344 ? MEIE : _GEN_119; // @[csr.scala 382:44 csr.scala 217:27]
  wire  _GEN_137 = io_addr == 32'h344 ? MTIE : _GEN_120; // @[csr.scala 382:44 csr.scala 218:27]
  wire  _GEN_138 = io_addr == 32'h344 ? MSIE : _GEN_121; // @[csr.scala 382:44 csr.scala 226:27]
  wire [31:0] _GEN_139 = io_addr == 32'h344 ? _T_97 : _GEN_122; // @[csr.scala 382:44 csr.scala 282:8]
  wire [31:0] _GEN_140 = io_addr == 32'h344 ? _GEN_0 : _GEN_123; // @[csr.scala 382:44]
  wire [31:0] _GEN_141 = io_addr == 32'h344 ? mtvec : _GEN_124; // @[csr.scala 382:44 csr.scala 209:31]
  wire [31:0] _GEN_142 = io_addr == 32'h344 ? mscratch : _GEN_125; // @[csr.scala 382:44 csr.scala 233:29]
  wire [34:0] _GEN_143 = io_addr == 32'h344 ? {{3'd0}, mepc} : _GEN_126; // @[csr.scala 382:44 csr.scala 235:29]
  wire [31:0] _GEN_144 = io_addr == 32'h344 ? mcause : _GEN_127; // @[csr.scala 382:44 csr.scala 236:29]
  wire [31:0] _GEN_147 = io_addr == 32'h344 ? _T_102 : _GEN_130; // @[csr.scala 382:44 csr.scala 284:9]
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
  wire [31:0] _GEN_159 = io_addr == 32'h300 ? _T_97 : _GEN_139; // @[csr.scala 377:42 csr.scala 282:8]
  wire [31:0] _GEN_160 = io_addr == 32'h300 ? _GEN_0 : _GEN_140; // @[csr.scala 377:42]
  wire [31:0] _GEN_161 = io_addr == 32'h300 ? mtvec : _GEN_141; // @[csr.scala 377:42 csr.scala 209:31]
  wire [34:0] _GEN_163 = io_addr == 32'h300 ? {{3'd0}, mepc} : _GEN_143; // @[csr.scala 377:42 csr.scala 235:29]
  wire [31:0] _GEN_167 = io_addr == 32'h300 ? _T_102 : _GEN_147; // @[csr.scala 377:42 csr.scala 284:9]
  wire [31:0] _GEN_168 = io_addr == 32'h300 ? _GEN_5 : _GEN_148; // @[csr.scala 377:42]
  wire [31:0] _GEN_169 = io_addr == 32'h300 ? _GEN_1 : _GEN_149; // @[csr.scala 377:42]
  wire [31:0] _GEN_170 = io_addr == 32'h300 ? _GEN_6 : _GEN_150; // @[csr.scala 377:42]
  wire [34:0] _GEN_183 = wen ? _GEN_163 : {{3'd0}, mepc}; // @[csr.scala 376:21 csr.scala 235:29]
  wire [34:0] _GEN_191 = io_expt ? {{3'd0}, _GEN_15} : _GEN_183; // @[csr.scala 340:19]
  wire [34:0] _GEN_213 = _T_156 ? _GEN_191 : {{3'd0}, mepc}; // @[csr.scala 339:19 csr.scala 235:29]
  assign io_out = _T_10 ? cycle : _T_94; // @[Lookup.scala 33:37]
  assign io_expt = isEcall | isEbreak | isIllegal | isExtInt | iaddrInvalid_j | iaddrInvalid_b | laddrInvalid |
    saddrInvalid; // @[csr.scala 330:111]
  assign io_evec = mtvec; // @[csr.scala 331:11]
  assign io_epc = mepc; // @[csr.scala 333:10]
  always @(posedge clock) begin
    if (reset) begin // @[csr.scala 176:31]
      time_ <= 32'h0; // @[csr.scala 176:31]
    end else if (_T_156) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        time_ <= _T_97; // @[csr.scala 282:8]
      end else if (wen) begin // @[csr.scala 376:21]
        time_ <= _GEN_159;
      end else begin
        time_ <= _T_97; // @[csr.scala 282:8]
      end
    end else begin
      time_ <= _T_97; // @[csr.scala 282:8]
    end
    if (reset) begin // @[csr.scala 177:31]
      timeh <= 32'h0; // @[csr.scala 177:31]
    end else if (_T_156) begin // @[csr.scala 339:19]
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
    end else if (_T_156) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        cycle <= _T_102; // @[csr.scala 284:9]
      end else if (wen) begin // @[csr.scala 376:21]
        cycle <= _GEN_167;
      end else begin
        cycle <= _T_102; // @[csr.scala 284:9]
      end
    end else begin
      cycle <= _T_102; // @[csr.scala 284:9]
    end
    if (reset) begin // @[csr.scala 179:31]
      cycleh <= 32'h0; // @[csr.scala 179:31]
    end else if (_T_156) begin // @[csr.scala 339:19]
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
    end else if (_T_156) begin // @[csr.scala 339:19]
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
    end else if (_T_156) begin // @[csr.scala 339:19]
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
    end else if (_T_156) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        PRV1 <= 2'h3; // @[csr.scala 372:12]
      end else if (wen) begin // @[csr.scala 376:21]
        PRV1 <= _GEN_151;
      end
    end
    if (reset) begin // @[csr.scala 193:29]
      IE <= 1'h0; // @[csr.scala 193:29]
    end else if (_T_156) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        IE <= 1'h0; // @[csr.scala 371:10]
      end else if (wen) begin // @[csr.scala 376:21]
        IE <= _GEN_153;
      end
    end
    if (reset) begin // @[csr.scala 194:29]
      IE1 <= 1'h0; // @[csr.scala 194:29]
    end else if (_T_156) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        IE1 <= IE; // @[csr.scala 373:11]
      end else if (wen) begin // @[csr.scala 376:21]
        IE1 <= _GEN_152;
      end
    end
    if (reset) begin // @[csr.scala 209:31]
      mtvec <= 32'hdead; // @[csr.scala 209:31]
    end else if (_T_156) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          mtvec <= _GEN_161;
        end
      end
    end
    if (reset) begin // @[csr.scala 213:27]
      MTIP <= 1'h0; // @[csr.scala 213:27]
    end else if (_T_156) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          MTIP <= _GEN_154;
        end
      end
    end
    if (reset) begin // @[csr.scala 217:27]
      MEIE <= 1'h0; // @[csr.scala 217:27]
    end else if (_T_156) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          MEIE <= _GEN_156;
        end
      end
    end
    if (reset) begin // @[csr.scala 218:27]
      MTIE <= 1'h0; // @[csr.scala 218:27]
    end else if (_T_156) begin // @[csr.scala 339:19]
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
    end else if (_T_156) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          MSIP <= _GEN_155;
        end
      end
    end
    if (reset) begin // @[csr.scala 226:27]
      MSIE <= 1'h0; // @[csr.scala 226:27]
    end else if (_T_156) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          MSIE <= _GEN_158;
        end
      end
    end
    if (_T_156) begin // @[csr.scala 339:19]
      if (!(io_expt)) begin // @[csr.scala 340:19]
        if (wen) begin // @[csr.scala 376:21]
          if (!(io_addr == 32'h300)) begin // @[csr.scala 377:42]
            mscratch <= _GEN_142;
          end
        end
      end
    end
    mepc <= _GEN_213[31:0];
    if (_T_156) begin // @[csr.scala 339:19]
      if (io_expt) begin // @[csr.scala 340:19]
        if (isEcall) begin // @[csr.scala 361:20]
          mcause <= 32'hb;
        end else if (isExtInt) begin // @[csr.scala 362:12]
          mcause <= 32'h8000000b;
        end else begin
          mcause <= {{29'd0}, _T_195};
        end
      end else if (wen) begin // @[csr.scala 376:21]
        if (!(io_addr == 32'h300)) begin // @[csr.scala 377:42]
          mcause <= _GEN_144;
        end
      end
    end
    if (reset) begin // @[csr.scala 242:33]
      mtval <= 32'h13; // @[csr.scala 242:33]
    end else if (_T_156) begin // @[csr.scala 339:19]
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
    end else if (_T_121) begin // @[csr.scala 335:24]
      valid_pc <= _T_172; // @[csr.scala 336:14]
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
  wire  hi = io_alu_op[3] & shin[31]; // @[ALU.scala 54:47]
  wire [32:0] _T_61 = {hi,shin}; // @[ALU.scala 54:65]
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
  reg [31:0] _RAND_99;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] idm_io_imem; // @[core.scala 181:31]
  wire [31:0] idm_io_inst_bits; // @[core.scala 181:31]
  wire [4:0] idm_io_inst_rd; // @[core.scala 181:31]
  wire [4:0] idm_io_inst_rs1; // @[core.scala 181:31]
  wire [4:0] idm_io_inst_rs2; // @[core.scala 181:31]
  wire [11:0] idm_io_inst_csr; // @[core.scala 181:31]
  wire  csr_clock; // @[core.scala 208:26]
  wire  csr_reset; // @[core.scala 208:26]
  wire [31:0] csr_io_addr; // @[core.scala 208:26]
  wire [31:0] csr_io_in; // @[core.scala 208:26]
  wire [31:0] csr_io_out; // @[core.scala 208:26]
  wire [31:0] csr_io_cmd; // @[core.scala 208:26]
  wire [31:0] csr_io_rs1_addr; // @[core.scala 208:26]
  wire  csr_io_legal; // @[core.scala 208:26]
  wire  csr_io_interrupt_sig; // @[core.scala 208:26]
  wire [31:0] csr_io_pc; // @[core.scala 208:26]
  wire  csr_io_pc_invalid; // @[core.scala 208:26]
  wire  csr_io_j_check; // @[core.scala 208:26]
  wire  csr_io_b_check; // @[core.scala 208:26]
  wire  csr_io_stall; // @[core.scala 208:26]
  wire  csr_io_expt; // @[core.scala 208:26]
  wire [31:0] csr_io_evec; // @[core.scala 208:26]
  wire [31:0] csr_io_epc; // @[core.scala 208:26]
  wire [31:0] csr_io_inst; // @[core.scala 208:26]
  wire [1:0] csr_io_mem_wr; // @[core.scala 208:26]
  wire [2:0] csr_io_mask_type; // @[core.scala 208:26]
  wire [31:0] csr_io_alu_op1; // @[core.scala 208:26]
  wire [31:0] csr_io_alu_op2; // @[core.scala 208:26]
  wire [31:0] alu_io_op1; // @[core.scala 256:26]
  wire [31:0] alu_io_op2; // @[core.scala 256:26]
  wire [3:0] alu_io_alu_op; // @[core.scala 256:26]
  wire [31:0] alu_io_out; // @[core.scala 256:26]
  wire  alu_io_cmp_out; // @[core.scala 256:26]
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
  wire  _T_1773 = delay_stall != 4'h7; // @[core.scala 110:26]
  wire [3:0] _T_1775 = delay_stall + 4'h1; // @[core.scala 111:40]
  reg  valid_imem; // @[core.scala 118:35]
  wire  waitrequest = io_sw_w_waitrequest_sig | io_sw_w_datawaitreq_sig; // @[core.scala 121:39]
  reg  imem_req; // @[core.scala 124:27]
  wire  _T_3578 = mem_ctrl_mem_wr == 2'h1; // @[core.scala 212:25]
  wire  _T_3580 = mem_ctrl_mem_wr == 2'h1 | ex_ctrl_mem_wr == 2'h1; // @[core.scala 212:36]
  wire  _T_3581 = (ex_reg_waddr == idm_io_inst_rs1 | ex_reg_waddr == idm_io_inst_rs2) & _T_3580; // @[core.scala 211:74]
  wire  _T_3805 = mem_ctrl_br_type > 4'h3 & mem_alu_cmp_out; // @[core.scala 423:33]
  wire  _T_3806 = mem_ctrl_br_type == 4'h2; // @[core.scala 424:27]
  wire  _T_3807 = mem_ctrl_br_type > 4'h3 & mem_alu_cmp_out | _T_3806; // @[core.scala 423:53]
  wire  _T_3808 = mem_ctrl_br_type == 4'h1; // @[core.scala 425:27]
  wire  _T_3809 = _T_3807 | _T_3808; // @[core.scala 424:38]
  wire  _T_3810 = mem_ctrl_br_type == 4'h3; // @[core.scala 426:27]
  wire  inst_kill_branch = _T_3809 | _T_3810; // @[core.scala 425:37]
  wire  inst_kill = inst_kill_branch | csr_io_expt; // @[core.scala 428:36]
  wire  _T_3582 = ~inst_kill; // @[core.scala 212:71]
  wire  _T_3588 = idm_io_inst_rs1 != 5'h0 & idm_io_inst_rs1 == rf_waddr & _T_3582; // @[core.scala 213:57]
  wire  _T_3589 = _T_3581 & ~inst_kill | _T_3588; // @[core.scala 212:84]
  wire  _T_3594 = idm_io_inst_rs2 != 5'h0 & idm_io_inst_rs2 == rf_waddr & _T_3582; // @[core.scala 214:57]
  wire  _T_3595 = _T_3589 | _T_3594; // @[core.scala 213:73]
  wire  stall = _T_3595 | _T_1773; // @[core.scala 214:73]
  wire  _T_1776 = ~stall; // @[core.scala 125:10]
  wire  _T_1779 = ~waitrequest; // @[core.scala 125:34]
  wire  _T_1780 = ~stall & _T_3582 & ~waitrequest; // @[core.scala 125:31]
  reg  REG_1; // @[core.scala 128:28]
  wire  _T_1782 = inst_kill & _T_1779; // @[core.scala 130:26]
  reg  REG_3; // @[core.scala 133:28]
  wire  _T_1784 = mem_ctrl_mem_wr == 2'h2; // @[core.scala 137:60]
  reg [31:0] id_inst_temp; // @[core.scala 146:37]
  reg [31:0] id_pc_temp; // @[core.scala 147:35]
  reg [31:0] id_npc_temp; // @[core.scala 148:36]
  wire  _T_1793 = _T_1776 & _T_1779; // @[core.scala 155:23]
  wire [31:0] _GEN_11 = _T_1776 & ~(valid_imem & io_r_imem_dat_ack) & _T_3582 & _T_1779 ? id_pc_temp : id_pc; // @[core.scala 167:92 core.scala 168:15 core.scala 176:15]
  wire [31:0] _GEN_12 = _T_1776 & ~(valid_imem & io_r_imem_dat_ack) & _T_3582 & _T_1779 ? id_npc_temp : id_npc; // @[core.scala 167:92 core.scala 169:16 core.scala 177:16]
  wire [31:0] _GEN_13 = _T_1776 & ~(valid_imem & io_r_imem_dat_ack) & _T_3582 & _T_1779 ? id_inst_temp : id_inst; // @[core.scala 167:92 core.scala 170:17 core.scala 178:17]
  wire [31:0] _GEN_14 = _T_1776 & ~(valid_imem & io_r_imem_dat_ack) & _T_3582 & _T_1779 ? 32'h0 : id_pc_temp; // @[core.scala 167:92 core.scala 172:20 core.scala 147:35]
  wire [31:0] _GEN_15 = _T_1776 & ~(valid_imem & io_r_imem_dat_ack) & _T_3582 & _T_1779 ? 32'h4 : id_npc_temp; // @[core.scala 167:92 core.scala 173:21 core.scala 148:36]
  wire [31:0] _GEN_16 = _T_1776 & ~(valid_imem & io_r_imem_dat_ack) & _T_3582 & _T_1779 ? 32'h13 : id_inst_temp; // @[core.scala 167:92 core.scala 174:22 core.scala 146:37]
  wire [31:0] _T_1808 = idm_io_inst_bits & 32'h7f; // @[control.scala 192:55]
  wire  _T_1809 = 32'h37 == _T_1808; // @[control.scala 192:55]
  wire  _T_1811 = 32'h17 == _T_1808; // @[control.scala 192:55]
  wire  _T_1813 = 32'h6f == _T_1808; // @[control.scala 192:55]
  wire [31:0] _T_1814 = idm_io_inst_bits & 32'h707f; // @[control.scala 192:55]
  wire  _T_1815 = 32'h67 == _T_1814; // @[control.scala 192:55]
  wire  _T_1817 = 32'h63 == _T_1814; // @[control.scala 192:55]
  wire  _T_1819 = 32'h1063 == _T_1814; // @[control.scala 192:55]
  wire  _T_1821 = 32'h4063 == _T_1814; // @[control.scala 192:55]
  wire  _T_1823 = 32'h5063 == _T_1814; // @[control.scala 192:55]
  wire  _T_1825 = 32'h6063 == _T_1814; // @[control.scala 192:55]
  wire  _T_1827 = 32'h7063 == _T_1814; // @[control.scala 192:55]
  wire  _T_1829 = 32'h3 == _T_1814; // @[control.scala 192:55]
  wire  _T_1831 = 32'h1003 == _T_1814; // @[control.scala 192:55]
  wire  _T_1833 = 32'h2003 == _T_1814; // @[control.scala 192:55]
  wire  _T_1835 = 32'h4003 == _T_1814; // @[control.scala 192:55]
  wire  _T_1837 = 32'h5003 == _T_1814; // @[control.scala 192:55]
  wire  _T_1839 = 32'h23 == _T_1814; // @[control.scala 192:55]
  wire  _T_1841 = 32'h1023 == _T_1814; // @[control.scala 192:55]
  wire  _T_1843 = 32'h2023 == _T_1814; // @[control.scala 192:55]
  wire  _T_1845 = 32'h13 == _T_1814; // @[control.scala 192:55]
  wire  _T_1847 = 32'h2013 == _T_1814; // @[control.scala 192:55]
  wire  _T_1849 = 32'h3013 == _T_1814; // @[control.scala 192:55]
  wire  _T_1851 = 32'h4013 == _T_1814; // @[control.scala 192:55]
  wire  _T_1853 = 32'h6013 == _T_1814; // @[control.scala 192:55]
  wire  _T_1855 = 32'h7013 == _T_1814; // @[control.scala 192:55]
  wire [31:0] _T_1856 = idm_io_inst_bits & 32'hfe00707f; // @[control.scala 192:55]
  wire  _T_1857 = 32'h1013 == _T_1856; // @[control.scala 192:55]
  wire [31:0] _T_1858 = idm_io_inst_bits & 32'hfc00707f; // @[control.scala 192:55]
  wire  _T_1859 = 32'h5013 == _T_1858; // @[control.scala 192:55]
  wire  _T_1861 = 32'h40005013 == _T_1858; // @[control.scala 192:55]
  wire  _T_1863 = 32'h33 == _T_1856; // @[control.scala 192:55]
  wire  _T_1865 = 32'h40000033 == _T_1856; // @[control.scala 192:55]
  wire  _T_1867 = 32'h1033 == _T_1856; // @[control.scala 192:55]
  wire  _T_1869 = 32'h2033 == _T_1856; // @[control.scala 192:55]
  wire  _T_1871 = 32'h3033 == _T_1856; // @[control.scala 192:55]
  wire  _T_1873 = 32'h4033 == _T_1856; // @[control.scala 192:55]
  wire  _T_1875 = 32'h5033 == _T_1856; // @[control.scala 192:55]
  wire  _T_1877 = 32'h40005033 == _T_1856; // @[control.scala 192:55]
  wire  _T_1879 = 32'h6033 == _T_1856; // @[control.scala 192:55]
  wire  _T_1881 = 32'h7033 == _T_1856; // @[control.scala 192:55]
  wire  _T_1883 = 32'h5073 == _T_1814; // @[control.scala 192:55]
  wire  _T_1885 = 32'h6073 == _T_1814; // @[control.scala 192:55]
  wire  _T_1887 = 32'h7073 == _T_1814; // @[control.scala 192:55]
  wire  _T_1889 = 32'h1073 == _T_1814; // @[control.scala 192:55]
  wire  _T_1891 = 32'h2073 == _T_1814; // @[control.scala 192:55]
  wire  _T_1893 = 32'h3073 == _T_1814; // @[control.scala 192:55]
  wire [31:0] _T_1894 = idm_io_inst_bits; // @[control.scala 192:55]
  wire  _T_1895 = 32'h73 == _T_1894; // @[control.scala 192:55]
  wire  _T_1897 = 32'h30200073 == _T_1894; // @[control.scala 192:55]
  wire  _T_1899 = 32'h10000073 == _T_1894; // @[control.scala 192:55]
  wire  _T_1901 = 32'h100073 == _T_1894; // @[control.scala 192:55]
  wire  _T_1903 = 32'h100f == _T_1814; // @[control.scala 192:55]
  wire  _T_1905 = 32'hf == _T_1814; // @[control.scala 192:55]
  wire  _T_1936 = _T_1845 | (_T_1847 | (_T_1849 | (_T_1851 | (_T_1853 | (_T_1855 | (_T_1857 | (_T_1859 | (_T_1861 | (
    _T_1863 | (_T_1865 | (_T_1867 | (_T_1869 | (_T_1871 | (_T_1873 | (_T_1875 | (_T_1877 | (_T_1879 | (_T_1881 | (
    _T_1883 | (_T_1885 | (_T_1887 | (_T_1889 | (_T_1891 | (_T_1893 | (_T_1895 | (_T_1897 | (_T_1899 | (_T_1901 | (
    _T_1903 | _T_1905))))))))))))))))))))))))))))); // @[Mux.scala 98:16]
  wire  id_ctrl_legal = _T_1809 | (_T_1811 | (_T_1813 | (_T_1815 | (_T_1817 | (_T_1819 | (_T_1821 | (_T_1823 | (_T_1825
     | (_T_1827 | (_T_1829 | (_T_1831 | (_T_1833 | (_T_1835 | (_T_1837 | (_T_1839 | (_T_1841 | (_T_1843 | _T_1936)))))))
    )))))))))); // @[Mux.scala 98:16]
  wire [1:0] _T_2057 = _T_1897 ? 2'h3 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_2058 = _T_1895 ? 2'h0 : _T_2057; // @[Mux.scala 98:16]
  wire [1:0] _T_2059 = _T_1893 ? 2'h0 : _T_2058; // @[Mux.scala 98:16]
  wire [1:0] _T_2060 = _T_1891 ? 2'h0 : _T_2059; // @[Mux.scala 98:16]
  wire [1:0] _T_2061 = _T_1889 ? 2'h0 : _T_2060; // @[Mux.scala 98:16]
  wire [1:0] _T_2062 = _T_1887 ? 2'h0 : _T_2061; // @[Mux.scala 98:16]
  wire [1:0] _T_2063 = _T_1885 ? 2'h0 : _T_2062; // @[Mux.scala 98:16]
  wire [1:0] _T_2064 = _T_1883 ? 2'h0 : _T_2063; // @[Mux.scala 98:16]
  wire [1:0] _T_2065 = _T_1881 ? 2'h0 : _T_2064; // @[Mux.scala 98:16]
  wire [1:0] _T_2066 = _T_1879 ? 2'h0 : _T_2065; // @[Mux.scala 98:16]
  wire [1:0] _T_2067 = _T_1877 ? 2'h0 : _T_2066; // @[Mux.scala 98:16]
  wire [1:0] _T_2068 = _T_1875 ? 2'h0 : _T_2067; // @[Mux.scala 98:16]
  wire [1:0] _T_2069 = _T_1873 ? 2'h0 : _T_2068; // @[Mux.scala 98:16]
  wire [1:0] _T_2070 = _T_1871 ? 2'h0 : _T_2069; // @[Mux.scala 98:16]
  wire [1:0] _T_2071 = _T_1869 ? 2'h0 : _T_2070; // @[Mux.scala 98:16]
  wire [1:0] _T_2072 = _T_1867 ? 2'h0 : _T_2071; // @[Mux.scala 98:16]
  wire [1:0] _T_2073 = _T_1865 ? 2'h0 : _T_2072; // @[Mux.scala 98:16]
  wire [1:0] _T_2074 = _T_1863 ? 2'h0 : _T_2073; // @[Mux.scala 98:16]
  wire [1:0] _T_2075 = _T_1861 ? 2'h0 : _T_2074; // @[Mux.scala 98:16]
  wire [1:0] _T_2076 = _T_1859 ? 2'h0 : _T_2075; // @[Mux.scala 98:16]
  wire [1:0] _T_2077 = _T_1857 ? 2'h0 : _T_2076; // @[Mux.scala 98:16]
  wire [1:0] _T_2078 = _T_1855 ? 2'h0 : _T_2077; // @[Mux.scala 98:16]
  wire [1:0] _T_2079 = _T_1853 ? 2'h0 : _T_2078; // @[Mux.scala 98:16]
  wire [1:0] _T_2080 = _T_1851 ? 2'h0 : _T_2079; // @[Mux.scala 98:16]
  wire [1:0] _T_2081 = _T_1849 ? 2'h0 : _T_2080; // @[Mux.scala 98:16]
  wire [1:0] _T_2082 = _T_1847 ? 2'h0 : _T_2081; // @[Mux.scala 98:16]
  wire [1:0] _T_2083 = _T_1845 ? 2'h0 : _T_2082; // @[Mux.scala 98:16]
  wire [1:0] _T_2084 = _T_1843 ? 2'h0 : _T_2083; // @[Mux.scala 98:16]
  wire [1:0] _T_2085 = _T_1841 ? 2'h0 : _T_2084; // @[Mux.scala 98:16]
  wire [1:0] _T_2086 = _T_1839 ? 2'h0 : _T_2085; // @[Mux.scala 98:16]
  wire [1:0] _T_2087 = _T_1837 ? 2'h0 : _T_2086; // @[Mux.scala 98:16]
  wire [1:0] _T_2088 = _T_1835 ? 2'h0 : _T_2087; // @[Mux.scala 98:16]
  wire [1:0] _T_2089 = _T_1833 ? 2'h0 : _T_2088; // @[Mux.scala 98:16]
  wire [1:0] _T_2090 = _T_1831 ? 2'h0 : _T_2089; // @[Mux.scala 98:16]
  wire [1:0] _T_2091 = _T_1829 ? 2'h0 : _T_2090; // @[Mux.scala 98:16]
  wire [2:0] _T_2092 = _T_1827 ? 3'h7 : {{1'd0}, _T_2091}; // @[Mux.scala 98:16]
  wire [3:0] _T_2093 = _T_1825 ? 4'h9 : {{1'd0}, _T_2092}; // @[Mux.scala 98:16]
  wire [3:0] _T_2094 = _T_1823 ? 4'h6 : _T_2093; // @[Mux.scala 98:16]
  wire [3:0] _T_2095 = _T_1821 ? 4'h8 : _T_2094; // @[Mux.scala 98:16]
  wire [3:0] _T_2096 = _T_1819 ? 4'h4 : _T_2095; // @[Mux.scala 98:16]
  wire [3:0] _T_2097 = _T_1817 ? 4'h5 : _T_2096; // @[Mux.scala 98:16]
  wire [3:0] _T_2098 = _T_1815 ? 4'h2 : _T_2097; // @[Mux.scala 98:16]
  wire [3:0] _T_2099 = _T_1813 ? 4'h1 : _T_2098; // @[Mux.scala 98:16]
  wire [3:0] _T_2100 = _T_1811 ? 4'h0 : _T_2099; // @[Mux.scala 98:16]
  wire [3:0] id_ctrl_br_type = _T_1809 ? 4'h0 : _T_2100; // @[Mux.scala 98:16]
  wire  _T_2209 = _T_1887 ? 1'h0 : _T_1889 | (_T_1891 | _T_1893); // @[Mux.scala 98:16]
  wire  _T_2210 = _T_1885 ? 1'h0 : _T_2209; // @[Mux.scala 98:16]
  wire  _T_2211 = _T_1883 ? 1'h0 : _T_2210; // @[Mux.scala 98:16]
  wire  _T_2241 = _T_1823 | (_T_1825 | (_T_1827 | (_T_1829 | (_T_1831 | (_T_1833 | (_T_1835 | (_T_1837 | (_T_1839 | (
    _T_1841 | (_T_1843 | (_T_1845 | (_T_1847 | (_T_1849 | (_T_1851 | (_T_1853 | (_T_1855 | (_T_1857 | (_T_1859 | (
    _T_1861 | (_T_1863 | (_T_1865 | (_T_1867 | (_T_1869 | (_T_1871 | (_T_1873 | (_T_1875 | (_T_1877 | (_T_1879 | (
    _T_1881 | _T_2211))))))))))))))))))))))))))))); // @[Mux.scala 98:16]
  wire  _T_2245 = _T_1815 | (_T_1817 | (_T_1819 | (_T_1821 | _T_2241))); // @[Mux.scala 98:16]
  wire [1:0] _T_2246 = _T_1813 ? 2'h2 : {{1'd0}, _T_2245}; // @[Mux.scala 98:16]
  wire [1:0] _T_2356 = _T_1887 ? 2'h2 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_2357 = _T_1885 ? 2'h2 : _T_2356; // @[Mux.scala 98:16]
  wire [1:0] _T_2358 = _T_1883 ? 2'h2 : _T_2357; // @[Mux.scala 98:16]
  wire [1:0] _T_2359 = _T_1881 ? 2'h1 : _T_2358; // @[Mux.scala 98:16]
  wire [1:0] _T_2360 = _T_1879 ? 2'h1 : _T_2359; // @[Mux.scala 98:16]
  wire [1:0] _T_2361 = _T_1877 ? 2'h1 : _T_2360; // @[Mux.scala 98:16]
  wire [1:0] _T_2362 = _T_1875 ? 2'h1 : _T_2361; // @[Mux.scala 98:16]
  wire [1:0] _T_2363 = _T_1873 ? 2'h1 : _T_2362; // @[Mux.scala 98:16]
  wire [1:0] _T_2364 = _T_1871 ? 2'h1 : _T_2363; // @[Mux.scala 98:16]
  wire [1:0] _T_2365 = _T_1869 ? 2'h1 : _T_2364; // @[Mux.scala 98:16]
  wire [1:0] _T_2366 = _T_1867 ? 2'h1 : _T_2365; // @[Mux.scala 98:16]
  wire [1:0] _T_2367 = _T_1865 ? 2'h1 : _T_2366; // @[Mux.scala 98:16]
  wire [1:0] _T_2368 = _T_1863 ? 2'h1 : _T_2367; // @[Mux.scala 98:16]
  wire [1:0] _T_2369 = _T_1861 ? 2'h2 : _T_2368; // @[Mux.scala 98:16]
  wire [1:0] _T_2370 = _T_1859 ? 2'h2 : _T_2369; // @[Mux.scala 98:16]
  wire [1:0] _T_2371 = _T_1857 ? 2'h2 : _T_2370; // @[Mux.scala 98:16]
  wire [1:0] _T_2372 = _T_1855 ? 2'h2 : _T_2371; // @[Mux.scala 98:16]
  wire [1:0] _T_2373 = _T_1853 ? 2'h2 : _T_2372; // @[Mux.scala 98:16]
  wire [1:0] _T_2374 = _T_1851 ? 2'h2 : _T_2373; // @[Mux.scala 98:16]
  wire [1:0] _T_2375 = _T_1849 ? 2'h2 : _T_2374; // @[Mux.scala 98:16]
  wire [1:0] _T_2376 = _T_1847 ? 2'h2 : _T_2375; // @[Mux.scala 98:16]
  wire [1:0] _T_2377 = _T_1845 ? 2'h2 : _T_2376; // @[Mux.scala 98:16]
  wire [1:0] _T_2378 = _T_1843 ? 2'h2 : _T_2377; // @[Mux.scala 98:16]
  wire [1:0] _T_2379 = _T_1841 ? 2'h2 : _T_2378; // @[Mux.scala 98:16]
  wire [1:0] _T_2380 = _T_1839 ? 2'h2 : _T_2379; // @[Mux.scala 98:16]
  wire [1:0] _T_2381 = _T_1837 ? 2'h2 : _T_2380; // @[Mux.scala 98:16]
  wire [1:0] _T_2382 = _T_1835 ? 2'h2 : _T_2381; // @[Mux.scala 98:16]
  wire [1:0] _T_2383 = _T_1833 ? 2'h2 : _T_2382; // @[Mux.scala 98:16]
  wire [1:0] _T_2384 = _T_1831 ? 2'h2 : _T_2383; // @[Mux.scala 98:16]
  wire [1:0] _T_2385 = _T_1829 ? 2'h2 : _T_2384; // @[Mux.scala 98:16]
  wire [1:0] _T_2386 = _T_1827 ? 2'h1 : _T_2385; // @[Mux.scala 98:16]
  wire [1:0] _T_2387 = _T_1825 ? 2'h1 : _T_2386; // @[Mux.scala 98:16]
  wire [1:0] _T_2388 = _T_1823 ? 2'h1 : _T_2387; // @[Mux.scala 98:16]
  wire [1:0] _T_2389 = _T_1821 ? 2'h1 : _T_2388; // @[Mux.scala 98:16]
  wire [1:0] _T_2390 = _T_1819 ? 2'h1 : _T_2389; // @[Mux.scala 98:16]
  wire [1:0] _T_2391 = _T_1817 ? 2'h1 : _T_2390; // @[Mux.scala 98:16]
  wire [1:0] _T_2392 = _T_1815 ? 2'h2 : _T_2391; // @[Mux.scala 98:16]
  wire [1:0] _T_2393 = _T_1813 ? 2'h2 : _T_2392; // @[Mux.scala 98:16]
  wire [2:0] _T_2503 = _T_1887 ? 3'h5 : 3'h0; // @[Mux.scala 98:16]
  wire [2:0] _T_2504 = _T_1885 ? 3'h5 : _T_2503; // @[Mux.scala 98:16]
  wire [2:0] _T_2505 = _T_1883 ? 3'h5 : _T_2504; // @[Mux.scala 98:16]
  wire [2:0] _T_2506 = _T_1881 ? 3'h0 : _T_2505; // @[Mux.scala 98:16]
  wire [2:0] _T_2507 = _T_1879 ? 3'h0 : _T_2506; // @[Mux.scala 98:16]
  wire [2:0] _T_2508 = _T_1877 ? 3'h0 : _T_2507; // @[Mux.scala 98:16]
  wire [2:0] _T_2509 = _T_1875 ? 3'h0 : _T_2508; // @[Mux.scala 98:16]
  wire [2:0] _T_2510 = _T_1873 ? 3'h0 : _T_2509; // @[Mux.scala 98:16]
  wire [2:0] _T_2511 = _T_1871 ? 3'h0 : _T_2510; // @[Mux.scala 98:16]
  wire [2:0] _T_2512 = _T_1869 ? 3'h0 : _T_2511; // @[Mux.scala 98:16]
  wire [2:0] _T_2513 = _T_1867 ? 3'h0 : _T_2512; // @[Mux.scala 98:16]
  wire [2:0] _T_2514 = _T_1865 ? 3'h0 : _T_2513; // @[Mux.scala 98:16]
  wire [2:0] _T_2515 = _T_1863 ? 3'h0 : _T_2514; // @[Mux.scala 98:16]
  wire [2:0] _T_2516 = _T_1861 ? 3'h0 : _T_2515; // @[Mux.scala 98:16]
  wire [2:0] _T_2517 = _T_1859 ? 3'h0 : _T_2516; // @[Mux.scala 98:16]
  wire [2:0] _T_2518 = _T_1857 ? 3'h0 : _T_2517; // @[Mux.scala 98:16]
  wire [2:0] _T_2519 = _T_1855 ? 3'h0 : _T_2518; // @[Mux.scala 98:16]
  wire [2:0] _T_2520 = _T_1853 ? 3'h0 : _T_2519; // @[Mux.scala 98:16]
  wire [2:0] _T_2521 = _T_1851 ? 3'h0 : _T_2520; // @[Mux.scala 98:16]
  wire [2:0] _T_2522 = _T_1849 ? 3'h0 : _T_2521; // @[Mux.scala 98:16]
  wire [2:0] _T_2523 = _T_1847 ? 3'h0 : _T_2522; // @[Mux.scala 98:16]
  wire [2:0] _T_2524 = _T_1845 ? 3'h0 : _T_2523; // @[Mux.scala 98:16]
  wire [2:0] _T_2525 = _T_1843 ? 3'h1 : _T_2524; // @[Mux.scala 98:16]
  wire [2:0] _T_2526 = _T_1841 ? 3'h1 : _T_2525; // @[Mux.scala 98:16]
  wire [2:0] _T_2527 = _T_1839 ? 3'h1 : _T_2526; // @[Mux.scala 98:16]
  wire [2:0] _T_2528 = _T_1837 ? 3'h0 : _T_2527; // @[Mux.scala 98:16]
  wire [2:0] _T_2529 = _T_1835 ? 3'h0 : _T_2528; // @[Mux.scala 98:16]
  wire [2:0] _T_2530 = _T_1833 ? 3'h0 : _T_2529; // @[Mux.scala 98:16]
  wire [2:0] _T_2531 = _T_1831 ? 3'h0 : _T_2530; // @[Mux.scala 98:16]
  wire [2:0] _T_2532 = _T_1829 ? 3'h0 : _T_2531; // @[Mux.scala 98:16]
  wire [2:0] _T_2533 = _T_1827 ? 3'h2 : _T_2532; // @[Mux.scala 98:16]
  wire [2:0] _T_2534 = _T_1825 ? 3'h2 : _T_2533; // @[Mux.scala 98:16]
  wire [2:0] _T_2535 = _T_1823 ? 3'h2 : _T_2534; // @[Mux.scala 98:16]
  wire [2:0] _T_2536 = _T_1821 ? 3'h2 : _T_2535; // @[Mux.scala 98:16]
  wire [2:0] _T_2537 = _T_1819 ? 3'h2 : _T_2536; // @[Mux.scala 98:16]
  wire [2:0] _T_2538 = _T_1817 ? 3'h2 : _T_2537; // @[Mux.scala 98:16]
  wire [2:0] _T_2539 = _T_1815 ? 3'h0 : _T_2538; // @[Mux.scala 98:16]
  wire [2:0] _T_2540 = _T_1813 ? 3'h4 : _T_2539; // @[Mux.scala 98:16]
  wire [3:0] _T_2647 = _T_1893 ? 4'h8 : 4'h0; // @[Mux.scala 98:16]
  wire [3:0] _T_2648 = _T_1891 ? 4'h8 : _T_2647; // @[Mux.scala 98:16]
  wire [3:0] _T_2649 = _T_1889 ? 4'h8 : _T_2648; // @[Mux.scala 98:16]
  wire [3:0] _T_2650 = _T_1887 ? 4'h0 : _T_2649; // @[Mux.scala 98:16]
  wire [3:0] _T_2651 = _T_1885 ? 4'h0 : _T_2650; // @[Mux.scala 98:16]
  wire [3:0] _T_2652 = _T_1883 ? 4'h0 : _T_2651; // @[Mux.scala 98:16]
  wire [3:0] _T_2653 = _T_1881 ? 4'h7 : _T_2652; // @[Mux.scala 98:16]
  wire [3:0] _T_2654 = _T_1879 ? 4'h6 : _T_2653; // @[Mux.scala 98:16]
  wire [3:0] _T_2655 = _T_1877 ? 4'hb : _T_2654; // @[Mux.scala 98:16]
  wire [3:0] _T_2656 = _T_1875 ? 4'h5 : _T_2655; // @[Mux.scala 98:16]
  wire [3:0] _T_2657 = _T_1873 ? 4'h4 : _T_2656; // @[Mux.scala 98:16]
  wire [3:0] _T_2658 = _T_1871 ? 4'he : _T_2657; // @[Mux.scala 98:16]
  wire [3:0] _T_2659 = _T_1869 ? 4'hc : _T_2658; // @[Mux.scala 98:16]
  wire [3:0] _T_2660 = _T_1867 ? 4'h1 : _T_2659; // @[Mux.scala 98:16]
  wire [3:0] _T_2661 = _T_1865 ? 4'ha : _T_2660; // @[Mux.scala 98:16]
  wire [3:0] _T_2662 = _T_1863 ? 4'h0 : _T_2661; // @[Mux.scala 98:16]
  wire [3:0] _T_2663 = _T_1861 ? 4'hb : _T_2662; // @[Mux.scala 98:16]
  wire [3:0] _T_2664 = _T_1859 ? 4'h5 : _T_2663; // @[Mux.scala 98:16]
  wire [3:0] _T_2665 = _T_1857 ? 4'h1 : _T_2664; // @[Mux.scala 98:16]
  wire [3:0] _T_2666 = _T_1855 ? 4'h7 : _T_2665; // @[Mux.scala 98:16]
  wire [3:0] _T_2667 = _T_1853 ? 4'h6 : _T_2666; // @[Mux.scala 98:16]
  wire [3:0] _T_2668 = _T_1851 ? 4'h4 : _T_2667; // @[Mux.scala 98:16]
  wire [3:0] _T_2669 = _T_1849 ? 4'he : _T_2668; // @[Mux.scala 98:16]
  wire [3:0] _T_2670 = _T_1847 ? 4'hc : _T_2669; // @[Mux.scala 98:16]
  wire [3:0] _T_2671 = _T_1845 ? 4'h0 : _T_2670; // @[Mux.scala 98:16]
  wire [3:0] _T_2672 = _T_1843 ? 4'h0 : _T_2671; // @[Mux.scala 98:16]
  wire [3:0] _T_2673 = _T_1841 ? 4'h0 : _T_2672; // @[Mux.scala 98:16]
  wire [3:0] _T_2674 = _T_1839 ? 4'h0 : _T_2673; // @[Mux.scala 98:16]
  wire [3:0] _T_2675 = _T_1837 ? 4'h0 : _T_2674; // @[Mux.scala 98:16]
  wire [3:0] _T_2676 = _T_1835 ? 4'h0 : _T_2675; // @[Mux.scala 98:16]
  wire [3:0] _T_2677 = _T_1833 ? 4'h0 : _T_2676; // @[Mux.scala 98:16]
  wire [3:0] _T_2678 = _T_1831 ? 4'h0 : _T_2677; // @[Mux.scala 98:16]
  wire [3:0] _T_2679 = _T_1829 ? 4'h0 : _T_2678; // @[Mux.scala 98:16]
  wire [3:0] _T_2680 = _T_1827 ? 4'hf : _T_2679; // @[Mux.scala 98:16]
  wire [3:0] _T_2681 = _T_1825 ? 4'he : _T_2680; // @[Mux.scala 98:16]
  wire [3:0] _T_2682 = _T_1823 ? 4'hd : _T_2681; // @[Mux.scala 98:16]
  wire [3:0] _T_2683 = _T_1821 ? 4'hc : _T_2682; // @[Mux.scala 98:16]
  wire [3:0] _T_2684 = _T_1819 ? 4'h3 : _T_2683; // @[Mux.scala 98:16]
  wire [3:0] _T_2685 = _T_1817 ? 4'h2 : _T_2684; // @[Mux.scala 98:16]
  wire [3:0] _T_2686 = _T_1815 ? 4'h0 : _T_2685; // @[Mux.scala 98:16]
  wire [3:0] _T_2687 = _T_1813 ? 4'h0 : _T_2686; // @[Mux.scala 98:16]
  wire [1:0] _T_2791 = _T_1899 ? 2'h3 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_2792 = _T_1897 ? 2'h0 : _T_2791; // @[Mux.scala 98:16]
  wire [1:0] _T_2793 = _T_1895 ? 2'h0 : _T_2792; // @[Mux.scala 98:16]
  wire [1:0] _T_2794 = _T_1893 ? 2'h3 : _T_2793; // @[Mux.scala 98:16]
  wire [1:0] _T_2795 = _T_1891 ? 2'h3 : _T_2794; // @[Mux.scala 98:16]
  wire [1:0] _T_2796 = _T_1889 ? 2'h3 : _T_2795; // @[Mux.scala 98:16]
  wire [1:0] _T_2797 = _T_1887 ? 2'h3 : _T_2796; // @[Mux.scala 98:16]
  wire [1:0] _T_2798 = _T_1885 ? 2'h3 : _T_2797; // @[Mux.scala 98:16]
  wire [1:0] _T_2799 = _T_1883 ? 2'h3 : _T_2798; // @[Mux.scala 98:16]
  wire [1:0] _T_2800 = _T_1881 ? 2'h1 : _T_2799; // @[Mux.scala 98:16]
  wire [1:0] _T_2801 = _T_1879 ? 2'h1 : _T_2800; // @[Mux.scala 98:16]
  wire [1:0] _T_2802 = _T_1877 ? 2'h1 : _T_2801; // @[Mux.scala 98:16]
  wire [1:0] _T_2803 = _T_1875 ? 2'h1 : _T_2802; // @[Mux.scala 98:16]
  wire [1:0] _T_2804 = _T_1873 ? 2'h1 : _T_2803; // @[Mux.scala 98:16]
  wire [1:0] _T_2805 = _T_1871 ? 2'h1 : _T_2804; // @[Mux.scala 98:16]
  wire [1:0] _T_2806 = _T_1869 ? 2'h1 : _T_2805; // @[Mux.scala 98:16]
  wire [1:0] _T_2807 = _T_1867 ? 2'h1 : _T_2806; // @[Mux.scala 98:16]
  wire [1:0] _T_2808 = _T_1865 ? 2'h1 : _T_2807; // @[Mux.scala 98:16]
  wire [1:0] _T_2809 = _T_1863 ? 2'h1 : _T_2808; // @[Mux.scala 98:16]
  wire [1:0] _T_2810 = _T_1861 ? 2'h1 : _T_2809; // @[Mux.scala 98:16]
  wire [1:0] _T_2811 = _T_1859 ? 2'h1 : _T_2810; // @[Mux.scala 98:16]
  wire [1:0] _T_2812 = _T_1857 ? 2'h1 : _T_2811; // @[Mux.scala 98:16]
  wire [1:0] _T_2813 = _T_1855 ? 2'h1 : _T_2812; // @[Mux.scala 98:16]
  wire [1:0] _T_2814 = _T_1853 ? 2'h1 : _T_2813; // @[Mux.scala 98:16]
  wire [1:0] _T_2815 = _T_1851 ? 2'h1 : _T_2814; // @[Mux.scala 98:16]
  wire [1:0] _T_2816 = _T_1849 ? 2'h1 : _T_2815; // @[Mux.scala 98:16]
  wire [1:0] _T_2817 = _T_1847 ? 2'h1 : _T_2816; // @[Mux.scala 98:16]
  wire [1:0] _T_2818 = _T_1845 ? 2'h1 : _T_2817; // @[Mux.scala 98:16]
  wire [1:0] _T_2819 = _T_1843 ? 2'h0 : _T_2818; // @[Mux.scala 98:16]
  wire [1:0] _T_2820 = _T_1841 ? 2'h0 : _T_2819; // @[Mux.scala 98:16]
  wire [1:0] _T_2821 = _T_1839 ? 2'h0 : _T_2820; // @[Mux.scala 98:16]
  wire [1:0] _T_2822 = _T_1837 ? 2'h2 : _T_2821; // @[Mux.scala 98:16]
  wire [1:0] _T_2823 = _T_1835 ? 2'h2 : _T_2822; // @[Mux.scala 98:16]
  wire [1:0] _T_2824 = _T_1833 ? 2'h2 : _T_2823; // @[Mux.scala 98:16]
  wire [1:0] _T_2825 = _T_1831 ? 2'h2 : _T_2824; // @[Mux.scala 98:16]
  wire [1:0] _T_2826 = _T_1829 ? 2'h2 : _T_2825; // @[Mux.scala 98:16]
  wire [1:0] _T_2827 = _T_1827 ? 2'h0 : _T_2826; // @[Mux.scala 98:16]
  wire [1:0] _T_2828 = _T_1825 ? 2'h0 : _T_2827; // @[Mux.scala 98:16]
  wire [1:0] _T_2829 = _T_1823 ? 2'h0 : _T_2828; // @[Mux.scala 98:16]
  wire [1:0] _T_2830 = _T_1821 ? 2'h0 : _T_2829; // @[Mux.scala 98:16]
  wire [1:0] _T_2831 = _T_1819 ? 2'h0 : _T_2830; // @[Mux.scala 98:16]
  wire [1:0] _T_2832 = _T_1817 ? 2'h0 : _T_2831; // @[Mux.scala 98:16]
  wire [1:0] _T_2833 = _T_1815 ? 2'h0 : _T_2832; // @[Mux.scala 98:16]
  wire [1:0] _T_2834 = _T_1813 ? 2'h0 : _T_2833; // @[Mux.scala 98:16]
  wire  _T_2966 = _T_1843 ? 1'h0 : _T_1845 | (_T_1847 | (_T_1849 | (_T_1851 | (_T_1853 | (_T_1855 | (_T_1857 | (_T_1859
     | (_T_1861 | (_T_1863 | (_T_1865 | (_T_1867 | (_T_1869 | (_T_1871 | (_T_1873 | (_T_1875 | (_T_1877 | (_T_1879 | (
    _T_1881 | (_T_1883 | (_T_1885 | (_T_1887 | (_T_1889 | (_T_1891 | _T_1893))))))))))))))))))))))); // @[Mux.scala 98:16]
  wire  _T_2967 = _T_1841 ? 1'h0 : _T_2966; // @[Mux.scala 98:16]
  wire  _T_2968 = _T_1839 ? 1'h0 : _T_2967; // @[Mux.scala 98:16]
  wire  _T_2974 = _T_1827 ? 1'h0 : _T_1829 | (_T_1831 | (_T_1833 | (_T_1835 | (_T_1837 | _T_2968)))); // @[Mux.scala 98:16]
  wire  _T_2975 = _T_1825 ? 1'h0 : _T_2974; // @[Mux.scala 98:16]
  wire  _T_2976 = _T_1823 ? 1'h0 : _T_2975; // @[Mux.scala 98:16]
  wire  _T_2977 = _T_1821 ? 1'h0 : _T_2976; // @[Mux.scala 98:16]
  wire  _T_2978 = _T_1819 ? 1'h0 : _T_2977; // @[Mux.scala 98:16]
  wire  _T_2979 = _T_1817 ? 1'h0 : _T_2978; // @[Mux.scala 98:16]
  wire  id_ctrl_rf_wen = _T_1809 | (_T_1811 | (_T_1813 | (_T_1815 | _T_2979))); // @[Mux.scala 98:16]
  wire  _T_3083 = _T_1903 ? 1'h0 : _T_1905; // @[Mux.scala 98:16]
  wire  _T_3084 = _T_1901 ? 1'h0 : _T_3083; // @[Mux.scala 98:16]
  wire  _T_3085 = _T_1899 ? 1'h0 : _T_3084; // @[Mux.scala 98:16]
  wire  _T_3086 = _T_1897 ? 1'h0 : _T_3085; // @[Mux.scala 98:16]
  wire  _T_3087 = _T_1895 ? 1'h0 : _T_3086; // @[Mux.scala 98:16]
  wire  _T_3088 = _T_1893 ? 1'h0 : _T_3087; // @[Mux.scala 98:16]
  wire  _T_3089 = _T_1891 ? 1'h0 : _T_3088; // @[Mux.scala 98:16]
  wire  _T_3090 = _T_1889 ? 1'h0 : _T_3089; // @[Mux.scala 98:16]
  wire  _T_3091 = _T_1887 ? 1'h0 : _T_3090; // @[Mux.scala 98:16]
  wire  _T_3092 = _T_1885 ? 1'h0 : _T_3091; // @[Mux.scala 98:16]
  wire  _T_3093 = _T_1883 ? 1'h0 : _T_3092; // @[Mux.scala 98:16]
  wire  _T_3094 = _T_1881 ? 1'h0 : _T_3093; // @[Mux.scala 98:16]
  wire  _T_3095 = _T_1879 ? 1'h0 : _T_3094; // @[Mux.scala 98:16]
  wire  _T_3096 = _T_1877 ? 1'h0 : _T_3095; // @[Mux.scala 98:16]
  wire  _T_3097 = _T_1875 ? 1'h0 : _T_3096; // @[Mux.scala 98:16]
  wire  _T_3098 = _T_1873 ? 1'h0 : _T_3097; // @[Mux.scala 98:16]
  wire  _T_3099 = _T_1871 ? 1'h0 : _T_3098; // @[Mux.scala 98:16]
  wire  _T_3100 = _T_1869 ? 1'h0 : _T_3099; // @[Mux.scala 98:16]
  wire  _T_3101 = _T_1867 ? 1'h0 : _T_3100; // @[Mux.scala 98:16]
  wire  _T_3102 = _T_1865 ? 1'h0 : _T_3101; // @[Mux.scala 98:16]
  wire  _T_3103 = _T_1863 ? 1'h0 : _T_3102; // @[Mux.scala 98:16]
  wire  _T_3104 = _T_1861 ? 1'h0 : _T_3103; // @[Mux.scala 98:16]
  wire  _T_3105 = _T_1859 ? 1'h0 : _T_3104; // @[Mux.scala 98:16]
  wire  _T_3106 = _T_1857 ? 1'h0 : _T_3105; // @[Mux.scala 98:16]
  wire  _T_3107 = _T_1855 ? 1'h0 : _T_3106; // @[Mux.scala 98:16]
  wire  _T_3108 = _T_1853 ? 1'h0 : _T_3107; // @[Mux.scala 98:16]
  wire  _T_3109 = _T_1851 ? 1'h0 : _T_3108; // @[Mux.scala 98:16]
  wire  _T_3110 = _T_1849 ? 1'h0 : _T_3109; // @[Mux.scala 98:16]
  wire  _T_3111 = _T_1847 ? 1'h0 : _T_3110; // @[Mux.scala 98:16]
  wire  _T_3112 = _T_1845 ? 1'h0 : _T_3111; // @[Mux.scala 98:16]
  wire  _T_3121 = _T_1827 ? 1'h0 : _T_1829 | (_T_1831 | (_T_1833 | (_T_1835 | (_T_1837 | (_T_1839 | (_T_1841 | (_T_1843
     | _T_3112))))))); // @[Mux.scala 98:16]
  wire  _T_3122 = _T_1825 ? 1'h0 : _T_3121; // @[Mux.scala 98:16]
  wire  _T_3123 = _T_1823 ? 1'h0 : _T_3122; // @[Mux.scala 98:16]
  wire  _T_3124 = _T_1821 ? 1'h0 : _T_3123; // @[Mux.scala 98:16]
  wire  _T_3125 = _T_1819 ? 1'h0 : _T_3124; // @[Mux.scala 98:16]
  wire  _T_3126 = _T_1817 ? 1'h0 : _T_3125; // @[Mux.scala 98:16]
  wire  _T_3127 = _T_1815 ? 1'h0 : _T_3126; // @[Mux.scala 98:16]
  wire  _T_3128 = _T_1813 ? 1'h0 : _T_3127; // @[Mux.scala 98:16]
  wire [1:0] _T_3260 = _T_1843 ? 2'h2 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_3261 = _T_1841 ? 2'h2 : _T_3260; // @[Mux.scala 98:16]
  wire [1:0] _T_3262 = _T_1839 ? 2'h2 : _T_3261; // @[Mux.scala 98:16]
  wire [1:0] _T_3263 = _T_1837 ? 2'h1 : _T_3262; // @[Mux.scala 98:16]
  wire [1:0] _T_3264 = _T_1835 ? 2'h1 : _T_3263; // @[Mux.scala 98:16]
  wire [1:0] _T_3265 = _T_1833 ? 2'h1 : _T_3264; // @[Mux.scala 98:16]
  wire [1:0] _T_3266 = _T_1831 ? 2'h1 : _T_3265; // @[Mux.scala 98:16]
  wire [1:0] _T_3267 = _T_1829 ? 2'h1 : _T_3266; // @[Mux.scala 98:16]
  wire [1:0] _T_3268 = _T_1827 ? 2'h0 : _T_3267; // @[Mux.scala 98:16]
  wire [1:0] _T_3269 = _T_1825 ? 2'h0 : _T_3268; // @[Mux.scala 98:16]
  wire [1:0] _T_3270 = _T_1823 ? 2'h0 : _T_3269; // @[Mux.scala 98:16]
  wire [1:0] _T_3271 = _T_1821 ? 2'h0 : _T_3270; // @[Mux.scala 98:16]
  wire [1:0] _T_3272 = _T_1819 ? 2'h0 : _T_3271; // @[Mux.scala 98:16]
  wire [1:0] _T_3273 = _T_1817 ? 2'h0 : _T_3272; // @[Mux.scala 98:16]
  wire [1:0] _T_3274 = _T_1815 ? 2'h0 : _T_3273; // @[Mux.scala 98:16]
  wire [1:0] _T_3275 = _T_1813 ? 2'h0 : _T_3274; // @[Mux.scala 98:16]
  wire [1:0] _T_3407 = _T_1843 ? 2'h3 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_3408 = _T_1841 ? 2'h2 : _T_3407; // @[Mux.scala 98:16]
  wire [1:0] _T_3409 = _T_1839 ? 2'h1 : _T_3408; // @[Mux.scala 98:16]
  wire [2:0] _T_3410 = _T_1837 ? 3'h6 : {{1'd0}, _T_3409}; // @[Mux.scala 98:16]
  wire [2:0] _T_3411 = _T_1835 ? 3'h5 : _T_3410; // @[Mux.scala 98:16]
  wire [2:0] _T_3412 = _T_1833 ? 3'h3 : _T_3411; // @[Mux.scala 98:16]
  wire [2:0] _T_3413 = _T_1831 ? 3'h2 : _T_3412; // @[Mux.scala 98:16]
  wire [2:0] _T_3414 = _T_1829 ? 3'h1 : _T_3413; // @[Mux.scala 98:16]
  wire [2:0] _T_3415 = _T_1827 ? 3'h0 : _T_3414; // @[Mux.scala 98:16]
  wire [2:0] _T_3416 = _T_1825 ? 3'h0 : _T_3415; // @[Mux.scala 98:16]
  wire [2:0] _T_3417 = _T_1823 ? 3'h0 : _T_3416; // @[Mux.scala 98:16]
  wire [2:0] _T_3418 = _T_1821 ? 3'h0 : _T_3417; // @[Mux.scala 98:16]
  wire [2:0] _T_3419 = _T_1819 ? 3'h0 : _T_3418; // @[Mux.scala 98:16]
  wire [2:0] _T_3420 = _T_1817 ? 3'h0 : _T_3419; // @[Mux.scala 98:16]
  wire [2:0] _T_3421 = _T_1815 ? 3'h0 : _T_3420; // @[Mux.scala 98:16]
  wire [2:0] _T_3422 = _T_1813 ? 3'h0 : _T_3421; // @[Mux.scala 98:16]
  wire [2:0] _T_3525 = _T_1901 ? 3'h4 : 3'h0; // @[Mux.scala 98:16]
  wire [2:0] _T_3526 = _T_1899 ? 3'h4 : _T_3525; // @[Mux.scala 98:16]
  wire [2:0] _T_3527 = _T_1897 ? 3'h4 : _T_3526; // @[Mux.scala 98:16]
  wire [2:0] _T_3528 = _T_1895 ? 3'h4 : _T_3527; // @[Mux.scala 98:16]
  wire [2:0] _T_3529 = _T_1893 ? 3'h3 : _T_3528; // @[Mux.scala 98:16]
  wire [2:0] _T_3530 = _T_1891 ? 3'h2 : _T_3529; // @[Mux.scala 98:16]
  wire [2:0] _T_3531 = _T_1889 ? 3'h1 : _T_3530; // @[Mux.scala 98:16]
  wire [2:0] _T_3532 = _T_1887 ? 3'h3 : _T_3531; // @[Mux.scala 98:16]
  wire [2:0] _T_3533 = _T_1885 ? 3'h2 : _T_3532; // @[Mux.scala 98:16]
  wire [2:0] _T_3534 = _T_1883 ? 3'h1 : _T_3533; // @[Mux.scala 98:16]
  wire [2:0] _T_3535 = _T_1881 ? 3'h0 : _T_3534; // @[Mux.scala 98:16]
  wire [2:0] _T_3536 = _T_1879 ? 3'h0 : _T_3535; // @[Mux.scala 98:16]
  wire [2:0] _T_3537 = _T_1877 ? 3'h0 : _T_3536; // @[Mux.scala 98:16]
  wire [2:0] _T_3538 = _T_1875 ? 3'h0 : _T_3537; // @[Mux.scala 98:16]
  wire [2:0] _T_3539 = _T_1873 ? 3'h0 : _T_3538; // @[Mux.scala 98:16]
  wire [2:0] _T_3540 = _T_1871 ? 3'h0 : _T_3539; // @[Mux.scala 98:16]
  wire [2:0] _T_3541 = _T_1869 ? 3'h0 : _T_3540; // @[Mux.scala 98:16]
  wire [2:0] _T_3542 = _T_1867 ? 3'h0 : _T_3541; // @[Mux.scala 98:16]
  wire [2:0] _T_3543 = _T_1865 ? 3'h0 : _T_3542; // @[Mux.scala 98:16]
  wire [2:0] _T_3544 = _T_1863 ? 3'h0 : _T_3543; // @[Mux.scala 98:16]
  wire [2:0] _T_3545 = _T_1861 ? 3'h0 : _T_3544; // @[Mux.scala 98:16]
  wire [2:0] _T_3546 = _T_1859 ? 3'h0 : _T_3545; // @[Mux.scala 98:16]
  wire [2:0] _T_3547 = _T_1857 ? 3'h0 : _T_3546; // @[Mux.scala 98:16]
  wire [2:0] _T_3548 = _T_1855 ? 3'h0 : _T_3547; // @[Mux.scala 98:16]
  wire [2:0] _T_3549 = _T_1853 ? 3'h0 : _T_3548; // @[Mux.scala 98:16]
  wire [2:0] _T_3550 = _T_1851 ? 3'h0 : _T_3549; // @[Mux.scala 98:16]
  wire [2:0] _T_3551 = _T_1849 ? 3'h0 : _T_3550; // @[Mux.scala 98:16]
  wire [2:0] _T_3552 = _T_1847 ? 3'h0 : _T_3551; // @[Mux.scala 98:16]
  wire [2:0] _T_3553 = _T_1845 ? 3'h0 : _T_3552; // @[Mux.scala 98:16]
  wire [2:0] _T_3554 = _T_1843 ? 3'h0 : _T_3553; // @[Mux.scala 98:16]
  wire [2:0] _T_3555 = _T_1841 ? 3'h0 : _T_3554; // @[Mux.scala 98:16]
  wire [2:0] _T_3556 = _T_1839 ? 3'h0 : _T_3555; // @[Mux.scala 98:16]
  wire [2:0] _T_3557 = _T_1837 ? 3'h0 : _T_3556; // @[Mux.scala 98:16]
  wire [2:0] _T_3558 = _T_1835 ? 3'h0 : _T_3557; // @[Mux.scala 98:16]
  wire [2:0] _T_3559 = _T_1833 ? 3'h0 : _T_3558; // @[Mux.scala 98:16]
  wire [2:0] _T_3560 = _T_1831 ? 3'h0 : _T_3559; // @[Mux.scala 98:16]
  wire [2:0] _T_3561 = _T_1829 ? 3'h0 : _T_3560; // @[Mux.scala 98:16]
  wire [2:0] _T_3562 = _T_1827 ? 3'h0 : _T_3561; // @[Mux.scala 98:16]
  wire [2:0] _T_3563 = _T_1825 ? 3'h0 : _T_3562; // @[Mux.scala 98:16]
  wire [2:0] _T_3564 = _T_1823 ? 3'h0 : _T_3563; // @[Mux.scala 98:16]
  wire [2:0] _T_3565 = _T_1821 ? 3'h0 : _T_3564; // @[Mux.scala 98:16]
  wire [2:0] _T_3566 = _T_1819 ? 3'h0 : _T_3565; // @[Mux.scala 98:16]
  wire [2:0] _T_3567 = _T_1817 ? 3'h0 : _T_3566; // @[Mux.scala 98:16]
  wire [2:0] _T_3568 = _T_1815 ? 3'h0 : _T_3567; // @[Mux.scala 98:16]
  wire [2:0] _T_3569 = _T_1813 ? 3'h0 : _T_3568; // @[Mux.scala 98:16]
  wire [2:0] _T_3570 = _T_1811 ? 3'h0 : _T_3569; // @[Mux.scala 98:16]
  wire [2:0] id_ctrl_csr_cmd = _T_1809 ? 3'h0 : _T_3570; // @[Mux.scala 98:16]
  reg [31:0] rv32i_reg_0; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_1; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_2; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_3; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_4; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_5; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_6; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_7; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_8; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_9; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_10; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_11; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_12; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_13; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_14; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_15; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_16; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_17; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_18; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_19; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_20; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_21; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_22; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_23; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_24; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_25; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_26; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_27; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_28; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_29; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_30; // @[core.scala 196:39]
  reg [31:0] rv32i_reg_31; // @[core.scala 196:39]
  wire [31:0] _GEN_36 = 5'h1 == idm_io_inst_rs1 ? rv32i_reg_1 : rv32i_reg_0; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_37 = 5'h2 == idm_io_inst_rs1 ? rv32i_reg_2 : _GEN_36; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_38 = 5'h3 == idm_io_inst_rs1 ? rv32i_reg_3 : _GEN_37; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_39 = 5'h4 == idm_io_inst_rs1 ? rv32i_reg_4 : _GEN_38; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_40 = 5'h5 == idm_io_inst_rs1 ? rv32i_reg_5 : _GEN_39; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_41 = 5'h6 == idm_io_inst_rs1 ? rv32i_reg_6 : _GEN_40; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_42 = 5'h7 == idm_io_inst_rs1 ? rv32i_reg_7 : _GEN_41; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_43 = 5'h8 == idm_io_inst_rs1 ? rv32i_reg_8 : _GEN_42; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_44 = 5'h9 == idm_io_inst_rs1 ? rv32i_reg_9 : _GEN_43; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_45 = 5'ha == idm_io_inst_rs1 ? rv32i_reg_10 : _GEN_44; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_46 = 5'hb == idm_io_inst_rs1 ? rv32i_reg_11 : _GEN_45; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_47 = 5'hc == idm_io_inst_rs1 ? rv32i_reg_12 : _GEN_46; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_48 = 5'hd == idm_io_inst_rs1 ? rv32i_reg_13 : _GEN_47; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_49 = 5'he == idm_io_inst_rs1 ? rv32i_reg_14 : _GEN_48; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_50 = 5'hf == idm_io_inst_rs1 ? rv32i_reg_15 : _GEN_49; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_51 = 5'h10 == idm_io_inst_rs1 ? rv32i_reg_16 : _GEN_50; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_52 = 5'h11 == idm_io_inst_rs1 ? rv32i_reg_17 : _GEN_51; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_53 = 5'h12 == idm_io_inst_rs1 ? rv32i_reg_18 : _GEN_52; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_54 = 5'h13 == idm_io_inst_rs1 ? rv32i_reg_19 : _GEN_53; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_55 = 5'h14 == idm_io_inst_rs1 ? rv32i_reg_20 : _GEN_54; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_56 = 5'h15 == idm_io_inst_rs1 ? rv32i_reg_21 : _GEN_55; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_57 = 5'h16 == idm_io_inst_rs1 ? rv32i_reg_22 : _GEN_56; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_58 = 5'h17 == idm_io_inst_rs1 ? rv32i_reg_23 : _GEN_57; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_59 = 5'h18 == idm_io_inst_rs1 ? rv32i_reg_24 : _GEN_58; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_60 = 5'h19 == idm_io_inst_rs1 ? rv32i_reg_25 : _GEN_59; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_61 = 5'h1a == idm_io_inst_rs1 ? rv32i_reg_26 : _GEN_60; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_62 = 5'h1b == idm_io_inst_rs1 ? rv32i_reg_27 : _GEN_61; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_63 = 5'h1c == idm_io_inst_rs1 ? rv32i_reg_28 : _GEN_62; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_64 = 5'h1d == idm_io_inst_rs1 ? rv32i_reg_29 : _GEN_63; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_65 = 5'h1e == idm_io_inst_rs1 ? rv32i_reg_30 : _GEN_64; // @[core.scala 197:27 core.scala 197:27]
  wire [31:0] _GEN_68 = 5'h1 == idm_io_inst_rs2 ? rv32i_reg_1 : rv32i_reg_0; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_69 = 5'h2 == idm_io_inst_rs2 ? rv32i_reg_2 : _GEN_68; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_70 = 5'h3 == idm_io_inst_rs2 ? rv32i_reg_3 : _GEN_69; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_71 = 5'h4 == idm_io_inst_rs2 ? rv32i_reg_4 : _GEN_70; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_72 = 5'h5 == idm_io_inst_rs2 ? rv32i_reg_5 : _GEN_71; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_73 = 5'h6 == idm_io_inst_rs2 ? rv32i_reg_6 : _GEN_72; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_74 = 5'h7 == idm_io_inst_rs2 ? rv32i_reg_7 : _GEN_73; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_75 = 5'h8 == idm_io_inst_rs2 ? rv32i_reg_8 : _GEN_74; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_76 = 5'h9 == idm_io_inst_rs2 ? rv32i_reg_9 : _GEN_75; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_77 = 5'ha == idm_io_inst_rs2 ? rv32i_reg_10 : _GEN_76; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_78 = 5'hb == idm_io_inst_rs2 ? rv32i_reg_11 : _GEN_77; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_79 = 5'hc == idm_io_inst_rs2 ? rv32i_reg_12 : _GEN_78; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_80 = 5'hd == idm_io_inst_rs2 ? rv32i_reg_13 : _GEN_79; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_81 = 5'he == idm_io_inst_rs2 ? rv32i_reg_14 : _GEN_80; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_82 = 5'hf == idm_io_inst_rs2 ? rv32i_reg_15 : _GEN_81; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_83 = 5'h10 == idm_io_inst_rs2 ? rv32i_reg_16 : _GEN_82; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_84 = 5'h11 == idm_io_inst_rs2 ? rv32i_reg_17 : _GEN_83; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_85 = 5'h12 == idm_io_inst_rs2 ? rv32i_reg_18 : _GEN_84; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_86 = 5'h13 == idm_io_inst_rs2 ? rv32i_reg_19 : _GEN_85; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_87 = 5'h14 == idm_io_inst_rs2 ? rv32i_reg_20 : _GEN_86; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_88 = 5'h15 == idm_io_inst_rs2 ? rv32i_reg_21 : _GEN_87; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_89 = 5'h16 == idm_io_inst_rs2 ? rv32i_reg_22 : _GEN_88; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_90 = 5'h17 == idm_io_inst_rs2 ? rv32i_reg_23 : _GEN_89; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_91 = 5'h18 == idm_io_inst_rs2 ? rv32i_reg_24 : _GEN_90; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_92 = 5'h19 == idm_io_inst_rs2 ? rv32i_reg_25 : _GEN_91; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_93 = 5'h1a == idm_io_inst_rs2 ? rv32i_reg_26 : _GEN_92; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_94 = 5'h1b == idm_io_inst_rs2 ? rv32i_reg_27 : _GEN_93; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_95 = 5'h1c == idm_io_inst_rs2 ? rv32i_reg_28 : _GEN_94; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_96 = 5'h1d == idm_io_inst_rs2 ? rv32i_reg_29 : _GEN_95; // @[core.scala 198:27 core.scala 198:27]
  wire [31:0] _GEN_97 = 5'h1e == idm_io_inst_rs2 ? rv32i_reg_30 : _GEN_96; // @[core.scala 198:27 core.scala 198:27]
  reg  interrupt_sig; // @[core.scala 205:38]
  wire  _GEN_105 = (stall | inst_kill) & _T_1779 | ex_ctrl_rf_wen; // @[core.scala 236:54 core.scala 239:17 core.scala 46:39]
  wire  _GEN_112 = (stall | inst_kill) & _T_1779 | ex_ctrl_legal; // @[core.scala 236:54 core.scala 239:17 core.scala 46:39]
  wire  _GEN_129 = _T_1780 ? id_ctrl_rf_wen : _GEN_105; // @[core.scala 222:48 core.scala 225:17]
  wire  _GEN_136 = _T_1780 ? id_ctrl_legal : _GEN_112; // @[core.scala 222:48 core.scala 225:17]
  wire  _T_3610 = ex_ctrl_imm_type == 3'h5; // @[control.scala 198:28]
  wire  _T_3612 = ex_inst[31]; // @[control.scala 198:53]
  wire  _T_3613 = ex_ctrl_imm_type == 3'h5 ? $signed(1'sh0) : $signed(_T_3612); // @[control.scala 198:23]
  wire  _T_3614 = ex_ctrl_imm_type == 3'h3; // @[control.scala 199:30]
  wire [10:0] _T_3616 = ex_inst[30:20]; // @[control.scala 199:53]
  wire [7:0] _T_3622 = ex_inst[19:12]; // @[control.scala 200:76]
  wire  _T_3626 = _T_3614 | _T_3610; // @[control.scala 201:37]
  wire  _T_3629 = ex_inst[20]; // @[control.scala 202:41]
  wire  _T_3630 = ex_ctrl_imm_type == 3'h2; // @[control.scala 203:25]
  wire  _T_3632 = ex_inst[7]; // @[control.scala 203:44]
  wire  _T_3633 = ex_ctrl_imm_type == 3'h2 ? $signed(_T_3632) : $signed(_T_3613); // @[control.scala 203:20]
  wire  _T_3634 = ex_ctrl_imm_type == 3'h4 ? $signed(_T_3629) : $signed(_T_3633); // @[control.scala 202:16]
  wire [5:0] lo_hi_hi = _T_3626 ? 6'h0 : ex_inst[30:25]; // @[control.scala 204:24]
  wire  _T_3641 = ex_ctrl_imm_type == 3'h1; // @[control.scala 206:21]
  wire [3:0] _T_3648 = _T_3610 ? ex_inst[19:16] : ex_inst[24:21]; // @[control.scala 207:20]
  wire [3:0] _T_3649 = ex_ctrl_imm_type == 3'h1 | _T_3630 ? ex_inst[11:8] : _T_3648; // @[control.scala 206:16]
  wire [3:0] lo_hi_lo = _T_3614 ? 4'h0 : _T_3649; // @[control.scala 205:23]
  wire  _T_3656 = _T_3610 & ex_inst[15]; // @[control.scala 210:20]
  wire  _T_3657 = ex_ctrl_imm_type == 3'h0 ? ex_inst[20] : _T_3656; // @[control.scala 209:16]
  wire  lo_lo = _T_3641 ? ex_inst[7] : _T_3657; // @[control.scala 208:21]
  wire  hi_lo_lo = _T_3614 | _T_3610 ? $signed(1'sh0) : $signed(_T_3634); // @[Cat.scala 30:58]
  wire [7:0] hi_lo_hi = ex_ctrl_imm_type != 3'h3 & ex_ctrl_imm_type != 3'h4 ? $signed({8{_T_3613}}) : $signed(_T_3622); // @[Cat.scala 30:58]
  wire [10:0] hi_hi_lo = ex_ctrl_imm_type == 3'h3 ? $signed(_T_3616) : $signed({11{_T_3613}}); // @[Cat.scala 30:58]
  wire  hi_hi_hi = ex_ctrl_imm_type == 3'h5 ? $signed(1'sh0) : $signed(_T_3612); // @[Cat.scala 30:58]
  wire [31:0] ex_imm = {hi_hi_hi,hi_hi_lo,hi_lo_hi,hi_lo_lo,lo_hi_hi,lo_hi_lo,lo_lo}; // @[control.scala 212:57]
  wire  _T_3659 = ex_reg_raddr_0 != 5'h0; // @[core.scala 259:26]
  wire  _T_3660 = ex_reg_raddr_0 == mem_reg_waddr; // @[core.scala 259:53]
  wire  _T_3661 = ex_reg_raddr_0 != 5'h0 & ex_reg_raddr_0 == mem_reg_waddr; // @[core.scala 259:34]
  wire  _T_3662 = mem_ctrl_csr_cmd != 3'h0; // @[core.scala 259:91]
  wire  _T_3663 = ex_reg_raddr_0 != 5'h0 & ex_reg_raddr_0 == mem_reg_waddr & mem_ctrl_csr_cmd != 3'h0; // @[core.scala 259:71]
  wire  _T_3668 = _T_3661 & mem_ctrl_rf_wen; // @[core.scala 260:71]
  wire  _T_3670 = ex_reg_raddr_0 == rf_waddr; // @[core.scala 261:53]
  wire  _T_3671 = _T_3659 & ex_reg_raddr_0 == rf_waddr; // @[core.scala 261:34]
  wire  _T_3673 = _T_3659 & ex_reg_raddr_0 == rf_waddr & wb_ctrl_rf_wen; // @[core.scala 261:70]
  wire  _T_3676 = wb_ctrl_csr_cmd == 3'h0; // @[core.scala 261:145]
  wire  _T_3677 = _T_3659 & ex_reg_raddr_0 == rf_waddr & wb_ctrl_rf_wen & wb_ctrl_mem_en & wb_ctrl_csr_cmd == 3'h0; // @[core.scala 261:126]
  wire  _T_3683 = ~wb_ctrl_mem_en; // @[core.scala 262:116]
  wire  _T_3686 = _T_3673 & ~wb_ctrl_mem_en & _T_3676; // @[core.scala 262:126]
  wire  _T_3690 = ~ex_ctrl_rf_wen; // @[core.scala 263:88]
  wire  _T_3693 = _T_3671 & ~ex_ctrl_rf_wen & ex_ctrl_mem_en; // @[core.scala 263:98]
  wire  _T_3699 = wb_ctrl_csr_cmd != 3'h0; // @[core.scala 264:117]
  wire  _T_3700 = _T_3673 & wb_ctrl_csr_cmd != 3'h0; // @[core.scala 264:98]
  wire [31:0] _T_3701 = _T_3700 ? wb_csr_data : ex_rs_0; // @[Mux.scala 98:16]
  wire [31:0] _T_3702 = _T_3693 ? wb_alu_out : _T_3701; // @[Mux.scala 98:16]
  wire [31:0] _T_3703 = _T_3686 ? wb_alu_out : _T_3702; // @[Mux.scala 98:16]
  wire [31:0] _T_3704 = _T_3677 ? io_r_dmem_dat_data : _T_3703; // @[Mux.scala 98:16]
  wire [31:0] _T_3705 = _T_3668 ? mem_alu_out : _T_3704; // @[Mux.scala 98:16]
  wire [31:0] ex_reg_rs1_bypass = _T_3663 ? mem_csr_data : _T_3705; // @[Mux.scala 98:16]
  wire  _T_3707 = ex_reg_raddr_1 != 5'h0; // @[core.scala 267:26]
  wire  _T_3709 = ex_reg_raddr_1 != 5'h0 & ex_reg_raddr_1 == mem_reg_waddr; // @[core.scala 267:34]
  wire  _T_3711 = ex_reg_raddr_1 != 5'h0 & ex_reg_raddr_1 == mem_reg_waddr & _T_3662; // @[core.scala 267:71]
  wire  _T_3716 = _T_3709 & mem_ctrl_rf_wen; // @[core.scala 268:71]
  wire  _T_3719 = _T_3707 & ex_reg_raddr_1 == rf_waddr; // @[core.scala 269:34]
  wire  _T_3721 = _T_3707 & ex_reg_raddr_1 == rf_waddr & wb_ctrl_rf_wen; // @[core.scala 269:70]
  wire  _T_3725 = _T_3707 & ex_reg_raddr_1 == rf_waddr & wb_ctrl_rf_wen & wb_ctrl_mem_en & _T_3676; // @[core.scala 269:126]
  wire  _T_3734 = _T_3721 & _T_3683 & _T_3676; // @[core.scala 270:126]
  wire  _T_3741 = _T_3719 & _T_3690 & ex_ctrl_mem_en; // @[core.scala 271:98]
  wire  _T_3748 = _T_3721 & _T_3699; // @[core.scala 272:98]
  wire [31:0] _T_3749 = _T_3748 ? wb_csr_data : ex_rs_1; // @[Mux.scala 98:16]
  wire [31:0] _T_3750 = _T_3741 ? wb_alu_out : _T_3749; // @[Mux.scala 98:16]
  wire [31:0] _T_3751 = _T_3734 ? wb_alu_out : _T_3750; // @[Mux.scala 98:16]
  wire [31:0] _T_3752 = _T_3725 ? io_r_dmem_dat_data : _T_3751; // @[Mux.scala 98:16]
  wire [31:0] _T_3753 = _T_3716 ? mem_alu_out : _T_3752; // @[Mux.scala 98:16]
  wire [31:0] ex_reg_rs2_bypass = _T_3711 ? mem_csr_data : _T_3753; // @[Mux.scala 98:16]
  wire  _T_3755 = ex_ctrl_alu_op1 == 2'h1; // @[core.scala 277:26]
  wire  _T_3756 = ex_ctrl_alu_op1 == 2'h2; // @[core.scala 278:26]
  wire [31:0] _T_3759 = _T_3756 ? ex_pc : 32'h0; // @[Mux.scala 98:16]
  wire  _T_3761 = ex_ctrl_alu_op2 == 2'h1; // @[core.scala 283:26]
  wire  _T_3762 = ex_ctrl_alu_op2 == 2'h2; // @[core.scala 284:26]
  wire [31:0] _T_3763 = {hi_hi_hi,hi_hi_lo,hi_lo_hi,hi_lo_lo,lo_hi_hi,lo_hi_lo,lo_lo}; // @[core.scala 284:49]
  wire [31:0] _T_3766 = _T_3762 ? _T_3763 : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _T_3772 = _T_3662 ? mem_csr_data : mem_alu_out; // @[core.scala 296:51]
  wire [31:0] _T_3775 = _T_3699 ? wb_csr_data : wb_alu_out; // @[core.scala 297:54]
  wire [31:0] _T_3776 = _T_3670 ? _T_3775 : ex_reg_rs1_bypass; // @[core.scala 297:16]
  wire [31:0] _T_3777 = _T_3660 ? _T_3772 : _T_3776; // @[core.scala 296:12]
  wire  _GEN_153 = _T_1782 | mem_ctrl_rf_wen; // @[core.scala 344:43 core.scala 347:18 core.scala 58:40]
  wire  _GEN_175 = _T_3582 & _T_1779 ? ex_ctrl_rf_wen : _GEN_153; // @[core.scala 331:38 core.scala 334:18]
  wire  _T_3786 = ~io_sw_halt; // @[core.scala 361:21]
  wire  _T_3792 = 2'h0 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire  _T_3793 = 2'h1 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [39:0] _GEN_387 = {mem_rs_1, 8'h0}; // @[core.scala 391:53]
  wire [46:0] _T_3794 = {{7'd0}, _GEN_387}; // @[core.scala 391:53]
  wire  _T_3795 = 2'h2 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [47:0] _GEN_388 = {mem_rs_1, 16'h0}; // @[core.scala 395:53]
  wire [62:0] _T_3796 = {{15'd0}, _GEN_388}; // @[core.scala 395:53]
  wire  _T_3797 = 2'h3 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [55:0] _GEN_389 = {mem_rs_1, 24'h0}; // @[core.scala 399:53]
  wire [62:0] _T_3798 = {{7'd0}, _GEN_389}; // @[core.scala 399:53]
  wire [62:0] _GEN_196 = _T_3797 ? _T_3798 : {{31'd0}, io_sw_w_dat}; // @[Conditional.scala 39:67 core.scala 399:40]
  wire [3:0] _GEN_197 = _T_3795 ? 4'h4 : 4'h8; // @[Conditional.scala 39:67 core.scala 394:46]
  wire [62:0] _GEN_198 = _T_3795 ? _T_3796 : _GEN_196; // @[Conditional.scala 39:67 core.scala 395:40]
  wire [3:0] _GEN_199 = _T_3793 ? 4'h2 : _GEN_197; // @[Conditional.scala 39:67 core.scala 390:46]
  wire [62:0] _GEN_200 = _T_3793 ? {{16'd0}, _T_3794} : _GEN_198; // @[Conditional.scala 39:67 core.scala 391:40]
  wire [3:0] _GEN_201 = _T_3792 ? 4'h1 : _GEN_199; // @[Conditional.scala 40:58 core.scala 386:46]
  wire [62:0] _GEN_202 = _T_3792 ? {{31'd0}, mem_rs_1} : _GEN_200; // @[Conditional.scala 40:58 core.scala 387:40]
  wire [62:0] _GEN_204 = _T_3795 ? _T_3796 : {{31'd0}, io_sw_w_dat}; // @[Conditional.scala 39:67 core.scala 410:40]
  wire [3:0] _GEN_205 = _T_3792 ? 4'h3 : 4'hc; // @[Conditional.scala 40:58 core.scala 405:46]
  wire [62:0] _GEN_206 = _T_3792 ? {{31'd0}, mem_rs_1} : _GEN_204; // @[Conditional.scala 40:58 core.scala 406:40]
  wire [3:0] _GEN_207 = mem_ctrl_mask_type == 3'h2 ? _GEN_205 : 4'hf; // @[core.scala 402:49 core.scala 414:38]
  wire [62:0] _GEN_208 = mem_ctrl_mask_type == 3'h2 ? _GEN_206 : {{31'd0}, mem_rs_1}; // @[core.scala 402:49 core.scala 415:32]
  wire [3:0] _GEN_209 = mem_ctrl_mask_type == 3'h1 ? _GEN_201 : _GEN_207; // @[core.scala 383:43]
  wire [62:0] _GEN_210 = mem_ctrl_mask_type == 3'h1 ? _GEN_202 : _GEN_208; // @[core.scala 383:43]
  wire [62:0] _GEN_212 = _T_1784 ? _GEN_210 : {{31'd0}, io_sw_w_dat}; // @[core.scala 382:37]
  wire  _GEN_218 = _T_1779 ? mem_ctrl_rf_wen : wb_ctrl_rf_wen; // @[core.scala 432:24 core.scala 434:17 core.scala 69:39]
  wire  _T_3817 = 2'h0 == wb_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [23:0] hi_1 = io_r_dmem_dat_data[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] lo_1 = io_r_dmem_dat_data[7:0]; // @[core.scala 448:89]
  wire [31:0] _T_3820 = {hi_1,lo_1}; // @[Cat.scala 30:58]
  wire  _T_3821 = 2'h1 == wb_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [23:0] hi_2 = io_r_dmem_dat_data[15] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] lo_2 = io_r_dmem_dat_data[15:8]; // @[core.scala 451:90]
  wire [31:0] _T_3824 = {hi_2,lo_2}; // @[Cat.scala 30:58]
  wire  _T_3825 = 2'h2 == wb_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [23:0] hi_3 = io_r_dmem_dat_data[23] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] lo_3 = io_r_dmem_dat_data[23:16]; // @[core.scala 454:90]
  wire [31:0] _T_3828 = {hi_3,lo_3}; // @[Cat.scala 30:58]
  wire [23:0] hi_4 = io_r_dmem_dat_data[31] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] lo_4 = io_r_dmem_dat_data[31:24]; // @[core.scala 457:90]
  wire [31:0] _T_3832 = {hi_4,lo_4}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_232 = _T_3825 ? _T_3828 : _T_3832; // @[Conditional.scala 39:67 core.scala 454:31]
  wire [31:0] _GEN_233 = _T_3821 ? _T_3824 : _GEN_232; // @[Conditional.scala 39:67 core.scala 451:31]
  wire [31:0] _GEN_234 = _T_3817 ? _T_3820 : _GEN_233; // @[Conditional.scala 40:58 core.scala 448:31]
  wire [31:0] _T_3836 = {24'h0,lo_1}; // @[Cat.scala 30:58]
  wire [31:0] _T_3838 = {24'h0,lo_2}; // @[Cat.scala 30:58]
  wire [31:0] _T_3840 = {24'h0,lo_3}; // @[Cat.scala 30:58]
  wire [31:0] _T_3842 = {24'h0,lo_4}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_236 = _T_3825 ? _T_3840 : _T_3842; // @[Conditional.scala 39:67 core.scala 469:31]
  wire [31:0] _GEN_237 = _T_3821 ? _T_3838 : _GEN_236; // @[Conditional.scala 39:67 core.scala 466:31]
  wire [31:0] _GEN_238 = _T_3817 ? _T_3836 : _GEN_237; // @[Conditional.scala 40:58 core.scala 463:31]
  wire [15:0] hi_5 = io_r_dmem_dat_data[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 72:12]
  wire [15:0] lo_9 = io_r_dmem_dat_data[15:0]; // @[core.scala 478:90]
  wire [31:0] _T_3848 = {hi_5,lo_9}; // @[Cat.scala 30:58]
  wire [15:0] hi_6 = io_r_dmem_dat_data[31] ? 16'hffff : 16'h0; // @[Bitwise.scala 72:12]
  wire [15:0] lo_10 = io_r_dmem_dat_data[31:16]; // @[core.scala 481:90]
  wire [31:0] _T_3852 = {hi_6,lo_10}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_241 = _T_3825 ? _T_3852 : 32'h0; // @[Conditional.scala 39:67 core.scala 481:31]
  wire [31:0] _GEN_242 = _T_3817 ? _T_3848 : _GEN_241; // @[Conditional.scala 40:58 core.scala 478:31]
  wire [31:0] _T_3858 = {16'h0,lo_9}; // @[Cat.scala 30:58]
  wire [31:0] _T_3860 = {16'h0,lo_10}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_245 = _T_3825 ? _T_3860 : 32'h0; // @[Conditional.scala 39:67 core.scala 497:31]
  wire [31:0] _GEN_246 = _T_3817 ? _T_3858 : _GEN_245; // @[Conditional.scala 40:58 core.scala 494:31]
  wire [31:0] _GEN_247 = wb_ctrl_mask_type == 3'h6 ? _GEN_246 : io_r_dmem_dat_data; // @[core.scala 491:49 core.scala 508:23]
  wire [31:0] _GEN_248 = wb_ctrl_mask_type == 3'h2 ? _GEN_242 : _GEN_247; // @[core.scala 475:48]
  wire [31:0] _GEN_249 = wb_ctrl_mask_type == 3'h5 ? _GEN_238 : _GEN_248; // @[core.scala 460:49]
  wire [31:0] _GEN_250 = wb_ctrl_mask_type == 3'h1 ? _GEN_234 : _GEN_249; // @[core.scala 445:42]
  wire [31:0] dmem_data = wb_ctrl_mem_wr == 2'h1 ? _GEN_250 : io_r_dmem_dat_data; // @[core.scala 444:36 core.scala 511:19]
  wire  _T_3863 = wb_ctrl_wb_sel == 2'h1; // @[core.scala 517:25]
  wire  _T_3864 = wb_ctrl_wb_sel == 2'h0; // @[core.scala 518:25]
  wire  _T_3865 = wb_ctrl_wb_sel == 2'h3; // @[core.scala 519:25]
  wire  _T_3866 = wb_ctrl_wb_sel == 2'h2; // @[core.scala 520:25]
  wire [31:0] _T_3867 = _T_3866 ? dmem_data : wb_alu_out; // @[Mux.scala 98:16]
  wire [31:0] _T_3868 = _T_3865 ? wb_csr_data : _T_3867; // @[Mux.scala 98:16]
  wire [31:0] _T_3869 = _T_3864 ? wb_npc : _T_3868; // @[Mux.scala 98:16]
  wire [31:0] rf_wdata = _T_3863 ? wb_alu_out : _T_3869; // @[Mux.scala 98:16]
  wire [31:0] _T_3884 = mem_pc + mem_imm; // @[core.scala 543:81]
  wire [31:0] _T_3887 = _T_3806 ? mem_alu_out : npc; // @[core.scala 545:36]
  wire [31:0] _T_3888 = _T_3808 ? mem_alu_out : _T_3887; // @[core.scala 544:32]
  wire [31:0] _T_3889 = _T_3805 ? _T_3884 : _T_3888; // @[core.scala 543:28]
  wire [31:0] _T_3890 = _T_3810 ? csr_io_epc : _T_3889; // @[core.scala 542:24]
  wire  _GEN_349 = _T_3786 ? 1'h0 : 1'h1; // @[core.scala 538:38 core.scala 539:19 core.scala 552:19]
  wire [31:0] _GEN_355 = 5'h1 == io_sw_g_add[4:0] ? rv32i_reg_1 : rv32i_reg_0; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_356 = 5'h2 == io_sw_g_add[4:0] ? rv32i_reg_2 : _GEN_355; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_357 = 5'h3 == io_sw_g_add[4:0] ? rv32i_reg_3 : _GEN_356; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_358 = 5'h4 == io_sw_g_add[4:0] ? rv32i_reg_4 : _GEN_357; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_359 = 5'h5 == io_sw_g_add[4:0] ? rv32i_reg_5 : _GEN_358; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_360 = 5'h6 == io_sw_g_add[4:0] ? rv32i_reg_6 : _GEN_359; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_361 = 5'h7 == io_sw_g_add[4:0] ? rv32i_reg_7 : _GEN_360; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_362 = 5'h8 == io_sw_g_add[4:0] ? rv32i_reg_8 : _GEN_361; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_363 = 5'h9 == io_sw_g_add[4:0] ? rv32i_reg_9 : _GEN_362; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_364 = 5'ha == io_sw_g_add[4:0] ? rv32i_reg_10 : _GEN_363; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_365 = 5'hb == io_sw_g_add[4:0] ? rv32i_reg_11 : _GEN_364; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_366 = 5'hc == io_sw_g_add[4:0] ? rv32i_reg_12 : _GEN_365; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_367 = 5'hd == io_sw_g_add[4:0] ? rv32i_reg_13 : _GEN_366; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_368 = 5'he == io_sw_g_add[4:0] ? rv32i_reg_14 : _GEN_367; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_369 = 5'hf == io_sw_g_add[4:0] ? rv32i_reg_15 : _GEN_368; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_370 = 5'h10 == io_sw_g_add[4:0] ? rv32i_reg_16 : _GEN_369; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_371 = 5'h11 == io_sw_g_add[4:0] ? rv32i_reg_17 : _GEN_370; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_372 = 5'h12 == io_sw_g_add[4:0] ? rv32i_reg_18 : _GEN_371; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_373 = 5'h13 == io_sw_g_add[4:0] ? rv32i_reg_19 : _GEN_372; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_374 = 5'h14 == io_sw_g_add[4:0] ? rv32i_reg_20 : _GEN_373; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_375 = 5'h15 == io_sw_g_add[4:0] ? rv32i_reg_21 : _GEN_374; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_376 = 5'h16 == io_sw_g_add[4:0] ? rv32i_reg_22 : _GEN_375; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_377 = 5'h17 == io_sw_g_add[4:0] ? rv32i_reg_23 : _GEN_376; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_378 = 5'h18 == io_sw_g_add[4:0] ? rv32i_reg_24 : _GEN_377; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_379 = 5'h19 == io_sw_g_add[4:0] ? rv32i_reg_25 : _GEN_378; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_380 = 5'h1a == io_sw_g_add[4:0] ? rv32i_reg_26 : _GEN_379; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_381 = 5'h1b == io_sw_g_add[4:0] ? rv32i_reg_27 : _GEN_380; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_382 = 5'h1c == io_sw_g_add[4:0] ? rv32i_reg_28 : _GEN_381; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_383 = 5'h1d == io_sw_g_add[4:0] ? rv32i_reg_29 : _GEN_382; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_384 = 5'h1e == io_sw_g_add[4:0] ? rv32i_reg_30 : _GEN_383; // @[core.scala 580:21 core.scala 580:21]
  wire [31:0] _GEN_385 = 5'h1f == io_sw_g_add[4:0] ? rv32i_reg_31 : _GEN_384; // @[core.scala 580:21 core.scala 580:21]
  IDModule idm ( // @[core.scala 181:31]
    .io_imem(idm_io_imem),
    .io_inst_bits(idm_io_inst_bits),
    .io_inst_rd(idm_io_inst_rd),
    .io_inst_rs1(idm_io_inst_rs1),
    .io_inst_rs2(idm_io_inst_rs2),
    .io_inst_csr(idm_io_inst_csr)
  );
  CSR csr ( // @[core.scala 208:26]
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
  ALU alu ( // @[core.scala 256:26]
    .io_op1(alu_io_op1),
    .io_op2(alu_io_op2),
    .io_alu_op(alu_io_alu_op),
    .io_out(alu_io_out),
    .io_cmp_out(alu_io_cmp_out)
  );
  assign io_imem_add_addr = w_req ? w_addr : pc_cntr; // @[core.scala 563:16 core.scala 564:29 core.scala 566:26]
  assign io_r_imem_dat_req = imem_req; // @[core.scala 141:23]
  assign io_w_imem_dat_req = w_req; // @[core.scala 571:26]
  assign io_w_imem_dat_data = w_data; // @[core.scala 570:26]
  assign io_w_imem_dat_byteenable = 4'hf; // @[core.scala 572:30]
  assign io_dmem_add_addr = ~io_sw_halt ? mem_alu_out : io_sw_w_add; // @[core.scala 361:34 core.scala 363:26 core.scala 370:26]
  assign io_r_dmem_dat_req = ~io_sw_halt & _T_3578; // @[core.scala 361:34 core.scala 366:27 core.scala 375:27]
  assign io_w_dmem_dat_req = ~io_sw_halt ? _T_1784 : 1'h1; // @[core.scala 361:34 core.scala 364:27 core.scala 372:27]
  assign io_w_dmem_dat_data = _GEN_212[31:0];
  assign io_w_dmem_dat_byteenable = _T_1784 ? _GEN_209 : 4'hf; // @[core.scala 382:37 core.scala 418:34]
  assign io_sw_r_add = pc_cntr; // @[core.scala 558:18]
  assign io_sw_r_dat = id_inst; // @[core.scala 557:18]
  assign io_sw_g_dat = io_sw_halt ? _GEN_385 : 32'h0; // @[core.scala 579:33 core.scala 580:21 core.scala 582:21]
  assign io_sw_r_pc = id_pc; // @[core.scala 559:18]
  assign io_sw_r_ex_raddr1 = {{27'd0}, ex_reg_raddr_0}; // @[core.scala 323:23]
  assign io_sw_r_ex_raddr2 = {{27'd0}, ex_reg_raddr_1}; // @[core.scala 324:23]
  assign io_sw_r_ex_rs1 = _T_3663 ? mem_csr_data : _T_3705; // @[Mux.scala 98:16]
  assign io_sw_r_ex_rs2 = _T_3711 ? mem_csr_data : _T_3753; // @[Mux.scala 98:16]
  assign io_sw_r_ex_imm = {hi_hi_hi,hi_hi_lo,hi_lo_hi,hi_lo_lo,lo_hi_hi,lo_hi_lo,lo_lo}; // @[core.scala 327:30]
  assign io_sw_r_mem_alu_out = mem_alu_out; // @[core.scala 358:25]
  assign io_sw_r_wb_alu_out = wb_alu_out; // @[core.scala 530:28]
  assign io_sw_r_wb_rf_wdata = _T_3863 ? wb_alu_out : _T_3869; // @[Mux.scala 98:16]
  assign io_sw_r_wb_rf_waddr = {{27'd0}, rf_waddr}; // @[core.scala 531:29]
  assign io_sw_r_stall_sig = ex_inst; // @[core.scala 216:23]
  assign idm_io_imem = id_inst; // @[core.scala 182:17]
  assign csr_clock = clock;
  assign csr_reset = reset;
  assign csr_io_addr = ex_csr_addr; // @[core.scala 305:17]
  assign csr_io_in = _T_3610 ? _T_3763 : _T_3777; // @[core.scala 295:27]
  assign csr_io_cmd = ex_csr_cmd; // @[core.scala 306:16]
  assign csr_io_rs1_addr = {{27'd0}, ex_inst[19:15]}; // @[core.scala 314:31]
  assign csr_io_legal = ex_ctrl_legal; // @[core.scala 313:36]
  assign csr_io_interrupt_sig = interrupt_sig; // @[core.scala 319:26]
  assign csr_io_pc = ex_pc; // @[core.scala 304:15]
  assign csr_io_pc_invalid = inst_kill_branch | ex_pc == 32'h0; // @[core.scala 202:45]
  assign csr_io_j_check = ex_j_check; // @[core.scala 317:20]
  assign csr_io_b_check = ex_b_check; // @[core.scala 318:20]
  assign csr_io_stall = _T_3595 | _T_1773; // @[core.scala 214:73]
  assign csr_io_inst = ex_inst; // @[core.scala 308:17]
  assign csr_io_mem_wr = ex_ctrl_mem_wr; // @[core.scala 309:19]
  assign csr_io_mask_type = ex_ctrl_mask_type; // @[core.scala 310:22]
  assign csr_io_alu_op1 = _T_3755 ? ex_reg_rs1_bypass : _T_3759; // @[Mux.scala 98:16]
  assign csr_io_alu_op2 = _T_3761 ? ex_reg_rs2_bypass : _T_3766; // @[Mux.scala 98:16]
  assign alu_io_op1 = _T_3755 ? ex_reg_rs1_bypass : _T_3759; // @[Mux.scala 98:16]
  assign alu_io_op2 = _T_3761 ? ex_reg_rs2_bypass : _T_3766; // @[Mux.scala 98:16]
  assign alu_io_alu_op = ex_ctrl_alu_func; // @[core.scala 290:19]
  always @(posedge clock) begin
    if (reset) begin // @[core.scala 33:30]
      if_pc <= 32'h0; // @[core.scala 33:30]
    end else if (~stall & _T_3582 & ~waitrequest) begin // @[core.scala 125:48]
      if_pc <= pc_cntr; // @[core.scala 126:15]
    end else if (inst_kill & _T_1779) begin // @[core.scala 130:43]
      if_pc <= 32'h0; // @[core.scala 131:15]
    end
    if (reset) begin // @[core.scala 34:31]
      if_npc <= 32'h4; // @[core.scala 34:31]
    end else if (~stall & _T_3582 & ~waitrequest) begin // @[core.scala 125:48]
      if_npc <= npc; // @[core.scala 127:16]
    end else if (inst_kill & _T_1779) begin // @[core.scala 130:43]
      if_npc <= 32'h4; // @[core.scala 132:16]
    end
    if (reset) begin // @[core.scala 37:32]
      id_inst <= 32'h13; // @[core.scala 37:32]
    end else if (!((stall | waitrequest) & _T_3582 & valid_imem & io_r_imem_dat_ack)) begin // @[core.scala 151:83]
      if (_T_1776 & _T_1779 & _T_3582 & valid_imem & io_r_imem_dat_ack) begin // @[core.scala 155:89]
        id_inst <= io_r_imem_dat_data; // @[core.scala 158:17]
      end else if (_T_1782) begin // @[core.scala 159:43]
        id_inst <= 32'h13; // @[core.scala 162:17]
      end else begin
        id_inst <= _GEN_13;
      end
    end
    if (reset) begin // @[core.scala 38:30]
      id_pc <= 32'h0; // @[core.scala 38:30]
    end else if (!((stall | waitrequest) & _T_3582 & valid_imem & io_r_imem_dat_ack)) begin // @[core.scala 151:83]
      if (_T_1776 & _T_1779 & _T_3582 & valid_imem & io_r_imem_dat_ack) begin // @[core.scala 155:89]
        id_pc <= if_pc; // @[core.scala 156:15]
      end else if (_T_1782) begin // @[core.scala 159:43]
        id_pc <= 32'h0; // @[core.scala 160:15]
      end else begin
        id_pc <= _GEN_11;
      end
    end
    if (reset) begin // @[core.scala 39:31]
      id_npc <= 32'h4; // @[core.scala 39:31]
    end else if (!((stall | waitrequest) & _T_3582 & valid_imem & io_r_imem_dat_ack)) begin // @[core.scala 151:83]
      if (_T_1776 & _T_1779 & _T_3582 & valid_imem & io_r_imem_dat_ack) begin // @[core.scala 155:89]
        id_npc <= if_npc; // @[core.scala 157:16]
      end else if (_T_1782) begin // @[core.scala 159:43]
        id_npc <= 32'h4; // @[core.scala 161:16]
      end else begin
        id_npc <= _GEN_12;
      end
    end
    if (reset) begin // @[core.scala 43:30]
      ex_pc <= 32'h0; // @[core.scala 43:30]
    end else if (_T_1780) begin // @[core.scala 222:48]
      ex_pc <= id_pc; // @[core.scala 223:15]
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_pc <= 32'h0; // @[core.scala 237:15]
    end
    if (reset) begin // @[core.scala 44:31]
      ex_npc <= 32'h4; // @[core.scala 44:31]
    end else if (_T_1780) begin // @[core.scala 222:48]
      ex_npc <= id_npc; // @[core.scala 224:16]
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_npc <= 32'h4; // @[core.scala 238:16]
    end
    if (reset) begin // @[core.scala 45:32]
      ex_inst <= 32'h13; // @[core.scala 45:32]
    end else if (_T_1780) begin // @[core.scala 222:48]
      ex_inst <= id_inst; // @[core.scala 226:17]
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_inst <= 32'h13; // @[core.scala 240:17]
    end
    ex_ctrl_legal <= reset | _GEN_136; // @[core.scala 46:39 core.scala 46:39]
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_br_type <= 4'h0; // @[core.scala 46:39]
    end else if (_T_1780) begin // @[core.scala 222:48]
      if (_T_1809) begin // @[Mux.scala 98:16]
        ex_ctrl_br_type <= 4'h0;
      end else if (_T_1811) begin // @[Mux.scala 98:16]
        ex_ctrl_br_type <= 4'h0;
      end else begin
        ex_ctrl_br_type <= _T_2099;
      end
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_ctrl_br_type <= 4'h0; // @[core.scala 239:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_alu_op1 <= 2'h1; // @[core.scala 46:39]
    end else if (_T_1780) begin // @[core.scala 222:48]
      if (_T_1809) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_op1 <= 2'h0;
      end else if (_T_1811) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_op1 <= 2'h2;
      end else begin
        ex_ctrl_alu_op1 <= _T_2246;
      end
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_ctrl_alu_op1 <= 2'h1; // @[core.scala 239:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_alu_op2 <= 2'h2; // @[core.scala 46:39]
    end else if (_T_1780) begin // @[core.scala 222:48]
      if (_T_1809) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1811) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_op2 <= 2'h2;
      end else begin
        ex_ctrl_alu_op2 <= _T_2393;
      end
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_ctrl_alu_op2 <= 2'h2; // @[core.scala 239:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_imm_type <= 3'h0; // @[core.scala 46:39]
    end else if (_T_1780) begin // @[core.scala 222:48]
      if (_T_1809) begin // @[Mux.scala 98:16]
        ex_ctrl_imm_type <= 3'h3;
      end else if (_T_1811) begin // @[Mux.scala 98:16]
        ex_ctrl_imm_type <= 3'h3;
      end else begin
        ex_ctrl_imm_type <= _T_2540;
      end
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_ctrl_imm_type <= 3'h0; // @[core.scala 239:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_alu_func <= 4'h0; // @[core.scala 46:39]
    end else if (_T_1780) begin // @[core.scala 222:48]
      if (_T_1809) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_func <= 4'h9;
      end else if (_T_1811) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_func <= 4'h0;
      end else begin
        ex_ctrl_alu_func <= _T_2687;
      end
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_ctrl_alu_func <= 4'h0; // @[core.scala 239:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_wb_sel <= 2'h1; // @[core.scala 46:39]
    end else if (_T_1780) begin // @[core.scala 222:48]
      if (_T_1809) begin // @[Mux.scala 98:16]
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1811) begin // @[Mux.scala 98:16]
        ex_ctrl_wb_sel <= 2'h1;
      end else begin
        ex_ctrl_wb_sel <= _T_2834;
      end
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_ctrl_wb_sel <= 2'h1; // @[core.scala 239:17]
    end
    ex_ctrl_rf_wen <= reset | _GEN_129; // @[core.scala 46:39 core.scala 46:39]
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_mem_en <= 1'h0; // @[core.scala 46:39]
    end else if (_T_1780) begin // @[core.scala 222:48]
      if (_T_1809) begin // @[Mux.scala 98:16]
        ex_ctrl_mem_en <= 1'h0;
      end else if (_T_1811) begin // @[Mux.scala 98:16]
        ex_ctrl_mem_en <= 1'h0;
      end else begin
        ex_ctrl_mem_en <= _T_3128;
      end
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_ctrl_mem_en <= 1'h0; // @[core.scala 239:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_mem_wr <= 2'h0; // @[core.scala 46:39]
    end else if (_T_1780) begin // @[core.scala 222:48]
      if (_T_1809) begin // @[Mux.scala 98:16]
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1811) begin // @[Mux.scala 98:16]
        ex_ctrl_mem_wr <= 2'h0;
      end else begin
        ex_ctrl_mem_wr <= _T_3275;
      end
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_ctrl_mem_wr <= 2'h0; // @[core.scala 239:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_mask_type <= 3'h0; // @[core.scala 46:39]
    end else if (_T_1780) begin // @[core.scala 222:48]
      if (_T_1809) begin // @[Mux.scala 98:16]
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1811) begin // @[Mux.scala 98:16]
        ex_ctrl_mask_type <= 3'h0;
      end else begin
        ex_ctrl_mask_type <= _T_3422;
      end
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_ctrl_mask_type <= 3'h0; // @[core.scala 239:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_csr_cmd <= 3'h0; // @[core.scala 46:39]
    end else if (_T_1780) begin // @[core.scala 222:48]
      if (_T_1809) begin // @[Mux.scala 98:16]
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1811) begin // @[Mux.scala 98:16]
        ex_ctrl_csr_cmd <= 3'h0;
      end else begin
        ex_ctrl_csr_cmd <= _T_3569;
      end
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_ctrl_csr_cmd <= 3'h0; // @[core.scala 239:17]
    end
    if (reset) begin // @[core.scala 47:42]
      ex_reg_raddr_0 <= 5'h0; // @[core.scala 47:42]
    end else if (_T_1780) begin // @[core.scala 222:48]
      ex_reg_raddr_0 <= idm_io_inst_rs1; // @[core.scala 227:25]
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_reg_raddr_0 <= 5'h0; // @[core.scala 241:22]
    end
    if (reset) begin // @[core.scala 47:42]
      ex_reg_raddr_1 <= 5'h0; // @[core.scala 47:42]
    end else if (_T_1780) begin // @[core.scala 222:48]
      ex_reg_raddr_1 <= idm_io_inst_rs2; // @[core.scala 228:25]
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_reg_raddr_1 <= 5'h0; // @[core.scala 241:22]
    end
    if (reset) begin // @[core.scala 48:37]
      ex_reg_waddr <= 5'h0; // @[core.scala 48:37]
    end else if (_T_1780) begin // @[core.scala 222:48]
      ex_reg_waddr <= idm_io_inst_rd; // @[core.scala 229:22]
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_reg_waddr <= 5'h0; // @[core.scala 242:22]
    end
    if (reset) begin // @[core.scala 49:35]
      ex_rs_0 <= 32'h0; // @[core.scala 49:35]
    end else if (_T_1780) begin // @[core.scala 222:48]
      if (idm_io_inst_rs1 == 5'h0) begin // @[core.scala 197:27]
        ex_rs_0 <= 32'h0;
      end else if (5'h1f == idm_io_inst_rs1) begin // @[core.scala 197:27]
        ex_rs_0 <= rv32i_reg_31; // @[core.scala 197:27]
      end else begin
        ex_rs_0 <= _GEN_65;
      end
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_rs_0 <= 32'h0; // @[core.scala 243:15]
    end
    if (reset) begin // @[core.scala 49:35]
      ex_rs_1 <= 32'h0; // @[core.scala 49:35]
    end else if (_T_1780) begin // @[core.scala 222:48]
      if (idm_io_inst_rs2 == 5'h0) begin // @[core.scala 198:27]
        ex_rs_1 <= 32'h0;
      end else if (5'h1f == idm_io_inst_rs2) begin // @[core.scala 198:27]
        ex_rs_1 <= rv32i_reg_31; // @[core.scala 198:27]
      end else begin
        ex_rs_1 <= _GEN_97;
      end
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_rs_1 <= 32'h0; // @[core.scala 243:15]
    end
    if (reset) begin // @[core.scala 50:36]
      ex_csr_addr <= 32'h0; // @[core.scala 50:36]
    end else if (_T_1780) begin // @[core.scala 222:48]
      ex_csr_addr <= {{20'd0}, idm_io_inst_csr}; // @[core.scala 232:21]
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_csr_addr <= 32'h0; // @[core.scala 244:21]
    end
    if (reset) begin // @[core.scala 51:35]
      ex_csr_cmd <= 32'h0; // @[core.scala 51:35]
    end else if (_T_1780) begin // @[core.scala 222:48]
      ex_csr_cmd <= {{29'd0}, id_ctrl_csr_cmd}; // @[core.scala 233:20]
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_csr_cmd <= 32'h0; // @[core.scala 245:20]
    end
    if (reset) begin // @[core.scala 52:35]
      ex_b_check <= 1'h0; // @[core.scala 52:35]
    end else if (_T_1780) begin // @[core.scala 222:48]
      ex_b_check <= id_ctrl_br_type > 4'h3; // @[core.scala 235:20]
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_b_check <= 1'h0; // @[core.scala 247:20]
    end
    if (reset) begin // @[core.scala 53:35]
      ex_j_check <= 1'h0; // @[core.scala 53:35]
    end else if (_T_1780) begin // @[core.scala 222:48]
      ex_j_check <= id_ctrl_br_type == 4'h1 | id_ctrl_br_type == 4'h2; // @[core.scala 234:20]
    end else if ((stall | inst_kill) & _T_1779) begin // @[core.scala 236:54]
      ex_j_check <= 1'h0; // @[core.scala 246:20]
    end
    if (reset) begin // @[core.scala 56:31]
      mem_pc <= 32'h0; // @[core.scala 56:31]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_pc <= ex_pc; // @[core.scala 332:16]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_pc <= 32'h0; // @[core.scala 345:16]
    end
    if (reset) begin // @[core.scala 57:32]
      mem_npc <= 32'h4; // @[core.scala 57:32]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_npc <= ex_npc; // @[core.scala 333:17]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_npc <= 32'h4; // @[core.scala 346:17]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_br_type <= 4'h0; // @[core.scala 58:40]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_ctrl_br_type <= ex_ctrl_br_type; // @[core.scala 334:18]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_ctrl_br_type <= 4'h0; // @[core.scala 347:18]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_wb_sel <= 2'h1; // @[core.scala 58:40]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_ctrl_wb_sel <= ex_ctrl_wb_sel; // @[core.scala 334:18]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_ctrl_wb_sel <= 2'h1; // @[core.scala 347:18]
    end
    mem_ctrl_rf_wen <= reset | _GEN_175; // @[core.scala 58:40 core.scala 58:40]
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_mem_en <= 1'h0; // @[core.scala 58:40]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_ctrl_mem_en <= ex_ctrl_mem_en; // @[core.scala 334:18]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_ctrl_mem_en <= 1'h0; // @[core.scala 347:18]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_mem_wr <= 2'h0; // @[core.scala 58:40]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_ctrl_mem_wr <= ex_ctrl_mem_wr; // @[core.scala 334:18]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_ctrl_mem_wr <= 2'h0; // @[core.scala 347:18]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_mask_type <= 3'h0; // @[core.scala 58:40]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_ctrl_mask_type <= ex_ctrl_mask_type; // @[core.scala 334:18]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_ctrl_mask_type <= 3'h0; // @[core.scala 347:18]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_csr_cmd <= 3'h0; // @[core.scala 58:40]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_ctrl_csr_cmd <= ex_ctrl_csr_cmd; // @[core.scala 334:18]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_ctrl_csr_cmd <= 3'h0; // @[core.scala 347:18]
    end
    if (reset) begin // @[core.scala 59:32]
      mem_imm <= 32'sh0; // @[core.scala 59:32]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_imm <= ex_imm; // @[core.scala 336:17]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_imm <= 32'sh0; // @[core.scala 349:17]
    end
    if (reset) begin // @[core.scala 60:38]
      mem_reg_waddr <= 5'h0; // @[core.scala 60:38]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_reg_waddr <= ex_reg_waddr; // @[core.scala 335:23]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_reg_waddr <= 5'h0; // @[core.scala 348:23]
    end
    if (reset) begin // @[core.scala 61:36]
      mem_rs_1 <= 32'h0; // @[core.scala 61:36]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      if (_T_3711) begin // @[Mux.scala 98:16]
        mem_rs_1 <= mem_csr_data;
      end else if (_T_3716) begin // @[Mux.scala 98:16]
        mem_rs_1 <= mem_alu_out;
      end else begin
        mem_rs_1 <= _T_3752;
      end
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_rs_1 <= 32'h0; // @[core.scala 350:16]
    end
    if (reset) begin // @[core.scala 62:36]
      mem_alu_out <= 32'h0; // @[core.scala 62:36]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_alu_out <= alu_io_out; // @[core.scala 339:21]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_alu_out <= 32'h0; // @[core.scala 351:21]
    end
    if (reset) begin // @[core.scala 63:40]
      mem_alu_cmp_out <= 1'h0; // @[core.scala 63:40]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_alu_cmp_out <= alu_io_cmp_out; // @[core.scala 340:25]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_alu_cmp_out <= 1'h0; // @[core.scala 352:25]
    end
    if (reset) begin // @[core.scala 65:37]
      mem_csr_data <= 32'h0; // @[core.scala 65:37]
    end else if (_T_3582 & _T_1779) begin // @[core.scala 331:38]
      mem_csr_data <= csr_io_out; // @[core.scala 342:22]
    end else if (_T_1782) begin // @[core.scala 344:43]
      mem_csr_data <= 32'h0; // @[core.scala 354:22]
    end
    if (reset) begin // @[core.scala 68:31]
      wb_npc <= 32'h4; // @[core.scala 68:31]
    end else if (_T_1779) begin // @[core.scala 432:24]
      wb_npc <= mem_npc; // @[core.scala 433:16]
    end
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_wb_sel <= 2'h1; // @[core.scala 69:39]
    end else if (_T_1779) begin // @[core.scala 432:24]
      wb_ctrl_wb_sel <= mem_ctrl_wb_sel; // @[core.scala 434:17]
    end
    wb_ctrl_rf_wen <= reset | _GEN_218; // @[core.scala 69:39 core.scala 69:39]
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_mem_en <= 1'h0; // @[core.scala 69:39]
    end else if (_T_1779) begin // @[core.scala 432:24]
      wb_ctrl_mem_en <= mem_ctrl_mem_en; // @[core.scala 434:17]
    end
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_mem_wr <= 2'h0; // @[core.scala 69:39]
    end else if (_T_1779) begin // @[core.scala 432:24]
      wb_ctrl_mem_wr <= mem_ctrl_mem_wr; // @[core.scala 434:17]
    end
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_mask_type <= 3'h0; // @[core.scala 69:39]
    end else if (_T_1779) begin // @[core.scala 432:24]
      wb_ctrl_mask_type <= mem_ctrl_mask_type; // @[core.scala 434:17]
    end
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_csr_cmd <= 3'h0; // @[core.scala 69:39]
    end else if (_T_1779) begin // @[core.scala 432:24]
      wb_ctrl_csr_cmd <= mem_ctrl_csr_cmd; // @[core.scala 434:17]
    end
    if (reset) begin // @[core.scala 70:37]
      rf_waddr <= 5'h0; // @[core.scala 70:37]
    end else if (_T_1779) begin // @[core.scala 432:24]
      rf_waddr <= mem_reg_waddr; // @[core.scala 435:22]
    end
    if (reset) begin // @[core.scala 71:35]
      wb_alu_out <= 32'h0; // @[core.scala 71:35]
    end else if (_T_1779) begin // @[core.scala 432:24]
      wb_alu_out <= mem_alu_out; // @[core.scala 436:20]
    end
    if (reset) begin // @[core.scala 74:36]
      wb_csr_data <= 32'h0; // @[core.scala 74:36]
    end else if (_T_1779) begin // @[core.scala 432:24]
      wb_csr_data <= mem_csr_data; // @[core.scala 439:21]
    end
    if (reset) begin // @[core.scala 86:32]
      pc_cntr <= 32'h0; // @[core.scala 86:32]
    end else if (_T_3786) begin // @[core.scala 538:38]
      if (_T_1793 & imem_req) begin // @[core.scala 540:54]
        if (csr_io_expt) begin // @[core.scala 541:31]
          pc_cntr <= csr_io_evec;
        end else begin
          pc_cntr <= _T_3890;
        end
      end
    end else begin
      pc_cntr <= io_sw_w_pc; // @[core.scala 553:21]
    end
    w_req <= reset | _GEN_349; // @[core.scala 94:30 core.scala 94:30]
    if (reset) begin // @[core.scala 96:31]
      w_addr <= 32'h0; // @[core.scala 96:31]
    end else if (!(_T_3786)) begin // @[core.scala 538:38]
      w_addr <= io_sw_w_add; // @[core.scala 550:20]
    end
    if (reset) begin // @[core.scala 97:31]
      w_data <= 32'h0; // @[core.scala 97:31]
    end else if (!(_T_3786)) begin // @[core.scala 538:38]
      w_data <= io_sw_w_dat; // @[core.scala 551:20]
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
        delay_stall <= _T_1775; // @[core.scala 111:25]
      end
    end else begin
      delay_stall <= 4'h0; // @[core.scala 114:21]
    end
    valid_imem <= reset | _T_1780; // @[core.scala 118:35 core.scala 118:35]
    if (reset) begin // @[core.scala 124:27]
      imem_req <= 1'h0; // @[core.scala 124:27]
    end else if (~stall & _T_3582 & ~waitrequest) begin // @[core.scala 125:48]
      imem_req <= REG_1; // @[core.scala 128:18]
    end else if (inst_kill & _T_1779) begin // @[core.scala 130:43]
      imem_req <= REG_3; // @[core.scala 133:18]
    end else if (_T_3578 | mem_ctrl_mem_wr == 2'h2) begin // @[core.scala 137:72]
      imem_req <= 1'h0; // @[core.scala 138:18]
    end
    REG_1 <= imem_read_sig; // @[core.scala 128:28]
    REG_3 <= imem_read_sig; // @[core.scala 133:28]
    if (reset) begin // @[core.scala 146:37]
      id_inst_temp <= 32'h13; // @[core.scala 146:37]
    end else if ((stall | waitrequest) & _T_3582 & valid_imem & io_r_imem_dat_ack) begin // @[core.scala 151:83]
      id_inst_temp <= io_r_imem_dat_data; // @[core.scala 154:22]
    end else if (!(_T_1776 & _T_1779 & _T_3582 & valid_imem & io_r_imem_dat_ack)) begin // @[core.scala 155:89]
      if (_T_1782) begin // @[core.scala 159:43]
        id_inst_temp <= 32'h13; // @[core.scala 166:22]
      end else begin
        id_inst_temp <= _GEN_16;
      end
    end
    if (reset) begin // @[core.scala 147:35]
      id_pc_temp <= 32'h0; // @[core.scala 147:35]
    end else if ((stall | waitrequest) & _T_3582 & valid_imem & io_r_imem_dat_ack) begin // @[core.scala 151:83]
      id_pc_temp <= if_pc; // @[core.scala 152:20]
    end else if (!(_T_1776 & _T_1779 & _T_3582 & valid_imem & io_r_imem_dat_ack)) begin // @[core.scala 155:89]
      if (_T_1782) begin // @[core.scala 159:43]
        id_pc_temp <= 32'h0; // @[core.scala 164:20]
      end else begin
        id_pc_temp <= _GEN_14;
      end
    end
    if (reset) begin // @[core.scala 148:36]
      id_npc_temp <= 32'h4; // @[core.scala 148:36]
    end else if ((stall | waitrequest) & _T_3582 & valid_imem & io_r_imem_dat_ack) begin // @[core.scala 151:83]
      id_npc_temp <= if_npc; // @[core.scala 153:21]
    end else if (!(_T_1776 & _T_1779 & _T_3582 & valid_imem & io_r_imem_dat_ack)) begin // @[core.scala 155:89]
      if (_T_1782) begin // @[core.scala 159:43]
        id_npc_temp <= 32'h4; // @[core.scala 165:21]
      end else begin
        id_npc_temp <= _GEN_15;
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_0 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h0 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_0 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_1 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h1 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_1 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_2 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h2 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_2 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_3 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h3 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_3 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_4 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h4 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_4 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_5 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h5 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_5 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_6 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h6 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_6 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_7 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h7 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_7 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_8 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h8 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_8 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_9 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h9 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_9 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_10 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'ha == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_10 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_11 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'hb == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_11 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_12 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'hc == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_12 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_13 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'hd == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_13 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_14 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'he == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_14 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_15 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'hf == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_15 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_16 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h10 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_16 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_17 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h11 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_17 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_18 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h12 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_18 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_19 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h13 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_19 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_20 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h14 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_20 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_21 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h15 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_21 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_22 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h16 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_22 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_23 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h17 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_23 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_24 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h18 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_24 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_25 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h19 == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_25 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_26 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h1a == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_26 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_27 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h1b == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_27 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_28 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h1c == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_28 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_29 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h1d == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_29 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_30 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h1e == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_30 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 196:39]
      rv32i_reg_31 <= 32'h0; // @[core.scala 196:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 523:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 524:53]
        if (5'h1f == rf_waddr) begin // @[core.scala 525:37]
          rv32i_reg_31 <= rf_wdata; // @[core.scala 525:37]
        end
      end
    end
    if (reset) begin // @[core.scala 205:38]
      interrupt_sig <= 1'h0; // @[core.scala 205:38]
    end else begin
      interrupt_sig <= io_sw_w_interrupt_sig; // @[core.scala 206:19]
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
  imem_req = _RAND_61[0:0];
  _RAND_62 = {1{`RANDOM}};
  REG_1 = _RAND_62[0:0];
  _RAND_63 = {1{`RANDOM}};
  REG_3 = _RAND_63[0:0];
  _RAND_64 = {1{`RANDOM}};
  id_inst_temp = _RAND_64[31:0];
  _RAND_65 = {1{`RANDOM}};
  id_pc_temp = _RAND_65[31:0];
  _RAND_66 = {1{`RANDOM}};
  id_npc_temp = _RAND_66[31:0];
  _RAND_67 = {1{`RANDOM}};
  rv32i_reg_0 = _RAND_67[31:0];
  _RAND_68 = {1{`RANDOM}};
  rv32i_reg_1 = _RAND_68[31:0];
  _RAND_69 = {1{`RANDOM}};
  rv32i_reg_2 = _RAND_69[31:0];
  _RAND_70 = {1{`RANDOM}};
  rv32i_reg_3 = _RAND_70[31:0];
  _RAND_71 = {1{`RANDOM}};
  rv32i_reg_4 = _RAND_71[31:0];
  _RAND_72 = {1{`RANDOM}};
  rv32i_reg_5 = _RAND_72[31:0];
  _RAND_73 = {1{`RANDOM}};
  rv32i_reg_6 = _RAND_73[31:0];
  _RAND_74 = {1{`RANDOM}};
  rv32i_reg_7 = _RAND_74[31:0];
  _RAND_75 = {1{`RANDOM}};
  rv32i_reg_8 = _RAND_75[31:0];
  _RAND_76 = {1{`RANDOM}};
  rv32i_reg_9 = _RAND_76[31:0];
  _RAND_77 = {1{`RANDOM}};
  rv32i_reg_10 = _RAND_77[31:0];
  _RAND_78 = {1{`RANDOM}};
  rv32i_reg_11 = _RAND_78[31:0];
  _RAND_79 = {1{`RANDOM}};
  rv32i_reg_12 = _RAND_79[31:0];
  _RAND_80 = {1{`RANDOM}};
  rv32i_reg_13 = _RAND_80[31:0];
  _RAND_81 = {1{`RANDOM}};
  rv32i_reg_14 = _RAND_81[31:0];
  _RAND_82 = {1{`RANDOM}};
  rv32i_reg_15 = _RAND_82[31:0];
  _RAND_83 = {1{`RANDOM}};
  rv32i_reg_16 = _RAND_83[31:0];
  _RAND_84 = {1{`RANDOM}};
  rv32i_reg_17 = _RAND_84[31:0];
  _RAND_85 = {1{`RANDOM}};
  rv32i_reg_18 = _RAND_85[31:0];
  _RAND_86 = {1{`RANDOM}};
  rv32i_reg_19 = _RAND_86[31:0];
  _RAND_87 = {1{`RANDOM}};
  rv32i_reg_20 = _RAND_87[31:0];
  _RAND_88 = {1{`RANDOM}};
  rv32i_reg_21 = _RAND_88[31:0];
  _RAND_89 = {1{`RANDOM}};
  rv32i_reg_22 = _RAND_89[31:0];
  _RAND_90 = {1{`RANDOM}};
  rv32i_reg_23 = _RAND_90[31:0];
  _RAND_91 = {1{`RANDOM}};
  rv32i_reg_24 = _RAND_91[31:0];
  _RAND_92 = {1{`RANDOM}};
  rv32i_reg_25 = _RAND_92[31:0];
  _RAND_93 = {1{`RANDOM}};
  rv32i_reg_26 = _RAND_93[31:0];
  _RAND_94 = {1{`RANDOM}};
  rv32i_reg_27 = _RAND_94[31:0];
  _RAND_95 = {1{`RANDOM}};
  rv32i_reg_28 = _RAND_95[31:0];
  _RAND_96 = {1{`RANDOM}};
  rv32i_reg_29 = _RAND_96[31:0];
  _RAND_97 = {1{`RANDOM}};
  rv32i_reg_30 = _RAND_97[31:0];
  _RAND_98 = {1{`RANDOM}};
  rv32i_reg_31 = _RAND_98[31:0];
  _RAND_99 = {1{`RANDOM}};
  interrupt_sig = _RAND_99[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
