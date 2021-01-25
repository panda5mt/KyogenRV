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
  reg [31:0] _RAND_100;
  reg [31:0] _RAND_101;
  reg [31:0] _RAND_102;
  reg [31:0] _RAND_103;
  reg [31:0] _RAND_104;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] idm_io_imem; // @[core.scala 254:31]
  wire [31:0] idm_io_inst_bits; // @[core.scala 254:31]
  wire [4:0] idm_io_inst_rd; // @[core.scala 254:31]
  wire [4:0] idm_io_inst_rs1; // @[core.scala 254:31]
  wire [4:0] idm_io_inst_rs2; // @[core.scala 254:31]
  wire [11:0] idm_io_inst_csr; // @[core.scala 254:31]
  wire  csr_clock; // @[core.scala 279:26]
  wire  csr_reset; // @[core.scala 279:26]
  wire [31:0] csr_io_addr; // @[core.scala 279:26]
  wire [31:0] csr_io_in; // @[core.scala 279:26]
  wire [31:0] csr_io_out; // @[core.scala 279:26]
  wire [31:0] csr_io_cmd; // @[core.scala 279:26]
  wire [31:0] csr_io_rs1_addr; // @[core.scala 279:26]
  wire  csr_io_legal; // @[core.scala 279:26]
  wire  csr_io_interrupt_sig; // @[core.scala 279:26]
  wire [31:0] csr_io_pc; // @[core.scala 279:26]
  wire  csr_io_pc_invalid; // @[core.scala 279:26]
  wire  csr_io_j_check; // @[core.scala 279:26]
  wire  csr_io_b_check; // @[core.scala 279:26]
  wire  csr_io_stall; // @[core.scala 279:26]
  wire  csr_io_expt; // @[core.scala 279:26]
  wire [31:0] csr_io_evec; // @[core.scala 279:26]
  wire [31:0] csr_io_epc; // @[core.scala 279:26]
  wire [31:0] csr_io_inst; // @[core.scala 279:26]
  wire [1:0] csr_io_mem_wr; // @[core.scala 279:26]
  wire [2:0] csr_io_mask_type; // @[core.scala 279:26]
  wire [31:0] csr_io_alu_op1; // @[core.scala 279:26]
  wire [31:0] csr_io_alu_op2; // @[core.scala 279:26]
  wire [31:0] alu_io_op1; // @[core.scala 331:26]
  wire [31:0] alu_io_op2; // @[core.scala 331:26]
  wire [3:0] alu_io_alu_op; // @[core.scala 331:26]
  wire [31:0] alu_io_out; // @[core.scala 331:26]
  wire  alu_io_cmp_out; // @[core.scala 331:26]
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
  reg  w_req; // @[core.scala 91:30]
  reg [31:0] w_addr; // @[core.scala 93:31]
  reg [31:0] w_data; // @[core.scala 94:31]
  reg  imem_read_sig; // @[core.scala 99:38]
  reg [3:0] delay_stall; // @[core.scala 104:36]
  wire  _T_1773 = delay_stall != 4'h7; // @[core.scala 106:26]
  wire [3:0] _T_1775 = delay_stall + 4'h1; // @[core.scala 107:40]
  reg  valid_imem; // @[core.scala 114:35]
  wire  _T_1776 = wb_ctrl_mem_wr == 2'h1; // @[core.scala 117:45]
  wire  dmem_rd_wait = wb_ctrl_mem_wr == 2'h1 & ~io_r_dmem_dat_ack; // @[core.scala 117:55]
  wire  waitrequest = io_sw_w_waitrequest_sig | io_sw_w_datawaitreq_sig | dmem_rd_wait; // @[core.scala 118:52]
  reg  imem_req; // @[core.scala 121:33]
  wire  _T_1780 = mem_ctrl_mem_wr != 2'h0; // @[core.scala 122:80]
  wire  loadstore_in_pipe = ex_ctrl_mem_wr != 2'h0 | mem_ctrl_mem_wr != 2'h0; // @[core.scala 122:60]
  wire  loadstore_proc = _T_1780 | wb_ctrl_mem_wr != 2'h0; // @[core.scala 123:92]
  wire  _T_3603 = mem_ctrl_mem_wr == 2'h1; // @[core.scala 283:25]
  wire  _T_3605 = mem_ctrl_mem_wr == 2'h1 | ex_ctrl_mem_wr == 2'h1; // @[core.scala 283:36]
  wire  _T_3606 = (ex_reg_waddr == idm_io_inst_rs1 | ex_reg_waddr == idm_io_inst_rs2) & _T_3605; // @[core.scala 282:74]
  wire  _T_3834 = mem_ctrl_br_type > 4'h3 & mem_alu_cmp_out; // @[core.scala 497:33]
  wire  _T_3835 = mem_ctrl_br_type == 4'h2; // @[core.scala 498:27]
  wire  _T_3836 = mem_ctrl_br_type > 4'h3 & mem_alu_cmp_out | _T_3835; // @[core.scala 497:53]
  wire  _T_3837 = mem_ctrl_br_type == 4'h1; // @[core.scala 499:27]
  wire  _T_3838 = _T_3836 | _T_3837; // @[core.scala 498:38]
  wire  _T_3839 = mem_ctrl_br_type == 4'h3; // @[core.scala 500:27]
  wire  inst_kill_branch = _T_3838 | _T_3839; // @[core.scala 499:37]
  wire  inst_kill = inst_kill_branch | csr_io_expt; // @[core.scala 502:36]
  wire  _T_3607 = ~inst_kill; // @[core.scala 283:71]
  wire  _T_3613 = idm_io_inst_rs1 != 5'h0 & idm_io_inst_rs1 == rf_waddr & _T_3607; // @[core.scala 284:57]
  wire  _T_3614 = _T_3606 & ~inst_kill | _T_3613; // @[core.scala 283:84]
  wire  _T_3619 = idm_io_inst_rs2 != 5'h0 & idm_io_inst_rs2 == rf_waddr & _T_3607; // @[core.scala 285:57]
  wire  _T_3620 = _T_3614 | _T_3619; // @[core.scala 284:73]
  wire [31:0] _T_1980 = idm_io_inst_bits & 32'h7f; // @[control.scala 192:55]
  wire  _T_1981 = 32'h37 == _T_1980; // @[control.scala 192:55]
  wire  _T_1983 = 32'h17 == _T_1980; // @[control.scala 192:55]
  wire  _T_1985 = 32'h6f == _T_1980; // @[control.scala 192:55]
  wire [31:0] _T_1986 = idm_io_inst_bits & 32'h707f; // @[control.scala 192:55]
  wire  _T_1987 = 32'h67 == _T_1986; // @[control.scala 192:55]
  wire  _T_1989 = 32'h63 == _T_1986; // @[control.scala 192:55]
  wire  _T_1991 = 32'h1063 == _T_1986; // @[control.scala 192:55]
  wire  _T_1993 = 32'h4063 == _T_1986; // @[control.scala 192:55]
  wire  _T_1995 = 32'h5063 == _T_1986; // @[control.scala 192:55]
  wire  _T_1997 = 32'h6063 == _T_1986; // @[control.scala 192:55]
  wire  _T_1999 = 32'h7063 == _T_1986; // @[control.scala 192:55]
  wire  _T_2001 = 32'h3 == _T_1986; // @[control.scala 192:55]
  wire  _T_2003 = 32'h1003 == _T_1986; // @[control.scala 192:55]
  wire  _T_2005 = 32'h2003 == _T_1986; // @[control.scala 192:55]
  wire  _T_2007 = 32'h4003 == _T_1986; // @[control.scala 192:55]
  wire  _T_2009 = 32'h5003 == _T_1986; // @[control.scala 192:55]
  wire  _T_2011 = 32'h23 == _T_1986; // @[control.scala 192:55]
  wire  _T_2013 = 32'h1023 == _T_1986; // @[control.scala 192:55]
  wire  _T_2015 = 32'h2023 == _T_1986; // @[control.scala 192:55]
  wire  _T_2017 = 32'h13 == _T_1986; // @[control.scala 192:55]
  wire  _T_2019 = 32'h2013 == _T_1986; // @[control.scala 192:55]
  wire  _T_2021 = 32'h3013 == _T_1986; // @[control.scala 192:55]
  wire  _T_2023 = 32'h4013 == _T_1986; // @[control.scala 192:55]
  wire  _T_2025 = 32'h6013 == _T_1986; // @[control.scala 192:55]
  wire  _T_2027 = 32'h7013 == _T_1986; // @[control.scala 192:55]
  wire [31:0] _T_2028 = idm_io_inst_bits & 32'hfe00707f; // @[control.scala 192:55]
  wire  _T_2029 = 32'h1013 == _T_2028; // @[control.scala 192:55]
  wire [31:0] _T_2030 = idm_io_inst_bits & 32'hfc00707f; // @[control.scala 192:55]
  wire  _T_2031 = 32'h5013 == _T_2030; // @[control.scala 192:55]
  wire  _T_2033 = 32'h40005013 == _T_2030; // @[control.scala 192:55]
  wire  _T_2035 = 32'h33 == _T_2028; // @[control.scala 192:55]
  wire  _T_2037 = 32'h40000033 == _T_2028; // @[control.scala 192:55]
  wire  _T_2039 = 32'h1033 == _T_2028; // @[control.scala 192:55]
  wire  _T_2041 = 32'h2033 == _T_2028; // @[control.scala 192:55]
  wire  _T_2043 = 32'h3033 == _T_2028; // @[control.scala 192:55]
  wire  _T_2045 = 32'h4033 == _T_2028; // @[control.scala 192:55]
  wire  _T_2047 = 32'h5033 == _T_2028; // @[control.scala 192:55]
  wire  _T_2049 = 32'h40005033 == _T_2028; // @[control.scala 192:55]
  wire  _T_2051 = 32'h6033 == _T_2028; // @[control.scala 192:55]
  wire  _T_2053 = 32'h7033 == _T_2028; // @[control.scala 192:55]
  wire  _T_2055 = 32'h5073 == _T_1986; // @[control.scala 192:55]
  wire  _T_2057 = 32'h6073 == _T_1986; // @[control.scala 192:55]
  wire  _T_2059 = 32'h7073 == _T_1986; // @[control.scala 192:55]
  wire  _T_2061 = 32'h1073 == _T_1986; // @[control.scala 192:55]
  wire  _T_2063 = 32'h2073 == _T_1986; // @[control.scala 192:55]
  wire  _T_2065 = 32'h3073 == _T_1986; // @[control.scala 192:55]
  wire [31:0] _T_2066 = idm_io_inst_bits; // @[control.scala 192:55]
  wire  _T_2067 = 32'h73 == _T_2066; // @[control.scala 192:55]
  wire  _T_2069 = 32'h30200073 == _T_2066; // @[control.scala 192:55]
  wire  _T_2071 = 32'h10000073 == _T_2066; // @[control.scala 192:55]
  wire  _T_2073 = 32'h100073 == _T_2066; // @[control.scala 192:55]
  wire  _T_2075 = 32'h100f == _T_1986; // @[control.scala 192:55]
  wire  _T_2077 = 32'hf == _T_1986; // @[control.scala 192:55]
  wire [1:0] _T_2082 = _T_2069 ? 2'h3 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_2083 = _T_2067 ? 2'h0 : _T_2082; // @[Mux.scala 98:16]
  wire [1:0] _T_2084 = _T_2065 ? 2'h0 : _T_2083; // @[Mux.scala 98:16]
  wire [1:0] _T_2085 = _T_2063 ? 2'h0 : _T_2084; // @[Mux.scala 98:16]
  wire [1:0] _T_2086 = _T_2061 ? 2'h0 : _T_2085; // @[Mux.scala 98:16]
  wire [1:0] _T_2087 = _T_2059 ? 2'h0 : _T_2086; // @[Mux.scala 98:16]
  wire [1:0] _T_2088 = _T_2057 ? 2'h0 : _T_2087; // @[Mux.scala 98:16]
  wire [1:0] _T_2089 = _T_2055 ? 2'h0 : _T_2088; // @[Mux.scala 98:16]
  wire [1:0] _T_2090 = _T_2053 ? 2'h0 : _T_2089; // @[Mux.scala 98:16]
  wire [1:0] _T_2091 = _T_2051 ? 2'h0 : _T_2090; // @[Mux.scala 98:16]
  wire [1:0] _T_2092 = _T_2049 ? 2'h0 : _T_2091; // @[Mux.scala 98:16]
  wire [1:0] _T_2093 = _T_2047 ? 2'h0 : _T_2092; // @[Mux.scala 98:16]
  wire [1:0] _T_2094 = _T_2045 ? 2'h0 : _T_2093; // @[Mux.scala 98:16]
  wire [1:0] _T_2095 = _T_2043 ? 2'h0 : _T_2094; // @[Mux.scala 98:16]
  wire [1:0] _T_2096 = _T_2041 ? 2'h0 : _T_2095; // @[Mux.scala 98:16]
  wire [1:0] _T_2097 = _T_2039 ? 2'h0 : _T_2096; // @[Mux.scala 98:16]
  wire [1:0] _T_2098 = _T_2037 ? 2'h0 : _T_2097; // @[Mux.scala 98:16]
  wire [1:0] _T_2099 = _T_2035 ? 2'h0 : _T_2098; // @[Mux.scala 98:16]
  wire [1:0] _T_2100 = _T_2033 ? 2'h0 : _T_2099; // @[Mux.scala 98:16]
  wire [1:0] _T_2101 = _T_2031 ? 2'h0 : _T_2100; // @[Mux.scala 98:16]
  wire [1:0] _T_2102 = _T_2029 ? 2'h0 : _T_2101; // @[Mux.scala 98:16]
  wire [1:0] _T_2103 = _T_2027 ? 2'h0 : _T_2102; // @[Mux.scala 98:16]
  wire [1:0] _T_2104 = _T_2025 ? 2'h0 : _T_2103; // @[Mux.scala 98:16]
  wire [1:0] _T_2105 = _T_2023 ? 2'h0 : _T_2104; // @[Mux.scala 98:16]
  wire [1:0] _T_2106 = _T_2021 ? 2'h0 : _T_2105; // @[Mux.scala 98:16]
  wire [1:0] _T_2107 = _T_2019 ? 2'h0 : _T_2106; // @[Mux.scala 98:16]
  wire [1:0] _T_2108 = _T_2017 ? 2'h0 : _T_2107; // @[Mux.scala 98:16]
  wire [1:0] _T_2109 = _T_2015 ? 2'h0 : _T_2108; // @[Mux.scala 98:16]
  wire [1:0] _T_2110 = _T_2013 ? 2'h0 : _T_2109; // @[Mux.scala 98:16]
  wire [1:0] _T_2111 = _T_2011 ? 2'h0 : _T_2110; // @[Mux.scala 98:16]
  wire [1:0] _T_2112 = _T_2009 ? 2'h0 : _T_2111; // @[Mux.scala 98:16]
  wire [1:0] _T_2113 = _T_2007 ? 2'h0 : _T_2112; // @[Mux.scala 98:16]
  wire [1:0] _T_2114 = _T_2005 ? 2'h0 : _T_2113; // @[Mux.scala 98:16]
  wire [1:0] _T_2115 = _T_2003 ? 2'h0 : _T_2114; // @[Mux.scala 98:16]
  wire [1:0] _T_2116 = _T_2001 ? 2'h0 : _T_2115; // @[Mux.scala 98:16]
  wire [2:0] _T_2117 = _T_1999 ? 3'h7 : {{1'd0}, _T_2116}; // @[Mux.scala 98:16]
  wire [3:0] _T_2118 = _T_1997 ? 4'h9 : {{1'd0}, _T_2117}; // @[Mux.scala 98:16]
  wire [3:0] _T_2119 = _T_1995 ? 4'h6 : _T_2118; // @[Mux.scala 98:16]
  wire [3:0] _T_2120 = _T_1993 ? 4'h8 : _T_2119; // @[Mux.scala 98:16]
  wire [3:0] _T_2121 = _T_1991 ? 4'h4 : _T_2120; // @[Mux.scala 98:16]
  wire [3:0] _T_2122 = _T_1989 ? 4'h5 : _T_2121; // @[Mux.scala 98:16]
  wire [3:0] _T_2123 = _T_1987 ? 4'h2 : _T_2122; // @[Mux.scala 98:16]
  wire [3:0] _T_2124 = _T_1985 ? 4'h1 : _T_2123; // @[Mux.scala 98:16]
  wire [3:0] _T_2125 = _T_1983 ? 4'h0 : _T_2124; // @[Mux.scala 98:16]
  wire [3:0] id_ctrl_br_type = _T_1981 ? 4'h0 : _T_2125; // @[Mux.scala 98:16]
  wire  _T_3621 = id_ctrl_br_type != 4'h0; // @[core.scala 287:24]
  wire  _T_3625 = id_ctrl_br_type != 4'h0 & ex_ctrl_br_type != 4'h0 & _T_3607; // @[core.scala 287:62]
  wire  _T_3626 = _T_3620 | _T_3625; // @[core.scala 285:73]
  wire  _T_3633 = loadstore_in_pipe & _T_3621 & _T_3607; // @[core.scala 288:91]
  wire  _T_3634 = _T_3626 | _T_3633; // @[core.scala 287:78]
  wire  stall = _T_3634 | _T_1773; // @[core.scala 288:107]
  wire  _T_1783 = ~stall; // @[core.scala 125:10]
  wire  _T_1786 = ~waitrequest; // @[core.scala 125:34]
  wire  _T_1787 = ~stall & _T_3607 & ~waitrequest; // @[core.scala 125:31]
  wire  _T_1789 = ~stall & _T_3607 & ~waitrequest & ~loadstore_in_pipe; // @[core.scala 125:47]
  reg  REG_1; // @[core.scala 128:28]
  wire  _T_1791 = inst_kill & _T_1786; // @[core.scala 130:26]
  reg  REG_3; // @[core.scala 133:28]
  reg [31:0] id_inst_temp; // @[core.scala 146:37]
  reg [31:0] id_pc_temp; // @[core.scala 147:35]
  reg [31:0] id_npc_temp; // @[core.scala 148:36]
  reg [31:0] id_inst2_temp; // @[core.scala 149:38]
  reg [31:0] id_pc2_temp; // @[core.scala 150:36]
  reg [31:0] id_npc2_temp; // @[core.scala 151:37]
  wire  valid_id_inst = valid_imem & io_r_imem_dat_ack; // @[core.scala 153:42]
  reg  in_loadstore; // @[core.scala 154:37]
  wire  _GEN_11 = imem_req ? 1'h0 : in_loadstore; // @[core.scala 158:25 core.scala 159:22 core.scala 154:37]
  wire  _GEN_12 = _T_1780 | _GEN_11; // @[core.scala 156:35 core.scala 157:22]
  reg  temp_lock; // @[core.scala 162:34]
  wire  _GEN_13 = imem_req & io_r_imem_dat_ack ? 1'h0 : temp_lock; // @[core.scala 163:40 core.scala 164:19 core.scala 162:34]
  wire  _T_1798 = ~temp_lock; // @[core.scala 168:88]
  wire  _GEN_14 = _T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock | _GEN_13; // @[core.scala 168:99 core.scala 169:19]
  wire [31:0] _GEN_15 = _T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock ? if_pc : id_pc_temp; // @[core.scala 168:99 core.scala 170:20 core.scala 147:35]
  wire [31:0] _GEN_16 = _T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock ? if_npc : id_npc_temp; // @[core.scala 168:99 core.scala 171:21 core.scala 148:36]
  wire [31:0] _GEN_17 = _T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock ? io_r_imem_dat_data : id_inst_temp; // @[core.scala 168:99 core.scala 172:22 core.scala 146:37]
  wire [31:0] _GEN_18 = _T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock ? id_pc : id_pc2_temp; // @[core.scala 168:99 core.scala 174:21 core.scala 150:36]
  wire [31:0] _GEN_19 = _T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock ? id_npc : id_npc2_temp; // @[core.scala 168:99 core.scala 175:22 core.scala 151:37]
  wire [31:0] _GEN_20 = _T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock ? id_inst : id_inst2_temp; // @[core.scala 168:99 core.scala 176:23 core.scala 149:38]
  wire [31:0] _GEN_21 = _T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock ? 32'h0 : id_pc; // @[core.scala 168:99 core.scala 178:15 core.scala 38:30]
  wire [31:0] _GEN_22 = _T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock ? 32'h4 : id_npc; // @[core.scala 168:99 core.scala 179:16 core.scala 39:31]
  wire [31:0] _GEN_23 = _T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock ? 32'h13 : id_inst; // @[core.scala 168:99 core.scala 180:17 core.scala 37:32]
  wire  _T_1823 = ~in_loadstore; // @[core.scala 223:20]
  wire [31:0] _T_1830 = id_pc_temp + 32'h4; // @[core.scala 225:37]
  wire [31:0] _T_1832 = id_npc_temp + 32'h4; // @[core.scala 226:39]
  wire [31:0] _GEN_24 = id_pc2_temp == id_pc_temp & id_pc_temp != 32'h0 ? _T_1830 : id_pc_temp; // @[core.scala 224:71 core.scala 225:23 core.scala 229:23]
  wire [31:0] _GEN_25 = id_pc2_temp == id_pc_temp & id_pc_temp != 32'h0 ? _T_1832 : id_npc_temp; // @[core.scala 224:71 core.scala 226:24 core.scala 230:24]
  wire [31:0] _GEN_27 = ~in_loadstore & _T_1786 ? _GEN_24 : _GEN_21; // @[core.scala 223:51]
  wire [31:0] _GEN_28 = ~in_loadstore & _T_1786 ? _GEN_25 : _GEN_22; // @[core.scala 223:51]
  wire [31:0] _GEN_29 = ~in_loadstore & _T_1786 ? id_inst_temp : _GEN_23; // @[core.scala 223:51]
  wire [31:0] _GEN_30 = ~in_loadstore & _T_1786 ? 32'h0 : _GEN_15; // @[core.scala 223:51 core.scala 235:24]
  wire [31:0] _GEN_31 = ~in_loadstore & _T_1786 ? 32'h4 : _GEN_16; // @[core.scala 223:51 core.scala 236:25]
  wire [31:0] _GEN_32 = ~in_loadstore & _T_1786 ? 32'h13 : _GEN_17; // @[core.scala 223:51 core.scala 237:26]
  wire [31:0] _GEN_33 = ~in_loadstore & _T_1786 ? 32'h0 : _GEN_18; // @[core.scala 223:51 core.scala 239:25]
  wire [31:0] _GEN_34 = ~in_loadstore & _T_1786 ? 32'h4 : _GEN_19; // @[core.scala 223:51 core.scala 240:26]
  wire [31:0] _GEN_35 = ~in_loadstore & _T_1786 ? 32'h13 : _GEN_20; // @[core.scala 223:51 core.scala 241:27]
  wire [31:0] _GEN_36 = in_loadstore ? id_pc2_temp : _GEN_27; // @[core.scala 212:28 core.scala 213:19]
  wire [31:0] _GEN_37 = in_loadstore ? id_npc2_temp : _GEN_28; // @[core.scala 212:28 core.scala 214:20]
  wire [31:0] _GEN_38 = in_loadstore ? id_inst2_temp : _GEN_29; // @[core.scala 212:28 core.scala 215:21]
  wire  _GEN_39 = in_loadstore ? 1'h0 : _GEN_14; // @[core.scala 212:28 core.scala 221:23]
  wire [31:0] _GEN_40 = in_loadstore ? _GEN_15 : _GEN_30; // @[core.scala 212:28]
  wire [31:0] _GEN_41 = in_loadstore ? _GEN_16 : _GEN_31; // @[core.scala 212:28]
  wire [31:0] _GEN_42 = in_loadstore ? _GEN_17 : _GEN_32; // @[core.scala 212:28]
  wire [31:0] _GEN_43 = in_loadstore ? _GEN_18 : _GEN_33; // @[core.scala 212:28]
  wire [31:0] _GEN_44 = in_loadstore ? _GEN_19 : _GEN_34; // @[core.scala 212:28]
  wire [31:0] _GEN_45 = in_loadstore ? _GEN_20 : _GEN_35; // @[core.scala 212:28]
  wire [31:0] _GEN_46 = _T_3607 & _T_1783 & ~valid_id_inst & imem_req ? _GEN_36 : id_pc; // @[core.scala 211:88 core.scala 249:15]
  wire [31:0] _GEN_47 = _T_3607 & _T_1783 & ~valid_id_inst & imem_req ? _GEN_37 : id_npc; // @[core.scala 211:88 core.scala 250:16]
  wire [31:0] _GEN_48 = _T_3607 & _T_1783 & ~valid_id_inst & imem_req ? _GEN_38 : id_inst; // @[core.scala 211:88 core.scala 251:17]
  wire  _GEN_49 = _T_3607 & _T_1783 & ~valid_id_inst & imem_req ? _GEN_39 : _GEN_14; // @[core.scala 211:88]
  wire [31:0] _GEN_50 = _T_3607 & _T_1783 & ~valid_id_inst & imem_req ? _GEN_40 : _GEN_15; // @[core.scala 211:88]
  wire [31:0] _GEN_51 = _T_3607 & _T_1783 & ~valid_id_inst & imem_req ? _GEN_41 : _GEN_16; // @[core.scala 211:88]
  wire [31:0] _GEN_52 = _T_3607 & _T_1783 & ~valid_id_inst & imem_req ? _GEN_42 : _GEN_17; // @[core.scala 211:88]
  wire [31:0] _GEN_53 = _T_3607 & _T_1783 & ~valid_id_inst & imem_req ? _GEN_43 : _GEN_18; // @[core.scala 211:88]
  wire [31:0] _GEN_54 = _T_3607 & _T_1783 & ~valid_id_inst & imem_req ? _GEN_44 : _GEN_19; // @[core.scala 211:88]
  wire [31:0] _GEN_55 = _T_3607 & _T_1783 & ~valid_id_inst & imem_req ? _GEN_45 : _GEN_20; // @[core.scala 211:88]
  wire  _GEN_65 = _T_1791 & imem_req ? _GEN_14 : _GEN_49; // @[core.scala 199:55]
  wire  _GEN_75 = valid_id_inst & _T_1783 & _T_1786 & _T_3607 & imem_req ? _GEN_14 : _GEN_65; // @[core.scala 194:83]
  wire  _GEN_76 = (stall | waitrequest) & _T_3607 & valid_id_inst & imem_req & _T_1798 | _GEN_75; // @[core.scala 184:91 core.scala 185:19]
  wire  _T_1961 = _T_2017 | (_T_2019 | (_T_2021 | (_T_2023 | (_T_2025 | (_T_2027 | (_T_2029 | (_T_2031 | (_T_2033 | (
    _T_2035 | (_T_2037 | (_T_2039 | (_T_2041 | (_T_2043 | (_T_2045 | (_T_2047 | (_T_2049 | (_T_2051 | (_T_2053 | (
    _T_2055 | (_T_2057 | (_T_2059 | (_T_2061 | (_T_2063 | (_T_2065 | (_T_2067 | (_T_2069 | (_T_2071 | (_T_2073 | (
    _T_2075 | _T_2077))))))))))))))))))))))))))))); // @[Mux.scala 98:16]
  wire  id_ctrl_legal = _T_1981 | (_T_1983 | (_T_1985 | (_T_1987 | (_T_1989 | (_T_1991 | (_T_1993 | (_T_1995 | (_T_1997
     | (_T_1999 | (_T_2001 | (_T_2003 | (_T_2005 | (_T_2007 | (_T_2009 | (_T_2011 | (_T_2013 | (_T_2015 | _T_1961)))))))
    )))))))))); // @[Mux.scala 98:16]
  wire  _T_2234 = _T_2059 ? 1'h0 : _T_2061 | (_T_2063 | _T_2065); // @[Mux.scala 98:16]
  wire  _T_2235 = _T_2057 ? 1'h0 : _T_2234; // @[Mux.scala 98:16]
  wire  _T_2236 = _T_2055 ? 1'h0 : _T_2235; // @[Mux.scala 98:16]
  wire  _T_2266 = _T_1995 | (_T_1997 | (_T_1999 | (_T_2001 | (_T_2003 | (_T_2005 | (_T_2007 | (_T_2009 | (_T_2011 | (
    _T_2013 | (_T_2015 | (_T_2017 | (_T_2019 | (_T_2021 | (_T_2023 | (_T_2025 | (_T_2027 | (_T_2029 | (_T_2031 | (
    _T_2033 | (_T_2035 | (_T_2037 | (_T_2039 | (_T_2041 | (_T_2043 | (_T_2045 | (_T_2047 | (_T_2049 | (_T_2051 | (
    _T_2053 | _T_2236))))))))))))))))))))))))))))); // @[Mux.scala 98:16]
  wire  _T_2270 = _T_1987 | (_T_1989 | (_T_1991 | (_T_1993 | _T_2266))); // @[Mux.scala 98:16]
  wire [1:0] _T_2271 = _T_1985 ? 2'h2 : {{1'd0}, _T_2270}; // @[Mux.scala 98:16]
  wire [1:0] _T_2381 = _T_2059 ? 2'h2 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_2382 = _T_2057 ? 2'h2 : _T_2381; // @[Mux.scala 98:16]
  wire [1:0] _T_2383 = _T_2055 ? 2'h2 : _T_2382; // @[Mux.scala 98:16]
  wire [1:0] _T_2384 = _T_2053 ? 2'h1 : _T_2383; // @[Mux.scala 98:16]
  wire [1:0] _T_2385 = _T_2051 ? 2'h1 : _T_2384; // @[Mux.scala 98:16]
  wire [1:0] _T_2386 = _T_2049 ? 2'h1 : _T_2385; // @[Mux.scala 98:16]
  wire [1:0] _T_2387 = _T_2047 ? 2'h1 : _T_2386; // @[Mux.scala 98:16]
  wire [1:0] _T_2388 = _T_2045 ? 2'h1 : _T_2387; // @[Mux.scala 98:16]
  wire [1:0] _T_2389 = _T_2043 ? 2'h1 : _T_2388; // @[Mux.scala 98:16]
  wire [1:0] _T_2390 = _T_2041 ? 2'h1 : _T_2389; // @[Mux.scala 98:16]
  wire [1:0] _T_2391 = _T_2039 ? 2'h1 : _T_2390; // @[Mux.scala 98:16]
  wire [1:0] _T_2392 = _T_2037 ? 2'h1 : _T_2391; // @[Mux.scala 98:16]
  wire [1:0] _T_2393 = _T_2035 ? 2'h1 : _T_2392; // @[Mux.scala 98:16]
  wire [1:0] _T_2394 = _T_2033 ? 2'h2 : _T_2393; // @[Mux.scala 98:16]
  wire [1:0] _T_2395 = _T_2031 ? 2'h2 : _T_2394; // @[Mux.scala 98:16]
  wire [1:0] _T_2396 = _T_2029 ? 2'h2 : _T_2395; // @[Mux.scala 98:16]
  wire [1:0] _T_2397 = _T_2027 ? 2'h2 : _T_2396; // @[Mux.scala 98:16]
  wire [1:0] _T_2398 = _T_2025 ? 2'h2 : _T_2397; // @[Mux.scala 98:16]
  wire [1:0] _T_2399 = _T_2023 ? 2'h2 : _T_2398; // @[Mux.scala 98:16]
  wire [1:0] _T_2400 = _T_2021 ? 2'h2 : _T_2399; // @[Mux.scala 98:16]
  wire [1:0] _T_2401 = _T_2019 ? 2'h2 : _T_2400; // @[Mux.scala 98:16]
  wire [1:0] _T_2402 = _T_2017 ? 2'h2 : _T_2401; // @[Mux.scala 98:16]
  wire [1:0] _T_2403 = _T_2015 ? 2'h2 : _T_2402; // @[Mux.scala 98:16]
  wire [1:0] _T_2404 = _T_2013 ? 2'h2 : _T_2403; // @[Mux.scala 98:16]
  wire [1:0] _T_2405 = _T_2011 ? 2'h2 : _T_2404; // @[Mux.scala 98:16]
  wire [1:0] _T_2406 = _T_2009 ? 2'h2 : _T_2405; // @[Mux.scala 98:16]
  wire [1:0] _T_2407 = _T_2007 ? 2'h2 : _T_2406; // @[Mux.scala 98:16]
  wire [1:0] _T_2408 = _T_2005 ? 2'h2 : _T_2407; // @[Mux.scala 98:16]
  wire [1:0] _T_2409 = _T_2003 ? 2'h2 : _T_2408; // @[Mux.scala 98:16]
  wire [1:0] _T_2410 = _T_2001 ? 2'h2 : _T_2409; // @[Mux.scala 98:16]
  wire [1:0] _T_2411 = _T_1999 ? 2'h1 : _T_2410; // @[Mux.scala 98:16]
  wire [1:0] _T_2412 = _T_1997 ? 2'h1 : _T_2411; // @[Mux.scala 98:16]
  wire [1:0] _T_2413 = _T_1995 ? 2'h1 : _T_2412; // @[Mux.scala 98:16]
  wire [1:0] _T_2414 = _T_1993 ? 2'h1 : _T_2413; // @[Mux.scala 98:16]
  wire [1:0] _T_2415 = _T_1991 ? 2'h1 : _T_2414; // @[Mux.scala 98:16]
  wire [1:0] _T_2416 = _T_1989 ? 2'h1 : _T_2415; // @[Mux.scala 98:16]
  wire [1:0] _T_2417 = _T_1987 ? 2'h2 : _T_2416; // @[Mux.scala 98:16]
  wire [1:0] _T_2418 = _T_1985 ? 2'h2 : _T_2417; // @[Mux.scala 98:16]
  wire [2:0] _T_2528 = _T_2059 ? 3'h5 : 3'h0; // @[Mux.scala 98:16]
  wire [2:0] _T_2529 = _T_2057 ? 3'h5 : _T_2528; // @[Mux.scala 98:16]
  wire [2:0] _T_2530 = _T_2055 ? 3'h5 : _T_2529; // @[Mux.scala 98:16]
  wire [2:0] _T_2531 = _T_2053 ? 3'h0 : _T_2530; // @[Mux.scala 98:16]
  wire [2:0] _T_2532 = _T_2051 ? 3'h0 : _T_2531; // @[Mux.scala 98:16]
  wire [2:0] _T_2533 = _T_2049 ? 3'h0 : _T_2532; // @[Mux.scala 98:16]
  wire [2:0] _T_2534 = _T_2047 ? 3'h0 : _T_2533; // @[Mux.scala 98:16]
  wire [2:0] _T_2535 = _T_2045 ? 3'h0 : _T_2534; // @[Mux.scala 98:16]
  wire [2:0] _T_2536 = _T_2043 ? 3'h0 : _T_2535; // @[Mux.scala 98:16]
  wire [2:0] _T_2537 = _T_2041 ? 3'h0 : _T_2536; // @[Mux.scala 98:16]
  wire [2:0] _T_2538 = _T_2039 ? 3'h0 : _T_2537; // @[Mux.scala 98:16]
  wire [2:0] _T_2539 = _T_2037 ? 3'h0 : _T_2538; // @[Mux.scala 98:16]
  wire [2:0] _T_2540 = _T_2035 ? 3'h0 : _T_2539; // @[Mux.scala 98:16]
  wire [2:0] _T_2541 = _T_2033 ? 3'h0 : _T_2540; // @[Mux.scala 98:16]
  wire [2:0] _T_2542 = _T_2031 ? 3'h0 : _T_2541; // @[Mux.scala 98:16]
  wire [2:0] _T_2543 = _T_2029 ? 3'h0 : _T_2542; // @[Mux.scala 98:16]
  wire [2:0] _T_2544 = _T_2027 ? 3'h0 : _T_2543; // @[Mux.scala 98:16]
  wire [2:0] _T_2545 = _T_2025 ? 3'h0 : _T_2544; // @[Mux.scala 98:16]
  wire [2:0] _T_2546 = _T_2023 ? 3'h0 : _T_2545; // @[Mux.scala 98:16]
  wire [2:0] _T_2547 = _T_2021 ? 3'h0 : _T_2546; // @[Mux.scala 98:16]
  wire [2:0] _T_2548 = _T_2019 ? 3'h0 : _T_2547; // @[Mux.scala 98:16]
  wire [2:0] _T_2549 = _T_2017 ? 3'h0 : _T_2548; // @[Mux.scala 98:16]
  wire [2:0] _T_2550 = _T_2015 ? 3'h1 : _T_2549; // @[Mux.scala 98:16]
  wire [2:0] _T_2551 = _T_2013 ? 3'h1 : _T_2550; // @[Mux.scala 98:16]
  wire [2:0] _T_2552 = _T_2011 ? 3'h1 : _T_2551; // @[Mux.scala 98:16]
  wire [2:0] _T_2553 = _T_2009 ? 3'h0 : _T_2552; // @[Mux.scala 98:16]
  wire [2:0] _T_2554 = _T_2007 ? 3'h0 : _T_2553; // @[Mux.scala 98:16]
  wire [2:0] _T_2555 = _T_2005 ? 3'h0 : _T_2554; // @[Mux.scala 98:16]
  wire [2:0] _T_2556 = _T_2003 ? 3'h0 : _T_2555; // @[Mux.scala 98:16]
  wire [2:0] _T_2557 = _T_2001 ? 3'h0 : _T_2556; // @[Mux.scala 98:16]
  wire [2:0] _T_2558 = _T_1999 ? 3'h2 : _T_2557; // @[Mux.scala 98:16]
  wire [2:0] _T_2559 = _T_1997 ? 3'h2 : _T_2558; // @[Mux.scala 98:16]
  wire [2:0] _T_2560 = _T_1995 ? 3'h2 : _T_2559; // @[Mux.scala 98:16]
  wire [2:0] _T_2561 = _T_1993 ? 3'h2 : _T_2560; // @[Mux.scala 98:16]
  wire [2:0] _T_2562 = _T_1991 ? 3'h2 : _T_2561; // @[Mux.scala 98:16]
  wire [2:0] _T_2563 = _T_1989 ? 3'h2 : _T_2562; // @[Mux.scala 98:16]
  wire [2:0] _T_2564 = _T_1987 ? 3'h0 : _T_2563; // @[Mux.scala 98:16]
  wire [2:0] _T_2565 = _T_1985 ? 3'h4 : _T_2564; // @[Mux.scala 98:16]
  wire [3:0] _T_2672 = _T_2065 ? 4'h8 : 4'h0; // @[Mux.scala 98:16]
  wire [3:0] _T_2673 = _T_2063 ? 4'h8 : _T_2672; // @[Mux.scala 98:16]
  wire [3:0] _T_2674 = _T_2061 ? 4'h8 : _T_2673; // @[Mux.scala 98:16]
  wire [3:0] _T_2675 = _T_2059 ? 4'h0 : _T_2674; // @[Mux.scala 98:16]
  wire [3:0] _T_2676 = _T_2057 ? 4'h0 : _T_2675; // @[Mux.scala 98:16]
  wire [3:0] _T_2677 = _T_2055 ? 4'h0 : _T_2676; // @[Mux.scala 98:16]
  wire [3:0] _T_2678 = _T_2053 ? 4'h7 : _T_2677; // @[Mux.scala 98:16]
  wire [3:0] _T_2679 = _T_2051 ? 4'h6 : _T_2678; // @[Mux.scala 98:16]
  wire [3:0] _T_2680 = _T_2049 ? 4'hb : _T_2679; // @[Mux.scala 98:16]
  wire [3:0] _T_2681 = _T_2047 ? 4'h5 : _T_2680; // @[Mux.scala 98:16]
  wire [3:0] _T_2682 = _T_2045 ? 4'h4 : _T_2681; // @[Mux.scala 98:16]
  wire [3:0] _T_2683 = _T_2043 ? 4'he : _T_2682; // @[Mux.scala 98:16]
  wire [3:0] _T_2684 = _T_2041 ? 4'hc : _T_2683; // @[Mux.scala 98:16]
  wire [3:0] _T_2685 = _T_2039 ? 4'h1 : _T_2684; // @[Mux.scala 98:16]
  wire [3:0] _T_2686 = _T_2037 ? 4'ha : _T_2685; // @[Mux.scala 98:16]
  wire [3:0] _T_2687 = _T_2035 ? 4'h0 : _T_2686; // @[Mux.scala 98:16]
  wire [3:0] _T_2688 = _T_2033 ? 4'hb : _T_2687; // @[Mux.scala 98:16]
  wire [3:0] _T_2689 = _T_2031 ? 4'h5 : _T_2688; // @[Mux.scala 98:16]
  wire [3:0] _T_2690 = _T_2029 ? 4'h1 : _T_2689; // @[Mux.scala 98:16]
  wire [3:0] _T_2691 = _T_2027 ? 4'h7 : _T_2690; // @[Mux.scala 98:16]
  wire [3:0] _T_2692 = _T_2025 ? 4'h6 : _T_2691; // @[Mux.scala 98:16]
  wire [3:0] _T_2693 = _T_2023 ? 4'h4 : _T_2692; // @[Mux.scala 98:16]
  wire [3:0] _T_2694 = _T_2021 ? 4'he : _T_2693; // @[Mux.scala 98:16]
  wire [3:0] _T_2695 = _T_2019 ? 4'hc : _T_2694; // @[Mux.scala 98:16]
  wire [3:0] _T_2696 = _T_2017 ? 4'h0 : _T_2695; // @[Mux.scala 98:16]
  wire [3:0] _T_2697 = _T_2015 ? 4'h0 : _T_2696; // @[Mux.scala 98:16]
  wire [3:0] _T_2698 = _T_2013 ? 4'h0 : _T_2697; // @[Mux.scala 98:16]
  wire [3:0] _T_2699 = _T_2011 ? 4'h0 : _T_2698; // @[Mux.scala 98:16]
  wire [3:0] _T_2700 = _T_2009 ? 4'h0 : _T_2699; // @[Mux.scala 98:16]
  wire [3:0] _T_2701 = _T_2007 ? 4'h0 : _T_2700; // @[Mux.scala 98:16]
  wire [3:0] _T_2702 = _T_2005 ? 4'h0 : _T_2701; // @[Mux.scala 98:16]
  wire [3:0] _T_2703 = _T_2003 ? 4'h0 : _T_2702; // @[Mux.scala 98:16]
  wire [3:0] _T_2704 = _T_2001 ? 4'h0 : _T_2703; // @[Mux.scala 98:16]
  wire [3:0] _T_2705 = _T_1999 ? 4'hf : _T_2704; // @[Mux.scala 98:16]
  wire [3:0] _T_2706 = _T_1997 ? 4'he : _T_2705; // @[Mux.scala 98:16]
  wire [3:0] _T_2707 = _T_1995 ? 4'hd : _T_2706; // @[Mux.scala 98:16]
  wire [3:0] _T_2708 = _T_1993 ? 4'hc : _T_2707; // @[Mux.scala 98:16]
  wire [3:0] _T_2709 = _T_1991 ? 4'h3 : _T_2708; // @[Mux.scala 98:16]
  wire [3:0] _T_2710 = _T_1989 ? 4'h2 : _T_2709; // @[Mux.scala 98:16]
  wire [3:0] _T_2711 = _T_1987 ? 4'h0 : _T_2710; // @[Mux.scala 98:16]
  wire [3:0] _T_2712 = _T_1985 ? 4'h0 : _T_2711; // @[Mux.scala 98:16]
  wire [1:0] _T_2816 = _T_2071 ? 2'h3 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_2817 = _T_2069 ? 2'h0 : _T_2816; // @[Mux.scala 98:16]
  wire [1:0] _T_2818 = _T_2067 ? 2'h0 : _T_2817; // @[Mux.scala 98:16]
  wire [1:0] _T_2819 = _T_2065 ? 2'h3 : _T_2818; // @[Mux.scala 98:16]
  wire [1:0] _T_2820 = _T_2063 ? 2'h3 : _T_2819; // @[Mux.scala 98:16]
  wire [1:0] _T_2821 = _T_2061 ? 2'h3 : _T_2820; // @[Mux.scala 98:16]
  wire [1:0] _T_2822 = _T_2059 ? 2'h3 : _T_2821; // @[Mux.scala 98:16]
  wire [1:0] _T_2823 = _T_2057 ? 2'h3 : _T_2822; // @[Mux.scala 98:16]
  wire [1:0] _T_2824 = _T_2055 ? 2'h3 : _T_2823; // @[Mux.scala 98:16]
  wire [1:0] _T_2825 = _T_2053 ? 2'h1 : _T_2824; // @[Mux.scala 98:16]
  wire [1:0] _T_2826 = _T_2051 ? 2'h1 : _T_2825; // @[Mux.scala 98:16]
  wire [1:0] _T_2827 = _T_2049 ? 2'h1 : _T_2826; // @[Mux.scala 98:16]
  wire [1:0] _T_2828 = _T_2047 ? 2'h1 : _T_2827; // @[Mux.scala 98:16]
  wire [1:0] _T_2829 = _T_2045 ? 2'h1 : _T_2828; // @[Mux.scala 98:16]
  wire [1:0] _T_2830 = _T_2043 ? 2'h1 : _T_2829; // @[Mux.scala 98:16]
  wire [1:0] _T_2831 = _T_2041 ? 2'h1 : _T_2830; // @[Mux.scala 98:16]
  wire [1:0] _T_2832 = _T_2039 ? 2'h1 : _T_2831; // @[Mux.scala 98:16]
  wire [1:0] _T_2833 = _T_2037 ? 2'h1 : _T_2832; // @[Mux.scala 98:16]
  wire [1:0] _T_2834 = _T_2035 ? 2'h1 : _T_2833; // @[Mux.scala 98:16]
  wire [1:0] _T_2835 = _T_2033 ? 2'h1 : _T_2834; // @[Mux.scala 98:16]
  wire [1:0] _T_2836 = _T_2031 ? 2'h1 : _T_2835; // @[Mux.scala 98:16]
  wire [1:0] _T_2837 = _T_2029 ? 2'h1 : _T_2836; // @[Mux.scala 98:16]
  wire [1:0] _T_2838 = _T_2027 ? 2'h1 : _T_2837; // @[Mux.scala 98:16]
  wire [1:0] _T_2839 = _T_2025 ? 2'h1 : _T_2838; // @[Mux.scala 98:16]
  wire [1:0] _T_2840 = _T_2023 ? 2'h1 : _T_2839; // @[Mux.scala 98:16]
  wire [1:0] _T_2841 = _T_2021 ? 2'h1 : _T_2840; // @[Mux.scala 98:16]
  wire [1:0] _T_2842 = _T_2019 ? 2'h1 : _T_2841; // @[Mux.scala 98:16]
  wire [1:0] _T_2843 = _T_2017 ? 2'h1 : _T_2842; // @[Mux.scala 98:16]
  wire [1:0] _T_2844 = _T_2015 ? 2'h0 : _T_2843; // @[Mux.scala 98:16]
  wire [1:0] _T_2845 = _T_2013 ? 2'h0 : _T_2844; // @[Mux.scala 98:16]
  wire [1:0] _T_2846 = _T_2011 ? 2'h0 : _T_2845; // @[Mux.scala 98:16]
  wire [1:0] _T_2847 = _T_2009 ? 2'h2 : _T_2846; // @[Mux.scala 98:16]
  wire [1:0] _T_2848 = _T_2007 ? 2'h2 : _T_2847; // @[Mux.scala 98:16]
  wire [1:0] _T_2849 = _T_2005 ? 2'h2 : _T_2848; // @[Mux.scala 98:16]
  wire [1:0] _T_2850 = _T_2003 ? 2'h2 : _T_2849; // @[Mux.scala 98:16]
  wire [1:0] _T_2851 = _T_2001 ? 2'h2 : _T_2850; // @[Mux.scala 98:16]
  wire [1:0] _T_2852 = _T_1999 ? 2'h0 : _T_2851; // @[Mux.scala 98:16]
  wire [1:0] _T_2853 = _T_1997 ? 2'h0 : _T_2852; // @[Mux.scala 98:16]
  wire [1:0] _T_2854 = _T_1995 ? 2'h0 : _T_2853; // @[Mux.scala 98:16]
  wire [1:0] _T_2855 = _T_1993 ? 2'h0 : _T_2854; // @[Mux.scala 98:16]
  wire [1:0] _T_2856 = _T_1991 ? 2'h0 : _T_2855; // @[Mux.scala 98:16]
  wire [1:0] _T_2857 = _T_1989 ? 2'h0 : _T_2856; // @[Mux.scala 98:16]
  wire [1:0] _T_2858 = _T_1987 ? 2'h0 : _T_2857; // @[Mux.scala 98:16]
  wire [1:0] _T_2859 = _T_1985 ? 2'h0 : _T_2858; // @[Mux.scala 98:16]
  wire  _T_2991 = _T_2015 ? 1'h0 : _T_2017 | (_T_2019 | (_T_2021 | (_T_2023 | (_T_2025 | (_T_2027 | (_T_2029 | (_T_2031
     | (_T_2033 | (_T_2035 | (_T_2037 | (_T_2039 | (_T_2041 | (_T_2043 | (_T_2045 | (_T_2047 | (_T_2049 | (_T_2051 | (
    _T_2053 | (_T_2055 | (_T_2057 | (_T_2059 | (_T_2061 | (_T_2063 | _T_2065))))))))))))))))))))))); // @[Mux.scala 98:16]
  wire  _T_2992 = _T_2013 ? 1'h0 : _T_2991; // @[Mux.scala 98:16]
  wire  _T_2993 = _T_2011 ? 1'h0 : _T_2992; // @[Mux.scala 98:16]
  wire  _T_2999 = _T_1999 ? 1'h0 : _T_2001 | (_T_2003 | (_T_2005 | (_T_2007 | (_T_2009 | _T_2993)))); // @[Mux.scala 98:16]
  wire  _T_3000 = _T_1997 ? 1'h0 : _T_2999; // @[Mux.scala 98:16]
  wire  _T_3001 = _T_1995 ? 1'h0 : _T_3000; // @[Mux.scala 98:16]
  wire  _T_3002 = _T_1993 ? 1'h0 : _T_3001; // @[Mux.scala 98:16]
  wire  _T_3003 = _T_1991 ? 1'h0 : _T_3002; // @[Mux.scala 98:16]
  wire  _T_3004 = _T_1989 ? 1'h0 : _T_3003; // @[Mux.scala 98:16]
  wire  id_ctrl_rf_wen = _T_1981 | (_T_1983 | (_T_1985 | (_T_1987 | _T_3004))); // @[Mux.scala 98:16]
  wire  _T_3108 = _T_2075 ? 1'h0 : _T_2077; // @[Mux.scala 98:16]
  wire  _T_3109 = _T_2073 ? 1'h0 : _T_3108; // @[Mux.scala 98:16]
  wire  _T_3110 = _T_2071 ? 1'h0 : _T_3109; // @[Mux.scala 98:16]
  wire  _T_3111 = _T_2069 ? 1'h0 : _T_3110; // @[Mux.scala 98:16]
  wire  _T_3112 = _T_2067 ? 1'h0 : _T_3111; // @[Mux.scala 98:16]
  wire  _T_3113 = _T_2065 ? 1'h0 : _T_3112; // @[Mux.scala 98:16]
  wire  _T_3114 = _T_2063 ? 1'h0 : _T_3113; // @[Mux.scala 98:16]
  wire  _T_3115 = _T_2061 ? 1'h0 : _T_3114; // @[Mux.scala 98:16]
  wire  _T_3116 = _T_2059 ? 1'h0 : _T_3115; // @[Mux.scala 98:16]
  wire  _T_3117 = _T_2057 ? 1'h0 : _T_3116; // @[Mux.scala 98:16]
  wire  _T_3118 = _T_2055 ? 1'h0 : _T_3117; // @[Mux.scala 98:16]
  wire  _T_3119 = _T_2053 ? 1'h0 : _T_3118; // @[Mux.scala 98:16]
  wire  _T_3120 = _T_2051 ? 1'h0 : _T_3119; // @[Mux.scala 98:16]
  wire  _T_3121 = _T_2049 ? 1'h0 : _T_3120; // @[Mux.scala 98:16]
  wire  _T_3122 = _T_2047 ? 1'h0 : _T_3121; // @[Mux.scala 98:16]
  wire  _T_3123 = _T_2045 ? 1'h0 : _T_3122; // @[Mux.scala 98:16]
  wire  _T_3124 = _T_2043 ? 1'h0 : _T_3123; // @[Mux.scala 98:16]
  wire  _T_3125 = _T_2041 ? 1'h0 : _T_3124; // @[Mux.scala 98:16]
  wire  _T_3126 = _T_2039 ? 1'h0 : _T_3125; // @[Mux.scala 98:16]
  wire  _T_3127 = _T_2037 ? 1'h0 : _T_3126; // @[Mux.scala 98:16]
  wire  _T_3128 = _T_2035 ? 1'h0 : _T_3127; // @[Mux.scala 98:16]
  wire  _T_3129 = _T_2033 ? 1'h0 : _T_3128; // @[Mux.scala 98:16]
  wire  _T_3130 = _T_2031 ? 1'h0 : _T_3129; // @[Mux.scala 98:16]
  wire  _T_3131 = _T_2029 ? 1'h0 : _T_3130; // @[Mux.scala 98:16]
  wire  _T_3132 = _T_2027 ? 1'h0 : _T_3131; // @[Mux.scala 98:16]
  wire  _T_3133 = _T_2025 ? 1'h0 : _T_3132; // @[Mux.scala 98:16]
  wire  _T_3134 = _T_2023 ? 1'h0 : _T_3133; // @[Mux.scala 98:16]
  wire  _T_3135 = _T_2021 ? 1'h0 : _T_3134; // @[Mux.scala 98:16]
  wire  _T_3136 = _T_2019 ? 1'h0 : _T_3135; // @[Mux.scala 98:16]
  wire  _T_3137 = _T_2017 ? 1'h0 : _T_3136; // @[Mux.scala 98:16]
  wire  _T_3146 = _T_1999 ? 1'h0 : _T_2001 | (_T_2003 | (_T_2005 | (_T_2007 | (_T_2009 | (_T_2011 | (_T_2013 | (_T_2015
     | _T_3137))))))); // @[Mux.scala 98:16]
  wire  _T_3147 = _T_1997 ? 1'h0 : _T_3146; // @[Mux.scala 98:16]
  wire  _T_3148 = _T_1995 ? 1'h0 : _T_3147; // @[Mux.scala 98:16]
  wire  _T_3149 = _T_1993 ? 1'h0 : _T_3148; // @[Mux.scala 98:16]
  wire  _T_3150 = _T_1991 ? 1'h0 : _T_3149; // @[Mux.scala 98:16]
  wire  _T_3151 = _T_1989 ? 1'h0 : _T_3150; // @[Mux.scala 98:16]
  wire  _T_3152 = _T_1987 ? 1'h0 : _T_3151; // @[Mux.scala 98:16]
  wire  _T_3153 = _T_1985 ? 1'h0 : _T_3152; // @[Mux.scala 98:16]
  wire [1:0] _T_3285 = _T_2015 ? 2'h2 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_3286 = _T_2013 ? 2'h2 : _T_3285; // @[Mux.scala 98:16]
  wire [1:0] _T_3287 = _T_2011 ? 2'h2 : _T_3286; // @[Mux.scala 98:16]
  wire [1:0] _T_3288 = _T_2009 ? 2'h1 : _T_3287; // @[Mux.scala 98:16]
  wire [1:0] _T_3289 = _T_2007 ? 2'h1 : _T_3288; // @[Mux.scala 98:16]
  wire [1:0] _T_3290 = _T_2005 ? 2'h1 : _T_3289; // @[Mux.scala 98:16]
  wire [1:0] _T_3291 = _T_2003 ? 2'h1 : _T_3290; // @[Mux.scala 98:16]
  wire [1:0] _T_3292 = _T_2001 ? 2'h1 : _T_3291; // @[Mux.scala 98:16]
  wire [1:0] _T_3293 = _T_1999 ? 2'h0 : _T_3292; // @[Mux.scala 98:16]
  wire [1:0] _T_3294 = _T_1997 ? 2'h0 : _T_3293; // @[Mux.scala 98:16]
  wire [1:0] _T_3295 = _T_1995 ? 2'h0 : _T_3294; // @[Mux.scala 98:16]
  wire [1:0] _T_3296 = _T_1993 ? 2'h0 : _T_3295; // @[Mux.scala 98:16]
  wire [1:0] _T_3297 = _T_1991 ? 2'h0 : _T_3296; // @[Mux.scala 98:16]
  wire [1:0] _T_3298 = _T_1989 ? 2'h0 : _T_3297; // @[Mux.scala 98:16]
  wire [1:0] _T_3299 = _T_1987 ? 2'h0 : _T_3298; // @[Mux.scala 98:16]
  wire [1:0] _T_3300 = _T_1985 ? 2'h0 : _T_3299; // @[Mux.scala 98:16]
  wire [1:0] _T_3432 = _T_2015 ? 2'h3 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_3433 = _T_2013 ? 2'h2 : _T_3432; // @[Mux.scala 98:16]
  wire [1:0] _T_3434 = _T_2011 ? 2'h1 : _T_3433; // @[Mux.scala 98:16]
  wire [2:0] _T_3435 = _T_2009 ? 3'h6 : {{1'd0}, _T_3434}; // @[Mux.scala 98:16]
  wire [2:0] _T_3436 = _T_2007 ? 3'h5 : _T_3435; // @[Mux.scala 98:16]
  wire [2:0] _T_3437 = _T_2005 ? 3'h3 : _T_3436; // @[Mux.scala 98:16]
  wire [2:0] _T_3438 = _T_2003 ? 3'h2 : _T_3437; // @[Mux.scala 98:16]
  wire [2:0] _T_3439 = _T_2001 ? 3'h1 : _T_3438; // @[Mux.scala 98:16]
  wire [2:0] _T_3440 = _T_1999 ? 3'h0 : _T_3439; // @[Mux.scala 98:16]
  wire [2:0] _T_3441 = _T_1997 ? 3'h0 : _T_3440; // @[Mux.scala 98:16]
  wire [2:0] _T_3442 = _T_1995 ? 3'h0 : _T_3441; // @[Mux.scala 98:16]
  wire [2:0] _T_3443 = _T_1993 ? 3'h0 : _T_3442; // @[Mux.scala 98:16]
  wire [2:0] _T_3444 = _T_1991 ? 3'h0 : _T_3443; // @[Mux.scala 98:16]
  wire [2:0] _T_3445 = _T_1989 ? 3'h0 : _T_3444; // @[Mux.scala 98:16]
  wire [2:0] _T_3446 = _T_1987 ? 3'h0 : _T_3445; // @[Mux.scala 98:16]
  wire [2:0] _T_3447 = _T_1985 ? 3'h0 : _T_3446; // @[Mux.scala 98:16]
  wire [2:0] _T_3550 = _T_2073 ? 3'h4 : 3'h0; // @[Mux.scala 98:16]
  wire [2:0] _T_3551 = _T_2071 ? 3'h4 : _T_3550; // @[Mux.scala 98:16]
  wire [2:0] _T_3552 = _T_2069 ? 3'h4 : _T_3551; // @[Mux.scala 98:16]
  wire [2:0] _T_3553 = _T_2067 ? 3'h4 : _T_3552; // @[Mux.scala 98:16]
  wire [2:0] _T_3554 = _T_2065 ? 3'h3 : _T_3553; // @[Mux.scala 98:16]
  wire [2:0] _T_3555 = _T_2063 ? 3'h2 : _T_3554; // @[Mux.scala 98:16]
  wire [2:0] _T_3556 = _T_2061 ? 3'h1 : _T_3555; // @[Mux.scala 98:16]
  wire [2:0] _T_3557 = _T_2059 ? 3'h3 : _T_3556; // @[Mux.scala 98:16]
  wire [2:0] _T_3558 = _T_2057 ? 3'h2 : _T_3557; // @[Mux.scala 98:16]
  wire [2:0] _T_3559 = _T_2055 ? 3'h1 : _T_3558; // @[Mux.scala 98:16]
  wire [2:0] _T_3560 = _T_2053 ? 3'h0 : _T_3559; // @[Mux.scala 98:16]
  wire [2:0] _T_3561 = _T_2051 ? 3'h0 : _T_3560; // @[Mux.scala 98:16]
  wire [2:0] _T_3562 = _T_2049 ? 3'h0 : _T_3561; // @[Mux.scala 98:16]
  wire [2:0] _T_3563 = _T_2047 ? 3'h0 : _T_3562; // @[Mux.scala 98:16]
  wire [2:0] _T_3564 = _T_2045 ? 3'h0 : _T_3563; // @[Mux.scala 98:16]
  wire [2:0] _T_3565 = _T_2043 ? 3'h0 : _T_3564; // @[Mux.scala 98:16]
  wire [2:0] _T_3566 = _T_2041 ? 3'h0 : _T_3565; // @[Mux.scala 98:16]
  wire [2:0] _T_3567 = _T_2039 ? 3'h0 : _T_3566; // @[Mux.scala 98:16]
  wire [2:0] _T_3568 = _T_2037 ? 3'h0 : _T_3567; // @[Mux.scala 98:16]
  wire [2:0] _T_3569 = _T_2035 ? 3'h0 : _T_3568; // @[Mux.scala 98:16]
  wire [2:0] _T_3570 = _T_2033 ? 3'h0 : _T_3569; // @[Mux.scala 98:16]
  wire [2:0] _T_3571 = _T_2031 ? 3'h0 : _T_3570; // @[Mux.scala 98:16]
  wire [2:0] _T_3572 = _T_2029 ? 3'h0 : _T_3571; // @[Mux.scala 98:16]
  wire [2:0] _T_3573 = _T_2027 ? 3'h0 : _T_3572; // @[Mux.scala 98:16]
  wire [2:0] _T_3574 = _T_2025 ? 3'h0 : _T_3573; // @[Mux.scala 98:16]
  wire [2:0] _T_3575 = _T_2023 ? 3'h0 : _T_3574; // @[Mux.scala 98:16]
  wire [2:0] _T_3576 = _T_2021 ? 3'h0 : _T_3575; // @[Mux.scala 98:16]
  wire [2:0] _T_3577 = _T_2019 ? 3'h0 : _T_3576; // @[Mux.scala 98:16]
  wire [2:0] _T_3578 = _T_2017 ? 3'h0 : _T_3577; // @[Mux.scala 98:16]
  wire [2:0] _T_3579 = _T_2015 ? 3'h0 : _T_3578; // @[Mux.scala 98:16]
  wire [2:0] _T_3580 = _T_2013 ? 3'h0 : _T_3579; // @[Mux.scala 98:16]
  wire [2:0] _T_3581 = _T_2011 ? 3'h0 : _T_3580; // @[Mux.scala 98:16]
  wire [2:0] _T_3582 = _T_2009 ? 3'h0 : _T_3581; // @[Mux.scala 98:16]
  wire [2:0] _T_3583 = _T_2007 ? 3'h0 : _T_3582; // @[Mux.scala 98:16]
  wire [2:0] _T_3584 = _T_2005 ? 3'h0 : _T_3583; // @[Mux.scala 98:16]
  wire [2:0] _T_3585 = _T_2003 ? 3'h0 : _T_3584; // @[Mux.scala 98:16]
  wire [2:0] _T_3586 = _T_2001 ? 3'h0 : _T_3585; // @[Mux.scala 98:16]
  wire [2:0] _T_3587 = _T_1999 ? 3'h0 : _T_3586; // @[Mux.scala 98:16]
  wire [2:0] _T_3588 = _T_1997 ? 3'h0 : _T_3587; // @[Mux.scala 98:16]
  wire [2:0] _T_3589 = _T_1995 ? 3'h0 : _T_3588; // @[Mux.scala 98:16]
  wire [2:0] _T_3590 = _T_1993 ? 3'h0 : _T_3589; // @[Mux.scala 98:16]
  wire [2:0] _T_3591 = _T_1991 ? 3'h0 : _T_3590; // @[Mux.scala 98:16]
  wire [2:0] _T_3592 = _T_1989 ? 3'h0 : _T_3591; // @[Mux.scala 98:16]
  wire [2:0] _T_3593 = _T_1987 ? 3'h0 : _T_3592; // @[Mux.scala 98:16]
  wire [2:0] _T_3594 = _T_1985 ? 3'h0 : _T_3593; // @[Mux.scala 98:16]
  wire [2:0] _T_3595 = _T_1983 ? 3'h0 : _T_3594; // @[Mux.scala 98:16]
  wire [2:0] id_ctrl_csr_cmd = _T_1981 ? 3'h0 : _T_3595; // @[Mux.scala 98:16]
  reg [31:0] rv32i_reg_0; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_1; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_2; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_3; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_4; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_5; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_6; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_7; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_8; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_9; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_10; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_11; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_12; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_13; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_14; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_15; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_16; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_17; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_18; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_19; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_20; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_21; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_22; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_23; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_24; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_25; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_26; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_27; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_28; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_29; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_30; // @[core.scala 268:39]
  reg [31:0] rv32i_reg_31; // @[core.scala 268:39]
  wire [31:0] _GEN_87 = 5'h1 == idm_io_inst_rs1 ? rv32i_reg_1 : rv32i_reg_0; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_88 = 5'h2 == idm_io_inst_rs1 ? rv32i_reg_2 : _GEN_87; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_89 = 5'h3 == idm_io_inst_rs1 ? rv32i_reg_3 : _GEN_88; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_90 = 5'h4 == idm_io_inst_rs1 ? rv32i_reg_4 : _GEN_89; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_91 = 5'h5 == idm_io_inst_rs1 ? rv32i_reg_5 : _GEN_90; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_92 = 5'h6 == idm_io_inst_rs1 ? rv32i_reg_6 : _GEN_91; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_93 = 5'h7 == idm_io_inst_rs1 ? rv32i_reg_7 : _GEN_92; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_94 = 5'h8 == idm_io_inst_rs1 ? rv32i_reg_8 : _GEN_93; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_95 = 5'h9 == idm_io_inst_rs1 ? rv32i_reg_9 : _GEN_94; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_96 = 5'ha == idm_io_inst_rs1 ? rv32i_reg_10 : _GEN_95; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_97 = 5'hb == idm_io_inst_rs1 ? rv32i_reg_11 : _GEN_96; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_98 = 5'hc == idm_io_inst_rs1 ? rv32i_reg_12 : _GEN_97; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_99 = 5'hd == idm_io_inst_rs1 ? rv32i_reg_13 : _GEN_98; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_100 = 5'he == idm_io_inst_rs1 ? rv32i_reg_14 : _GEN_99; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_101 = 5'hf == idm_io_inst_rs1 ? rv32i_reg_15 : _GEN_100; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_102 = 5'h10 == idm_io_inst_rs1 ? rv32i_reg_16 : _GEN_101; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_103 = 5'h11 == idm_io_inst_rs1 ? rv32i_reg_17 : _GEN_102; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_104 = 5'h12 == idm_io_inst_rs1 ? rv32i_reg_18 : _GEN_103; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_105 = 5'h13 == idm_io_inst_rs1 ? rv32i_reg_19 : _GEN_104; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_106 = 5'h14 == idm_io_inst_rs1 ? rv32i_reg_20 : _GEN_105; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_107 = 5'h15 == idm_io_inst_rs1 ? rv32i_reg_21 : _GEN_106; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_108 = 5'h16 == idm_io_inst_rs1 ? rv32i_reg_22 : _GEN_107; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_109 = 5'h17 == idm_io_inst_rs1 ? rv32i_reg_23 : _GEN_108; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_110 = 5'h18 == idm_io_inst_rs1 ? rv32i_reg_24 : _GEN_109; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_111 = 5'h19 == idm_io_inst_rs1 ? rv32i_reg_25 : _GEN_110; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_112 = 5'h1a == idm_io_inst_rs1 ? rv32i_reg_26 : _GEN_111; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_113 = 5'h1b == idm_io_inst_rs1 ? rv32i_reg_27 : _GEN_112; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_114 = 5'h1c == idm_io_inst_rs1 ? rv32i_reg_28 : _GEN_113; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_115 = 5'h1d == idm_io_inst_rs1 ? rv32i_reg_29 : _GEN_114; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_116 = 5'h1e == idm_io_inst_rs1 ? rv32i_reg_30 : _GEN_115; // @[core.scala 269:27 core.scala 269:27]
  wire [31:0] _GEN_119 = 5'h1 == idm_io_inst_rs2 ? rv32i_reg_1 : rv32i_reg_0; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_120 = 5'h2 == idm_io_inst_rs2 ? rv32i_reg_2 : _GEN_119; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_121 = 5'h3 == idm_io_inst_rs2 ? rv32i_reg_3 : _GEN_120; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_122 = 5'h4 == idm_io_inst_rs2 ? rv32i_reg_4 : _GEN_121; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_123 = 5'h5 == idm_io_inst_rs2 ? rv32i_reg_5 : _GEN_122; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_124 = 5'h6 == idm_io_inst_rs2 ? rv32i_reg_6 : _GEN_123; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_125 = 5'h7 == idm_io_inst_rs2 ? rv32i_reg_7 : _GEN_124; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_126 = 5'h8 == idm_io_inst_rs2 ? rv32i_reg_8 : _GEN_125; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_127 = 5'h9 == idm_io_inst_rs2 ? rv32i_reg_9 : _GEN_126; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_128 = 5'ha == idm_io_inst_rs2 ? rv32i_reg_10 : _GEN_127; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_129 = 5'hb == idm_io_inst_rs2 ? rv32i_reg_11 : _GEN_128; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_130 = 5'hc == idm_io_inst_rs2 ? rv32i_reg_12 : _GEN_129; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_131 = 5'hd == idm_io_inst_rs2 ? rv32i_reg_13 : _GEN_130; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_132 = 5'he == idm_io_inst_rs2 ? rv32i_reg_14 : _GEN_131; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_133 = 5'hf == idm_io_inst_rs2 ? rv32i_reg_15 : _GEN_132; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_134 = 5'h10 == idm_io_inst_rs2 ? rv32i_reg_16 : _GEN_133; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_135 = 5'h11 == idm_io_inst_rs2 ? rv32i_reg_17 : _GEN_134; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_136 = 5'h12 == idm_io_inst_rs2 ? rv32i_reg_18 : _GEN_135; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_137 = 5'h13 == idm_io_inst_rs2 ? rv32i_reg_19 : _GEN_136; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_138 = 5'h14 == idm_io_inst_rs2 ? rv32i_reg_20 : _GEN_137; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_139 = 5'h15 == idm_io_inst_rs2 ? rv32i_reg_21 : _GEN_138; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_140 = 5'h16 == idm_io_inst_rs2 ? rv32i_reg_22 : _GEN_139; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_141 = 5'h17 == idm_io_inst_rs2 ? rv32i_reg_23 : _GEN_140; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_142 = 5'h18 == idm_io_inst_rs2 ? rv32i_reg_24 : _GEN_141; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_143 = 5'h19 == idm_io_inst_rs2 ? rv32i_reg_25 : _GEN_142; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_144 = 5'h1a == idm_io_inst_rs2 ? rv32i_reg_26 : _GEN_143; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_145 = 5'h1b == idm_io_inst_rs2 ? rv32i_reg_27 : _GEN_144; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_146 = 5'h1c == idm_io_inst_rs2 ? rv32i_reg_28 : _GEN_145; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_147 = 5'h1d == idm_io_inst_rs2 ? rv32i_reg_29 : _GEN_146; // @[core.scala 270:27 core.scala 270:27]
  wire [31:0] _GEN_148 = 5'h1e == idm_io_inst_rs2 ? rv32i_reg_30 : _GEN_147; // @[core.scala 270:27 core.scala 270:27]
  reg  interrupt_sig; // @[core.scala 276:38]
  wire  _GEN_156 = (stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786 | ex_ctrl_rf_wen; // @[core.scala 311:88 core.scala 314:17 core.scala 46:39]
  wire  _GEN_163 = (stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786 | ex_ctrl_legal; // @[core.scala 311:88 core.scala 314:17 core.scala 46:39]
  wire  _GEN_180 = _T_1787 & ~loadstore_proc & _T_1823 ? id_ctrl_rf_wen : _GEN_156; // @[core.scala 297:84 core.scala 300:17]
  wire  _GEN_187 = _T_1787 & ~loadstore_proc & _T_1823 ? id_ctrl_legal : _GEN_163; // @[core.scala 297:84 core.scala 300:17]
  wire  _T_3655 = ex_ctrl_imm_type == 3'h5; // @[control.scala 198:28]
  wire  _T_3657 = ex_inst[31]; // @[control.scala 198:53]
  wire  _T_3658 = ex_ctrl_imm_type == 3'h5 ? $signed(1'sh0) : $signed(_T_3657); // @[control.scala 198:23]
  wire  _T_3659 = ex_ctrl_imm_type == 3'h3; // @[control.scala 199:30]
  wire [10:0] _T_3661 = ex_inst[30:20]; // @[control.scala 199:53]
  wire [7:0] _T_3667 = ex_inst[19:12]; // @[control.scala 200:76]
  wire  _T_3671 = _T_3659 | _T_3655; // @[control.scala 201:37]
  wire  _T_3674 = ex_inst[20]; // @[control.scala 202:41]
  wire  _T_3675 = ex_ctrl_imm_type == 3'h2; // @[control.scala 203:25]
  wire  _T_3677 = ex_inst[7]; // @[control.scala 203:44]
  wire  _T_3678 = ex_ctrl_imm_type == 3'h2 ? $signed(_T_3677) : $signed(_T_3658); // @[control.scala 203:20]
  wire  _T_3679 = ex_ctrl_imm_type == 3'h4 ? $signed(_T_3674) : $signed(_T_3678); // @[control.scala 202:16]
  wire [5:0] lo_hi_hi = _T_3671 ? 6'h0 : ex_inst[30:25]; // @[control.scala 204:24]
  wire  _T_3686 = ex_ctrl_imm_type == 3'h1; // @[control.scala 206:21]
  wire [3:0] _T_3693 = _T_3655 ? ex_inst[19:16] : ex_inst[24:21]; // @[control.scala 207:20]
  wire [3:0] _T_3694 = ex_ctrl_imm_type == 3'h1 | _T_3675 ? ex_inst[11:8] : _T_3693; // @[control.scala 206:16]
  wire [3:0] lo_hi_lo = _T_3659 ? 4'h0 : _T_3694; // @[control.scala 205:23]
  wire  _T_3701 = _T_3655 & ex_inst[15]; // @[control.scala 210:20]
  wire  _T_3702 = ex_ctrl_imm_type == 3'h0 ? ex_inst[20] : _T_3701; // @[control.scala 209:16]
  wire  lo_lo = _T_3686 ? ex_inst[7] : _T_3702; // @[control.scala 208:21]
  wire  hi_lo_lo = _T_3659 | _T_3655 ? $signed(1'sh0) : $signed(_T_3679); // @[Cat.scala 30:58]
  wire [7:0] hi_lo_hi = ex_ctrl_imm_type != 3'h3 & ex_ctrl_imm_type != 3'h4 ? $signed({8{_T_3658}}) : $signed(_T_3667); // @[Cat.scala 30:58]
  wire [10:0] hi_hi_lo = ex_ctrl_imm_type == 3'h3 ? $signed(_T_3661) : $signed({11{_T_3658}}); // @[Cat.scala 30:58]
  wire  hi_hi_hi = ex_ctrl_imm_type == 3'h5 ? $signed(1'sh0) : $signed(_T_3657); // @[Cat.scala 30:58]
  wire [31:0] ex_imm = {hi_hi_hi,hi_hi_lo,hi_lo_hi,hi_lo_lo,lo_hi_hi,lo_hi_lo,lo_lo}; // @[control.scala 212:57]
  wire  _T_3704 = ex_reg_raddr_0 != 5'h0; // @[core.scala 334:26]
  wire  _T_3705 = ex_reg_raddr_0 == mem_reg_waddr; // @[core.scala 334:53]
  wire  _T_3706 = ex_reg_raddr_0 != 5'h0 & ex_reg_raddr_0 == mem_reg_waddr; // @[core.scala 334:34]
  wire  _T_3707 = mem_ctrl_csr_cmd != 3'h0; // @[core.scala 334:91]
  wire  _T_3708 = ex_reg_raddr_0 != 5'h0 & ex_reg_raddr_0 == mem_reg_waddr & mem_ctrl_csr_cmd != 3'h0; // @[core.scala 334:71]
  wire  _T_3713 = _T_3706 & mem_ctrl_rf_wen; // @[core.scala 335:71]
  wire  _T_3715 = ex_reg_raddr_0 == rf_waddr; // @[core.scala 336:53]
  wire  _T_3718 = _T_3704 & ex_reg_raddr_0 == rf_waddr & wb_ctrl_rf_wen; // @[core.scala 336:70]
  wire  _T_3721 = wb_ctrl_csr_cmd == 3'h0; // @[core.scala 336:145]
  wire  _T_3722 = _T_3704 & ex_reg_raddr_0 == rf_waddr & wb_ctrl_rf_wen & wb_ctrl_mem_en & wb_ctrl_csr_cmd == 3'h0; // @[core.scala 336:126]
  wire  _T_3728 = ~wb_ctrl_mem_en; // @[core.scala 337:116]
  wire  _T_3731 = _T_3718 & ~wb_ctrl_mem_en & _T_3721; // @[core.scala 337:126]
  wire  _T_3737 = wb_ctrl_csr_cmd != 3'h0; // @[core.scala 339:117]
  wire  _T_3738 = _T_3718 & wb_ctrl_csr_cmd != 3'h0; // @[core.scala 339:98]
  wire [31:0] _T_3739 = _T_3738 ? wb_csr_data : ex_rs_0; // @[Mux.scala 98:16]
  wire [31:0] _T_3740 = _T_3731 ? wb_alu_out : _T_3739; // @[Mux.scala 98:16]
  wire [31:0] _T_3741 = _T_3722 ? io_r_dmem_dat_data : _T_3740; // @[Mux.scala 98:16]
  wire [31:0] _T_3742 = _T_3713 ? mem_alu_out : _T_3741; // @[Mux.scala 98:16]
  wire [31:0] ex_reg_rs1_bypass = _T_3708 ? mem_csr_data : _T_3742; // @[Mux.scala 98:16]
  wire  _T_3744 = ex_reg_raddr_1 != 5'h0; // @[core.scala 342:26]
  wire  _T_3746 = ex_reg_raddr_1 != 5'h0 & ex_reg_raddr_1 == mem_reg_waddr; // @[core.scala 342:34]
  wire  _T_3748 = ex_reg_raddr_1 != 5'h0 & ex_reg_raddr_1 == mem_reg_waddr & _T_3707; // @[core.scala 342:71]
  wire  _T_3753 = _T_3746 & mem_ctrl_rf_wen; // @[core.scala 343:71]
  wire  _T_3758 = _T_3744 & ex_reg_raddr_1 == rf_waddr & wb_ctrl_rf_wen; // @[core.scala 344:70]
  wire  _T_3762 = _T_3744 & ex_reg_raddr_1 == rf_waddr & wb_ctrl_rf_wen & wb_ctrl_mem_en & _T_3721; // @[core.scala 344:126]
  wire  _T_3771 = _T_3758 & _T_3728 & _T_3721; // @[core.scala 345:126]
  wire  _T_3778 = _T_3758 & _T_3737; // @[core.scala 347:98]
  wire [31:0] _T_3779 = _T_3778 ? wb_csr_data : ex_rs_1; // @[Mux.scala 98:16]
  wire [31:0] _T_3780 = _T_3771 ? wb_alu_out : _T_3779; // @[Mux.scala 98:16]
  wire [31:0] _T_3781 = _T_3762 ? io_r_dmem_dat_data : _T_3780; // @[Mux.scala 98:16]
  wire [31:0] _T_3782 = _T_3753 ? mem_alu_out : _T_3781; // @[Mux.scala 98:16]
  wire [31:0] ex_reg_rs2_bypass = _T_3748 ? mem_csr_data : _T_3782; // @[Mux.scala 98:16]
  wire  _T_3784 = ex_ctrl_alu_op1 == 2'h1; // @[core.scala 352:26]
  wire  _T_3785 = ex_ctrl_alu_op1 == 2'h2; // @[core.scala 353:26]
  wire [31:0] _T_3788 = _T_3785 ? ex_pc : 32'h0; // @[Mux.scala 98:16]
  wire  _T_3790 = ex_ctrl_alu_op2 == 2'h1; // @[core.scala 358:26]
  wire  _T_3791 = ex_ctrl_alu_op2 == 2'h2; // @[core.scala 359:26]
  wire [31:0] _T_3792 = {hi_hi_hi,hi_hi_lo,hi_lo_hi,hi_lo_lo,lo_hi_hi,lo_hi_lo,lo_lo}; // @[core.scala 359:49]
  wire [31:0] _T_3795 = _T_3791 ? _T_3792 : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _T_3801 = _T_3707 ? mem_csr_data : mem_alu_out; // @[core.scala 371:51]
  wire [31:0] _T_3804 = _T_3737 ? wb_csr_data : wb_alu_out; // @[core.scala 372:54]
  wire [31:0] _T_3805 = _T_3715 ? _T_3804 : ex_reg_rs1_bypass; // @[core.scala 372:16]
  wire [31:0] _T_3806 = _T_3705 ? _T_3801 : _T_3805; // @[core.scala 371:12]
  wire  _GEN_204 = _T_1791 | mem_ctrl_rf_wen; // @[core.scala 418:43 core.scala 421:18 core.scala 58:40]
  wire  _GEN_226 = _T_3607 & _T_1786 ? ex_ctrl_rf_wen : _GEN_204; // @[core.scala 405:38 core.scala 408:18]
  wire  _T_3815 = ~io_sw_halt; // @[core.scala 435:21]
  wire  _T_3816 = mem_ctrl_mem_wr == 2'h2; // @[core.scala 438:47]
  wire  _T_3821 = 2'h0 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire  _T_3822 = 2'h1 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [39:0] _GEN_438 = {mem_rs_1, 8'h0}; // @[core.scala 465:53]
  wire [46:0] _T_3823 = {{7'd0}, _GEN_438}; // @[core.scala 465:53]
  wire  _T_3824 = 2'h2 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [47:0] _GEN_439 = {mem_rs_1, 16'h0}; // @[core.scala 469:53]
  wire [62:0] _T_3825 = {{15'd0}, _GEN_439}; // @[core.scala 469:53]
  wire  _T_3826 = 2'h3 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [55:0] _GEN_440 = {mem_rs_1, 24'h0}; // @[core.scala 473:53]
  wire [62:0] _T_3827 = {{7'd0}, _GEN_440}; // @[core.scala 473:53]
  wire [62:0] _GEN_247 = _T_3826 ? _T_3827 : {{31'd0}, io_sw_w_dat}; // @[Conditional.scala 39:67 core.scala 473:40]
  wire [3:0] _GEN_248 = _T_3824 ? 4'h4 : 4'h8; // @[Conditional.scala 39:67 core.scala 468:46]
  wire [62:0] _GEN_249 = _T_3824 ? _T_3825 : _GEN_247; // @[Conditional.scala 39:67 core.scala 469:40]
  wire [3:0] _GEN_250 = _T_3822 ? 4'h2 : _GEN_248; // @[Conditional.scala 39:67 core.scala 464:46]
  wire [62:0] _GEN_251 = _T_3822 ? {{16'd0}, _T_3823} : _GEN_249; // @[Conditional.scala 39:67 core.scala 465:40]
  wire [3:0] _GEN_252 = _T_3821 ? 4'h1 : _GEN_250; // @[Conditional.scala 40:58 core.scala 460:46]
  wire [62:0] _GEN_253 = _T_3821 ? {{31'd0}, mem_rs_1} : _GEN_251; // @[Conditional.scala 40:58 core.scala 461:40]
  wire [62:0] _GEN_255 = _T_3824 ? _T_3825 : {{31'd0}, io_sw_w_dat}; // @[Conditional.scala 39:67 core.scala 484:40]
  wire [3:0] _GEN_256 = _T_3821 ? 4'h3 : 4'hc; // @[Conditional.scala 40:58 core.scala 479:46]
  wire [62:0] _GEN_257 = _T_3821 ? {{31'd0}, mem_rs_1} : _GEN_255; // @[Conditional.scala 40:58 core.scala 480:40]
  wire [3:0] _GEN_258 = mem_ctrl_mask_type == 3'h2 ? _GEN_256 : 4'hf; // @[core.scala 476:49 core.scala 488:38]
  wire [62:0] _GEN_259 = mem_ctrl_mask_type == 3'h2 ? _GEN_257 : {{31'd0}, mem_rs_1}; // @[core.scala 476:49 core.scala 489:32]
  wire [3:0] _GEN_260 = mem_ctrl_mask_type == 3'h1 ? _GEN_252 : _GEN_258; // @[core.scala 457:43]
  wire [62:0] _GEN_261 = mem_ctrl_mask_type == 3'h1 ? _GEN_253 : _GEN_259; // @[core.scala 457:43]
  wire [62:0] _GEN_263 = _T_3816 ? _GEN_261 : {{31'd0}, io_sw_w_dat}; // @[core.scala 456:37]
  wire  _GEN_269 = _T_1786 ? mem_ctrl_rf_wen : wb_ctrl_rf_wen; // @[core.scala 506:24 core.scala 508:17 core.scala 69:39]
  wire  _T_3846 = 2'h0 == wb_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [23:0] hi_1 = io_r_dmem_dat_data[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] lo_1 = io_r_dmem_dat_data[7:0]; // @[core.scala 522:89]
  wire [31:0] _T_3849 = {hi_1,lo_1}; // @[Cat.scala 30:58]
  wire  _T_3850 = 2'h1 == wb_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [23:0] hi_2 = io_r_dmem_dat_data[15] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] lo_2 = io_r_dmem_dat_data[15:8]; // @[core.scala 525:90]
  wire [31:0] _T_3853 = {hi_2,lo_2}; // @[Cat.scala 30:58]
  wire  _T_3854 = 2'h2 == wb_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [23:0] hi_3 = io_r_dmem_dat_data[23] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] lo_3 = io_r_dmem_dat_data[23:16]; // @[core.scala 528:90]
  wire [31:0] _T_3857 = {hi_3,lo_3}; // @[Cat.scala 30:58]
  wire [23:0] hi_4 = io_r_dmem_dat_data[31] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] lo_4 = io_r_dmem_dat_data[31:24]; // @[core.scala 531:90]
  wire [31:0] _T_3861 = {hi_4,lo_4}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_283 = _T_3854 ? _T_3857 : _T_3861; // @[Conditional.scala 39:67 core.scala 528:31]
  wire [31:0] _GEN_284 = _T_3850 ? _T_3853 : _GEN_283; // @[Conditional.scala 39:67 core.scala 525:31]
  wire [31:0] _GEN_285 = _T_3846 ? _T_3849 : _GEN_284; // @[Conditional.scala 40:58 core.scala 522:31]
  wire [31:0] _T_3865 = {24'h0,lo_1}; // @[Cat.scala 30:58]
  wire [31:0] _T_3867 = {24'h0,lo_2}; // @[Cat.scala 30:58]
  wire [31:0] _T_3869 = {24'h0,lo_3}; // @[Cat.scala 30:58]
  wire [31:0] _T_3871 = {24'h0,lo_4}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_287 = _T_3854 ? _T_3869 : _T_3871; // @[Conditional.scala 39:67 core.scala 543:31]
  wire [31:0] _GEN_288 = _T_3850 ? _T_3867 : _GEN_287; // @[Conditional.scala 39:67 core.scala 540:31]
  wire [31:0] _GEN_289 = _T_3846 ? _T_3865 : _GEN_288; // @[Conditional.scala 40:58 core.scala 537:31]
  wire [15:0] hi_5 = io_r_dmem_dat_data[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 72:12]
  wire [15:0] lo_9 = io_r_dmem_dat_data[15:0]; // @[core.scala 552:90]
  wire [31:0] _T_3877 = {hi_5,lo_9}; // @[Cat.scala 30:58]
  wire [15:0] hi_6 = io_r_dmem_dat_data[31] ? 16'hffff : 16'h0; // @[Bitwise.scala 72:12]
  wire [15:0] lo_10 = io_r_dmem_dat_data[31:16]; // @[core.scala 555:90]
  wire [31:0] _T_3881 = {hi_6,lo_10}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_292 = _T_3854 ? _T_3881 : 32'h0; // @[Conditional.scala 39:67 core.scala 555:31]
  wire [31:0] _GEN_293 = _T_3846 ? _T_3877 : _GEN_292; // @[Conditional.scala 40:58 core.scala 552:31]
  wire [31:0] _T_3887 = {16'h0,lo_9}; // @[Cat.scala 30:58]
  wire [31:0] _T_3889 = {16'h0,lo_10}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_296 = _T_3854 ? _T_3889 : 32'h0; // @[Conditional.scala 39:67 core.scala 571:31]
  wire [31:0] _GEN_297 = _T_3846 ? _T_3887 : _GEN_296; // @[Conditional.scala 40:58 core.scala 568:31]
  wire [31:0] _GEN_298 = wb_ctrl_mask_type == 3'h6 ? _GEN_297 : io_r_dmem_dat_data; // @[core.scala 565:49 core.scala 582:23]
  wire [31:0] _GEN_299 = wb_ctrl_mask_type == 3'h2 ? _GEN_293 : _GEN_298; // @[core.scala 549:48]
  wire [31:0] _GEN_300 = wb_ctrl_mask_type == 3'h5 ? _GEN_289 : _GEN_299; // @[core.scala 534:49]
  wire [31:0] _GEN_301 = wb_ctrl_mask_type == 3'h1 ? _GEN_285 : _GEN_300; // @[core.scala 519:42]
  wire [31:0] dmem_data = _T_1776 ? _GEN_301 : io_r_dmem_dat_data; // @[core.scala 518:36 core.scala 585:19]
  wire  _T_3892 = wb_ctrl_wb_sel == 2'h1; // @[core.scala 591:25]
  wire  _T_3893 = wb_ctrl_wb_sel == 2'h0; // @[core.scala 592:25]
  wire  _T_3894 = wb_ctrl_wb_sel == 2'h3; // @[core.scala 593:25]
  wire  _T_3895 = wb_ctrl_wb_sel == 2'h2; // @[core.scala 594:25]
  wire [31:0] _T_3896 = _T_3895 ? dmem_data : wb_alu_out; // @[Mux.scala 98:16]
  wire [31:0] _T_3897 = _T_3894 ? wb_csr_data : _T_3896; // @[Mux.scala 98:16]
  wire [31:0] _T_3898 = _T_3893 ? wb_npc : _T_3897; // @[Mux.scala 98:16]
  wire [31:0] rf_wdata = _T_3892 ? wb_alu_out : _T_3898; // @[Mux.scala 98:16]
  wire [31:0] _T_3913 = mem_pc + mem_imm; // @[core.scala 618:81]
  wire [31:0] _T_3916 = _T_3835 ? mem_alu_out : npc; // @[core.scala 620:36]
  wire [31:0] _T_3917 = _T_3837 ? mem_alu_out : _T_3916; // @[core.scala 619:32]
  wire [31:0] _T_3918 = _T_3834 ? _T_3913 : _T_3917; // @[core.scala 618:28]
  wire [31:0] _T_3919 = _T_3839 ? csr_io_epc : _T_3918; // @[core.scala 617:24]
  wire  _GEN_400 = _T_3815 ? 1'h0 : 1'h1; // @[core.scala 613:38 core.scala 614:19 core.scala 627:19]
  wire [31:0] _GEN_406 = 5'h1 == io_sw_g_add[4:0] ? rv32i_reg_1 : rv32i_reg_0; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_407 = 5'h2 == io_sw_g_add[4:0] ? rv32i_reg_2 : _GEN_406; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_408 = 5'h3 == io_sw_g_add[4:0] ? rv32i_reg_3 : _GEN_407; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_409 = 5'h4 == io_sw_g_add[4:0] ? rv32i_reg_4 : _GEN_408; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_410 = 5'h5 == io_sw_g_add[4:0] ? rv32i_reg_5 : _GEN_409; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_411 = 5'h6 == io_sw_g_add[4:0] ? rv32i_reg_6 : _GEN_410; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_412 = 5'h7 == io_sw_g_add[4:0] ? rv32i_reg_7 : _GEN_411; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_413 = 5'h8 == io_sw_g_add[4:0] ? rv32i_reg_8 : _GEN_412; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_414 = 5'h9 == io_sw_g_add[4:0] ? rv32i_reg_9 : _GEN_413; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_415 = 5'ha == io_sw_g_add[4:0] ? rv32i_reg_10 : _GEN_414; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_416 = 5'hb == io_sw_g_add[4:0] ? rv32i_reg_11 : _GEN_415; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_417 = 5'hc == io_sw_g_add[4:0] ? rv32i_reg_12 : _GEN_416; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_418 = 5'hd == io_sw_g_add[4:0] ? rv32i_reg_13 : _GEN_417; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_419 = 5'he == io_sw_g_add[4:0] ? rv32i_reg_14 : _GEN_418; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_420 = 5'hf == io_sw_g_add[4:0] ? rv32i_reg_15 : _GEN_419; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_421 = 5'h10 == io_sw_g_add[4:0] ? rv32i_reg_16 : _GEN_420; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_422 = 5'h11 == io_sw_g_add[4:0] ? rv32i_reg_17 : _GEN_421; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_423 = 5'h12 == io_sw_g_add[4:0] ? rv32i_reg_18 : _GEN_422; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_424 = 5'h13 == io_sw_g_add[4:0] ? rv32i_reg_19 : _GEN_423; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_425 = 5'h14 == io_sw_g_add[4:0] ? rv32i_reg_20 : _GEN_424; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_426 = 5'h15 == io_sw_g_add[4:0] ? rv32i_reg_21 : _GEN_425; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_427 = 5'h16 == io_sw_g_add[4:0] ? rv32i_reg_22 : _GEN_426; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_428 = 5'h17 == io_sw_g_add[4:0] ? rv32i_reg_23 : _GEN_427; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_429 = 5'h18 == io_sw_g_add[4:0] ? rv32i_reg_24 : _GEN_428; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_430 = 5'h19 == io_sw_g_add[4:0] ? rv32i_reg_25 : _GEN_429; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_431 = 5'h1a == io_sw_g_add[4:0] ? rv32i_reg_26 : _GEN_430; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_432 = 5'h1b == io_sw_g_add[4:0] ? rv32i_reg_27 : _GEN_431; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_433 = 5'h1c == io_sw_g_add[4:0] ? rv32i_reg_28 : _GEN_432; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_434 = 5'h1d == io_sw_g_add[4:0] ? rv32i_reg_29 : _GEN_433; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_435 = 5'h1e == io_sw_g_add[4:0] ? rv32i_reg_30 : _GEN_434; // @[core.scala 655:21 core.scala 655:21]
  wire [31:0] _GEN_436 = 5'h1f == io_sw_g_add[4:0] ? rv32i_reg_31 : _GEN_435; // @[core.scala 655:21 core.scala 655:21]
  IDModule idm ( // @[core.scala 254:31]
    .io_imem(idm_io_imem),
    .io_inst_bits(idm_io_inst_bits),
    .io_inst_rd(idm_io_inst_rd),
    .io_inst_rs1(idm_io_inst_rs1),
    .io_inst_rs2(idm_io_inst_rs2),
    .io_inst_csr(idm_io_inst_csr)
  );
  CSR csr ( // @[core.scala 279:26]
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
  ALU alu ( // @[core.scala 331:26]
    .io_op1(alu_io_op1),
    .io_op2(alu_io_op2),
    .io_alu_op(alu_io_alu_op),
    .io_out(alu_io_out),
    .io_cmp_out(alu_io_cmp_out)
  );
  assign io_imem_add_addr = w_req ? w_addr : pc_cntr; // @[core.scala 638:16 core.scala 639:29 core.scala 641:26]
  assign io_r_imem_dat_req = imem_req; // @[core.scala 141:23]
  assign io_w_imem_dat_req = w_req; // @[core.scala 646:26]
  assign io_w_imem_dat_data = w_data; // @[core.scala 645:26]
  assign io_w_imem_dat_byteenable = 4'hf; // @[core.scala 647:30]
  assign io_dmem_add_addr = ~io_sw_halt ? mem_alu_out : io_sw_w_add; // @[core.scala 435:34 core.scala 437:26 core.scala 444:26]
  assign io_r_dmem_dat_req = ~io_sw_halt & _T_3603; // @[core.scala 435:34 core.scala 440:27 core.scala 449:27]
  assign io_w_dmem_dat_req = ~io_sw_halt ? mem_ctrl_mem_wr == 2'h2 : 1'h1; // @[core.scala 435:34 core.scala 438:27 core.scala 446:27]
  assign io_w_dmem_dat_data = _GEN_263[31:0];
  assign io_w_dmem_dat_byteenable = _T_3816 ? _GEN_260 : 4'hf; // @[core.scala 456:37 core.scala 492:34]
  assign io_sw_r_add = pc_cntr; // @[core.scala 633:18]
  assign io_sw_r_dat = id_inst; // @[core.scala 632:18]
  assign io_sw_g_dat = io_sw_halt ? _GEN_436 : 32'h0; // @[core.scala 654:33 core.scala 655:21 core.scala 657:21]
  assign io_sw_r_pc = id_pc; // @[core.scala 634:18]
  assign io_sw_r_ex_raddr1 = {{27'd0}, ex_reg_raddr_0}; // @[core.scala 397:23]
  assign io_sw_r_ex_raddr2 = {{27'd0}, ex_reg_raddr_1}; // @[core.scala 398:23]
  assign io_sw_r_ex_rs1 = _T_3708 ? mem_csr_data : _T_3742; // @[Mux.scala 98:16]
  assign io_sw_r_ex_rs2 = _T_3748 ? mem_csr_data : _T_3782; // @[Mux.scala 98:16]
  assign io_sw_r_ex_imm = {hi_hi_hi,hi_hi_lo,hi_lo_hi,hi_lo_lo,lo_hi_hi,lo_hi_lo,lo_lo}; // @[core.scala 401:30]
  assign io_sw_r_mem_alu_out = mem_alu_out; // @[core.scala 432:25]
  assign io_sw_r_wb_alu_out = wb_alu_out; // @[core.scala 605:28]
  assign io_sw_r_wb_rf_wdata = _T_3892 ? wb_alu_out : _T_3898; // @[Mux.scala 98:16]
  assign io_sw_r_wb_rf_waddr = {{27'd0}, rf_waddr}; // @[core.scala 606:29]
  assign io_sw_r_stall_sig = ex_pc; // @[core.scala 290:23]
  assign idm_io_imem = id_inst; // @[core.scala 255:17]
  assign csr_clock = clock;
  assign csr_reset = reset;
  assign csr_io_addr = ex_csr_addr; // @[core.scala 379:17]
  assign csr_io_in = _T_3655 ? _T_3792 : _T_3806; // @[core.scala 370:27]
  assign csr_io_cmd = ex_csr_cmd; // @[core.scala 380:16]
  assign csr_io_rs1_addr = {{27'd0}, ex_inst[19:15]}; // @[core.scala 388:31]
  assign csr_io_legal = ex_ctrl_legal; // @[core.scala 387:36]
  assign csr_io_interrupt_sig = interrupt_sig; // @[core.scala 393:26]
  assign csr_io_pc = ex_pc; // @[core.scala 378:15]
  assign csr_io_pc_invalid = inst_kill_branch | ex_pc == 32'h0; // @[core.scala 273:45]
  assign csr_io_j_check = ex_j_check; // @[core.scala 391:20]
  assign csr_io_b_check = ex_b_check; // @[core.scala 392:20]
  assign csr_io_stall = _T_3634 | _T_1773; // @[core.scala 288:107]
  assign csr_io_inst = ex_inst; // @[core.scala 382:17]
  assign csr_io_mem_wr = ex_ctrl_mem_wr; // @[core.scala 383:19]
  assign csr_io_mask_type = ex_ctrl_mask_type; // @[core.scala 384:22]
  assign csr_io_alu_op1 = _T_3784 ? ex_reg_rs1_bypass : _T_3788; // @[Mux.scala 98:16]
  assign csr_io_alu_op2 = _T_3790 ? ex_reg_rs2_bypass : _T_3795; // @[Mux.scala 98:16]
  assign alu_io_op1 = _T_3784 ? ex_reg_rs1_bypass : _T_3788; // @[Mux.scala 98:16]
  assign alu_io_op2 = _T_3790 ? ex_reg_rs2_bypass : _T_3795; // @[Mux.scala 98:16]
  assign alu_io_alu_op = ex_ctrl_alu_func; // @[core.scala 365:19]
  always @(posedge clock) begin
    if (reset) begin // @[core.scala 33:30]
      if_pc <= 32'h0; // @[core.scala 33:30]
    end else if (~stall & _T_3607 & ~waitrequest & ~loadstore_in_pipe) begin // @[core.scala 125:70]
      if_pc <= pc_cntr; // @[core.scala 126:15]
    end else if (inst_kill & _T_1786) begin // @[core.scala 130:43]
      if_pc <= 32'h0; // @[core.scala 131:15]
    end
    if (reset) begin // @[core.scala 34:31]
      if_npc <= 32'h4; // @[core.scala 34:31]
    end else if (~stall & _T_3607 & ~waitrequest & ~loadstore_in_pipe) begin // @[core.scala 125:70]
      if_npc <= npc; // @[core.scala 127:16]
    end else if (inst_kill & _T_1786) begin // @[core.scala 130:43]
      if_npc <= 32'h4; // @[core.scala 132:16]
    end
    if (reset) begin // @[core.scala 37:32]
      id_inst <= 32'h13; // @[core.scala 37:32]
    end else if ((stall | waitrequest) & _T_3607 & valid_id_inst & imem_req & _T_1798) begin // @[core.scala 184:91]
      if (_T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock) begin // @[core.scala 168:99]
        id_inst <= 32'h13; // @[core.scala 180:17]
      end
    end else if (valid_id_inst & _T_1783 & _T_1786 & _T_3607 & imem_req) begin // @[core.scala 194:83]
      id_inst <= io_r_imem_dat_data; // @[core.scala 197:17]
    end else if (_T_1791 & imem_req) begin // @[core.scala 199:55]
      id_inst <= 32'h13; // @[core.scala 202:17]
    end else begin
      id_inst <= _GEN_48;
    end
    if (reset) begin // @[core.scala 38:30]
      id_pc <= 32'h0; // @[core.scala 38:30]
    end else if ((stall | waitrequest) & _T_3607 & valid_id_inst & imem_req & _T_1798) begin // @[core.scala 184:91]
      if (_T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock) begin // @[core.scala 168:99]
        id_pc <= 32'h0; // @[core.scala 178:15]
      end
    end else if (valid_id_inst & _T_1783 & _T_1786 & _T_3607 & imem_req) begin // @[core.scala 194:83]
      id_pc <= if_pc; // @[core.scala 195:15]
    end else if (_T_1791 & imem_req) begin // @[core.scala 199:55]
      id_pc <= 32'h0; // @[core.scala 200:15]
    end else begin
      id_pc <= _GEN_46;
    end
    if (reset) begin // @[core.scala 39:31]
      id_npc <= 32'h4; // @[core.scala 39:31]
    end else if ((stall | waitrequest) & _T_3607 & valid_id_inst & imem_req & _T_1798) begin // @[core.scala 184:91]
      if (_T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock) begin // @[core.scala 168:99]
        id_npc <= 32'h4; // @[core.scala 179:16]
      end
    end else if (valid_id_inst & _T_1783 & _T_1786 & _T_3607 & imem_req) begin // @[core.scala 194:83]
      id_npc <= if_npc; // @[core.scala 196:16]
    end else if (_T_1791 & imem_req) begin // @[core.scala 199:55]
      id_npc <= 32'h4; // @[core.scala 201:16]
    end else begin
      id_npc <= _GEN_47;
    end
    if (reset) begin // @[core.scala 43:30]
      ex_pc <= 32'h0; // @[core.scala 43:30]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      ex_pc <= id_pc; // @[core.scala 298:15]
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_pc <= 32'h0; // @[core.scala 312:15]
    end
    if (reset) begin // @[core.scala 44:31]
      ex_npc <= 32'h4; // @[core.scala 44:31]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      ex_npc <= id_npc; // @[core.scala 299:16]
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_npc <= 32'h4; // @[core.scala 313:16]
    end
    if (reset) begin // @[core.scala 45:32]
      ex_inst <= 32'h13; // @[core.scala 45:32]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      ex_inst <= id_inst; // @[core.scala 301:17]
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_inst <= 32'h13; // @[core.scala 315:17]
    end
    ex_ctrl_legal <= reset | _GEN_187; // @[core.scala 46:39 core.scala 46:39]
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_br_type <= 4'h0; // @[core.scala 46:39]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      if (_T_1981) begin // @[Mux.scala 98:16]
        ex_ctrl_br_type <= 4'h0;
      end else if (_T_1983) begin // @[Mux.scala 98:16]
        ex_ctrl_br_type <= 4'h0;
      end else begin
        ex_ctrl_br_type <= _T_2124;
      end
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_ctrl_br_type <= 4'h0; // @[core.scala 314:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_alu_op1 <= 2'h1; // @[core.scala 46:39]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      if (_T_1981) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_op1 <= 2'h0;
      end else if (_T_1983) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_op1 <= 2'h2;
      end else begin
        ex_ctrl_alu_op1 <= _T_2271;
      end
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_ctrl_alu_op1 <= 2'h1; // @[core.scala 314:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_alu_op2 <= 2'h2; // @[core.scala 46:39]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      if (_T_1981) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1983) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_op2 <= 2'h2;
      end else begin
        ex_ctrl_alu_op2 <= _T_2418;
      end
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_ctrl_alu_op2 <= 2'h2; // @[core.scala 314:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_imm_type <= 3'h0; // @[core.scala 46:39]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      if (_T_1981) begin // @[Mux.scala 98:16]
        ex_ctrl_imm_type <= 3'h3;
      end else if (_T_1983) begin // @[Mux.scala 98:16]
        ex_ctrl_imm_type <= 3'h3;
      end else begin
        ex_ctrl_imm_type <= _T_2565;
      end
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_ctrl_imm_type <= 3'h0; // @[core.scala 314:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_alu_func <= 4'h0; // @[core.scala 46:39]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      if (_T_1981) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_func <= 4'h9;
      end else if (_T_1983) begin // @[Mux.scala 98:16]
        ex_ctrl_alu_func <= 4'h0;
      end else begin
        ex_ctrl_alu_func <= _T_2712;
      end
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_ctrl_alu_func <= 4'h0; // @[core.scala 314:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_wb_sel <= 2'h1; // @[core.scala 46:39]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      if (_T_1981) begin // @[Mux.scala 98:16]
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1983) begin // @[Mux.scala 98:16]
        ex_ctrl_wb_sel <= 2'h1;
      end else begin
        ex_ctrl_wb_sel <= _T_2859;
      end
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_ctrl_wb_sel <= 2'h1; // @[core.scala 314:17]
    end
    ex_ctrl_rf_wen <= reset | _GEN_180; // @[core.scala 46:39 core.scala 46:39]
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_mem_en <= 1'h0; // @[core.scala 46:39]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      if (_T_1981) begin // @[Mux.scala 98:16]
        ex_ctrl_mem_en <= 1'h0;
      end else if (_T_1983) begin // @[Mux.scala 98:16]
        ex_ctrl_mem_en <= 1'h0;
      end else begin
        ex_ctrl_mem_en <= _T_3153;
      end
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_ctrl_mem_en <= 1'h0; // @[core.scala 314:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_mem_wr <= 2'h0; // @[core.scala 46:39]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      if (_T_1981) begin // @[Mux.scala 98:16]
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1983) begin // @[Mux.scala 98:16]
        ex_ctrl_mem_wr <= 2'h0;
      end else begin
        ex_ctrl_mem_wr <= _T_3300;
      end
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_ctrl_mem_wr <= 2'h0; // @[core.scala 314:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_mask_type <= 3'h0; // @[core.scala 46:39]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      if (_T_1981) begin // @[Mux.scala 98:16]
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1983) begin // @[Mux.scala 98:16]
        ex_ctrl_mask_type <= 3'h0;
      end else begin
        ex_ctrl_mask_type <= _T_3447;
      end
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_ctrl_mask_type <= 3'h0; // @[core.scala 314:17]
    end
    if (reset) begin // @[core.scala 46:39]
      ex_ctrl_csr_cmd <= 3'h0; // @[core.scala 46:39]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      if (_T_1981) begin // @[Mux.scala 98:16]
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1983) begin // @[Mux.scala 98:16]
        ex_ctrl_csr_cmd <= 3'h0;
      end else begin
        ex_ctrl_csr_cmd <= _T_3594;
      end
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_ctrl_csr_cmd <= 3'h0; // @[core.scala 314:17]
    end
    if (reset) begin // @[core.scala 47:42]
      ex_reg_raddr_0 <= 5'h0; // @[core.scala 47:42]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      ex_reg_raddr_0 <= idm_io_inst_rs1; // @[core.scala 302:25]
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_reg_raddr_0 <= 5'h0; // @[core.scala 316:22]
    end
    if (reset) begin // @[core.scala 47:42]
      ex_reg_raddr_1 <= 5'h0; // @[core.scala 47:42]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      ex_reg_raddr_1 <= idm_io_inst_rs2; // @[core.scala 303:25]
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_reg_raddr_1 <= 5'h0; // @[core.scala 316:22]
    end
    if (reset) begin // @[core.scala 48:37]
      ex_reg_waddr <= 5'h0; // @[core.scala 48:37]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      ex_reg_waddr <= idm_io_inst_rd; // @[core.scala 304:22]
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_reg_waddr <= 5'h0; // @[core.scala 317:22]
    end
    if (reset) begin // @[core.scala 49:35]
      ex_rs_0 <= 32'h0; // @[core.scala 49:35]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      if (idm_io_inst_rs1 == 5'h0) begin // @[core.scala 269:27]
        ex_rs_0 <= 32'h0;
      end else if (5'h1f == idm_io_inst_rs1) begin // @[core.scala 269:27]
        ex_rs_0 <= rv32i_reg_31; // @[core.scala 269:27]
      end else begin
        ex_rs_0 <= _GEN_116;
      end
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_rs_0 <= 32'h0; // @[core.scala 318:15]
    end
    if (reset) begin // @[core.scala 49:35]
      ex_rs_1 <= 32'h0; // @[core.scala 49:35]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      if (idm_io_inst_rs2 == 5'h0) begin // @[core.scala 270:27]
        ex_rs_1 <= 32'h0;
      end else if (5'h1f == idm_io_inst_rs2) begin // @[core.scala 270:27]
        ex_rs_1 <= rv32i_reg_31; // @[core.scala 270:27]
      end else begin
        ex_rs_1 <= _GEN_148;
      end
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_rs_1 <= 32'h0; // @[core.scala 318:15]
    end
    if (reset) begin // @[core.scala 50:36]
      ex_csr_addr <= 32'h0; // @[core.scala 50:36]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      ex_csr_addr <= {{20'd0}, idm_io_inst_csr}; // @[core.scala 307:21]
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_csr_addr <= 32'h0; // @[core.scala 319:21]
    end
    if (reset) begin // @[core.scala 51:35]
      ex_csr_cmd <= 32'h0; // @[core.scala 51:35]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      ex_csr_cmd <= {{29'd0}, id_ctrl_csr_cmd}; // @[core.scala 308:20]
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_csr_cmd <= 32'h0; // @[core.scala 320:20]
    end
    if (reset) begin // @[core.scala 52:35]
      ex_b_check <= 1'h0; // @[core.scala 52:35]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      ex_b_check <= id_ctrl_br_type > 4'h3; // @[core.scala 310:20]
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_b_check <= 1'h0; // @[core.scala 322:20]
    end
    if (reset) begin // @[core.scala 53:35]
      ex_j_check <= 1'h0; // @[core.scala 53:35]
    end else if (_T_1787 & ~loadstore_proc & _T_1823) begin // @[core.scala 297:84]
      ex_j_check <= id_ctrl_br_type == 4'h1 | id_ctrl_br_type == 4'h2; // @[core.scala 309:20]
    end else if ((stall | inst_kill | loadstore_proc | in_loadstore) & _T_1786) begin // @[core.scala 311:88]
      ex_j_check <= 1'h0; // @[core.scala 321:20]
    end
    if (reset) begin // @[core.scala 56:31]
      mem_pc <= 32'h0; // @[core.scala 56:31]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_pc <= ex_pc; // @[core.scala 406:16]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_pc <= 32'h0; // @[core.scala 419:16]
    end
    if (reset) begin // @[core.scala 57:32]
      mem_npc <= 32'h4; // @[core.scala 57:32]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_npc <= ex_npc; // @[core.scala 407:17]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_npc <= 32'h4; // @[core.scala 420:17]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_br_type <= 4'h0; // @[core.scala 58:40]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_ctrl_br_type <= ex_ctrl_br_type; // @[core.scala 408:18]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_ctrl_br_type <= 4'h0; // @[core.scala 421:18]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_wb_sel <= 2'h1; // @[core.scala 58:40]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_ctrl_wb_sel <= ex_ctrl_wb_sel; // @[core.scala 408:18]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_ctrl_wb_sel <= 2'h1; // @[core.scala 421:18]
    end
    mem_ctrl_rf_wen <= reset | _GEN_226; // @[core.scala 58:40 core.scala 58:40]
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_mem_en <= 1'h0; // @[core.scala 58:40]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_ctrl_mem_en <= ex_ctrl_mem_en; // @[core.scala 408:18]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_ctrl_mem_en <= 1'h0; // @[core.scala 421:18]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_mem_wr <= 2'h0; // @[core.scala 58:40]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_ctrl_mem_wr <= ex_ctrl_mem_wr; // @[core.scala 408:18]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_ctrl_mem_wr <= 2'h0; // @[core.scala 421:18]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_mask_type <= 3'h0; // @[core.scala 58:40]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_ctrl_mask_type <= ex_ctrl_mask_type; // @[core.scala 408:18]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_ctrl_mask_type <= 3'h0; // @[core.scala 421:18]
    end
    if (reset) begin // @[core.scala 58:40]
      mem_ctrl_csr_cmd <= 3'h0; // @[core.scala 58:40]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_ctrl_csr_cmd <= ex_ctrl_csr_cmd; // @[core.scala 408:18]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_ctrl_csr_cmd <= 3'h0; // @[core.scala 421:18]
    end
    if (reset) begin // @[core.scala 59:32]
      mem_imm <= 32'sh0; // @[core.scala 59:32]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_imm <= ex_imm; // @[core.scala 410:17]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_imm <= 32'sh0; // @[core.scala 423:17]
    end
    if (reset) begin // @[core.scala 60:38]
      mem_reg_waddr <= 5'h0; // @[core.scala 60:38]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_reg_waddr <= ex_reg_waddr; // @[core.scala 409:23]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_reg_waddr <= 5'h0; // @[core.scala 422:23]
    end
    if (reset) begin // @[core.scala 61:36]
      mem_rs_1 <= 32'h0; // @[core.scala 61:36]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      if (_T_3748) begin // @[Mux.scala 98:16]
        mem_rs_1 <= mem_csr_data;
      end else if (_T_3753) begin // @[Mux.scala 98:16]
        mem_rs_1 <= mem_alu_out;
      end else begin
        mem_rs_1 <= _T_3781;
      end
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_rs_1 <= 32'h0; // @[core.scala 424:16]
    end
    if (reset) begin // @[core.scala 62:36]
      mem_alu_out <= 32'h0; // @[core.scala 62:36]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_alu_out <= alu_io_out; // @[core.scala 413:21]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_alu_out <= 32'h0; // @[core.scala 425:21]
    end
    if (reset) begin // @[core.scala 63:40]
      mem_alu_cmp_out <= 1'h0; // @[core.scala 63:40]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_alu_cmp_out <= alu_io_cmp_out; // @[core.scala 414:25]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_alu_cmp_out <= 1'h0; // @[core.scala 426:25]
    end
    if (reset) begin // @[core.scala 65:37]
      mem_csr_data <= 32'h0; // @[core.scala 65:37]
    end else if (_T_3607 & _T_1786) begin // @[core.scala 405:38]
      mem_csr_data <= csr_io_out; // @[core.scala 416:22]
    end else if (_T_1791) begin // @[core.scala 418:43]
      mem_csr_data <= 32'h0; // @[core.scala 428:22]
    end
    if (reset) begin // @[core.scala 68:31]
      wb_npc <= 32'h4; // @[core.scala 68:31]
    end else if (_T_1786) begin // @[core.scala 506:24]
      wb_npc <= mem_npc; // @[core.scala 507:16]
    end
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_wb_sel <= 2'h1; // @[core.scala 69:39]
    end else if (_T_1786) begin // @[core.scala 506:24]
      wb_ctrl_wb_sel <= mem_ctrl_wb_sel; // @[core.scala 508:17]
    end
    wb_ctrl_rf_wen <= reset | _GEN_269; // @[core.scala 69:39 core.scala 69:39]
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_mem_en <= 1'h0; // @[core.scala 69:39]
    end else if (_T_1786) begin // @[core.scala 506:24]
      wb_ctrl_mem_en <= mem_ctrl_mem_en; // @[core.scala 508:17]
    end
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_mem_wr <= 2'h0; // @[core.scala 69:39]
    end else if (_T_1786) begin // @[core.scala 506:24]
      wb_ctrl_mem_wr <= mem_ctrl_mem_wr; // @[core.scala 508:17]
    end
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_mask_type <= 3'h0; // @[core.scala 69:39]
    end else if (_T_1786) begin // @[core.scala 506:24]
      wb_ctrl_mask_type <= mem_ctrl_mask_type; // @[core.scala 508:17]
    end
    if (reset) begin // @[core.scala 69:39]
      wb_ctrl_csr_cmd <= 3'h0; // @[core.scala 69:39]
    end else if (_T_1786) begin // @[core.scala 506:24]
      wb_ctrl_csr_cmd <= mem_ctrl_csr_cmd; // @[core.scala 508:17]
    end
    if (reset) begin // @[core.scala 70:37]
      rf_waddr <= 5'h0; // @[core.scala 70:37]
    end else if (_T_1786) begin // @[core.scala 506:24]
      rf_waddr <= mem_reg_waddr; // @[core.scala 509:22]
    end
    if (reset) begin // @[core.scala 71:35]
      wb_alu_out <= 32'h0; // @[core.scala 71:35]
    end else if (_T_1786) begin // @[core.scala 506:24]
      wb_alu_out <= mem_alu_out; // @[core.scala 510:20]
    end
    if (reset) begin // @[core.scala 74:36]
      wb_csr_data <= 32'h0; // @[core.scala 74:36]
    end else if (_T_1786) begin // @[core.scala 506:24]
      wb_csr_data <= mem_csr_data; // @[core.scala 513:21]
    end
    if (reset) begin // @[core.scala 86:32]
      pc_cntr <= 32'h0; // @[core.scala 86:32]
    end else if (_T_3815) begin // @[core.scala 613:38]
      if (_T_1783 & _T_1786 & imem_req) begin // @[core.scala 615:54]
        if (csr_io_expt) begin // @[core.scala 616:31]
          pc_cntr <= csr_io_evec;
        end else begin
          pc_cntr <= _T_3919;
        end
      end
    end else begin
      pc_cntr <= io_sw_w_pc; // @[core.scala 628:21]
    end
    w_req <= reset | _GEN_400; // @[core.scala 91:30 core.scala 91:30]
    if (reset) begin // @[core.scala 93:31]
      w_addr <= 32'h0; // @[core.scala 93:31]
    end else if (!(_T_3815)) begin // @[core.scala 613:38]
      w_addr <= io_sw_w_add; // @[core.scala 625:20]
    end
    if (reset) begin // @[core.scala 94:31]
      w_data <= 32'h0; // @[core.scala 94:31]
    end else if (!(_T_3815)) begin // @[core.scala 613:38]
      w_data <= io_sw_w_dat; // @[core.scala 626:20]
    end
    if (reset) begin // @[core.scala 99:38]
      imem_read_sig <= 1'h0; // @[core.scala 99:38]
    end else begin
      imem_read_sig <= ~io_w_imem_dat_req; // @[core.scala 99:38]
    end
    if (reset) begin // @[core.scala 104:36]
      delay_stall <= 4'h0; // @[core.scala 104:36]
    end else if (imem_read_sig) begin // @[core.scala 105:36]
      if (delay_stall != 4'h7) begin // @[core.scala 106:35]
        delay_stall <= _T_1775; // @[core.scala 107:25]
      end
    end else begin
      delay_stall <= 4'h0; // @[core.scala 110:21]
    end
    valid_imem <= reset | _T_1789; // @[core.scala 114:35 core.scala 114:35]
    if (reset) begin // @[core.scala 121:33]
      imem_req <= 1'h0; // @[core.scala 121:33]
    end else if (~stall & _T_3607 & ~waitrequest & ~loadstore_in_pipe) begin // @[core.scala 125:70]
      imem_req <= REG_1; // @[core.scala 128:18]
    end else if (inst_kill & _T_1786) begin // @[core.scala 130:43]
      imem_req <= REG_3; // @[core.scala 133:18]
    end else if (loadstore_in_pipe) begin // @[core.scala 137:31]
      imem_req <= 1'h0; // @[core.scala 138:18]
    end
    REG_1 <= imem_read_sig; // @[core.scala 128:28]
    REG_3 <= imem_read_sig; // @[core.scala 133:28]
    if (reset) begin // @[core.scala 146:37]
      id_inst_temp <= 32'h13; // @[core.scala 146:37]
    end else if ((stall | waitrequest) & _T_3607 & valid_id_inst & imem_req & _T_1798) begin // @[core.scala 184:91]
      id_inst_temp <= io_r_imem_dat_data; // @[core.scala 188:22]
    end else if (valid_id_inst & _T_1783 & _T_1786 & _T_3607 & imem_req) begin // @[core.scala 194:83]
      if (_T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock) begin // @[core.scala 168:99]
        id_inst_temp <= io_r_imem_dat_data; // @[core.scala 172:22]
      end
    end else if (_T_1791 & imem_req) begin // @[core.scala 199:55]
      id_inst_temp <= 32'h13; // @[core.scala 206:22]
    end else begin
      id_inst_temp <= _GEN_52;
    end
    if (reset) begin // @[core.scala 147:35]
      id_pc_temp <= 32'h0; // @[core.scala 147:35]
    end else if ((stall | waitrequest) & _T_3607 & valid_id_inst & imem_req & _T_1798) begin // @[core.scala 184:91]
      id_pc_temp <= if_pc; // @[core.scala 186:20]
    end else if (valid_id_inst & _T_1783 & _T_1786 & _T_3607 & imem_req) begin // @[core.scala 194:83]
      if (_T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock) begin // @[core.scala 168:99]
        id_pc_temp <= if_pc; // @[core.scala 170:20]
      end
    end else if (_T_1791 & imem_req) begin // @[core.scala 199:55]
      id_pc_temp <= 32'h0; // @[core.scala 204:20]
    end else begin
      id_pc_temp <= _GEN_50;
    end
    if (reset) begin // @[core.scala 148:36]
      id_npc_temp <= 32'h4; // @[core.scala 148:36]
    end else if ((stall | waitrequest) & _T_3607 & valid_id_inst & imem_req & _T_1798) begin // @[core.scala 184:91]
      id_npc_temp <= if_npc; // @[core.scala 187:21]
    end else if (valid_id_inst & _T_1783 & _T_1786 & _T_3607 & imem_req) begin // @[core.scala 194:83]
      if (_T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock) begin // @[core.scala 168:99]
        id_npc_temp <= if_npc; // @[core.scala 171:21]
      end
    end else if (_T_1791 & imem_req) begin // @[core.scala 199:55]
      id_npc_temp <= 32'h4; // @[core.scala 205:21]
    end else begin
      id_npc_temp <= _GEN_51;
    end
    if (reset) begin // @[core.scala 149:38]
      id_inst2_temp <= 32'h13; // @[core.scala 149:38]
    end else if ((stall | waitrequest) & _T_3607 & valid_id_inst & imem_req & _T_1798) begin // @[core.scala 184:91]
      id_inst2_temp <= id_inst; // @[core.scala 192:23]
    end else if (valid_id_inst & _T_1783 & _T_1786 & _T_3607 & imem_req) begin // @[core.scala 194:83]
      if (_T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock) begin // @[core.scala 168:99]
        id_inst2_temp <= id_inst; // @[core.scala 176:23]
      end
    end else if (_T_1791 & imem_req) begin // @[core.scala 199:55]
      id_inst2_temp <= 32'h13; // @[core.scala 209:23]
    end else begin
      id_inst2_temp <= _GEN_55;
    end
    if (reset) begin // @[core.scala 150:36]
      id_pc2_temp <= 32'h0; // @[core.scala 150:36]
    end else if ((stall | waitrequest) & _T_3607 & valid_id_inst & imem_req & _T_1798) begin // @[core.scala 184:91]
      id_pc2_temp <= id_pc; // @[core.scala 190:21]
    end else if (valid_id_inst & _T_1783 & _T_1786 & _T_3607 & imem_req) begin // @[core.scala 194:83]
      if (_T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock) begin // @[core.scala 168:99]
        id_pc2_temp <= id_pc; // @[core.scala 174:21]
      end
    end else if (_T_1791 & imem_req) begin // @[core.scala 199:55]
      id_pc2_temp <= 32'h0; // @[core.scala 207:21]
    end else begin
      id_pc2_temp <= _GEN_53;
    end
    if (reset) begin // @[core.scala 151:37]
      id_npc2_temp <= 32'h4; // @[core.scala 151:37]
    end else if ((stall | waitrequest) & _T_3607 & valid_id_inst & imem_req & _T_1798) begin // @[core.scala 184:91]
      id_npc2_temp <= id_npc; // @[core.scala 191:22]
    end else if (valid_id_inst & _T_1783 & _T_1786 & _T_3607 & imem_req) begin // @[core.scala 194:83]
      if (_T_3607 & ~imem_req & io_r_imem_dat_ack & ~temp_lock) begin // @[core.scala 168:99]
        id_npc2_temp <= id_npc; // @[core.scala 175:22]
      end
    end else if (_T_1791 & imem_req) begin // @[core.scala 199:55]
      id_npc2_temp <= 32'h4; // @[core.scala 208:22]
    end else begin
      id_npc2_temp <= _GEN_54;
    end
    if (reset) begin // @[core.scala 154:37]
      in_loadstore <= 1'h0; // @[core.scala 154:37]
    end else begin
      in_loadstore <= _GEN_12;
    end
    if (reset) begin // @[core.scala 162:34]
      temp_lock <= 1'h0; // @[core.scala 162:34]
    end else begin
      temp_lock <= _GEN_76;
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_0 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h0 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_0 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_1 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h1 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_1 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_2 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h2 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_2 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_3 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h3 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_3 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_4 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h4 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_4 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_5 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h5 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_5 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_6 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h6 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_6 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_7 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h7 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_7 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_8 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h8 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_8 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_9 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h9 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_9 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_10 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'ha == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_10 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_11 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'hb == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_11 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_12 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'hc == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_12 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_13 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'hd == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_13 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_14 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'he == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_14 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_15 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'hf == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_15 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_16 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h10 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_16 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_17 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h11 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_17 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_18 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h12 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_18 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_19 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h13 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_19 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_20 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h14 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_20 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_21 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h15 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_21 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_22 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h16 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_22 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_23 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h17 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_23 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_24 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h18 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_24 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_25 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h19 == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_25 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_26 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h1a == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_26 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_27 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h1b == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_27 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_28 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h1c == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_28 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_29 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h1d == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_29 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_30 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h1e == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_30 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 268:39]
      rv32i_reg_31 <= 32'h0; // @[core.scala 268:39]
    end else if (wb_ctrl_rf_wen) begin // @[core.scala 598:32]
      if (rf_waddr > 5'h0) begin // @[core.scala 599:53]
        if (5'h1f == rf_waddr) begin // @[core.scala 600:37]
          rv32i_reg_31 <= rf_wdata; // @[core.scala 600:37]
        end
      end
    end
    if (reset) begin // @[core.scala 276:38]
      interrupt_sig <= 1'h0; // @[core.scala 276:38]
    end else begin
      interrupt_sig <= io_sw_w_interrupt_sig; // @[core.scala 277:19]
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
  id_inst2_temp = _RAND_67[31:0];
  _RAND_68 = {1{`RANDOM}};
  id_pc2_temp = _RAND_68[31:0];
  _RAND_69 = {1{`RANDOM}};
  id_npc2_temp = _RAND_69[31:0];
  _RAND_70 = {1{`RANDOM}};
  in_loadstore = _RAND_70[0:0];
  _RAND_71 = {1{`RANDOM}};
  temp_lock = _RAND_71[0:0];
  _RAND_72 = {1{`RANDOM}};
  rv32i_reg_0 = _RAND_72[31:0];
  _RAND_73 = {1{`RANDOM}};
  rv32i_reg_1 = _RAND_73[31:0];
  _RAND_74 = {1{`RANDOM}};
  rv32i_reg_2 = _RAND_74[31:0];
  _RAND_75 = {1{`RANDOM}};
  rv32i_reg_3 = _RAND_75[31:0];
  _RAND_76 = {1{`RANDOM}};
  rv32i_reg_4 = _RAND_76[31:0];
  _RAND_77 = {1{`RANDOM}};
  rv32i_reg_5 = _RAND_77[31:0];
  _RAND_78 = {1{`RANDOM}};
  rv32i_reg_6 = _RAND_78[31:0];
  _RAND_79 = {1{`RANDOM}};
  rv32i_reg_7 = _RAND_79[31:0];
  _RAND_80 = {1{`RANDOM}};
  rv32i_reg_8 = _RAND_80[31:0];
  _RAND_81 = {1{`RANDOM}};
  rv32i_reg_9 = _RAND_81[31:0];
  _RAND_82 = {1{`RANDOM}};
  rv32i_reg_10 = _RAND_82[31:0];
  _RAND_83 = {1{`RANDOM}};
  rv32i_reg_11 = _RAND_83[31:0];
  _RAND_84 = {1{`RANDOM}};
  rv32i_reg_12 = _RAND_84[31:0];
  _RAND_85 = {1{`RANDOM}};
  rv32i_reg_13 = _RAND_85[31:0];
  _RAND_86 = {1{`RANDOM}};
  rv32i_reg_14 = _RAND_86[31:0];
  _RAND_87 = {1{`RANDOM}};
  rv32i_reg_15 = _RAND_87[31:0];
  _RAND_88 = {1{`RANDOM}};
  rv32i_reg_16 = _RAND_88[31:0];
  _RAND_89 = {1{`RANDOM}};
  rv32i_reg_17 = _RAND_89[31:0];
  _RAND_90 = {1{`RANDOM}};
  rv32i_reg_18 = _RAND_90[31:0];
  _RAND_91 = {1{`RANDOM}};
  rv32i_reg_19 = _RAND_91[31:0];
  _RAND_92 = {1{`RANDOM}};
  rv32i_reg_20 = _RAND_92[31:0];
  _RAND_93 = {1{`RANDOM}};
  rv32i_reg_21 = _RAND_93[31:0];
  _RAND_94 = {1{`RANDOM}};
  rv32i_reg_22 = _RAND_94[31:0];
  _RAND_95 = {1{`RANDOM}};
  rv32i_reg_23 = _RAND_95[31:0];
  _RAND_96 = {1{`RANDOM}};
  rv32i_reg_24 = _RAND_96[31:0];
  _RAND_97 = {1{`RANDOM}};
  rv32i_reg_25 = _RAND_97[31:0];
  _RAND_98 = {1{`RANDOM}};
  rv32i_reg_26 = _RAND_98[31:0];
  _RAND_99 = {1{`RANDOM}};
  rv32i_reg_27 = _RAND_99[31:0];
  _RAND_100 = {1{`RANDOM}};
  rv32i_reg_28 = _RAND_100[31:0];
  _RAND_101 = {1{`RANDOM}};
  rv32i_reg_29 = _RAND_101[31:0];
  _RAND_102 = {1{`RANDOM}};
  rv32i_reg_30 = _RAND_102[31:0];
  _RAND_103 = {1{`RANDOM}};
  rv32i_reg_31 = _RAND_103[31:0];
  _RAND_104 = {1{`RANDOM}};
  interrupt_sig = _RAND_104[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
