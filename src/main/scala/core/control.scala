package core

import chisel3._
import chisel3.util._

//import chisel3.util.ImplicitConversions._
import scala.collection.mutable.ArrayBuffer

import Instructions._
import ScalarOpConstants._
import MemoryOpConstants._

object util {
    implicit def uintToBitPat(x: UInt):BitPat = BitPat(x)
}

import util._

// ID-Stage

class ElementOfInstruction extends Bundle{
    val bits    = UInt(32.W)
    //val op      = UInt(7.W)         // opcode
    //val fct3    = UInt(3.W)         // funct3
    val rd      = UInt(5.W)         // rd or imm[4:0] 
    val rs1     = UInt(5.W)         // rs
    val rs2     = UInt(5.W)         // or shamt 
    //val imm115  = UInt(7.W)         //  
    //val imm     = UInt(12.W)        // imm[11:0]
}

class CDecoder(x: UInt){

    def inst(
        bits:   UInt,
        //op:     UInt = x(6, 0),
        //fct3:   UInt = x(14, 12),
        rd:     UInt = x(11, 7),
        rs1:    UInt = x(19, 15),
        rs2:    UInt = x(24, 20)
        //imm115: UInt = x(31, 25),
        //imm:    UInt = x(31, 20)
        ) = 
    {
        val res = Wire(new ElementOfInstruction)
        res.bits    := bits
        //res.op      := op
        //res.fct3    := fct3
        res.rd      := rd
        res.rs1     := rs1
        res.rs2     := rs2
        //res.imm115  := imm115
        //res.imm     := imm
        res // return (res)
    }
}

class IDModule extends Module{
    val io = IO(new Bundle {
        val imem = Input(UInt(32.W))
        val inst = Output(new ElementOfInstruction)
  })
  io.inst := new CDecoder(io.imem).inst(io.imem)
}

// abstract trait DecodeConstants {
//     val table: Array[(BitPat, List[BitPat])]
// }

