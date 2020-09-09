module IDModule(
  input  [31:0] io_imem,
  output [31:0] io_inst_bits,
  output [4:0]  io_inst_rd,
  output [4:0]  io_inst_rs1,
  output [4:0]  io_inst_rs2,
  output [11:0] io_inst_csr
);
  assign io_inst_bits = io_imem; // @[control.scala 64:13]
  assign io_inst_rd = io_imem[11:7]; // @[control.scala 64:13]
  assign io_inst_rs1 = io_imem[19:15]; // @[control.scala 64:13]
  assign io_inst_rs2 = io_imem[24:20]; // @[control.scala 64:13]
  assign io_inst_csr = io_imem[31:20]; // @[control.scala 64:13]
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
  wire  _T_3 = 32'h1 == io_cmd; // @[Mux.scala 80:60]
  wire [31:0] _T_4 = _T_3 ? io_in : 32'h0; // @[Mux.scala 80:57]
  wire  _T_5 = 32'h2 == io_cmd; // @[Mux.scala 80:60]
  wire [31:0] _T_6 = _T_5 ? _T : _T_4; // @[Mux.scala 80:57]
  wire  _T_7 = 32'h3 == io_cmd; // @[Mux.scala 80:60]
  wire [31:0] wdata = _T_7 ? _T_2 : _T_6; // @[Mux.scala 80:57]
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
  wire [31:0] _T_44 = io_addr & 32'hfff; // @[Lookup.scala 31:38]
  wire  _T_45 = 32'hc00 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_47 = 32'hc01 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_49 = 32'hc02 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_51 = 32'hc80 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_53 = 32'hc81 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_55 = 32'hc82 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_57 = 32'h900 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_59 = 32'h180 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_61 = 32'h901 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_63 = 32'h902 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_65 = 32'h980 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_67 = 32'h981 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_69 = 32'h982 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_71 = 32'hf00 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_73 = 32'hf13 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_75 = 32'hf14 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_77 = 32'h305 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_79 = 32'h302 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_81 = 32'h304 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_83 = 32'h321 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_85 = 32'h701 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_87 = 32'h741 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_89 = 32'h340 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_91 = 32'h341 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_93 = 32'h342 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_95 = 32'h344 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_97 = 32'h300 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_99 = 32'h301 == _T_44; // @[Lookup.scala 31:38]
  wire  _T_101 = 32'h343 == _T_44; // @[Lookup.scala 31:38]
  wire [31:0] _T_102 = _T_101 ? mtval : 32'h0; // @[Lookup.scala 33:37]
  wire [31:0] _T_103 = _T_99 ? 32'h40000000 : _T_102; // @[Lookup.scala 33:37]
  wire [31:0] _T_104 = _T_97 ? mstatus : _T_103; // @[Lookup.scala 33:37]
  wire [31:0] _T_105 = _T_95 ? mip : _T_104; // @[Lookup.scala 33:37]
  wire [31:0] _T_106 = _T_93 ? mcause : _T_105; // @[Lookup.scala 33:37]
  wire [31:0] _T_107 = _T_91 ? mepc : _T_106; // @[Lookup.scala 33:37]
  wire [31:0] _T_108 = _T_89 ? mscratch : _T_107; // @[Lookup.scala 33:37]
  wire [31:0] _T_109 = _T_87 ? timeh : _T_108; // @[Lookup.scala 33:37]
  wire [31:0] _T_110 = _T_85 ? time_ : _T_109; // @[Lookup.scala 33:37]
  wire [31:0] _T_111 = _T_83 ? 32'h0 : _T_110; // @[Lookup.scala 33:37]
  wire [31:0] _T_112 = _T_81 ? mie : _T_111; // @[Lookup.scala 33:37]
  wire [31:0] _T_113 = _T_79 ? 32'h0 : _T_112; // @[Lookup.scala 33:37]
  wire [31:0] _T_114 = _T_77 ? mtvec : _T_113; // @[Lookup.scala 33:37]
  wire [31:0] _T_115 = _T_75 ? 32'h0 : _T_114; // @[Lookup.scala 33:37]
  wire [31:0] _T_116 = _T_73 ? 32'h0 : _T_115; // @[Lookup.scala 33:37]
  wire [31:0] _T_117 = _T_71 ? 32'h100100 : _T_116; // @[Lookup.scala 33:37]
  wire [31:0] _T_118 = _T_69 ? instreth : _T_117; // @[Lookup.scala 33:37]
  wire [31:0] _T_119 = _T_67 ? timeh : _T_118; // @[Lookup.scala 33:37]
  wire [31:0] _T_120 = _T_65 ? cycleh : _T_119; // @[Lookup.scala 33:37]
  wire [31:0] _T_121 = _T_63 ? instret : _T_120; // @[Lookup.scala 33:37]
  wire [31:0] _T_122 = _T_61 ? time_ : _T_121; // @[Lookup.scala 33:37]
  wire [31:0] _T_123 = _T_59 ? 32'h0 : _T_122; // @[Lookup.scala 33:37]
  wire [31:0] _T_124 = _T_57 ? cycle : _T_123; // @[Lookup.scala 33:37]
  wire [31:0] _T_125 = _T_55 ? instreth : _T_124; // @[Lookup.scala 33:37]
  wire [31:0] _T_126 = _T_53 ? timeh : _T_125; // @[Lookup.scala 33:37]
  wire [31:0] _T_127 = _T_51 ? cycleh : _T_126; // @[Lookup.scala 33:37]
  wire [31:0] _T_128 = _T_49 ? instret : _T_127; // @[Lookup.scala 33:37]
  wire [31:0] _T_129 = _T_47 ? time_ : _T_128; // @[Lookup.scala 33:37]
  wire [31:0] _T_132 = time_ + 32'h1; // @[csr.scala 282:16]
  wire  _T_133 = &time_; // @[csr.scala 283:13]
  wire [31:0] _T_135 = timeh + 32'h1; // @[csr.scala 283:36]
  wire [31:0] _GEN_0 = _T_133 ? _T_135 : timeh; // @[csr.scala 283:19]
  wire [31:0] _T_137 = cycle + 32'h1; // @[csr.scala 284:18]
  wire  _T_138 = &cycle; // @[csr.scala 285:14]
  wire [31:0] _T_140 = cycleh + 32'h1; // @[csr.scala 285:39]
  wire [31:0] _GEN_1 = _T_138 ? _T_140 : cycleh; // @[csr.scala 285:20]
  wire  privInst = io_cmd == 32'h4; // @[csr.scala 291:35]
  wire  isExtInt = MEIP & MEIE; // @[csr.scala 293:33]
  wire  _T_143 = ~io_addr[0]; // @[csr.scala 294:40]
  wire  _T_144 = privInst & _T_143; // @[csr.scala 294:37]
  wire  _T_146 = ~io_addr[8]; // @[csr.scala 294:56]
  wire  isEcall = _T_144 & _T_146; // @[csr.scala 294:53]
  wire  _T_148 = privInst & io_addr[0]; // @[csr.scala 295:37]
  wire  isEbreak = _T_148 & _T_146; // @[csr.scala 295:53]
  wire  _T_151 = io_cmd == 32'h1; // @[csr.scala 296:36]
  wire  _T_153 = |io_rs1_addr; // @[csr.scala 296:72]
  wire  _T_154 = io_cmd[1] & _T_153; // @[csr.scala 296:60]
  wire  wen = _T_151 | _T_154; // @[csr.scala 296:47]
  wire  _T_155 = ~io_legal; // @[csr.scala 299:28]
  wire  _T_156 = ~io_pc_invalid; // @[csr.scala 299:41]
  wire  isIllegal = _T_155 & _T_156; // @[csr.scala 299:38]
  reg [31:0] pre_mepc; // @[csr.scala 302:37]
  reg [31:0] pre_calc_addr; // @[csr.scala 304:37]
  wire  _T_157 = io_b_check | io_j_check; // @[csr.scala 306:19]
  wire  iaddrInvalid_b = |io_pc[1:0]; // @[csr.scala 313:41]
  wire  _T_160 = |alu_calc_addr[1:0]; // @[csr.scala 314:63]
  wire  iaddrInvalid_j = io_j_check & _T_160; // @[csr.scala 314:41]
  wire  _T_161 = io_mem_wr == 2'h1; // @[csr.scala 316:16]
  wire  _T_162 = io_mask_type == 3'h3; // @[csr.scala 316:42]
  wire  _T_163 = _T_161 & _T_162; // @[csr.scala 316:26]
  wire  _T_167 = io_mask_type == 3'h2; // @[csr.scala 317:42]
  wire  _T_168 = _T_161 & _T_167; // @[csr.scala 317:26]
  wire  _T_171 = io_mask_type == 3'h6; // @[csr.scala 318:42]
  wire  _T_172 = _T_161 & _T_171; // @[csr.scala 318:26]
  wire  _T_174 = _T_172 & alu_calc_addr[0]; // @[Mux.scala 98:16]
  wire  _T_175 = _T_168 ? alu_calc_addr[0] : _T_174; // @[Mux.scala 98:16]
  wire  laddrInvalid = _T_163 ? _T_160 : _T_175; // @[Mux.scala 98:16]
  wire  _T_176 = io_mem_wr == 2'h2; // @[csr.scala 321:16]
  wire  _T_178 = _T_176 & _T_162; // @[csr.scala 321:26]
  wire  _T_183 = _T_176 & _T_167; // @[csr.scala 322:26]
  wire  _T_185 = _T_183 & alu_calc_addr[0]; // @[Mux.scala 98:16]
  wire  saddrInvalid = _T_178 ? _T_160 : _T_185; // @[Mux.scala 98:16]
  wire  _T_186 = io_inst != 32'h13; // @[csr.scala 325:34]
  wire  _T_187 = ~io_expt; // @[csr.scala 325:60]
  wire  _T_188 = _T_187 | isEcall; // @[csr.scala 325:69]
  wire  _T_189 = _T_188 | isEbreak; // @[csr.scala 325:80]
  wire  _T_190 = _T_186 & _T_189; // @[csr.scala 325:56]
  wire  _T_191 = ~io_stall; // @[csr.scala 325:96]
  wire  isInstRet = _T_190 & _T_191; // @[csr.scala 325:93]
  wire [31:0] _T_193 = instret + 32'h1; // @[csr.scala 326:40]
  wire [31:0] _GEN_5 = isInstRet ? _T_193 : instret; // @[csr.scala 326:19]
  wire  _T_194 = &instret; // @[csr.scala 327:29]
  wire  _T_195 = isInstRet & _T_194; // @[csr.scala 327:18]
  wire [31:0] _T_197 = instreth + 32'h1; // @[csr.scala 327:58]
  wire [31:0] _GEN_6 = _T_195 ? _T_197 : instreth; // @[csr.scala 327:35]
  wire  _T_198 = isEcall | isEbreak; // @[csr.scala 330:22]
  wire  _T_199 = _T_198 | isIllegal; // @[csr.scala 330:34]
  wire  _T_200 = _T_199 | isExtInt; // @[csr.scala 330:47]
  wire  _T_201 = _T_200 | iaddrInvalid_j; // @[csr.scala 330:59]
  wire  _T_202 = _T_201 | iaddrInvalid_b; // @[csr.scala 330:77]
  wire  _T_203 = _T_202 | laddrInvalid; // @[csr.scala 330:95]
  wire [31:0] _T_207 = {io_pc[31:2], 2'h0}; // @[csr.scala 336:28]
  wire  _T_209 = laddrInvalid | saddrInvalid; // @[csr.scala 347:31]
  wire  _T_212 = ~alu_calc_addr[1]; // @[csr.scala 352:34]
  wire  _T_213 = alu_calc_addr[0] & _T_212; // @[csr.scala 352:31]
  wire [31:0] _T_215 = {alu_calc_addr[31:1], 1'h0}; // @[csr.scala 353:40]
  wire [31:0] _T_217 = _T_215 + 32'h2; // @[csr.scala 353:55]
  wire [31:0] _GEN_13 = iaddrInvalid_b ? pre_mepc : io_pc; // @[csr.scala 344:34]
  wire [31:0] _GEN_15 = isExtInt ? valid_pc : _GEN_13; // @[csr.scala 341:21]
  wire  _T_225 = iaddrInvalid_j | iaddrInvalid_b; // @[csr.scala 364:32]
  wire [2:0] _T_226 = saddrInvalid ? 3'h6 : 3'h0; // @[csr.scala 367:22]
  wire [2:0] _T_227 = laddrInvalid ? 3'h4 : _T_226; // @[csr.scala 366:20]
  wire [2:0] _T_228 = isIllegal ? 3'h2 : _T_227; // @[csr.scala 365:18]
  wire [2:0] _T_229 = _T_225 ? 3'h0 : _T_228; // @[csr.scala 364:16]
  wire [2:0] _T_230 = isEbreak ? 3'h3 : _T_229; // @[csr.scala 363:14]
  wire  _T_233 = io_addr == 32'h300; // @[csr.scala 377:21]
  wire  _T_237 = io_addr == 32'h344; // @[csr.scala 382:27]
  wire  _T_240 = io_addr == 32'h304; // @[csr.scala 385:27]
  wire  _T_244 = io_addr == 32'h701; // @[csr.scala 389:27]
  wire  _T_245 = io_addr == 32'h741; // @[csr.scala 392:26]
  wire  _T_246 = io_addr == 32'h305; // @[csr.scala 399:26]
  wire  _T_247 = io_addr == 32'h340; // @[csr.scala 402:26]
  wire  _T_248 = io_addr == 32'h341; // @[csr.scala 405:26]
  wire [31:0] _T_249 = {{2'd0}, wdata[31:2]}; // @[csr.scala 406:23]
  wire [33:0] _GEN_236 = {_T_249, 2'h0}; // @[csr.scala 406:30]
  wire [34:0] _T_250 = {{1'd0}, _GEN_236}; // @[csr.scala 406:30]
  wire  _T_251 = io_addr == 32'h342; // @[csr.scala 408:26]
  wire [31:0] _T_252 = wdata & 32'h8000000f; // @[csr.scala 409:25]
  wire  _T_253 = io_addr == 32'h780; // @[csr.scala 414:26]
  wire  _T_254 = io_addr == 32'h781; // @[csr.scala 417:26]
  wire  _T_255 = io_addr == 32'h900; // @[csr.scala 420:26]
  wire  _T_256 = io_addr == 32'h901; // @[csr.scala 423:26]
  wire  _T_257 = io_addr == 32'h902; // @[csr.scala 426:26]
  wire  _T_258 = io_addr == 32'h980; // @[csr.scala 429:26]
  wire  _T_259 = io_addr == 32'h981; // @[csr.scala 432:26]
  wire  _T_260 = io_addr == 32'h982; // @[csr.scala 435:26]
  wire [34:0] _GEN_62 = _T_248 ? _T_250 : {{3'd0}, mepc}; // @[csr.scala 405:44]
  wire [34:0] _GEN_73 = _T_247 ? {{3'd0}, mepc} : _GEN_62; // @[csr.scala 402:48]
  wire [34:0] _GEN_85 = _T_246 ? {{3'd0}, mepc} : _GEN_73; // @[csr.scala 399:45]
  wire [34:0] _GEN_98 = _T_245 ? {{3'd0}, mepc} : _GEN_85; // @[csr.scala 392:46]
  wire [34:0] _GEN_111 = _T_244 ? {{3'd0}, mepc} : _GEN_98; // @[csr.scala 389:46]
  wire [34:0] _GEN_126 = _T_240 ? {{3'd0}, mepc} : _GEN_111; // @[csr.scala 385:44]
  wire [34:0] _GEN_143 = _T_237 ? {{3'd0}, mepc} : _GEN_126; // @[csr.scala 382:44]
  wire [34:0] _GEN_163 = _T_233 ? {{3'd0}, mepc} : _GEN_143; // @[csr.scala 377:42]
  wire [34:0] _GEN_183 = wen ? _GEN_163 : {{3'd0}, mepc}; // @[csr.scala 376:21]
  wire [34:0] _GEN_191 = io_expt ? {{3'd0}, _GEN_15} : _GEN_183; // @[csr.scala 340:19]
  wire [34:0] _GEN_213 = _T_191 ? _GEN_191 : {{3'd0}, mepc}; // @[csr.scala 339:19]
  assign io_out = _T_45 ? cycle : _T_129; // @[csr.scala 279:10]
  assign io_expt = _T_203 | saddrInvalid; // @[csr.scala 330:11]
  assign io_evec = mtvec; // @[csr.scala 331:11]
  assign io_epc = mepc; // @[csr.scala 333:10]
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
  always @(posedge clock) begin
    if (reset) begin
      time_ <= 32'h0;
    end else if (_T_191) begin
      if (io_expt) begin
        time_ <= _T_132;
      end else if (wen) begin
        if (_T_233) begin
          time_ <= _T_132;
        end else if (_T_237) begin
          time_ <= _T_132;
        end else if (_T_240) begin
          time_ <= _T_132;
        end else if (_T_244) begin
          if (_T_7) begin
            time_ <= _T_2;
          end else if (_T_5) begin
            time_ <= _T;
          end else if (_T_3) begin
            time_ <= io_in;
          end else begin
            time_ <= 32'h0;
          end
        end else if (_T_245) begin
          time_ <= _T_132;
        end else if (_T_246) begin
          time_ <= _T_132;
        end else if (_T_247) begin
          time_ <= _T_132;
        end else if (_T_248) begin
          time_ <= _T_132;
        end else if (_T_251) begin
          time_ <= _T_132;
        end else if (_T_253) begin
          time_ <= _T_132;
        end else if (_T_254) begin
          time_ <= _T_132;
        end else if (_T_255) begin
          time_ <= _T_132;
        end else if (_T_256) begin
          if (_T_7) begin
            time_ <= _T_2;
          end else if (_T_5) begin
            time_ <= _T;
          end else if (_T_3) begin
            time_ <= io_in;
          end else begin
            time_ <= 32'h0;
          end
        end else begin
          time_ <= _T_132;
        end
      end else begin
        time_ <= _T_132;
      end
    end else begin
      time_ <= _T_132;
    end
    if (reset) begin
      timeh <= 32'h0;
    end else if (_T_191) begin
      if (io_expt) begin
        if (_T_133) begin
          timeh <= _T_135;
        end
      end else if (wen) begin
        if (_T_233) begin
          if (_T_133) begin
            timeh <= _T_135;
          end
        end else if (_T_237) begin
          if (_T_133) begin
            timeh <= _T_135;
          end
        end else if (_T_240) begin
          if (_T_133) begin
            timeh <= _T_135;
          end
        end else if (_T_244) begin
          timeh <= _GEN_0;
        end else if (_T_245) begin
          if (_T_7) begin
            timeh <= _T_2;
          end else if (_T_5) begin
            timeh <= _T;
          end else if (_T_3) begin
            timeh <= io_in;
          end else begin
            timeh <= 32'h0;
          end
        end else if (_T_246) begin
          timeh <= _GEN_0;
        end else if (_T_247) begin
          timeh <= _GEN_0;
        end else if (_T_248) begin
          timeh <= _GEN_0;
        end else if (_T_251) begin
          timeh <= _GEN_0;
        end else if (_T_253) begin
          timeh <= _GEN_0;
        end else if (_T_254) begin
          timeh <= _GEN_0;
        end else if (_T_255) begin
          timeh <= _GEN_0;
        end else if (_T_256) begin
          timeh <= _GEN_0;
        end else if (_T_257) begin
          timeh <= _GEN_0;
        end else if (_T_258) begin
          timeh <= _GEN_0;
        end else if (_T_259) begin
          if (_T_7) begin
            timeh <= _T_2;
          end else if (_T_5) begin
            timeh <= _T;
          end else if (_T_3) begin
            timeh <= io_in;
          end else begin
            timeh <= 32'h0;
          end
        end else begin
          timeh <= _GEN_0;
        end
      end else begin
        timeh <= _GEN_0;
      end
    end else begin
      timeh <= _GEN_0;
    end
    if (reset) begin
      cycle <= 32'h0;
    end else if (_T_191) begin
      if (io_expt) begin
        cycle <= _T_137;
      end else if (wen) begin
        if (_T_233) begin
          cycle <= _T_137;
        end else if (_T_237) begin
          cycle <= _T_137;
        end else if (_T_240) begin
          cycle <= _T_137;
        end else if (_T_244) begin
          cycle <= _T_137;
        end else if (_T_245) begin
          cycle <= _T_137;
        end else if (_T_246) begin
          cycle <= _T_137;
        end else if (_T_247) begin
          cycle <= _T_137;
        end else if (_T_248) begin
          cycle <= _T_137;
        end else if (_T_251) begin
          cycle <= _T_137;
        end else if (_T_253) begin
          cycle <= _T_137;
        end else if (_T_254) begin
          cycle <= _T_137;
        end else if (_T_255) begin
          cycle <= wdata;
        end else begin
          cycle <= _T_137;
        end
      end else begin
        cycle <= _T_137;
      end
    end else begin
      cycle <= _T_137;
    end
    if (reset) begin
      cycleh <= 32'h0;
    end else if (_T_191) begin
      if (io_expt) begin
        if (_T_138) begin
          cycleh <= _T_140;
        end
      end else if (wen) begin
        if (_T_233) begin
          if (_T_138) begin
            cycleh <= _T_140;
          end
        end else if (_T_237) begin
          if (_T_138) begin
            cycleh <= _T_140;
          end
        end else if (_T_240) begin
          if (_T_138) begin
            cycleh <= _T_140;
          end
        end else if (_T_244) begin
          cycleh <= _GEN_1;
        end else if (_T_245) begin
          cycleh <= _GEN_1;
        end else if (_T_246) begin
          cycleh <= _GEN_1;
        end else if (_T_247) begin
          cycleh <= _GEN_1;
        end else if (_T_248) begin
          cycleh <= _GEN_1;
        end else if (_T_251) begin
          cycleh <= _GEN_1;
        end else if (_T_253) begin
          cycleh <= _GEN_1;
        end else if (_T_254) begin
          cycleh <= _GEN_1;
        end else if (_T_255) begin
          cycleh <= _GEN_1;
        end else if (_T_256) begin
          cycleh <= _GEN_1;
        end else if (_T_257) begin
          cycleh <= _GEN_1;
        end else if (_T_258) begin
          cycleh <= wdata;
        end else begin
          cycleh <= _GEN_1;
        end
      end else begin
        cycleh <= _GEN_1;
      end
    end else begin
      cycleh <= _GEN_1;
    end
    if (reset) begin
      instret <= 32'h0;
    end else if (_T_191) begin
      if (io_expt) begin
        if (isInstRet) begin
          instret <= _T_193;
        end
      end else if (wen) begin
        if (_T_233) begin
          if (isInstRet) begin
            instret <= _T_193;
          end
        end else if (_T_237) begin
          if (isInstRet) begin
            instret <= _T_193;
          end
        end else if (_T_240) begin
          if (isInstRet) begin
            instret <= _T_193;
          end
        end else if (_T_244) begin
          instret <= _GEN_5;
        end else if (_T_245) begin
          instret <= _GEN_5;
        end else if (_T_246) begin
          instret <= _GEN_5;
        end else if (_T_247) begin
          instret <= _GEN_5;
        end else if (_T_248) begin
          instret <= _GEN_5;
        end else if (_T_251) begin
          instret <= _GEN_5;
        end else if (_T_253) begin
          instret <= _GEN_5;
        end else if (_T_254) begin
          instret <= _GEN_5;
        end else if (_T_255) begin
          instret <= _GEN_5;
        end else if (_T_256) begin
          instret <= _GEN_5;
        end else if (_T_257) begin
          instret <= wdata;
        end else begin
          instret <= _GEN_5;
        end
      end else begin
        instret <= _GEN_5;
      end
    end else begin
      instret <= _GEN_5;
    end
    if (reset) begin
      instreth <= 32'h0;
    end else if (_T_191) begin
      if (io_expt) begin
        if (_T_195) begin
          instreth <= _T_197;
        end
      end else if (wen) begin
        if (_T_233) begin
          if (_T_195) begin
            instreth <= _T_197;
          end
        end else if (_T_237) begin
          if (_T_195) begin
            instreth <= _T_197;
          end
        end else if (_T_240) begin
          if (_T_195) begin
            instreth <= _T_197;
          end
        end else if (_T_244) begin
          instreth <= _GEN_6;
        end else if (_T_245) begin
          instreth <= _GEN_6;
        end else if (_T_246) begin
          instreth <= _GEN_6;
        end else if (_T_247) begin
          instreth <= _GEN_6;
        end else if (_T_248) begin
          instreth <= _GEN_6;
        end else if (_T_251) begin
          instreth <= _GEN_6;
        end else if (_T_253) begin
          instreth <= _GEN_6;
        end else if (_T_254) begin
          instreth <= _GEN_6;
        end else if (_T_255) begin
          instreth <= _GEN_6;
        end else if (_T_256) begin
          instreth <= _GEN_6;
        end else if (_T_257) begin
          instreth <= _GEN_6;
        end else if (_T_258) begin
          instreth <= _GEN_6;
        end else if (_T_259) begin
          instreth <= _GEN_6;
        end else if (_T_260) begin
          instreth <= wdata;
        end else begin
          instreth <= _GEN_6;
        end
      end else begin
        instreth <= _GEN_6;
      end
    end else begin
      instreth <= _GEN_6;
    end
    if (reset) begin
      PRV1 <= 2'h3;
    end else if (_T_191) begin
      if (io_expt) begin
        PRV1 <= 2'h3;
      end else if (wen) begin
        if (_T_233) begin
          PRV1 <= wdata[5:4];
        end
      end
    end
    if (reset) begin
      IE <= 1'h0;
    end else if (_T_191) begin
      if (io_expt) begin
        IE <= 1'h0;
      end else if (wen) begin
        if (_T_233) begin
          IE <= wdata[0];
        end
      end
    end
    if (reset) begin
      IE1 <= 1'h0;
    end else if (_T_191) begin
      if (io_expt) begin
        IE1 <= IE;
      end else if (wen) begin
        if (_T_233) begin
          IE1 <= wdata[3];
        end
      end
    end
    if (reset) begin
      mtvec <= 32'h1c0;
    end else if (_T_191) begin
      if (!(io_expt)) begin
        if (wen) begin
          if (!(_T_233)) begin
            if (!(_T_237)) begin
              if (!(_T_240)) begin
                if (!(_T_244)) begin
                  if (!(_T_245)) begin
                    if (_T_246) begin
                      mtvec <= wdata;
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if (reset) begin
      MTIP <= 1'h0;
    end else if (_T_191) begin
      if (!(io_expt)) begin
        if (wen) begin
          if (!(_T_233)) begin
            if (_T_237) begin
              MTIP <= wdata[7];
            end
          end
        end
      end
    end
    if (reset) begin
      MEIE <= 1'h0;
    end else if (_T_191) begin
      if (!(io_expt)) begin
        if (wen) begin
          if (!(_T_233)) begin
            if (!(_T_237)) begin
              if (_T_240) begin
                MEIE <= wdata[11];
              end
            end
          end
        end
      end
    end
    if (reset) begin
      MTIE <= 1'h0;
    end else if (_T_191) begin
      if (!(io_expt)) begin
        if (wen) begin
          if (!(_T_233)) begin
            if (!(_T_237)) begin
              if (_T_240) begin
                MTIE <= wdata[7];
              end
            end
          end
        end
      end
    end
    if (reset) begin
      MEIP <= 1'h0;
    end else begin
      MEIP <= io_interrupt_sig;
    end
    if (reset) begin
      MSIP <= 1'h0;
    end else if (_T_191) begin
      if (!(io_expt)) begin
        if (wen) begin
          if (!(_T_233)) begin
            if (_T_237) begin
              MSIP <= wdata[3];
            end
          end
        end
      end
    end
    if (reset) begin
      MSIE <= 1'h0;
    end else if (_T_191) begin
      if (!(io_expt)) begin
        if (wen) begin
          if (!(_T_233)) begin
            if (!(_T_237)) begin
              if (_T_240) begin
                MSIE <= wdata[3];
              end
            end
          end
        end
      end
    end
    if (_T_191) begin
      if (!(io_expt)) begin
        if (wen) begin
          if (!(_T_233)) begin
            if (!(_T_237)) begin
              if (!(_T_240)) begin
                if (!(_T_244)) begin
                  if (!(_T_245)) begin
                    if (!(_T_246)) begin
                      if (_T_247) begin
                        mscratch <= wdata;
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    mepc <= _GEN_213[31:0];
    if (_T_191) begin
      if (io_expt) begin
        if (isEcall) begin
          mcause <= 32'hb;
        end else if (isExtInt) begin
          mcause <= 32'h8000000b;
        end else begin
          mcause <= {{29'd0}, _T_230};
        end
      end else if (wen) begin
        if (!(_T_233)) begin
          if (!(_T_237)) begin
            if (!(_T_240)) begin
              if (!(_T_244)) begin
                if (!(_T_245)) begin
                  if (!(_T_246)) begin
                    if (!(_T_247)) begin
                      if (!(_T_248)) begin
                        if (_T_251) begin
                          mcause <= _T_252;
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if (reset) begin
      mtval <= 32'h13;
    end else if (_T_191) begin
      if (io_expt) begin
        if (isExtInt) begin
          mtval <= io_inst;
        end else if (iaddrInvalid_b) begin
          mtval <= pre_calc_addr;
        end else if (_T_209) begin
          mtval <= alu_calc_addr;
        end else if (iaddrInvalid_j) begin
          if (_T_213) begin
            mtval <= _T_217;
          end else begin
            mtval <= _T_215;
          end
        end else begin
          mtval <= io_inst;
        end
      end
    end
    if (reset) begin
      valid_pc <= 32'h0;
    end else if (_T_156) begin
      valid_pc <= _T_207;
    end
    if (reset) begin
      pre_mepc <= 32'h0;
    end else if (_T_157) begin
      pre_mepc <= io_pc;
    end
    if (reset) begin
      pre_calc_addr <= 32'h0;
    end else if (_T_157) begin
      pre_calc_addr <= alu_calc_addr;
    end
  end
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
  wire  _T_6 = io_alu_op == 4'hb; // @[ALU.scala 53:36]
  wire  _T_7 = io_alu_op == 4'h5; // @[ALU.scala 53:61]
  wire  _T_8 = _T_6 | _T_7; // @[ALU.scala 53:48]
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
  wire [31:0] shin = _T_8 ? io_op1 : _T_57; // @[ALU.scala 53:25]
  wire  _T_60 = io_alu_op[3] & shin[31]; // @[ALU.scala 54:47]
  wire [32:0] _T_62 = {_T_60,shin}; // @[ALU.scala 54:65]
  wire [32:0] _T_63 = $signed(_T_62) >>> shamt; // @[ALU.scala 54:72]
  wire [31:0] shift_r = _T_63[31:0]; // @[ALU.scala 54:81]
  wire [31:0] _T_67 = {{16'd0}, shift_r[31:16]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_69 = {shift_r[15:0], 16'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_71 = _T_69 & 32'hffff0000; // @[Bitwise.scala 103:75]
  wire [31:0] _T_72 = _T_67 | _T_71; // @[Bitwise.scala 103:39]
  wire [31:0] _GEN_5 = {{8'd0}, _T_72[31:8]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_77 = _GEN_5 & 32'hff00ff; // @[Bitwise.scala 103:31]
  wire [31:0] _T_79 = {_T_72[23:0], 8'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_81 = _T_79 & 32'hff00ff00; // @[Bitwise.scala 103:75]
  wire [31:0] _T_82 = _T_77 | _T_81; // @[Bitwise.scala 103:39]
  wire [31:0] _GEN_6 = {{4'd0}, _T_82[31:4]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_87 = _GEN_6 & 32'hf0f0f0f; // @[Bitwise.scala 103:31]
  wire [31:0] _T_89 = {_T_82[27:0], 4'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_91 = _T_89 & 32'hf0f0f0f0; // @[Bitwise.scala 103:75]
  wire [31:0] _T_92 = _T_87 | _T_91; // @[Bitwise.scala 103:39]
  wire [31:0] _GEN_7 = {{2'd0}, _T_92[31:2]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_97 = _GEN_7 & 32'h33333333; // @[Bitwise.scala 103:31]
  wire [31:0] _T_99 = {_T_92[29:0], 2'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_101 = _T_99 & 32'hcccccccc; // @[Bitwise.scala 103:75]
  wire [31:0] _T_102 = _T_97 | _T_101; // @[Bitwise.scala 103:39]
  wire [31:0] _GEN_8 = {{1'd0}, _T_102[31:1]}; // @[Bitwise.scala 103:31]
  wire [31:0] _T_107 = _GEN_8 & 32'h55555555; // @[Bitwise.scala 103:31]
  wire [31:0] _T_109 = {_T_102[30:0], 1'h0}; // @[Bitwise.scala 103:65]
  wire [31:0] _T_111 = _T_109 & 32'haaaaaaaa; // @[Bitwise.scala 103:75]
  wire [31:0] shift_l = _T_107 | _T_111; // @[Bitwise.scala 103:39]
  wire  _T_114 = io_op1[31] == io_op2[31]; // @[ALU.scala 56:36]
  wire  _T_116 = io_alu_op >= 4'he; // @[ALU.scala 29:37]
  wire  _T_119 = _T_116 ? io_op2[31] : io_op1[31]; // @[ALU.scala 56:64]
  wire  slt = _T_114 ? sum[31] : _T_119; // @[ALU.scala 56:24]
  wire  _T_122 = ~io_alu_op[3]; // @[ALU.scala 32:35]
  wire [31:0] _T_123 = io_op1 ^ io_op2; // @[ALU.scala 58:73]
  wire  _T_124 = _T_123 == 32'h0; // @[ALU.scala 58:83]
  wire  _T_125 = _T_122 ? _T_124 : slt; // @[ALU.scala 58:44]
  wire  cmp = io_alu_op[0] ^ _T_125; // @[ALU.scala 58:39]
  wire  _T_126 = io_alu_op == 4'h0; // @[ALU.scala 61:23]
  wire  _T_127 = io_alu_op == 4'ha; // @[ALU.scala 61:48]
  wire  _T_128 = _T_126 | _T_127; // @[ALU.scala 61:35]
  wire  _T_129 = io_alu_op == 4'hc; // @[ALU.scala 62:23]
  wire  _T_130 = io_alu_op == 4'he; // @[ALU.scala 62:48]
  wire  _T_131 = _T_129 | _T_130; // @[ALU.scala 62:35]
  wire  _T_135 = io_alu_op == 4'h1; // @[ALU.scala 64:23]
  wire  _T_136 = io_alu_op == 4'h7; // @[ALU.scala 65:23]
  wire [31:0] _T_137 = io_op1 & io_op2; // @[ALU.scala 65:43]
  wire  _T_138 = io_alu_op == 4'h6; // @[ALU.scala 66:23]
  wire [31:0] _T_139 = io_op1 | io_op2; // @[ALU.scala 66:43]
  wire  _T_140 = io_alu_op == 4'h4; // @[ALU.scala 67:23]
  wire  _T_142 = io_alu_op == 4'h8; // @[ALU.scala 68:23]
  wire [31:0] _T_143 = _T_142 ? io_op1 : io_op2; // @[ALU.scala 68:12]
  wire [31:0] _T_144 = _T_140 ? _T_123 : _T_143; // @[ALU.scala 67:12]
  wire [31:0] _T_145 = _T_138 ? _T_139 : _T_144; // @[ALU.scala 66:12]
  wire [31:0] _T_146 = _T_136 ? _T_137 : _T_145; // @[ALU.scala 65:12]
  wire [31:0] _T_147 = _T_135 ? shift_l : _T_146; // @[ALU.scala 64:12]
  wire [31:0] _T_148 = _T_8 ? shift_r : _T_147; // @[ALU.scala 63:12]
  wire [31:0] _T_149 = _T_131 ? {{31'd0}, cmp} : _T_148; // @[ALU.scala 62:12]
  assign io_out = _T_128 ? sum : _T_149; // @[ALU.scala 87:12]
  assign io_cmp_out = io_alu_op[0] ^ _T_125; // @[ALU.scala 88:16]
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
  input         io_sw_w_waitrequest_sig
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
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
`endif // RANDOMIZE_REG_INIT
  wire [31:0] idm_io_imem; // @[core.scala 157:31]
  wire [31:0] idm_io_inst_bits; // @[core.scala 157:31]
  wire [4:0] idm_io_inst_rd; // @[core.scala 157:31]
  wire [4:0] idm_io_inst_rs1; // @[core.scala 157:31]
  wire [4:0] idm_io_inst_rs2; // @[core.scala 157:31]
  wire [11:0] idm_io_inst_csr; // @[core.scala 157:31]
  reg [31:0] _T_3552 [0:31]; // @[core.scala 625:25]
  wire [31:0] _T_3552__T_3554_data; // @[core.scala 625:25]
  wire [4:0] _T_3552__T_3554_addr; // @[core.scala 625:25]
  wire [31:0] _T_3552__T_3556_data; // @[core.scala 625:25]
  wire [4:0] _T_3552__T_3556_addr; // @[core.scala 625:25]
  wire [31:0] _T_3552__T_3892_data; // @[core.scala 625:25]
  wire [4:0] _T_3552__T_3892_addr; // @[core.scala 625:25]
  wire [31:0] _T_3552__T_3895_data; // @[core.scala 625:25]
  wire [4:0] _T_3552__T_3895_addr; // @[core.scala 625:25]
  wire [31:0] _T_3552__T_3872_data; // @[core.scala 625:25]
  wire [4:0] _T_3552__T_3872_addr; // @[core.scala 625:25]
  wire  _T_3552__T_3872_mask; // @[core.scala 625:25]
  wire  _T_3552__T_3872_en; // @[core.scala 625:25]
  wire  csr_clock; // @[core.scala 182:26]
  wire  csr_reset; // @[core.scala 182:26]
  wire [31:0] csr_io_addr; // @[core.scala 182:26]
  wire [31:0] csr_io_in; // @[core.scala 182:26]
  wire [31:0] csr_io_out; // @[core.scala 182:26]
  wire [31:0] csr_io_cmd; // @[core.scala 182:26]
  wire [31:0] csr_io_rs1_addr; // @[core.scala 182:26]
  wire  csr_io_legal; // @[core.scala 182:26]
  wire  csr_io_interrupt_sig; // @[core.scala 182:26]
  wire [31:0] csr_io_pc; // @[core.scala 182:26]
  wire  csr_io_pc_invalid; // @[core.scala 182:26]
  wire  csr_io_j_check; // @[core.scala 182:26]
  wire  csr_io_b_check; // @[core.scala 182:26]
  wire  csr_io_stall; // @[core.scala 182:26]
  wire  csr_io_expt; // @[core.scala 182:26]
  wire [31:0] csr_io_evec; // @[core.scala 182:26]
  wire [31:0] csr_io_epc; // @[core.scala 182:26]
  wire [31:0] csr_io_inst; // @[core.scala 182:26]
  wire [1:0] csr_io_mem_wr; // @[core.scala 182:26]
  wire [2:0] csr_io_mask_type; // @[core.scala 182:26]
  wire [31:0] csr_io_alu_op1; // @[core.scala 182:26]
  wire [31:0] csr_io_alu_op2; // @[core.scala 182:26]
  wire [31:0] alu_io_op1; // @[core.scala 227:26]
  wire [31:0] alu_io_op2; // @[core.scala 227:26]
  wire [3:0] alu_io_alu_op; // @[core.scala 227:26]
  wire [31:0] alu_io_out; // @[core.scala 227:26]
  wire  alu_io_cmp_out; // @[core.scala 227:26]
  reg [31:0] if_pc; // @[core.scala 32:30]
  reg [31:0] if_npc; // @[core.scala 33:31]
  reg [31:0] id_inst; // @[core.scala 36:32]
  reg [31:0] id_pc; // @[core.scala 37:30]
  reg [31:0] id_npc; // @[core.scala 38:31]
  reg [31:0] ex_pc; // @[core.scala 42:30]
  reg [31:0] ex_npc; // @[core.scala 43:31]
  reg [31:0] ex_inst; // @[core.scala 44:32]
  reg  ex_ctrl_legal; // @[core.scala 45:39]
  reg [3:0] ex_ctrl_br_type; // @[core.scala 45:39]
  reg [1:0] ex_ctrl_alu_op1; // @[core.scala 45:39]
  reg [1:0] ex_ctrl_alu_op2; // @[core.scala 45:39]
  reg [2:0] ex_ctrl_imm_type; // @[core.scala 45:39]
  reg [3:0] ex_ctrl_alu_func; // @[core.scala 45:39]
  reg [1:0] ex_ctrl_wb_sel; // @[core.scala 45:39]
  reg  ex_ctrl_rf_wen; // @[core.scala 45:39]
  reg  ex_ctrl_mem_en; // @[core.scala 45:39]
  reg [1:0] ex_ctrl_mem_wr; // @[core.scala 45:39]
  reg [2:0] ex_ctrl_mask_type; // @[core.scala 45:39]
  reg [2:0] ex_ctrl_csr_cmd; // @[core.scala 45:39]
  reg [4:0] ex_reg_raddr_0; // @[core.scala 46:42]
  reg [4:0] ex_reg_raddr_1; // @[core.scala 46:42]
  reg [4:0] ex_reg_waddr; // @[core.scala 47:37]
  reg [31:0] ex_rs_0; // @[core.scala 48:35]
  reg [31:0] ex_rs_1; // @[core.scala 48:35]
  reg [31:0] ex_csr_addr; // @[core.scala 49:36]
  reg [31:0] ex_csr_cmd; // @[core.scala 50:35]
  reg  ex_b_check; // @[core.scala 51:35]
  reg  ex_j_check; // @[core.scala 52:35]
  reg [31:0] mem_pc; // @[core.scala 55:31]
  reg [31:0] mem_npc; // @[core.scala 56:32]
  reg [3:0] mem_ctrl_br_type; // @[core.scala 57:40]
  reg [1:0] mem_ctrl_wb_sel; // @[core.scala 57:40]
  reg  mem_ctrl_rf_wen; // @[core.scala 57:40]
  reg  mem_ctrl_mem_en; // @[core.scala 57:40]
  reg [1:0] mem_ctrl_mem_wr; // @[core.scala 57:40]
  reg [2:0] mem_ctrl_mask_type; // @[core.scala 57:40]
  reg [2:0] mem_ctrl_csr_cmd; // @[core.scala 57:40]
  reg [31:0] mem_imm; // @[core.scala 58:32]
  reg [4:0] mem_reg_waddr; // @[core.scala 59:38]
  reg [31:0] mem_rs_1; // @[core.scala 60:36]
  reg [31:0] mem_alu_out; // @[core.scala 61:36]
  reg  mem_alu_cmp_out; // @[core.scala 62:40]
  reg [31:0] mem_csr_data; // @[core.scala 64:37]
  reg [31:0] wb_npc; // @[core.scala 67:31]
  reg [1:0] wb_ctrl_wb_sel; // @[core.scala 68:39]
  reg  wb_ctrl_rf_wen; // @[core.scala 68:39]
  reg  wb_ctrl_mem_en; // @[core.scala 68:39]
  reg [1:0] wb_ctrl_mem_wr; // @[core.scala 68:39]
  reg [2:0] wb_ctrl_mask_type; // @[core.scala 68:39]
  reg [2:0] wb_ctrl_csr_cmd; // @[core.scala 68:39]
  reg [4:0] wb_reg_waddr; // @[core.scala 69:37]
  reg [31:0] wb_alu_out; // @[core.scala 70:35]
  reg [31:0] wb_csr_data; // @[core.scala 73:36]
  reg [31:0] pc_cntr; // @[core.scala 85:32]
  wire [31:0] npc = pc_cntr + 32'h4; // @[core.scala 86:29]
  reg  w_req; // @[core.scala 93:30]
  reg [31:0] w_addr; // @[core.scala 95:31]
  reg [31:0] w_data; // @[core.scala 96:31]
  wire  _T_1775 = ~io_w_imem_dat_req; // @[core.scala 102:39]
  reg  imem_read_sig; // @[core.scala 102:38]
  reg [2:0] delay_stall; // @[core.scala 107:36]
  wire  _T_1777 = delay_stall != 3'h6; // @[core.scala 109:26]
  wire [2:0] _T_1779 = delay_stall + 3'h1; // @[core.scala 110:40]
  reg  valid_imem; // @[core.scala 117:35]
  wire  _T_3558 = ex_reg_waddr == idm_io_inst_rs1; // @[core.scala 186:33]
  wire  _T_3559 = ex_reg_waddr == idm_io_inst_rs2; // @[core.scala 186:65]
  wire  _T_3560 = _T_3558 | _T_3559; // @[core.scala 186:49]
  wire  _T_3561 = mem_ctrl_mem_wr == 2'h1; // @[core.scala 187:29]
  wire  _T_3562 = ex_ctrl_mem_wr == 2'h1; // @[core.scala 187:59]
  wire  _T_3563 = _T_3561 | _T_3562; // @[core.scala 187:40]
  wire  _T_3564 = _T_3560 & _T_3563; // @[core.scala 186:82]
  wire  _T_3784 = mem_ctrl_br_type > 4'h3; // @[core.scala 396:26]
  wire  _T_3785 = _T_3784 & mem_alu_cmp_out; // @[core.scala 396:33]
  wire  _T_3786 = mem_ctrl_br_type == 4'h2; // @[core.scala 397:27]
  wire  _T_3787 = _T_3785 | _T_3786; // @[core.scala 396:53]
  wire  _T_3788 = mem_ctrl_br_type == 4'h1; // @[core.scala 398:27]
  wire  _T_3789 = _T_3787 | _T_3788; // @[core.scala 397:38]
  wire  _T_3790 = mem_ctrl_br_type == 4'h3; // @[core.scala 399:27]
  wire  inst_kill_branch = _T_3789 | _T_3790; // @[core.scala 398:37]
  wire  inst_kill = inst_kill_branch | csr_io_expt; // @[core.scala 401:36]
  wire  _T_3565 = ~inst_kill; // @[core.scala 187:75]
  wire  _T_3566 = _T_3564 & _T_3565; // @[core.scala 187:71]
  wire  _T_3568 = _T_3566 | _T_1777; // @[core.scala 187:88]
  wire  stall = _T_3568 | io_sw_w_waitrequest_sig; // @[core.scala 187:113]
  wire  _T_1780 = ~stall; // @[core.scala 121:10]
  wire  _T_1782 = _T_1780 & _T_3565; // @[core.scala 121:17]
  wire  _GEN_5 = io_sw_w_waitrequest_sig ? 1'h0 : valid_imem; // @[core.scala 131:41]
  wire  _GEN_8 = inst_kill & imem_read_sig; // @[core.scala 126:27]
  wire  _GEN_9 = inst_kill ? 1'h0 : _GEN_5; // @[core.scala 126:27]
  wire  _GEN_13 = _T_1782 | _GEN_9; // @[core.scala 121:32]
  wire  _T_1786 = _T_1782 & valid_imem; // @[core.scala 143:31]
  wire  _T_1787 = ~valid_imem; // @[core.scala 151:16]
  wire [31:0] _T_1788 = idm_io_inst_bits & 32'h7f; // @[control.scala 192:55]
  wire  _T_1789 = 32'h37 == _T_1788; // @[control.scala 192:55]
  wire  _T_1791 = 32'h17 == _T_1788; // @[control.scala 192:55]
  wire  _T_1793 = 32'h6f == _T_1788; // @[control.scala 192:55]
  wire [31:0] _T_1794 = idm_io_inst_bits & 32'h707f; // @[control.scala 192:55]
  wire  _T_1795 = 32'h67 == _T_1794; // @[control.scala 192:55]
  wire  _T_1797 = 32'h63 == _T_1794; // @[control.scala 192:55]
  wire  _T_1799 = 32'h1063 == _T_1794; // @[control.scala 192:55]
  wire  _T_1801 = 32'h4063 == _T_1794; // @[control.scala 192:55]
  wire  _T_1803 = 32'h5063 == _T_1794; // @[control.scala 192:55]
  wire  _T_1805 = 32'h6063 == _T_1794; // @[control.scala 192:55]
  wire  _T_1807 = 32'h7063 == _T_1794; // @[control.scala 192:55]
  wire  _T_1809 = 32'h3 == _T_1794; // @[control.scala 192:55]
  wire  _T_1811 = 32'h1003 == _T_1794; // @[control.scala 192:55]
  wire  _T_1813 = 32'h2003 == _T_1794; // @[control.scala 192:55]
  wire  _T_1815 = 32'h4003 == _T_1794; // @[control.scala 192:55]
  wire  _T_1817 = 32'h5003 == _T_1794; // @[control.scala 192:55]
  wire  _T_1819 = 32'h23 == _T_1794; // @[control.scala 192:55]
  wire  _T_1821 = 32'h1023 == _T_1794; // @[control.scala 192:55]
  wire  _T_1823 = 32'h2023 == _T_1794; // @[control.scala 192:55]
  wire  _T_1825 = 32'h13 == _T_1794; // @[control.scala 192:55]
  wire  _T_1827 = 32'h2013 == _T_1794; // @[control.scala 192:55]
  wire  _T_1829 = 32'h3013 == _T_1794; // @[control.scala 192:55]
  wire  _T_1831 = 32'h4013 == _T_1794; // @[control.scala 192:55]
  wire  _T_1833 = 32'h6013 == _T_1794; // @[control.scala 192:55]
  wire  _T_1835 = 32'h7013 == _T_1794; // @[control.scala 192:55]
  wire [31:0] _T_1836 = idm_io_inst_bits & 32'hfe00707f; // @[control.scala 192:55]
  wire  _T_1837 = 32'h1013 == _T_1836; // @[control.scala 192:55]
  wire [31:0] _T_1838 = idm_io_inst_bits & 32'hfc00707f; // @[control.scala 192:55]
  wire  _T_1839 = 32'h5013 == _T_1838; // @[control.scala 192:55]
  wire  _T_1841 = 32'h40005013 == _T_1838; // @[control.scala 192:55]
  wire  _T_1843 = 32'h33 == _T_1836; // @[control.scala 192:55]
  wire  _T_1845 = 32'h40000033 == _T_1836; // @[control.scala 192:55]
  wire  _T_1847 = 32'h1033 == _T_1836; // @[control.scala 192:55]
  wire  _T_1849 = 32'h2033 == _T_1836; // @[control.scala 192:55]
  wire  _T_1851 = 32'h3033 == _T_1836; // @[control.scala 192:55]
  wire  _T_1853 = 32'h4033 == _T_1836; // @[control.scala 192:55]
  wire  _T_1855 = 32'h5033 == _T_1836; // @[control.scala 192:55]
  wire  _T_1857 = 32'h40005033 == _T_1836; // @[control.scala 192:55]
  wire  _T_1859 = 32'h6033 == _T_1836; // @[control.scala 192:55]
  wire  _T_1861 = 32'h7033 == _T_1836; // @[control.scala 192:55]
  wire  _T_1863 = 32'h5073 == _T_1794; // @[control.scala 192:55]
  wire  _T_1865 = 32'h6073 == _T_1794; // @[control.scala 192:55]
  wire  _T_1867 = 32'h7073 == _T_1794; // @[control.scala 192:55]
  wire  _T_1869 = 32'h1073 == _T_1794; // @[control.scala 192:55]
  wire  _T_1871 = 32'h2073 == _T_1794; // @[control.scala 192:55]
  wire  _T_1873 = 32'h3073 == _T_1794; // @[control.scala 192:55]
  wire [31:0] _T_1874 = idm_io_inst_bits; // @[control.scala 192:55]
  wire  _T_1875 = 32'h73 == _T_1874; // @[control.scala 192:55]
  wire  _T_1877 = 32'h30200073 == _T_1874; // @[control.scala 192:55]
  wire  _T_1879 = 32'h10000073 == _T_1874; // @[control.scala 192:55]
  wire  _T_1881 = 32'h100073 == _T_1874; // @[control.scala 192:55]
  wire  _T_1883 = 32'h100f == _T_1794; // @[control.scala 192:55]
  wire  _T_1885 = 32'hf == _T_1794; // @[control.scala 192:55]
  wire  _T_1887 = _T_1883 | _T_1885; // @[Mux.scala 98:16]
  wire  _T_1888 = _T_1881 | _T_1887; // @[Mux.scala 98:16]
  wire  _T_1889 = _T_1879 | _T_1888; // @[Mux.scala 98:16]
  wire  _T_1890 = _T_1877 | _T_1889; // @[Mux.scala 98:16]
  wire  _T_1891 = _T_1875 | _T_1890; // @[Mux.scala 98:16]
  wire  _T_1892 = _T_1873 | _T_1891; // @[Mux.scala 98:16]
  wire  _T_1893 = _T_1871 | _T_1892; // @[Mux.scala 98:16]
  wire  _T_1894 = _T_1869 | _T_1893; // @[Mux.scala 98:16]
  wire  _T_1895 = _T_1867 | _T_1894; // @[Mux.scala 98:16]
  wire  _T_1896 = _T_1865 | _T_1895; // @[Mux.scala 98:16]
  wire  _T_1897 = _T_1863 | _T_1896; // @[Mux.scala 98:16]
  wire  _T_1898 = _T_1861 | _T_1897; // @[Mux.scala 98:16]
  wire  _T_1899 = _T_1859 | _T_1898; // @[Mux.scala 98:16]
  wire  _T_1900 = _T_1857 | _T_1899; // @[Mux.scala 98:16]
  wire  _T_1901 = _T_1855 | _T_1900; // @[Mux.scala 98:16]
  wire  _T_1902 = _T_1853 | _T_1901; // @[Mux.scala 98:16]
  wire  _T_1903 = _T_1851 | _T_1902; // @[Mux.scala 98:16]
  wire  _T_1904 = _T_1849 | _T_1903; // @[Mux.scala 98:16]
  wire  _T_1905 = _T_1847 | _T_1904; // @[Mux.scala 98:16]
  wire  _T_1906 = _T_1845 | _T_1905; // @[Mux.scala 98:16]
  wire  _T_1907 = _T_1843 | _T_1906; // @[Mux.scala 98:16]
  wire  _T_1908 = _T_1841 | _T_1907; // @[Mux.scala 98:16]
  wire  _T_1909 = _T_1839 | _T_1908; // @[Mux.scala 98:16]
  wire  _T_1910 = _T_1837 | _T_1909; // @[Mux.scala 98:16]
  wire  _T_1911 = _T_1835 | _T_1910; // @[Mux.scala 98:16]
  wire  _T_1912 = _T_1833 | _T_1911; // @[Mux.scala 98:16]
  wire  _T_1913 = _T_1831 | _T_1912; // @[Mux.scala 98:16]
  wire  _T_1914 = _T_1829 | _T_1913; // @[Mux.scala 98:16]
  wire  _T_1915 = _T_1827 | _T_1914; // @[Mux.scala 98:16]
  wire  _T_1916 = _T_1825 | _T_1915; // @[Mux.scala 98:16]
  wire  _T_1917 = _T_1823 | _T_1916; // @[Mux.scala 98:16]
  wire  _T_1918 = _T_1821 | _T_1917; // @[Mux.scala 98:16]
  wire  _T_1919 = _T_1819 | _T_1918; // @[Mux.scala 98:16]
  wire  _T_1920 = _T_1817 | _T_1919; // @[Mux.scala 98:16]
  wire  _T_1921 = _T_1815 | _T_1920; // @[Mux.scala 98:16]
  wire  _T_1922 = _T_1813 | _T_1921; // @[Mux.scala 98:16]
  wire  _T_1923 = _T_1811 | _T_1922; // @[Mux.scala 98:16]
  wire  _T_1924 = _T_1809 | _T_1923; // @[Mux.scala 98:16]
  wire  _T_1925 = _T_1807 | _T_1924; // @[Mux.scala 98:16]
  wire  _T_1926 = _T_1805 | _T_1925; // @[Mux.scala 98:16]
  wire  _T_1927 = _T_1803 | _T_1926; // @[Mux.scala 98:16]
  wire  _T_1928 = _T_1801 | _T_1927; // @[Mux.scala 98:16]
  wire  _T_1929 = _T_1799 | _T_1928; // @[Mux.scala 98:16]
  wire  _T_1930 = _T_1797 | _T_1929; // @[Mux.scala 98:16]
  wire  _T_1931 = _T_1795 | _T_1930; // @[Mux.scala 98:16]
  wire  _T_1932 = _T_1793 | _T_1931; // @[Mux.scala 98:16]
  wire  _T_1933 = _T_1791 | _T_1932; // @[Mux.scala 98:16]
  wire  id_ctrl_legal = _T_1789 | _T_1933; // @[Mux.scala 98:16]
  wire [1:0] _T_2037 = _T_1877 ? 2'h3 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_2038 = _T_1875 ? 2'h0 : _T_2037; // @[Mux.scala 98:16]
  wire [1:0] _T_2039 = _T_1873 ? 2'h0 : _T_2038; // @[Mux.scala 98:16]
  wire [1:0] _T_2040 = _T_1871 ? 2'h0 : _T_2039; // @[Mux.scala 98:16]
  wire [1:0] _T_2041 = _T_1869 ? 2'h0 : _T_2040; // @[Mux.scala 98:16]
  wire [1:0] _T_2042 = _T_1867 ? 2'h0 : _T_2041; // @[Mux.scala 98:16]
  wire [1:0] _T_2043 = _T_1865 ? 2'h0 : _T_2042; // @[Mux.scala 98:16]
  wire [1:0] _T_2044 = _T_1863 ? 2'h0 : _T_2043; // @[Mux.scala 98:16]
  wire [1:0] _T_2045 = _T_1861 ? 2'h0 : _T_2044; // @[Mux.scala 98:16]
  wire [1:0] _T_2046 = _T_1859 ? 2'h0 : _T_2045; // @[Mux.scala 98:16]
  wire [1:0] _T_2047 = _T_1857 ? 2'h0 : _T_2046; // @[Mux.scala 98:16]
  wire [1:0] _T_2048 = _T_1855 ? 2'h0 : _T_2047; // @[Mux.scala 98:16]
  wire [1:0] _T_2049 = _T_1853 ? 2'h0 : _T_2048; // @[Mux.scala 98:16]
  wire [1:0] _T_2050 = _T_1851 ? 2'h0 : _T_2049; // @[Mux.scala 98:16]
  wire [1:0] _T_2051 = _T_1849 ? 2'h0 : _T_2050; // @[Mux.scala 98:16]
  wire [1:0] _T_2052 = _T_1847 ? 2'h0 : _T_2051; // @[Mux.scala 98:16]
  wire [1:0] _T_2053 = _T_1845 ? 2'h0 : _T_2052; // @[Mux.scala 98:16]
  wire [1:0] _T_2054 = _T_1843 ? 2'h0 : _T_2053; // @[Mux.scala 98:16]
  wire [1:0] _T_2055 = _T_1841 ? 2'h0 : _T_2054; // @[Mux.scala 98:16]
  wire [1:0] _T_2056 = _T_1839 ? 2'h0 : _T_2055; // @[Mux.scala 98:16]
  wire [1:0] _T_2057 = _T_1837 ? 2'h0 : _T_2056; // @[Mux.scala 98:16]
  wire [1:0] _T_2058 = _T_1835 ? 2'h0 : _T_2057; // @[Mux.scala 98:16]
  wire [1:0] _T_2059 = _T_1833 ? 2'h0 : _T_2058; // @[Mux.scala 98:16]
  wire [1:0] _T_2060 = _T_1831 ? 2'h0 : _T_2059; // @[Mux.scala 98:16]
  wire [1:0] _T_2061 = _T_1829 ? 2'h0 : _T_2060; // @[Mux.scala 98:16]
  wire [1:0] _T_2062 = _T_1827 ? 2'h0 : _T_2061; // @[Mux.scala 98:16]
  wire [1:0] _T_2063 = _T_1825 ? 2'h0 : _T_2062; // @[Mux.scala 98:16]
  wire [1:0] _T_2064 = _T_1823 ? 2'h0 : _T_2063; // @[Mux.scala 98:16]
  wire [1:0] _T_2065 = _T_1821 ? 2'h0 : _T_2064; // @[Mux.scala 98:16]
  wire [1:0] _T_2066 = _T_1819 ? 2'h0 : _T_2065; // @[Mux.scala 98:16]
  wire [1:0] _T_2067 = _T_1817 ? 2'h0 : _T_2066; // @[Mux.scala 98:16]
  wire [1:0] _T_2068 = _T_1815 ? 2'h0 : _T_2067; // @[Mux.scala 98:16]
  wire [1:0] _T_2069 = _T_1813 ? 2'h0 : _T_2068; // @[Mux.scala 98:16]
  wire [1:0] _T_2070 = _T_1811 ? 2'h0 : _T_2069; // @[Mux.scala 98:16]
  wire [1:0] _T_2071 = _T_1809 ? 2'h0 : _T_2070; // @[Mux.scala 98:16]
  wire [2:0] _T_2072 = _T_1807 ? 3'h7 : {{1'd0}, _T_2071}; // @[Mux.scala 98:16]
  wire [3:0] _T_2073 = _T_1805 ? 4'h9 : {{1'd0}, _T_2072}; // @[Mux.scala 98:16]
  wire [3:0] _T_2074 = _T_1803 ? 4'h6 : _T_2073; // @[Mux.scala 98:16]
  wire [3:0] _T_2075 = _T_1801 ? 4'h8 : _T_2074; // @[Mux.scala 98:16]
  wire [3:0] _T_2076 = _T_1799 ? 4'h4 : _T_2075; // @[Mux.scala 98:16]
  wire [3:0] _T_2077 = _T_1797 ? 4'h5 : _T_2076; // @[Mux.scala 98:16]
  wire [3:0] _T_2078 = _T_1795 ? 4'h2 : _T_2077; // @[Mux.scala 98:16]
  wire [3:0] _T_2079 = _T_1793 ? 4'h1 : _T_2078; // @[Mux.scala 98:16]
  wire [3:0] _T_2080 = _T_1791 ? 4'h0 : _T_2079; // @[Mux.scala 98:16]
  wire [3:0] id_ctrl_br_type = _T_1789 ? 4'h0 : _T_2080; // @[Mux.scala 98:16]
  wire  _T_2187 = _T_1871 | _T_1873; // @[Mux.scala 98:16]
  wire  _T_2188 = _T_1869 | _T_2187; // @[Mux.scala 98:16]
  wire  _T_2189 = _T_1867 ? 1'h0 : _T_2188; // @[Mux.scala 98:16]
  wire  _T_2190 = _T_1865 ? 1'h0 : _T_2189; // @[Mux.scala 98:16]
  wire  _T_2191 = _T_1863 ? 1'h0 : _T_2190; // @[Mux.scala 98:16]
  wire  _T_2192 = _T_1861 | _T_2191; // @[Mux.scala 98:16]
  wire  _T_2193 = _T_1859 | _T_2192; // @[Mux.scala 98:16]
  wire  _T_2194 = _T_1857 | _T_2193; // @[Mux.scala 98:16]
  wire  _T_2195 = _T_1855 | _T_2194; // @[Mux.scala 98:16]
  wire  _T_2196 = _T_1853 | _T_2195; // @[Mux.scala 98:16]
  wire  _T_2197 = _T_1851 | _T_2196; // @[Mux.scala 98:16]
  wire  _T_2198 = _T_1849 | _T_2197; // @[Mux.scala 98:16]
  wire  _T_2199 = _T_1847 | _T_2198; // @[Mux.scala 98:16]
  wire  _T_2200 = _T_1845 | _T_2199; // @[Mux.scala 98:16]
  wire  _T_2201 = _T_1843 | _T_2200; // @[Mux.scala 98:16]
  wire  _T_2202 = _T_1841 | _T_2201; // @[Mux.scala 98:16]
  wire  _T_2203 = _T_1839 | _T_2202; // @[Mux.scala 98:16]
  wire  _T_2204 = _T_1837 | _T_2203; // @[Mux.scala 98:16]
  wire  _T_2205 = _T_1835 | _T_2204; // @[Mux.scala 98:16]
  wire  _T_2206 = _T_1833 | _T_2205; // @[Mux.scala 98:16]
  wire  _T_2207 = _T_1831 | _T_2206; // @[Mux.scala 98:16]
  wire  _T_2208 = _T_1829 | _T_2207; // @[Mux.scala 98:16]
  wire  _T_2209 = _T_1827 | _T_2208; // @[Mux.scala 98:16]
  wire  _T_2210 = _T_1825 | _T_2209; // @[Mux.scala 98:16]
  wire  _T_2211 = _T_1823 | _T_2210; // @[Mux.scala 98:16]
  wire  _T_2212 = _T_1821 | _T_2211; // @[Mux.scala 98:16]
  wire  _T_2213 = _T_1819 | _T_2212; // @[Mux.scala 98:16]
  wire  _T_2214 = _T_1817 | _T_2213; // @[Mux.scala 98:16]
  wire  _T_2215 = _T_1815 | _T_2214; // @[Mux.scala 98:16]
  wire  _T_2216 = _T_1813 | _T_2215; // @[Mux.scala 98:16]
  wire  _T_2217 = _T_1811 | _T_2216; // @[Mux.scala 98:16]
  wire  _T_2218 = _T_1809 | _T_2217; // @[Mux.scala 98:16]
  wire  _T_2219 = _T_1807 | _T_2218; // @[Mux.scala 98:16]
  wire  _T_2220 = _T_1805 | _T_2219; // @[Mux.scala 98:16]
  wire  _T_2221 = _T_1803 | _T_2220; // @[Mux.scala 98:16]
  wire  _T_2222 = _T_1801 | _T_2221; // @[Mux.scala 98:16]
  wire  _T_2223 = _T_1799 | _T_2222; // @[Mux.scala 98:16]
  wire  _T_2224 = _T_1797 | _T_2223; // @[Mux.scala 98:16]
  wire  _T_2225 = _T_1795 | _T_2224; // @[Mux.scala 98:16]
  wire  _T_2924 = _T_1867 | _T_2188; // @[Mux.scala 98:16]
  wire  _T_2925 = _T_1865 | _T_2924; // @[Mux.scala 98:16]
  wire  _T_2926 = _T_1863 | _T_2925; // @[Mux.scala 98:16]
  wire  _T_2927 = _T_1861 | _T_2926; // @[Mux.scala 98:16]
  wire  _T_2928 = _T_1859 | _T_2927; // @[Mux.scala 98:16]
  wire  _T_2929 = _T_1857 | _T_2928; // @[Mux.scala 98:16]
  wire  _T_2930 = _T_1855 | _T_2929; // @[Mux.scala 98:16]
  wire  _T_2931 = _T_1853 | _T_2930; // @[Mux.scala 98:16]
  wire  _T_2932 = _T_1851 | _T_2931; // @[Mux.scala 98:16]
  wire  _T_2933 = _T_1849 | _T_2932; // @[Mux.scala 98:16]
  wire  _T_2934 = _T_1847 | _T_2933; // @[Mux.scala 98:16]
  wire  _T_2935 = _T_1845 | _T_2934; // @[Mux.scala 98:16]
  wire  _T_2936 = _T_1843 | _T_2935; // @[Mux.scala 98:16]
  wire  _T_2937 = _T_1841 | _T_2936; // @[Mux.scala 98:16]
  wire  _T_2938 = _T_1839 | _T_2937; // @[Mux.scala 98:16]
  wire  _T_2939 = _T_1837 | _T_2938; // @[Mux.scala 98:16]
  wire  _T_2940 = _T_1835 | _T_2939; // @[Mux.scala 98:16]
  wire  _T_2941 = _T_1833 | _T_2940; // @[Mux.scala 98:16]
  wire  _T_2942 = _T_1831 | _T_2941; // @[Mux.scala 98:16]
  wire  _T_2943 = _T_1829 | _T_2942; // @[Mux.scala 98:16]
  wire  _T_2944 = _T_1827 | _T_2943; // @[Mux.scala 98:16]
  wire  _T_2945 = _T_1825 | _T_2944; // @[Mux.scala 98:16]
  wire  _T_2946 = _T_1823 ? 1'h0 : _T_2945; // @[Mux.scala 98:16]
  wire  _T_2947 = _T_1821 ? 1'h0 : _T_2946; // @[Mux.scala 98:16]
  wire  _T_2948 = _T_1819 ? 1'h0 : _T_2947; // @[Mux.scala 98:16]
  wire  _T_2949 = _T_1817 | _T_2948; // @[Mux.scala 98:16]
  wire  _T_2950 = _T_1815 | _T_2949; // @[Mux.scala 98:16]
  wire  _T_2951 = _T_1813 | _T_2950; // @[Mux.scala 98:16]
  wire  _T_2952 = _T_1811 | _T_2951; // @[Mux.scala 98:16]
  wire  _T_2953 = _T_1809 | _T_2952; // @[Mux.scala 98:16]
  wire  _T_2954 = _T_1807 ? 1'h0 : _T_2953; // @[Mux.scala 98:16]
  wire  _T_2955 = _T_1805 ? 1'h0 : _T_2954; // @[Mux.scala 98:16]
  wire  _T_2956 = _T_1803 ? 1'h0 : _T_2955; // @[Mux.scala 98:16]
  wire  _T_2957 = _T_1801 ? 1'h0 : _T_2956; // @[Mux.scala 98:16]
  wire  _T_2958 = _T_1799 ? 1'h0 : _T_2957; // @[Mux.scala 98:16]
  wire  _T_2959 = _T_1797 ? 1'h0 : _T_2958; // @[Mux.scala 98:16]
  wire  _T_2960 = _T_1795 | _T_2959; // @[Mux.scala 98:16]
  wire  _T_2961 = _T_1793 | _T_2960; // @[Mux.scala 98:16]
  wire  _T_2962 = _T_1791 | _T_2961; // @[Mux.scala 98:16]
  wire  id_ctrl_rf_wen = _T_1789 | _T_2962; // @[Mux.scala 98:16]
  wire  _T_3063 = _T_1883 ? 1'h0 : _T_1885; // @[Mux.scala 98:16]
  wire  _T_3064 = _T_1881 ? 1'h0 : _T_3063; // @[Mux.scala 98:16]
  wire  _T_3065 = _T_1879 ? 1'h0 : _T_3064; // @[Mux.scala 98:16]
  wire  _T_3066 = _T_1877 ? 1'h0 : _T_3065; // @[Mux.scala 98:16]
  wire  _T_3067 = _T_1875 ? 1'h0 : _T_3066; // @[Mux.scala 98:16]
  wire  _T_3068 = _T_1873 ? 1'h0 : _T_3067; // @[Mux.scala 98:16]
  wire  _T_3069 = _T_1871 ? 1'h0 : _T_3068; // @[Mux.scala 98:16]
  wire  _T_3070 = _T_1869 ? 1'h0 : _T_3069; // @[Mux.scala 98:16]
  wire  _T_3071 = _T_1867 ? 1'h0 : _T_3070; // @[Mux.scala 98:16]
  wire  _T_3072 = _T_1865 ? 1'h0 : _T_3071; // @[Mux.scala 98:16]
  wire  _T_3073 = _T_1863 ? 1'h0 : _T_3072; // @[Mux.scala 98:16]
  wire  _T_3074 = _T_1861 ? 1'h0 : _T_3073; // @[Mux.scala 98:16]
  wire  _T_3075 = _T_1859 ? 1'h0 : _T_3074; // @[Mux.scala 98:16]
  wire  _T_3076 = _T_1857 ? 1'h0 : _T_3075; // @[Mux.scala 98:16]
  wire  _T_3077 = _T_1855 ? 1'h0 : _T_3076; // @[Mux.scala 98:16]
  wire  _T_3078 = _T_1853 ? 1'h0 : _T_3077; // @[Mux.scala 98:16]
  wire  _T_3079 = _T_1851 ? 1'h0 : _T_3078; // @[Mux.scala 98:16]
  wire  _T_3080 = _T_1849 ? 1'h0 : _T_3079; // @[Mux.scala 98:16]
  wire  _T_3081 = _T_1847 ? 1'h0 : _T_3080; // @[Mux.scala 98:16]
  wire  _T_3082 = _T_1845 ? 1'h0 : _T_3081; // @[Mux.scala 98:16]
  wire  _T_3083 = _T_1843 ? 1'h0 : _T_3082; // @[Mux.scala 98:16]
  wire  _T_3084 = _T_1841 ? 1'h0 : _T_3083; // @[Mux.scala 98:16]
  wire  _T_3085 = _T_1839 ? 1'h0 : _T_3084; // @[Mux.scala 98:16]
  wire  _T_3086 = _T_1837 ? 1'h0 : _T_3085; // @[Mux.scala 98:16]
  wire  _T_3087 = _T_1835 ? 1'h0 : _T_3086; // @[Mux.scala 98:16]
  wire  _T_3088 = _T_1833 ? 1'h0 : _T_3087; // @[Mux.scala 98:16]
  wire  _T_3089 = _T_1831 ? 1'h0 : _T_3088; // @[Mux.scala 98:16]
  wire  _T_3090 = _T_1829 ? 1'h0 : _T_3089; // @[Mux.scala 98:16]
  wire  _T_3091 = _T_1827 ? 1'h0 : _T_3090; // @[Mux.scala 98:16]
  wire  _T_3092 = _T_1825 ? 1'h0 : _T_3091; // @[Mux.scala 98:16]
  wire  _T_3093 = _T_1823 | _T_3092; // @[Mux.scala 98:16]
  wire  _T_3094 = _T_1821 | _T_3093; // @[Mux.scala 98:16]
  wire  _T_3095 = _T_1819 | _T_3094; // @[Mux.scala 98:16]
  wire  _T_3096 = _T_1817 | _T_3095; // @[Mux.scala 98:16]
  wire  _T_3097 = _T_1815 | _T_3096; // @[Mux.scala 98:16]
  wire  _T_3098 = _T_1813 | _T_3097; // @[Mux.scala 98:16]
  wire  _T_3099 = _T_1811 | _T_3098; // @[Mux.scala 98:16]
  wire  _T_3100 = _T_1809 | _T_3099; // @[Mux.scala 98:16]
  wire  _T_3101 = _T_1807 ? 1'h0 : _T_3100; // @[Mux.scala 98:16]
  wire  _T_3102 = _T_1805 ? 1'h0 : _T_3101; // @[Mux.scala 98:16]
  wire  _T_3103 = _T_1803 ? 1'h0 : _T_3102; // @[Mux.scala 98:16]
  wire  _T_3104 = _T_1801 ? 1'h0 : _T_3103; // @[Mux.scala 98:16]
  wire  _T_3105 = _T_1799 ? 1'h0 : _T_3104; // @[Mux.scala 98:16]
  wire  _T_3106 = _T_1797 ? 1'h0 : _T_3105; // @[Mux.scala 98:16]
  wire  _T_3107 = _T_1795 ? 1'h0 : _T_3106; // @[Mux.scala 98:16]
  wire  _T_3108 = _T_1793 ? 1'h0 : _T_3107; // @[Mux.scala 98:16]
  wire  _T_3109 = _T_1791 ? 1'h0 : _T_3108; // @[Mux.scala 98:16]
  wire  id_ctrl_mem_en = _T_1789 ? 1'h0 : _T_3109; // @[Mux.scala 98:16]
  wire [1:0] _T_3387 = _T_1823 ? 2'h3 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_3388 = _T_1821 ? 2'h2 : _T_3387; // @[Mux.scala 98:16]
  wire [1:0] _T_3389 = _T_1819 ? 2'h1 : _T_3388; // @[Mux.scala 98:16]
  wire [2:0] _T_3505 = _T_1881 ? 3'h4 : 3'h0; // @[Mux.scala 98:16]
  wire [2:0] _T_3506 = _T_1879 ? 3'h4 : _T_3505; // @[Mux.scala 98:16]
  wire [2:0] _T_3507 = _T_1877 ? 3'h4 : _T_3506; // @[Mux.scala 98:16]
  wire [2:0] _T_3508 = _T_1875 ? 3'h4 : _T_3507; // @[Mux.scala 98:16]
  wire [2:0] _T_3509 = _T_1873 ? 3'h3 : _T_3508; // @[Mux.scala 98:16]
  wire [2:0] _T_3510 = _T_1871 ? 3'h2 : _T_3509; // @[Mux.scala 98:16]
  wire [2:0] _T_3511 = _T_1869 ? 3'h1 : _T_3510; // @[Mux.scala 98:16]
  wire [2:0] _T_3512 = _T_1867 ? 3'h3 : _T_3511; // @[Mux.scala 98:16]
  wire [2:0] _T_3513 = _T_1865 ? 3'h2 : _T_3512; // @[Mux.scala 98:16]
  wire [2:0] _T_3514 = _T_1863 ? 3'h1 : _T_3513; // @[Mux.scala 98:16]
  wire [2:0] _T_3515 = _T_1861 ? 3'h0 : _T_3514; // @[Mux.scala 98:16]
  wire [2:0] _T_3516 = _T_1859 ? 3'h0 : _T_3515; // @[Mux.scala 98:16]
  wire [2:0] _T_3517 = _T_1857 ? 3'h0 : _T_3516; // @[Mux.scala 98:16]
  wire [2:0] _T_3518 = _T_1855 ? 3'h0 : _T_3517; // @[Mux.scala 98:16]
  wire [2:0] _T_3519 = _T_1853 ? 3'h0 : _T_3518; // @[Mux.scala 98:16]
  wire [2:0] _T_3520 = _T_1851 ? 3'h0 : _T_3519; // @[Mux.scala 98:16]
  wire [2:0] _T_3521 = _T_1849 ? 3'h0 : _T_3520; // @[Mux.scala 98:16]
  wire [2:0] _T_3522 = _T_1847 ? 3'h0 : _T_3521; // @[Mux.scala 98:16]
  wire [2:0] _T_3523 = _T_1845 ? 3'h0 : _T_3522; // @[Mux.scala 98:16]
  wire [2:0] _T_3524 = _T_1843 ? 3'h0 : _T_3523; // @[Mux.scala 98:16]
  wire [2:0] _T_3525 = _T_1841 ? 3'h0 : _T_3524; // @[Mux.scala 98:16]
  wire [2:0] _T_3526 = _T_1839 ? 3'h0 : _T_3525; // @[Mux.scala 98:16]
  wire [2:0] _T_3527 = _T_1837 ? 3'h0 : _T_3526; // @[Mux.scala 98:16]
  wire [2:0] _T_3528 = _T_1835 ? 3'h0 : _T_3527; // @[Mux.scala 98:16]
  wire [2:0] _T_3529 = _T_1833 ? 3'h0 : _T_3528; // @[Mux.scala 98:16]
  wire [2:0] _T_3530 = _T_1831 ? 3'h0 : _T_3529; // @[Mux.scala 98:16]
  wire [2:0] _T_3531 = _T_1829 ? 3'h0 : _T_3530; // @[Mux.scala 98:16]
  wire [2:0] _T_3532 = _T_1827 ? 3'h0 : _T_3531; // @[Mux.scala 98:16]
  wire [2:0] _T_3533 = _T_1825 ? 3'h0 : _T_3532; // @[Mux.scala 98:16]
  wire [2:0] _T_3534 = _T_1823 ? 3'h0 : _T_3533; // @[Mux.scala 98:16]
  wire [2:0] _T_3535 = _T_1821 ? 3'h0 : _T_3534; // @[Mux.scala 98:16]
  wire [2:0] _T_3536 = _T_1819 ? 3'h0 : _T_3535; // @[Mux.scala 98:16]
  wire [2:0] _T_3537 = _T_1817 ? 3'h0 : _T_3536; // @[Mux.scala 98:16]
  wire [2:0] _T_3538 = _T_1815 ? 3'h0 : _T_3537; // @[Mux.scala 98:16]
  wire [2:0] _T_3539 = _T_1813 ? 3'h0 : _T_3538; // @[Mux.scala 98:16]
  wire [2:0] _T_3540 = _T_1811 ? 3'h0 : _T_3539; // @[Mux.scala 98:16]
  wire [2:0] _T_3541 = _T_1809 ? 3'h0 : _T_3540; // @[Mux.scala 98:16]
  wire [2:0] _T_3542 = _T_1807 ? 3'h0 : _T_3541; // @[Mux.scala 98:16]
  wire [2:0] _T_3543 = _T_1805 ? 3'h0 : _T_3542; // @[Mux.scala 98:16]
  wire [2:0] _T_3544 = _T_1803 ? 3'h0 : _T_3543; // @[Mux.scala 98:16]
  wire [2:0] _T_3545 = _T_1801 ? 3'h0 : _T_3544; // @[Mux.scala 98:16]
  wire [2:0] _T_3546 = _T_1799 ? 3'h0 : _T_3545; // @[Mux.scala 98:16]
  wire [2:0] _T_3547 = _T_1797 ? 3'h0 : _T_3546; // @[Mux.scala 98:16]
  wire [2:0] _T_3548 = _T_1795 ? 3'h0 : _T_3547; // @[Mux.scala 98:16]
  wire [2:0] _T_3549 = _T_1793 ? 3'h0 : _T_3548; // @[Mux.scala 98:16]
  wire [2:0] _T_3550 = _T_1791 ? 3'h0 : _T_3549; // @[Mux.scala 98:16]
  wire [2:0] id_ctrl_csr_cmd = _T_1789 ? 3'h0 : _T_3550; // @[Mux.scala 98:16]
  wire  _T_3553 = idm_io_inst_rs1 == 5'h0; // @[core.scala 628:14]
  wire  _T_3555 = idm_io_inst_rs2 == 5'h0; // @[core.scala 628:14]
  wire  _T_3557 = ex_pc == 32'h0; // @[core.scala 176:55]
  reg  interrupt_sig; // @[core.scala 179:38]
  wire  _T_3573 = id_ctrl_br_type == 4'h1; // @[core.scala 205:36]
  wire  _T_3574 = id_ctrl_br_type == 4'h2; // @[core.scala 205:66]
  wire  _T_3575 = _T_3573 | _T_3574; // @[core.scala 205:46]
  wire  _T_3576 = id_ctrl_br_type > 4'h3; // @[core.scala 206:36]
  wire [2:0] _GEN_25 = _T_1782 ? id_ctrl_csr_cmd : 3'h0; // @[core.scala 195:28]
  wire  _GEN_28 = _T_1782 & id_ctrl_mem_en; // @[core.scala 195:28]
  wire  _GEN_29 = _T_1782 ? id_ctrl_rf_wen : 1'h1; // @[core.scala 195:28]
  wire  _GEN_36 = _T_1782 ? id_ctrl_legal : 1'h1; // @[core.scala 195:28]
  wire [11:0] _GEN_43 = _T_1782 ? idm_io_inst_csr : 12'h0; // @[core.scala 195:28]
  wire  _GEN_45 = _T_1782 & _T_3575; // @[core.scala 195:28]
  wire  _GEN_46 = _T_1782 & _T_3576; // @[core.scala 195:28]
  wire  _T_3579 = ex_ctrl_imm_type == 3'h5; // @[control.scala 198:28]
  wire  _T_3581 = ex_inst[31]; // @[control.scala 198:53]
  wire  _T_3582 = _T_3579 ? $signed(1'sh0) : $signed(_T_3581); // @[control.scala 198:23]
  wire  _T_3583 = ex_ctrl_imm_type == 3'h3; // @[control.scala 199:30]
  wire [10:0] _T_3585 = ex_inst[30:20]; // @[control.scala 199:53]
  wire  _T_3587 = ex_ctrl_imm_type != 3'h3; // @[control.scala 200:30]
  wire  _T_3588 = ex_ctrl_imm_type != 3'h4; // @[control.scala 200:47]
  wire  _T_3589 = _T_3587 & _T_3588; // @[control.scala 200:40]
  wire [7:0] _T_3591 = ex_inst[19:12]; // @[control.scala 200:76]
  wire  _T_3595 = _T_3583 | _T_3579; // @[control.scala 201:37]
  wire  _T_3596 = ex_ctrl_imm_type == 3'h4; // @[control.scala 202:21]
  wire  _T_3598 = ex_inst[20]; // @[control.scala 202:41]
  wire  _T_3599 = ex_ctrl_imm_type == 3'h2; // @[control.scala 203:25]
  wire  _T_3601 = ex_inst[7]; // @[control.scala 203:44]
  wire  _T_3602 = _T_3599 ? $signed(_T_3601) : $signed(_T_3582); // @[control.scala 203:20]
  wire  _T_3603 = _T_3596 ? $signed(_T_3598) : $signed(_T_3602); // @[control.scala 202:16]
  wire [5:0] _T_3609 = _T_3595 ? 6'h0 : ex_inst[30:25]; // @[control.scala 204:24]
  wire  _T_3611 = ex_ctrl_imm_type == 3'h1; // @[control.scala 206:21]
  wire  _T_3613 = _T_3611 | _T_3599; // @[control.scala 206:31]
  wire [3:0] _T_3618 = _T_3579 ? ex_inst[19:16] : ex_inst[24:21]; // @[control.scala 207:20]
  wire [3:0] _T_3619 = _T_3613 ? ex_inst[11:8] : _T_3618; // @[control.scala 206:16]
  wire [3:0] _T_3620 = _T_3583 ? 4'h0 : _T_3619; // @[control.scala 205:23]
  wire  _T_3623 = ex_ctrl_imm_type == 3'h0; // @[control.scala 209:21]
  wire  _T_3627 = _T_3579 & ex_inst[15]; // @[control.scala 210:20]
  wire  _T_3628 = _T_3623 ? ex_inst[20] : _T_3627; // @[control.scala 209:16]
  wire  _T_3629 = _T_3611 ? ex_inst[7] : _T_3628; // @[control.scala 208:21]
  wire  _T_3632 = _T_3595 ? $signed(1'sh0) : $signed(_T_3603); // @[Cat.scala 29:58]
  wire [7:0] _T_3633 = _T_3589 ? $signed({8{_T_3582}}) : $signed(_T_3591); // @[Cat.scala 29:58]
  wire [10:0] _T_3635 = _T_3583 ? $signed(_T_3585) : $signed({11{_T_3582}}); // @[Cat.scala 29:58]
  wire  _T_3636 = _T_3579 ? $signed(1'sh0) : $signed(_T_3581); // @[Cat.scala 29:58]
  wire [31:0] ex_imm = {_T_3636,_T_3635,_T_3633,_T_3632,_T_3609,_T_3620,_T_3629}; // @[control.scala 212:57]
  wire  _T_3640 = ex_reg_raddr_0 != 5'h0; // @[core.scala 230:26]
  wire  _T_3641 = ex_reg_raddr_0 == mem_reg_waddr; // @[core.scala 230:53]
  wire  _T_3642 = _T_3640 & _T_3641; // @[core.scala 230:34]
  wire  _T_3643 = mem_ctrl_csr_cmd != 3'h0; // @[core.scala 230:91]
  wire  _T_3644 = _T_3642 & _T_3643; // @[core.scala 230:71]
  wire  _T_3649 = _T_3642 & mem_ctrl_rf_wen; // @[core.scala 231:71]
  wire  _T_3651 = ex_reg_raddr_0 == wb_reg_waddr; // @[core.scala 232:53]
  wire  _T_3652 = _T_3640 & _T_3651; // @[core.scala 232:34]
  wire  _T_3654 = _T_3652 & wb_ctrl_rf_wen; // @[core.scala 232:70]
  wire  _T_3656 = _T_3654 & wb_ctrl_mem_en; // @[core.scala 232:98]
  wire  _T_3657 = wb_ctrl_csr_cmd == 3'h0; // @[core.scala 232:145]
  wire  _T_3658 = _T_3656 & _T_3657; // @[core.scala 232:126]
  wire  _T_3664 = ~wb_ctrl_mem_en; // @[core.scala 233:116]
  wire  _T_3665 = _T_3654 & _T_3664; // @[core.scala 233:98]
  wire  _T_3667 = _T_3665 & _T_3657; // @[core.scala 233:126]
  wire  _T_3671 = ~ex_ctrl_rf_wen; // @[core.scala 234:88]
  wire  _T_3672 = _T_3652 & _T_3671; // @[core.scala 234:70]
  wire  _T_3674 = _T_3672 & ex_ctrl_mem_en; // @[core.scala 234:98]
  wire  _T_3680 = wb_ctrl_csr_cmd != 3'h0; // @[core.scala 235:117]
  wire  _T_3681 = _T_3654 & _T_3680; // @[core.scala 235:98]
  wire [31:0] _T_3682 = _T_3681 ? wb_csr_data : ex_rs_0; // @[Mux.scala 98:16]
  wire [31:0] _T_3683 = _T_3674 ? wb_alu_out : _T_3682; // @[Mux.scala 98:16]
  wire [31:0] _T_3684 = _T_3667 ? wb_alu_out : _T_3683; // @[Mux.scala 98:16]
  wire [31:0] _T_3685 = _T_3658 ? io_r_dmem_dat_data : _T_3684; // @[Mux.scala 98:16]
  wire [31:0] _T_3686 = _T_3649 ? mem_alu_out : _T_3685; // @[Mux.scala 98:16]
  wire [31:0] ex_reg_rs1_bypass = _T_3644 ? mem_csr_data : _T_3686; // @[Mux.scala 98:16]
  wire  _T_3688 = ex_reg_raddr_1 != 5'h0; // @[core.scala 240:26]
  wire  _T_3689 = ex_reg_raddr_1 == mem_reg_waddr; // @[core.scala 240:53]
  wire  _T_3690 = _T_3688 & _T_3689; // @[core.scala 240:34]
  wire  _T_3692 = _T_3690 & _T_3643; // @[core.scala 240:71]
  wire  _T_3697 = _T_3690 & mem_ctrl_rf_wen; // @[core.scala 241:71]
  wire  _T_3699 = ex_reg_raddr_1 == wb_reg_waddr; // @[core.scala 242:53]
  wire  _T_3700 = _T_3688 & _T_3699; // @[core.scala 242:34]
  wire  _T_3702 = _T_3700 & wb_ctrl_rf_wen; // @[core.scala 242:70]
  wire  _T_3704 = _T_3702 & wb_ctrl_mem_en; // @[core.scala 242:98]
  wire  _T_3706 = _T_3704 & _T_3657; // @[core.scala 242:126]
  wire  _T_3713 = _T_3702 & _T_3664; // @[core.scala 243:98]
  wire  _T_3715 = _T_3713 & _T_3657; // @[core.scala 243:126]
  wire  _T_3720 = _T_3700 & _T_3671; // @[core.scala 244:70]
  wire  _T_3722 = _T_3720 & ex_ctrl_mem_en; // @[core.scala 244:98]
  wire  _T_3729 = _T_3702 & _T_3680; // @[core.scala 245:98]
  wire [31:0] _T_3730 = _T_3729 ? wb_csr_data : ex_rs_1; // @[Mux.scala 98:16]
  wire [31:0] _T_3731 = _T_3722 ? wb_alu_out : _T_3730; // @[Mux.scala 98:16]
  wire [31:0] _T_3732 = _T_3715 ? wb_alu_out : _T_3731; // @[Mux.scala 98:16]
  wire [31:0] _T_3733 = _T_3706 ? io_r_dmem_dat_data : _T_3732; // @[Mux.scala 98:16]
  wire [31:0] _T_3734 = _T_3697 ? mem_alu_out : _T_3733; // @[Mux.scala 98:16]
  wire [31:0] ex_reg_rs2_bypass = _T_3692 ? mem_csr_data : _T_3734; // @[Mux.scala 98:16]
  wire  _T_3736 = ex_ctrl_alu_op1 == 2'h1; // @[core.scala 250:26]
  wire  _T_3737 = ex_ctrl_alu_op1 == 2'h2; // @[core.scala 251:26]
  wire [31:0] _T_3740 = _T_3737 ? ex_pc : 32'h0; // @[Mux.scala 98:16]
  wire  _T_3742 = ex_ctrl_alu_op2 == 2'h1; // @[core.scala 256:26]
  wire  _T_3743 = ex_ctrl_alu_op2 == 2'h2; // @[core.scala 257:26]
  wire [31:0] _T_3744 = {_T_3636,_T_3635,_T_3633,_T_3632,_T_3609,_T_3620,_T_3629}; // @[core.scala 257:49]
  wire [31:0] _T_3747 = _T_3743 ? _T_3744 : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _T_3753 = _T_3643 ? mem_csr_data : mem_alu_out; // @[core.scala 269:51]
  wire [31:0] _T_3756 = _T_3680 ? wb_csr_data : wb_alu_out; // @[core.scala 270:54]
  wire [31:0] _T_3757 = _T_3651 ? _T_3756 : ex_reg_rs1_bypass; // @[core.scala 270:16]
  wire [31:0] _T_3758 = _T_3641 ? _T_3753 : _T_3757; // @[core.scala 269:12]
  wire  _T_3763 = ~io_sw_w_waitrequest_sig; // @[core.scala 304:25]
  wire  _T_3764 = _T_3565 & _T_3763; // @[core.scala 304:22]
  wire  _GEN_53 = inst_kill | mem_ctrl_rf_wen; // @[core.scala 317:28]
  wire  _GEN_75 = _T_3764 ? ex_ctrl_rf_wen : _GEN_53; // @[core.scala 304:51]
  wire  _T_3766 = ~io_sw_halt; // @[core.scala 334:22]
  wire  _T_3767 = mem_ctrl_mem_wr == 2'h2; // @[core.scala 337:57]
  wire  _T_3770 = mem_ctrl_mask_type == 3'h1; // @[core.scala 356:33]
  wire  _T_3772 = 2'h0 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire  _T_3773 = 2'h1 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [39:0] _GEN_155 = {mem_rs_1, 8'h0}; // @[core.scala 364:53]
  wire [46:0] _T_3774 = {{7'd0}, _GEN_155}; // @[core.scala 364:53]
  wire  _T_3775 = 2'h2 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [47:0] _GEN_156 = {mem_rs_1, 16'h0}; // @[core.scala 368:53]
  wire [62:0] _T_3776 = {{15'd0}, _GEN_156}; // @[core.scala 368:53]
  wire  _T_3777 = 2'h3 == mem_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [55:0] _GEN_157 = {mem_rs_1, 24'h0}; // @[core.scala 372:53]
  wire [62:0] _T_3778 = {{7'd0}, _GEN_157}; // @[core.scala 372:53]
  wire [62:0] _GEN_96 = _T_3777 ? _T_3778 : {{31'd0}, io_sw_w_dat}; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_97 = _T_3775 ? 4'h4 : 4'h8; // @[Conditional.scala 39:67]
  wire [62:0] _GEN_98 = _T_3775 ? _T_3776 : _GEN_96; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_99 = _T_3773 ? 4'h2 : _GEN_97; // @[Conditional.scala 39:67]
  wire [62:0] _GEN_100 = _T_3773 ? {{16'd0}, _T_3774} : _GEN_98; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_101 = _T_3772 ? 4'h1 : _GEN_99; // @[Conditional.scala 40:58]
  wire [62:0] _GEN_102 = _T_3772 ? {{31'd0}, mem_rs_1} : _GEN_100; // @[Conditional.scala 40:58]
  wire  _T_3779 = mem_ctrl_mask_type == 3'h2; // @[core.scala 375:39]
  wire [62:0] _GEN_104 = _T_3775 ? _T_3776 : {{31'd0}, io_sw_w_dat}; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_105 = _T_3772 ? 4'h3 : 4'hc; // @[Conditional.scala 40:58]
  wire [62:0] _GEN_106 = _T_3772 ? {{31'd0}, mem_rs_1} : _GEN_104; // @[Conditional.scala 40:58]
  wire [3:0] _GEN_107 = _T_3779 ? _GEN_105 : 4'hf; // @[core.scala 375:49]
  wire [62:0] _GEN_108 = _T_3779 ? _GEN_106 : {{31'd0}, mem_rs_1}; // @[core.scala 375:49]
  wire [3:0] _GEN_109 = _T_3770 ? _GEN_101 : _GEN_107; // @[core.scala 356:43]
  wire [62:0] _GEN_110 = _T_3770 ? _GEN_102 : _GEN_108; // @[core.scala 356:43]
  wire [62:0] _GEN_112 = _T_3767 ? _GEN_110 : {{31'd0}, io_sw_w_dat}; // @[core.scala 355:37]
  wire  _T_3793 = wb_ctrl_mem_wr == 2'h1; // @[core.scala 416:25]
  wire  _T_3794 = wb_ctrl_mask_type == 3'h1; // @[core.scala 417:32]
  wire  _T_3796 = 2'h0 == wb_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [23:0] _T_3799 = io_r_dmem_dat_data[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_3801 = {_T_3799,io_r_dmem_dat_data[7:0]}; // @[Cat.scala 29:58]
  wire  _T_3802 = 2'h1 == wb_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [23:0] _T_3805 = io_r_dmem_dat_data[15] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_3807 = {_T_3805,io_r_dmem_dat_data[15:8]}; // @[Cat.scala 29:58]
  wire  _T_3808 = 2'h2 == wb_alu_out[1:0]; // @[Conditional.scala 37:30]
  wire [23:0] _T_3811 = io_r_dmem_dat_data[23] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_3813 = {_T_3811,io_r_dmem_dat_data[23:16]}; // @[Cat.scala 29:58]
  wire [23:0] _T_3817 = io_r_dmem_dat_data[31] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_3819 = {_T_3817,io_r_dmem_dat_data[31:24]}; // @[Cat.scala 29:58]
  wire [31:0] _GEN_114 = _T_3808 ? _T_3813 : _T_3819; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_115 = _T_3802 ? _T_3807 : _GEN_114; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_116 = _T_3796 ? _T_3801 : _GEN_115; // @[Conditional.scala 40:58]
  wire  _T_3820 = wb_ctrl_mask_type == 3'h5; // @[core.scala 424:38]
  wire [31:0] _T_3824 = {24'h0,io_r_dmem_dat_data[7:0]}; // @[Cat.scala 29:58]
  wire [31:0] _T_3827 = {24'h0,io_r_dmem_dat_data[15:8]}; // @[Cat.scala 29:58]
  wire [31:0] _T_3830 = {24'h0,io_r_dmem_dat_data[23:16]}; // @[Cat.scala 29:58]
  wire [31:0] _T_3833 = {24'h0,io_r_dmem_dat_data[31:24]}; // @[Cat.scala 29:58]
  wire [31:0] _GEN_118 = _T_3808 ? _T_3830 : _T_3833; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_119 = _T_3802 ? _T_3827 : _GEN_118; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_120 = _T_3796 ? _T_3824 : _GEN_119; // @[Conditional.scala 40:58]
  wire  _T_3834 = wb_ctrl_mask_type == 3'h2; // @[core.scala 431:38]
  wire [15:0] _T_3839 = io_r_dmem_dat_data[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_3841 = {_T_3839,io_r_dmem_dat_data[15:0]}; // @[Cat.scala 29:58]
  wire [15:0] _T_3845 = io_r_dmem_dat_data[31] ? 16'hffff : 16'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_3847 = {_T_3845,io_r_dmem_dat_data[31:16]}; // @[Cat.scala 29:58]
  wire [31:0] _GEN_123 = _T_3808 ? _T_3847 : 32'h0; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_124 = _T_3796 ? _T_3841 : _GEN_123; // @[Conditional.scala 40:58]
  wire  _T_3850 = wb_ctrl_mask_type == 3'h6; // @[core.scala 439:38]
  wire [31:0] _T_3854 = {16'h0,io_r_dmem_dat_data[15:0]}; // @[Cat.scala 29:58]
  wire [31:0] _T_3857 = {16'h0,io_r_dmem_dat_data[31:16]}; // @[Cat.scala 29:58]
  wire [31:0] _GEN_127 = _T_3808 ? _T_3857 : 32'h0; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_128 = _T_3796 ? _T_3854 : _GEN_127; // @[Conditional.scala 40:58]
  wire [31:0] _GEN_129 = _T_3850 ? _GEN_128 : io_r_dmem_dat_data; // @[core.scala 439:49]
  wire [31:0] _GEN_130 = _T_3834 ? _GEN_124 : _GEN_129; // @[core.scala 431:48]
  wire [31:0] _GEN_131 = _T_3820 ? _GEN_120 : _GEN_130; // @[core.scala 424:49]
  wire [31:0] _GEN_132 = _T_3794 ? _GEN_116 : _GEN_131; // @[core.scala 417:42]
  wire [31:0] dmem_data = _T_3793 ? _GEN_132 : io_r_dmem_dat_data; // @[core.scala 416:36]
  wire  _T_3860 = wb_ctrl_wb_sel == 2'h1; // @[core.scala 458:29]
  wire  _T_3861 = wb_ctrl_wb_sel == 2'h0; // @[core.scala 459:29]
  wire  _T_3862 = wb_ctrl_wb_sel == 2'h3; // @[core.scala 460:29]
  wire  _T_3863 = wb_ctrl_wb_sel == 2'h2; // @[core.scala 461:29]
  wire [31:0] _T_3864 = _T_3863 ? dmem_data : wb_alu_out; // @[Mux.scala 98:16]
  wire [31:0] _T_3865 = _T_3862 ? wb_csr_data : _T_3864; // @[Mux.scala 98:16]
  wire [31:0] _T_3866 = _T_3861 ? wb_npc : _T_3865; // @[Mux.scala 98:16]
  wire  _T_3869 = wb_reg_waddr > 5'h0; // @[core.scala 632:16]
  wire  _T_3875 = _T_1780 & io_r_imem_dat_req; // @[core.scala 479:21]
  wire [31:0] _T_3881 = mem_pc + mem_imm; // @[core.scala 484:74]
  wire  _GEN_145 = _T_3766 ? 1'h0 : 1'h1; // @[core.scala 477:34]
  wire  _T_3890 = io_sw_g_add == 32'h0; // @[core.scala 628:14]
  wire [31:0] _T_3893 = _T_3890 ? 32'h0 : _T_3552__T_3892_data; // @[core.scala 628:8]
  IDModule idm ( // @[core.scala 157:31]
    .io_imem(idm_io_imem),
    .io_inst_bits(idm_io_inst_bits),
    .io_inst_rd(idm_io_inst_rd),
    .io_inst_rs1(idm_io_inst_rs1),
    .io_inst_rs2(idm_io_inst_rs2),
    .io_inst_csr(idm_io_inst_csr)
  );
  CSR csr ( // @[core.scala 182:26]
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
  ALU alu ( // @[core.scala 227:26]
    .io_op1(alu_io_op1),
    .io_op2(alu_io_op2),
    .io_alu_op(alu_io_alu_op),
    .io_out(alu_io_out),
    .io_cmp_out(alu_io_cmp_out)
  );
  assign _T_3552__T_3554_addr = idm_io_inst_rs1;
  assign _T_3552__T_3554_data = _T_3552[_T_3552__T_3554_addr]; // @[core.scala 625:25]
  assign _T_3552__T_3556_addr = idm_io_inst_rs2;
  assign _T_3552__T_3556_data = _T_3552[_T_3552__T_3556_addr]; // @[core.scala 625:25]
  assign _T_3552__T_3892_addr = io_sw_g_add[4:0];
  assign _T_3552__T_3892_data = _T_3552[_T_3552__T_3892_addr]; // @[core.scala 625:25]
  assign _T_3552__T_3895_addr = 5'h0;
  assign _T_3552__T_3895_data = _T_3552[_T_3552__T_3895_addr]; // @[core.scala 625:25]
  assign _T_3552__T_3872_data = _T_3860 ? wb_alu_out : _T_3866;
  assign _T_3552__T_3872_addr = wb_reg_waddr;
  assign _T_3552__T_3872_mask = 1'h1;
  assign _T_3552__T_3872_en = wb_ctrl_rf_wen & _T_3869;
  assign io_imem_add_addr = w_req ? w_addr : pc_cntr; // @[core.scala 504:29 core.scala 506:29]
  assign io_r_imem_dat_req = _T_1782 ? imem_read_sig : _GEN_8; // @[core.scala 124:27 core.scala 129:27 core.scala 134:27]
  assign io_w_imem_dat_req = w_req; // @[core.scala 511:26]
  assign io_w_imem_dat_data = w_data; // @[core.scala 510:26]
  assign io_w_imem_dat_byteenable = 4'hf; // @[core.scala 512:30]
  assign io_dmem_add_addr = _T_3766 ? mem_alu_out : io_sw_w_add; // @[core.scala 99:22 core.scala 336:37 core.scala 343:35]
  assign io_r_dmem_dat_req = _T_3766 & _T_3561; // @[core.scala 339:37 core.scala 348:37]
  assign io_w_dmem_dat_req = _T_3766 ? _T_3767 : 1'h1; // @[core.scala 337:37 core.scala 345:37]
  assign io_w_dmem_dat_data = _GEN_112[31:0]; // @[core.scala 344:37 core.scala 360:40 core.scala 364:40 core.scala 368:40 core.scala 372:40 core.scala 379:40 core.scala 383:40 core.scala 388:32]
  assign io_w_dmem_dat_byteenable = _T_3767 ? _GEN_109 : 4'hf; // @[core.scala 346:37 core.scala 359:46 core.scala 363:46 core.scala 367:46 core.scala 371:46 core.scala 378:46 core.scala 382:46 core.scala 387:38 core.scala 391:37]
  assign io_sw_r_add = pc_cntr; // @[core.scala 499:18]
  assign io_sw_r_dat = id_inst; // @[core.scala 498:18]
  assign io_sw_g_dat = io_sw_halt ? _T_3893 : 32'h0; // @[core.scala 518:21 core.scala 520:21]
  assign io_sw_r_pc = id_pc; // @[core.scala 500:18]
  assign io_sw_r_ex_raddr1 = {{27'd0}, ex_reg_raddr_0}; // @[core.scala 296:25]
  assign io_sw_r_ex_raddr2 = {{27'd0}, ex_reg_raddr_1}; // @[core.scala 297:25]
  assign io_sw_r_ex_rs1 = _T_3644 ? mem_csr_data : _T_3686; // @[core.scala 298:25]
  assign io_sw_r_ex_rs2 = _T_3692 ? mem_csr_data : _T_3734; // @[core.scala 299:25]
  assign io_sw_r_ex_imm = {_T_3636,_T_3635,_T_3633,_T_3632,_T_3609,_T_3620,_T_3629}; // @[core.scala 300:25]
  assign io_sw_r_mem_alu_out = mem_alu_out; // @[core.scala 331:25]
  assign io_sw_r_wb_alu_out = wb_alu_out; // @[core.scala 469:28]
  assign io_sw_r_wb_rf_wdata = _T_3860 ? wb_alu_out : _T_3866; // @[core.scala 471:29]
  assign io_sw_r_wb_rf_waddr = {{27'd0}, wb_reg_waddr}; // @[core.scala 470:29]
  assign io_sw_r_stall_sig = {{31'd0}, stall}; // @[core.scala 189:27]
  assign idm_io_imem = id_inst; // @[core.scala 158:17]
  assign csr_clock = clock;
  assign csr_reset = reset;
  assign csr_io_addr = ex_csr_addr; // @[core.scala 278:25]
  assign csr_io_in = _T_3579 ? _T_3744 : _T_3758; // @[core.scala 280:25]
  assign csr_io_cmd = ex_csr_cmd; // @[core.scala 279:25]
  assign csr_io_rs1_addr = {{27'd0}, ex_inst[19:15]}; // @[core.scala 287:25]
  assign csr_io_legal = ex_ctrl_legal; // @[core.scala 286:25]
  assign csr_io_interrupt_sig = interrupt_sig; // @[core.scala 292:25]
  assign csr_io_pc = ex_pc; // @[core.scala 277:25]
  assign csr_io_pc_invalid = inst_kill_branch | _T_3557; // @[core.scala 289:25]
  assign csr_io_j_check = ex_j_check; // @[core.scala 290:24]
  assign csr_io_b_check = ex_b_check; // @[core.scala 291:24]
  assign csr_io_stall = _T_3568 | io_sw_w_waitrequest_sig; // @[core.scala 288:25]
  assign csr_io_inst = ex_inst; // @[core.scala 281:25]
  assign csr_io_mem_wr = ex_ctrl_mem_wr; // @[core.scala 282:25]
  assign csr_io_mask_type = ex_ctrl_mask_type; // @[core.scala 283:25]
  assign csr_io_alu_op1 = _T_3736 ? ex_reg_rs1_bypass : _T_3740; // @[core.scala 284:25]
  assign csr_io_alu_op2 = _T_3742 ? ex_reg_rs2_bypass : _T_3747; // @[core.scala 285:25]
  assign alu_io_op1 = _T_3736 ? ex_reg_rs1_bypass : _T_3740; // @[core.scala 264:16]
  assign alu_io_op2 = _T_3742 ? ex_reg_rs2_bypass : _T_3747; // @[core.scala 265:16]
  assign alu_io_alu_op = ex_ctrl_alu_func; // @[core.scala 263:19]
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
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    _T_3552[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  if_pc = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  if_npc = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  id_inst = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  id_pc = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  id_npc = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  ex_pc = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  ex_npc = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  ex_inst = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  ex_ctrl_legal = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  ex_ctrl_br_type = _RAND_10[3:0];
  _RAND_11 = {1{`RANDOM}};
  ex_ctrl_alu_op1 = _RAND_11[1:0];
  _RAND_12 = {1{`RANDOM}};
  ex_ctrl_alu_op2 = _RAND_12[1:0];
  _RAND_13 = {1{`RANDOM}};
  ex_ctrl_imm_type = _RAND_13[2:0];
  _RAND_14 = {1{`RANDOM}};
  ex_ctrl_alu_func = _RAND_14[3:0];
  _RAND_15 = {1{`RANDOM}};
  ex_ctrl_wb_sel = _RAND_15[1:0];
  _RAND_16 = {1{`RANDOM}};
  ex_ctrl_rf_wen = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  ex_ctrl_mem_en = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  ex_ctrl_mem_wr = _RAND_18[1:0];
  _RAND_19 = {1{`RANDOM}};
  ex_ctrl_mask_type = _RAND_19[2:0];
  _RAND_20 = {1{`RANDOM}};
  ex_ctrl_csr_cmd = _RAND_20[2:0];
  _RAND_21 = {1{`RANDOM}};
  ex_reg_raddr_0 = _RAND_21[4:0];
  _RAND_22 = {1{`RANDOM}};
  ex_reg_raddr_1 = _RAND_22[4:0];
  _RAND_23 = {1{`RANDOM}};
  ex_reg_waddr = _RAND_23[4:0];
  _RAND_24 = {1{`RANDOM}};
  ex_rs_0 = _RAND_24[31:0];
  _RAND_25 = {1{`RANDOM}};
  ex_rs_1 = _RAND_25[31:0];
  _RAND_26 = {1{`RANDOM}};
  ex_csr_addr = _RAND_26[31:0];
  _RAND_27 = {1{`RANDOM}};
  ex_csr_cmd = _RAND_27[31:0];
  _RAND_28 = {1{`RANDOM}};
  ex_b_check = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  ex_j_check = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  mem_pc = _RAND_30[31:0];
  _RAND_31 = {1{`RANDOM}};
  mem_npc = _RAND_31[31:0];
  _RAND_32 = {1{`RANDOM}};
  mem_ctrl_br_type = _RAND_32[3:0];
  _RAND_33 = {1{`RANDOM}};
  mem_ctrl_wb_sel = _RAND_33[1:0];
  _RAND_34 = {1{`RANDOM}};
  mem_ctrl_rf_wen = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  mem_ctrl_mem_en = _RAND_35[0:0];
  _RAND_36 = {1{`RANDOM}};
  mem_ctrl_mem_wr = _RAND_36[1:0];
  _RAND_37 = {1{`RANDOM}};
  mem_ctrl_mask_type = _RAND_37[2:0];
  _RAND_38 = {1{`RANDOM}};
  mem_ctrl_csr_cmd = _RAND_38[2:0];
  _RAND_39 = {1{`RANDOM}};
  mem_imm = _RAND_39[31:0];
  _RAND_40 = {1{`RANDOM}};
  mem_reg_waddr = _RAND_40[4:0];
  _RAND_41 = {1{`RANDOM}};
  mem_rs_1 = _RAND_41[31:0];
  _RAND_42 = {1{`RANDOM}};
  mem_alu_out = _RAND_42[31:0];
  _RAND_43 = {1{`RANDOM}};
  mem_alu_cmp_out = _RAND_43[0:0];
  _RAND_44 = {1{`RANDOM}};
  mem_csr_data = _RAND_44[31:0];
  _RAND_45 = {1{`RANDOM}};
  wb_npc = _RAND_45[31:0];
  _RAND_46 = {1{`RANDOM}};
  wb_ctrl_wb_sel = _RAND_46[1:0];
  _RAND_47 = {1{`RANDOM}};
  wb_ctrl_rf_wen = _RAND_47[0:0];
  _RAND_48 = {1{`RANDOM}};
  wb_ctrl_mem_en = _RAND_48[0:0];
  _RAND_49 = {1{`RANDOM}};
  wb_ctrl_mem_wr = _RAND_49[1:0];
  _RAND_50 = {1{`RANDOM}};
  wb_ctrl_mask_type = _RAND_50[2:0];
  _RAND_51 = {1{`RANDOM}};
  wb_ctrl_csr_cmd = _RAND_51[2:0];
  _RAND_52 = {1{`RANDOM}};
  wb_reg_waddr = _RAND_52[4:0];
  _RAND_53 = {1{`RANDOM}};
  wb_alu_out = _RAND_53[31:0];
  _RAND_54 = {1{`RANDOM}};
  wb_csr_data = _RAND_54[31:0];
  _RAND_55 = {1{`RANDOM}};
  pc_cntr = _RAND_55[31:0];
  _RAND_56 = {1{`RANDOM}};
  w_req = _RAND_56[0:0];
  _RAND_57 = {1{`RANDOM}};
  w_addr = _RAND_57[31:0];
  _RAND_58 = {1{`RANDOM}};
  w_data = _RAND_58[31:0];
  _RAND_59 = {1{`RANDOM}};
  imem_read_sig = _RAND_59[0:0];
  _RAND_60 = {1{`RANDOM}};
  delay_stall = _RAND_60[2:0];
  _RAND_61 = {1{`RANDOM}};
  valid_imem = _RAND_61[0:0];
  _RAND_62 = {1{`RANDOM}};
  interrupt_sig = _RAND_62[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge ~clock) begin
    if(_T_3552__T_3872_en & _T_3552__T_3872_mask) begin
      _T_3552[_T_3552__T_3872_addr] <= _T_3552__T_3872_data; // @[core.scala 625:25]
    end
  end
  always @(posedge clock) begin
    if (reset) begin
      if_pc <= 32'h0;
    end else if (_T_1782) begin
      if_pc <= pc_cntr;
    end else if (inst_kill) begin
      if_pc <= 32'h0;
    end else if (io_sw_w_waitrequest_sig) begin
      if_pc <= 32'h0;
    end
    if (reset) begin
      if_npc <= 32'h4;
    end else if (_T_1782) begin
      if_npc <= npc;
    end else if (inst_kill) begin
      if_npc <= 32'h4;
    end else if (io_sw_w_waitrequest_sig) begin
      if_npc <= 32'h4;
    end
    if (reset) begin
      id_inst <= 32'h13;
    end else if (_T_1786) begin
      id_inst <= io_r_imem_dat_data;
    end else if (inst_kill) begin
      id_inst <= 32'h13;
    end else if (_T_1787) begin
      id_inst <= 32'h13;
    end
    if (reset) begin
      id_pc <= 32'h0;
    end else if (_T_1786) begin
      id_pc <= if_pc;
    end else if (inst_kill) begin
      id_pc <= 32'h0;
    end
    if (reset) begin
      id_npc <= 32'h4;
    end else if (_T_1786) begin
      id_npc <= if_npc;
    end else if (inst_kill) begin
      id_npc <= 32'h4;
    end
    if (reset) begin
      ex_pc <= 32'h0;
    end else if (_T_1782) begin
      ex_pc <= id_pc;
    end else begin
      ex_pc <= 32'h0;
    end
    if (reset) begin
      ex_npc <= 32'h4;
    end else if (_T_1782) begin
      ex_npc <= id_npc;
    end else begin
      ex_npc <= 32'h4;
    end
    if (reset) begin
      ex_inst <= 32'h13;
    end else if (_T_1782) begin
      ex_inst <= idm_io_inst_bits;
    end else begin
      ex_inst <= 32'h13;
    end
    ex_ctrl_legal <= reset | _GEN_36;
    if (reset) begin
      ex_ctrl_br_type <= 4'h0;
    end else if (_T_1782) begin
      if (_T_1789) begin
        ex_ctrl_br_type <= 4'h0;
      end else if (_T_1791) begin
        ex_ctrl_br_type <= 4'h0;
      end else if (_T_1793) begin
        ex_ctrl_br_type <= 4'h1;
      end else if (_T_1795) begin
        ex_ctrl_br_type <= 4'h2;
      end else if (_T_1797) begin
        ex_ctrl_br_type <= 4'h5;
      end else if (_T_1799) begin
        ex_ctrl_br_type <= 4'h4;
      end else if (_T_1801) begin
        ex_ctrl_br_type <= 4'h8;
      end else if (_T_1803) begin
        ex_ctrl_br_type <= 4'h6;
      end else if (_T_1805) begin
        ex_ctrl_br_type <= 4'h9;
      end else begin
        ex_ctrl_br_type <= {{1'd0}, _T_2072};
      end
    end else begin
      ex_ctrl_br_type <= 4'h0;
    end
    if (reset) begin
      ex_ctrl_alu_op1 <= 2'h1;
    end else if (_T_1782) begin
      if (_T_1789) begin
        ex_ctrl_alu_op1 <= 2'h0;
      end else if (_T_1791) begin
        ex_ctrl_alu_op1 <= 2'h2;
      end else if (_T_1793) begin
        ex_ctrl_alu_op1 <= 2'h2;
      end else begin
        ex_ctrl_alu_op1 <= {{1'd0}, _T_2225};
      end
    end else begin
      ex_ctrl_alu_op1 <= 2'h1;
    end
    if (reset) begin
      ex_ctrl_alu_op2 <= 2'h2;
    end else if (_T_1782) begin
      if (_T_1789) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1791) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1793) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1795) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1797) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1799) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1801) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1803) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1805) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1807) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1809) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1811) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1813) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1815) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1817) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1819) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1821) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1823) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1825) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1827) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1829) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1831) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1833) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1835) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1837) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1839) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1841) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1843) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1845) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1847) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1849) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1851) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1853) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1855) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1857) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1859) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1861) begin
        ex_ctrl_alu_op2 <= 2'h1;
      end else if (_T_1863) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1865) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else if (_T_1867) begin
        ex_ctrl_alu_op2 <= 2'h2;
      end else begin
        ex_ctrl_alu_op2 <= 2'h0;
      end
    end else begin
      ex_ctrl_alu_op2 <= 2'h2;
    end
    if (reset) begin
      ex_ctrl_imm_type <= 3'h0;
    end else if (_T_1782) begin
      if (_T_1789) begin
        ex_ctrl_imm_type <= 3'h3;
      end else if (_T_1791) begin
        ex_ctrl_imm_type <= 3'h3;
      end else if (_T_1793) begin
        ex_ctrl_imm_type <= 3'h4;
      end else if (_T_1795) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1797) begin
        ex_ctrl_imm_type <= 3'h2;
      end else if (_T_1799) begin
        ex_ctrl_imm_type <= 3'h2;
      end else if (_T_1801) begin
        ex_ctrl_imm_type <= 3'h2;
      end else if (_T_1803) begin
        ex_ctrl_imm_type <= 3'h2;
      end else if (_T_1805) begin
        ex_ctrl_imm_type <= 3'h2;
      end else if (_T_1807) begin
        ex_ctrl_imm_type <= 3'h2;
      end else if (_T_1809) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1811) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1813) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1815) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1817) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1819) begin
        ex_ctrl_imm_type <= 3'h1;
      end else if (_T_1821) begin
        ex_ctrl_imm_type <= 3'h1;
      end else if (_T_1823) begin
        ex_ctrl_imm_type <= 3'h1;
      end else if (_T_1825) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1827) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1829) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1831) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1833) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1835) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1837) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1839) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1841) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1843) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1845) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1847) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1849) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1851) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1853) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1855) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1857) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1859) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1861) begin
        ex_ctrl_imm_type <= 3'h0;
      end else if (_T_1863) begin
        ex_ctrl_imm_type <= 3'h5;
      end else if (_T_1865) begin
        ex_ctrl_imm_type <= 3'h5;
      end else if (_T_1867) begin
        ex_ctrl_imm_type <= 3'h5;
      end else begin
        ex_ctrl_imm_type <= 3'h0;
      end
    end else begin
      ex_ctrl_imm_type <= 3'h0;
    end
    if (reset) begin
      ex_ctrl_alu_func <= 4'h0;
    end else if (_T_1782) begin
      if (_T_1789) begin
        ex_ctrl_alu_func <= 4'h9;
      end else if (_T_1791) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1793) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1795) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1797) begin
        ex_ctrl_alu_func <= 4'h2;
      end else if (_T_1799) begin
        ex_ctrl_alu_func <= 4'h3;
      end else if (_T_1801) begin
        ex_ctrl_alu_func <= 4'hc;
      end else if (_T_1803) begin
        ex_ctrl_alu_func <= 4'hd;
      end else if (_T_1805) begin
        ex_ctrl_alu_func <= 4'he;
      end else if (_T_1807) begin
        ex_ctrl_alu_func <= 4'hf;
      end else if (_T_1809) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1811) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1813) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1815) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1817) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1819) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1821) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1823) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1825) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1827) begin
        ex_ctrl_alu_func <= 4'hc;
      end else if (_T_1829) begin
        ex_ctrl_alu_func <= 4'he;
      end else if (_T_1831) begin
        ex_ctrl_alu_func <= 4'h4;
      end else if (_T_1833) begin
        ex_ctrl_alu_func <= 4'h6;
      end else if (_T_1835) begin
        ex_ctrl_alu_func <= 4'h7;
      end else if (_T_1837) begin
        ex_ctrl_alu_func <= 4'h1;
      end else if (_T_1839) begin
        ex_ctrl_alu_func <= 4'h5;
      end else if (_T_1841) begin
        ex_ctrl_alu_func <= 4'hb;
      end else if (_T_1843) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1845) begin
        ex_ctrl_alu_func <= 4'ha;
      end else if (_T_1847) begin
        ex_ctrl_alu_func <= 4'h1;
      end else if (_T_1849) begin
        ex_ctrl_alu_func <= 4'hc;
      end else if (_T_1851) begin
        ex_ctrl_alu_func <= 4'he;
      end else if (_T_1853) begin
        ex_ctrl_alu_func <= 4'h4;
      end else if (_T_1855) begin
        ex_ctrl_alu_func <= 4'h5;
      end else if (_T_1857) begin
        ex_ctrl_alu_func <= 4'hb;
      end else if (_T_1859) begin
        ex_ctrl_alu_func <= 4'h6;
      end else if (_T_1861) begin
        ex_ctrl_alu_func <= 4'h7;
      end else if (_T_1863) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1865) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1867) begin
        ex_ctrl_alu_func <= 4'h0;
      end else if (_T_1869) begin
        ex_ctrl_alu_func <= 4'h8;
      end else if (_T_1871) begin
        ex_ctrl_alu_func <= 4'h8;
      end else if (_T_1873) begin
        ex_ctrl_alu_func <= 4'h8;
      end else begin
        ex_ctrl_alu_func <= 4'h0;
      end
    end else begin
      ex_ctrl_alu_func <= 4'h0;
    end
    if (reset) begin
      ex_ctrl_wb_sel <= 2'h1;
    end else if (_T_1782) begin
      if (_T_1789) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1791) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1793) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1795) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1797) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1799) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1801) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1803) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1805) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1807) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1809) begin
        ex_ctrl_wb_sel <= 2'h2;
      end else if (_T_1811) begin
        ex_ctrl_wb_sel <= 2'h2;
      end else if (_T_1813) begin
        ex_ctrl_wb_sel <= 2'h2;
      end else if (_T_1815) begin
        ex_ctrl_wb_sel <= 2'h2;
      end else if (_T_1817) begin
        ex_ctrl_wb_sel <= 2'h2;
      end else if (_T_1819) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1821) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1823) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1825) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1827) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1829) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1831) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1833) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1835) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1837) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1839) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1841) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1843) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1845) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1847) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1849) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1851) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1853) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1855) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1857) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1859) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1861) begin
        ex_ctrl_wb_sel <= 2'h1;
      end else if (_T_1863) begin
        ex_ctrl_wb_sel <= 2'h3;
      end else if (_T_1865) begin
        ex_ctrl_wb_sel <= 2'h3;
      end else if (_T_1867) begin
        ex_ctrl_wb_sel <= 2'h3;
      end else if (_T_1869) begin
        ex_ctrl_wb_sel <= 2'h3;
      end else if (_T_1871) begin
        ex_ctrl_wb_sel <= 2'h3;
      end else if (_T_1873) begin
        ex_ctrl_wb_sel <= 2'h3;
      end else if (_T_1875) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1877) begin
        ex_ctrl_wb_sel <= 2'h0;
      end else if (_T_1879) begin
        ex_ctrl_wb_sel <= 2'h3;
      end else begin
        ex_ctrl_wb_sel <= 2'h0;
      end
    end else begin
      ex_ctrl_wb_sel <= 2'h1;
    end
    ex_ctrl_rf_wen <= reset | _GEN_29;
    if (reset) begin
      ex_ctrl_mem_en <= 1'h0;
    end else begin
      ex_ctrl_mem_en <= _GEN_28;
    end
    if (reset) begin
      ex_ctrl_mem_wr <= 2'h0;
    end else if (_T_1782) begin
      if (_T_1789) begin
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1791) begin
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1793) begin
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1795) begin
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1797) begin
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1799) begin
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1801) begin
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1803) begin
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1805) begin
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1807) begin
        ex_ctrl_mem_wr <= 2'h0;
      end else if (_T_1809) begin
        ex_ctrl_mem_wr <= 2'h1;
      end else if (_T_1811) begin
        ex_ctrl_mem_wr <= 2'h1;
      end else if (_T_1813) begin
        ex_ctrl_mem_wr <= 2'h1;
      end else if (_T_1815) begin
        ex_ctrl_mem_wr <= 2'h1;
      end else if (_T_1817) begin
        ex_ctrl_mem_wr <= 2'h1;
      end else if (_T_1819) begin
        ex_ctrl_mem_wr <= 2'h2;
      end else if (_T_1821) begin
        ex_ctrl_mem_wr <= 2'h2;
      end else if (_T_1823) begin
        ex_ctrl_mem_wr <= 2'h2;
      end else begin
        ex_ctrl_mem_wr <= 2'h0;
      end
    end else begin
      ex_ctrl_mem_wr <= 2'h0;
    end
    if (reset) begin
      ex_ctrl_mask_type <= 3'h0;
    end else if (_T_1782) begin
      if (_T_1789) begin
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1791) begin
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1793) begin
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1795) begin
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1797) begin
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1799) begin
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1801) begin
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1803) begin
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1805) begin
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1807) begin
        ex_ctrl_mask_type <= 3'h0;
      end else if (_T_1809) begin
        ex_ctrl_mask_type <= 3'h1;
      end else if (_T_1811) begin
        ex_ctrl_mask_type <= 3'h2;
      end else if (_T_1813) begin
        ex_ctrl_mask_type <= 3'h3;
      end else if (_T_1815) begin
        ex_ctrl_mask_type <= 3'h5;
      end else if (_T_1817) begin
        ex_ctrl_mask_type <= 3'h6;
      end else begin
        ex_ctrl_mask_type <= {{1'd0}, _T_3389};
      end
    end else begin
      ex_ctrl_mask_type <= 3'h0;
    end
    if (reset) begin
      ex_ctrl_csr_cmd <= 3'h0;
    end else if (_T_1782) begin
      if (_T_1789) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1791) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1793) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1795) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1797) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1799) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1801) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1803) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1805) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1807) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1809) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1811) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1813) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1815) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1817) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1819) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1821) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1823) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1825) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1827) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1829) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1831) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1833) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1835) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1837) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1839) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1841) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1843) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1845) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1847) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1849) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1851) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1853) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1855) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1857) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1859) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1861) begin
        ex_ctrl_csr_cmd <= 3'h0;
      end else if (_T_1863) begin
        ex_ctrl_csr_cmd <= 3'h1;
      end else if (_T_1865) begin
        ex_ctrl_csr_cmd <= 3'h2;
      end else if (_T_1867) begin
        ex_ctrl_csr_cmd <= 3'h3;
      end else if (_T_1869) begin
        ex_ctrl_csr_cmd <= 3'h1;
      end else if (_T_1871) begin
        ex_ctrl_csr_cmd <= 3'h2;
      end else if (_T_1873) begin
        ex_ctrl_csr_cmd <= 3'h3;
      end else if (_T_1875) begin
        ex_ctrl_csr_cmd <= 3'h4;
      end else if (_T_1877) begin
        ex_ctrl_csr_cmd <= 3'h4;
      end else if (_T_1879) begin
        ex_ctrl_csr_cmd <= 3'h4;
      end else if (_T_1881) begin
        ex_ctrl_csr_cmd <= 3'h4;
      end else begin
        ex_ctrl_csr_cmd <= 3'h0;
      end
    end else begin
      ex_ctrl_csr_cmd <= 3'h0;
    end
    if (reset) begin
      ex_reg_raddr_0 <= 5'h0;
    end else if (_T_1782) begin
      ex_reg_raddr_0 <= idm_io_inst_rs1;
    end else begin
      ex_reg_raddr_0 <= 5'h0;
    end
    if (reset) begin
      ex_reg_raddr_1 <= 5'h0;
    end else if (_T_1782) begin
      ex_reg_raddr_1 <= idm_io_inst_rs2;
    end else begin
      ex_reg_raddr_1 <= 5'h0;
    end
    if (reset) begin
      ex_reg_waddr <= 5'h0;
    end else if (_T_1782) begin
      ex_reg_waddr <= idm_io_inst_rd;
    end else begin
      ex_reg_waddr <= 5'h0;
    end
    if (reset) begin
      ex_rs_0 <= 32'h0;
    end else if (_T_1782) begin
      if (_T_3553) begin
        ex_rs_0 <= 32'h0;
      end else begin
        ex_rs_0 <= _T_3552__T_3554_data;
      end
    end else begin
      ex_rs_0 <= 32'h0;
    end
    if (reset) begin
      ex_rs_1 <= 32'h0;
    end else if (_T_1782) begin
      if (_T_3555) begin
        ex_rs_1 <= 32'h0;
      end else begin
        ex_rs_1 <= _T_3552__T_3556_data;
      end
    end else begin
      ex_rs_1 <= 32'h0;
    end
    if (reset) begin
      ex_csr_addr <= 32'h0;
    end else begin
      ex_csr_addr <= {{20'd0}, _GEN_43};
    end
    if (reset) begin
      ex_csr_cmd <= 32'h0;
    end else begin
      ex_csr_cmd <= {{29'd0}, _GEN_25};
    end
    if (reset) begin
      ex_b_check <= 1'h0;
    end else begin
      ex_b_check <= _GEN_46;
    end
    if (reset) begin
      ex_j_check <= 1'h0;
    end else begin
      ex_j_check <= _GEN_45;
    end
    if (reset) begin
      mem_pc <= 32'h0;
    end else if (_T_3764) begin
      mem_pc <= ex_pc;
    end else if (inst_kill) begin
      mem_pc <= 32'h0;
    end
    if (reset) begin
      mem_npc <= 32'h4;
    end else if (_T_3764) begin
      mem_npc <= ex_npc;
    end else if (inst_kill) begin
      mem_npc <= 32'h4;
    end
    if (reset) begin
      mem_ctrl_br_type <= 4'h0;
    end else if (_T_3764) begin
      mem_ctrl_br_type <= ex_ctrl_br_type;
    end else if (inst_kill) begin
      mem_ctrl_br_type <= 4'h0;
    end
    if (reset) begin
      mem_ctrl_wb_sel <= 2'h1;
    end else if (_T_3764) begin
      mem_ctrl_wb_sel <= ex_ctrl_wb_sel;
    end else if (inst_kill) begin
      mem_ctrl_wb_sel <= 2'h1;
    end
    mem_ctrl_rf_wen <= reset | _GEN_75;
    if (reset) begin
      mem_ctrl_mem_en <= 1'h0;
    end else if (_T_3764) begin
      mem_ctrl_mem_en <= ex_ctrl_mem_en;
    end else if (inst_kill) begin
      mem_ctrl_mem_en <= 1'h0;
    end
    if (reset) begin
      mem_ctrl_mem_wr <= 2'h0;
    end else if (_T_3764) begin
      mem_ctrl_mem_wr <= ex_ctrl_mem_wr;
    end else if (inst_kill) begin
      mem_ctrl_mem_wr <= 2'h0;
    end
    if (reset) begin
      mem_ctrl_mask_type <= 3'h0;
    end else if (_T_3764) begin
      mem_ctrl_mask_type <= ex_ctrl_mask_type;
    end else if (inst_kill) begin
      mem_ctrl_mask_type <= 3'h0;
    end
    if (reset) begin
      mem_ctrl_csr_cmd <= 3'h0;
    end else if (_T_3764) begin
      mem_ctrl_csr_cmd <= ex_ctrl_csr_cmd;
    end else if (inst_kill) begin
      mem_ctrl_csr_cmd <= 3'h0;
    end
    if (reset) begin
      mem_imm <= 32'sh0;
    end else if (_T_3764) begin
      mem_imm <= ex_imm;
    end else if (inst_kill) begin
      mem_imm <= 32'sh0;
    end
    if (reset) begin
      mem_reg_waddr <= 5'h0;
    end else if (_T_3764) begin
      mem_reg_waddr <= ex_reg_waddr;
    end else if (inst_kill) begin
      mem_reg_waddr <= 5'h0;
    end
    if (reset) begin
      mem_rs_1 <= 32'h0;
    end else if (_T_3764) begin
      if (_T_3692) begin
        mem_rs_1 <= mem_csr_data;
      end else if (_T_3697) begin
        mem_rs_1 <= mem_alu_out;
      end else if (_T_3706) begin
        mem_rs_1 <= io_r_dmem_dat_data;
      end else if (_T_3715) begin
        mem_rs_1 <= wb_alu_out;
      end else if (_T_3722) begin
        mem_rs_1 <= wb_alu_out;
      end else if (_T_3729) begin
        mem_rs_1 <= wb_csr_data;
      end else begin
        mem_rs_1 <= ex_rs_1;
      end
    end else if (inst_kill) begin
      mem_rs_1 <= 32'h0;
    end
    if (reset) begin
      mem_alu_out <= 32'h0;
    end else if (_T_3764) begin
      mem_alu_out <= alu_io_out;
    end else if (inst_kill) begin
      mem_alu_out <= 32'h0;
    end
    if (reset) begin
      mem_alu_cmp_out <= 1'h0;
    end else if (_T_3764) begin
      mem_alu_cmp_out <= alu_io_cmp_out;
    end else if (inst_kill) begin
      mem_alu_cmp_out <= 1'h0;
    end
    if (reset) begin
      mem_csr_data <= 32'h0;
    end else if (_T_3764) begin
      mem_csr_data <= csr_io_out;
    end else if (inst_kill) begin
      mem_csr_data <= 32'h0;
    end
    if (reset) begin
      wb_npc <= 32'h4;
    end else begin
      wb_npc <= mem_npc;
    end
    if (reset) begin
      wb_ctrl_wb_sel <= 2'h1;
    end else begin
      wb_ctrl_wb_sel <= mem_ctrl_wb_sel;
    end
    wb_ctrl_rf_wen <= reset | mem_ctrl_rf_wen;
    if (reset) begin
      wb_ctrl_mem_en <= 1'h0;
    end else begin
      wb_ctrl_mem_en <= mem_ctrl_mem_en;
    end
    if (reset) begin
      wb_ctrl_mem_wr <= 2'h0;
    end else begin
      wb_ctrl_mem_wr <= mem_ctrl_mem_wr;
    end
    if (reset) begin
      wb_ctrl_mask_type <= 3'h0;
    end else begin
      wb_ctrl_mask_type <= mem_ctrl_mask_type;
    end
    if (reset) begin
      wb_ctrl_csr_cmd <= 3'h0;
    end else begin
      wb_ctrl_csr_cmd <= mem_ctrl_csr_cmd;
    end
    if (reset) begin
      wb_reg_waddr <= 5'h0;
    end else begin
      wb_reg_waddr <= mem_reg_waddr;
    end
    if (reset) begin
      wb_alu_out <= 32'h0;
    end else begin
      wb_alu_out <= mem_alu_out;
    end
    if (reset) begin
      wb_csr_data <= 32'h0;
    end else begin
      wb_csr_data <= mem_csr_data;
    end
    if (reset) begin
      pc_cntr <= 32'h0;
    end else if (_T_3766) begin
      if (_T_3875) begin
        if (csr_io_expt) begin
          pc_cntr <= csr_io_evec;
        end else if (_T_3790) begin
          pc_cntr <= csr_io_epc;
        end else if (_T_3785) begin
          pc_cntr <= _T_3881;
        end else if (_T_3788) begin
          pc_cntr <= mem_alu_out;
        end else if (_T_3786) begin
          pc_cntr <= mem_alu_out;
        end else begin
          pc_cntr <= npc;
        end
      end
    end else begin
      pc_cntr <= io_sw_w_pc;
    end
    w_req <= reset | _GEN_145;
    if (reset) begin
      w_addr <= 32'h0;
    end else if (!(_T_3766)) begin
      w_addr <= io_sw_w_add;
    end
    if (reset) begin
      w_data <= 32'h0;
    end else if (!(_T_3766)) begin
      w_data <= io_sw_w_dat;
    end
    if (reset) begin
      imem_read_sig <= 1'h0;
    end else begin
      imem_read_sig <= _T_1775;
    end
    if (reset) begin
      delay_stall <= 3'h0;
    end else if (imem_read_sig) begin
      if (_T_1777) begin
        delay_stall <= _T_1779;
      end
    end else begin
      delay_stall <= 3'h0;
    end
    valid_imem <= reset | _GEN_13;
    if (reset) begin
      interrupt_sig <= 1'h0;
    end else begin
      interrupt_sig <= io_sw_w_interrupt_sig;
    end
  end
endmodule