// See also instructions.scala and constant.scala
class IDecode /*(implicit val p: Parameters) extends DecodeConstants*/ {
    val table: Array[(BitPat, List[BitPat])] = Array(
                /* 1bit | 4bit   |  2bit  |   2bit  |  4bit   |  2bit  | 1bit | 1bit | 1bit | 3bit |  3bit */
                /* val  |  BR    |  op1   |   op2   |  ALU    |  wb    | rf   | mem  | mem  | mask |  csr  */
                /* inst | type   |  sel   |   sel   |  fcn    |  sel   | wen  |  en  |  wr  | type |  cmd  */
    LW      ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_ADD ,  WB_MEM, REN_1, MEN_1, M_XRD, MT_W /*,CSR.N*/),
    LB      ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_ADD ,  WB_MEM, REN_1, MEN_1, M_XRD, MT_B /*,CSR.N*/),
    LBU     ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_ADD ,  WB_MEM, REN_1, MEN_1, M_XRD, MT_BU /*,CSR.N*/),
    LH      ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_ADD ,  WB_MEM, REN_1, MEN_1, M_XRD, MT_H /*,CSR.N*/),
    LHU     ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_ADD ,  WB_MEM, REN_1, MEN_1, M_XRD, MT_HU /*,CSR.N*/),
    SW      ->  List(Y, BR_N  , OP1_RS1, OP2_IMS , ALU_ADD ,  WB_X  , REN_0, MEN_1, M_XWR, MT_W /*,CSR.N*/),
    SB      ->  List(Y, BR_N  , OP1_RS1, OP2_IMS , ALU_ADD ,  WB_X  , REN_0, MEN_1, M_XWR, MT_B /*,CSR.N*/),
    SH      ->  List(Y, BR_N  , OP1_RS1, OP2_IMS , ALU_ADD ,  WB_X  , REN_0, MEN_1, M_XWR, MT_H /*,CSR.N*/),

    AUIPC   ->  List(Y, BR_N  , OP1_IMU, OP2_PC  , ALU_ADD ,  WB_ALU, REN_1, MEN_0, M_X ,  MT_X /*,CSR.N*/),
    LUI     ->  List(Y, BR_N  , OP1_IMU, OP2_X   , ALU_COPY1, WB_ALU, REN_1, MEN_0, M_X ,  MT_X /*,CSR.N*/),
    ADDI    ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_ADD ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    ANDI    ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_AND ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    ORI     ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_OR  ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    XORI    ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_XOR ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    SLTI    ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_SLT ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    SLTIU   ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_SLTU,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    SLLI    ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_SLL ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    SRAI    ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_SRA ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    SRLI    ->  List(Y, BR_N  , OP1_RS1, OP2_IMI , ALU_SRL ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),

    SLL     ->  List(Y, BR_N  , OP1_RS1, OP2_RS2 , ALU_SLL ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    ADD     ->  List(Y, BR_N  , OP1_RS1, OP2_RS2 , ALU_ADD ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    SUB     ->  List(Y, BR_N  , OP1_RS1, OP2_RS2 , ALU_SUB ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    SLT     ->  List(Y, BR_N  , OP1_RS1, OP2_RS2 , ALU_SLT ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    SLTU    ->  List(Y, BR_N  , OP1_RS1, OP2_RS2 , ALU_SLTU,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    AND     ->  List(Y, BR_N  , OP1_RS1, OP2_RS2 , ALU_AND ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    OR      ->  List(Y, BR_N  , OP1_RS1, OP2_RS2 , ALU_OR  ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    XOR     ->  List(Y, BR_N  , OP1_RS1, OP2_RS2 , ALU_XOR ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    SRA     ->  List(Y, BR_N  , OP1_RS1, OP2_RS2 , ALU_SRA ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    SRL     ->  List(Y, BR_N  , OP1_RS1, OP2_RS2 , ALU_SRL ,  WB_ALU, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),

    JAL     ->  List(Y, BR_J  , OP1_X  , OP2_X   , ALU_X   ,  WB_PC4, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    JALR    ->  List(Y, BR_JR , OP1_RS1, OP2_IMI , ALU_X   ,  WB_PC4, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    BEQ     ->  List(Y, BR_EQ , OP1_X  , OP2_X   , ALU_X   ,  WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    BNE     ->  List(Y, BR_NE , OP1_X  , OP2_X   , ALU_X   ,  WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    BGE     ->  List(Y, BR_GE , OP1_X  , OP2_X   , ALU_X   ,  WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    BGEU    ->  List(Y, BR_GEU, OP1_X  , OP2_X   , ALU_X   ,  WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    BLT     ->  List(Y, BR_LT , OP1_X  , OP2_X   , ALU_X   ,  WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    BLTU    ->  List(Y, BR_LTU, OP1_X  , OP2_X   , ALU_X   ,  WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),

    CSRRWI  ->  List(Y, BR_N  , OP1_IMZ, OP2_X   , ALU_COPY1, WB_CSR, REN_1, MEN_0, M_X ,  MT_X /*,CSR.W*/),
    CSRRSI  ->  List(Y, BR_N  , OP1_IMZ, OP2_X   , ALU_COPY1, WB_CSR, REN_1, MEN_0, M_X ,  MT_X /*,CSR.S*/),
    CSRRCI  ->  List(Y, BR_N  , OP1_IMZ, OP2_X   , ALU_COPY1, WB_CSR, REN_1, MEN_0, M_X ,  MT_X /*,CSR.C*/),
    CSRRW   ->  List(Y, BR_N  , OP1_RS1, OP2_X   , ALU_COPY1, WB_CSR, REN_1, MEN_0, M_X ,  MT_X /*,CSR.W*/),
    CSRRS   ->  List(Y, BR_N  , OP1_RS1, OP2_X   , ALU_COPY1, WB_CSR, REN_1, MEN_0, M_X ,  MT_X /*,CSR.S*/),
    CSRRC   ->  List(Y, BR_N  , OP1_RS1, OP2_X   , ALU_COPY1, WB_CSR, REN_1, MEN_0, M_X ,  MT_X /*,CSR.C*/),

    ECALL   ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.I*/),
    //MRET    ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.I*/),
    //DRET    ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.I*/),
    EBREAK  ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.I*/),
    //WFI     ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/) // implemented as a NOP

    FENCE_I ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    FENCE   ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_1, M_X  , MT_X /*,CSR.N*/)
        // we are already sequentially consistent, so no need to honor the fence instruction
    )
}


// Internal Control Signal Bundle(ALU ctrl, memory ctrl, etc)
// from Rocket chip Decode.scala
class IntCtrlSigs extends Bundle {
    val legal       = Bool()
    val br_type     = Bits(BR_X.getWidth.W)

    val alu_op1     = Bits(OP1_X.getWidth.W)
    val alu_op2     = Bits(OP2_X.getWidth.W)
    val alu_func    = Bits(ALU_X.getWidth.W)
    
    val wb_sel      = Bits(WB_X.getWidth.W)
    val rf_wen      = Bool()//Bits(REN_X.getWidth.W)
    val mem_en      = Bool()//Bits(MEN_X.getWidth.W)

    val mem_wr      = Bits(M_SZ)
    val mask_type   = Bits(MT_SZ)

    def default: List[BitPat] = 
        List(X, BR_X  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_X, MEN_X, M_X  , MT_X/*CSR.N*/)

    def decode(
        inst:  UInt,
        table: Iterable[(BitPat, List[BitPat])]
        ) = 
    {
        val decoder = DecodeLogic(inst, default, mappingIn = table)

        val sigs = Seq(legal, br_type, alu_op1, alu_op2, alu_func, wb_sel, rf_wen, mem_en, mem_wr, mask_type)
        sigs zip decoder map {case (s,d) => (s := d) }

        this // return (this)
    }
}


object DecodeLogic {
    def apply(addr: UInt, default: Seq[BitPat], mappingIn: Iterable[(BitPat, Seq[BitPat])]): Seq[UInt] = {
        val mapping = ArrayBuffer.fill(default.size)(ArrayBuffer[(BitPat, BitPat)]())

        // Array(BEQ-> List(Y, ...,A2_RS2, A1_RS1, ...), JALR-> List(N, ...,A2_IMM, A1_RS1, ...), ...) の並びから、
        // ArrayBuffer(ArrayBuffer(BEQ -> Y, JALR -> N, ...),
        //             ...
        //             ArrayBuffer(BEQ -> A2_RS2, JALR -> A2_IMM, ...),
        //             ArrayBuffer(BEQ -> A1_RS1, JALR -> A1_RS1, ...), ...)
        // の形に並び替え
        for ((key, values) <- mappingIn)
        for ((value, i) <- values zipWithIndex)
        mapping(i) += key -> value

        for ((thisDefault, thisMapping) <- default zip mapping)
        yield apply(addr, thisDefault, thisMapping)
    }

    /** 1種類の制御信号を、機械語から生成する。
    * @param addr  機械語
    * @param mappinIn 命令のビットパターンと、対応する制御信号のシーケンス
    */
    def apply(addr: UInt, default: BitPat, mapping: Iterable[(BitPat, BitPat)]): UInt = {
    // MuxCase(default.value, Seq(
    //   addr === BEQ -> A2_RS2,
    //   addr === JALR -> A2_IMM, ...))
    // の形に変形
    MuxCase(default.value.U,
    mapping.map{ case (instBitPat, ctrlSigBitPat) => (addr === instBitPat) -> ctrlSigBitPat.value.U }.toSeq)
    }
}