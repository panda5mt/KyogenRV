// See README.md for license details.
package core

import chisel3._
import chisel3.util._
import _root_.core.ALU._
import _root_.core.Instructions._
import _root_.core.MemoryOpConstants._
import _root_.core.ScalarOpConstants._

import scala.collection.mutable.ArrayBuffer
import scala.language.implicitConversions

//noinspection ScalaStyle
object util {
    implicit def uintToBitPat(x: UInt): BitPat = BitPat(x)
}

import util._

// ID-Stage

class ElementOfInstruction extends Bundle{
    val bits: UInt  = UInt(32.W)
    //val op        = UInt(7.W)     // opcode
    //val fct3      = UInt(3.W)     // funct3
    val rd: UInt    = UInt(5.W)     // rd or imm[4:0]
    val rs1: UInt   = UInt(5.W)     // rs
    val rs2: UInt   = UInt(5.W)     // or shamt
    //val imm115    = UInt(7.W)     //
    //val imm: UInt   = UInt(12.W)    // imm[11:0]
}

class CDecoder(x: UInt){

    def inst(
        bits: UInt,
        //op:     UInt = x(6, 0),
        //fct3:   UInt = x(14, 12),
        rd: UInt    = x(11, 7),
        rs1: UInt   = x(19, 15),
        rs2: UInt   = x(24, 20)
        //imm115: UInt = x(31, 25),
        //imm: UInt   = x(31, 20)
        ): ElementOfInstruction =
    {
        val res = Wire(new ElementOfInstruction)
        res.bits    := bits
        //res.op    := op
        //res.fct3  := fct3
        res.rd      := rd
        res.rs1     := rs1
        res.rs2     := rs2
        //res.imm115  := imm115
        //res.imm     := imm
        res // return (res)
    }
}

class IDModule extends Module{
    val io = IO (
        new Bundle {
            val imem: UInt = Input(UInt(32.W))
            val inst: ElementOfInstruction = Output(new ElementOfInstruction)
        })
    io.inst := new CDecoder(x = io.imem).inst(bits = io.imem)
}


// See also instructions.scala and constant.scala
class IDecode {
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

    AUIPC   ->  List(Y, BR_N  , OP1_PC , OP2_IMU , ALU_ADD ,  WB_ALU, REN_1, MEN_0, M_X ,  MT_X /*,CSR.N*/),
    LUI     ->  List(Y, BR_N  , OP1_X  , OP2_IMU , ALU_COPY2, WB_ALU, REN_1, MEN_0, M_X ,  MT_X /*,CSR.N*/),
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

    JAL     ->  List(Y, BR_J  , OP1_PC , OP2_IMJ , ALU_ADD ,  WB_PC4, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    JALR    ->  List(Y, BR_JR , OP1_RS1, OP2_IMI , ALU_ADD ,  WB_PC4, REN_1, MEN_0, M_X  , MT_X /*,CSR.N*/),
    BEQ     ->  List(Y, BR_EQ , OP1_PC , OP2_IMB , ALU_ADD ,  WB_ALU, REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    BNE     ->  List(Y, BR_NE , OP1_PC , OP2_IMB , ALU_ADD ,  WB_ALU, REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    BGE     ->  List(Y, BR_GE , OP1_PC , OP2_IMB , ALU_ADD ,  WB_ALU, REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    BGEU    ->  List(Y, BR_GEU, OP1_PC , OP2_IMB , ALU_ADD ,  WB_ALU, REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    BLT     ->  List(Y, BR_LT , OP1_PC , OP2_IMB , ALU_ADD ,  WB_ALU, REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    BLTU    ->  List(Y, BR_LTU, OP1_PC , OP2_IMB , ALU_ADD ,  WB_ALU, REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),

    CSRRWI  ->  List(Y, BR_N  , OP1_X  , OP2_IMZ , ALU_COPY1, WB_CSR, REN_1, MEN_0, M_X ,  MT_X /*,CSR.W*/),
    CSRRSI  ->  List(Y, BR_N  , OP1_X  , OP2_IMZ , ALU_COPY1, WB_CSR, REN_1, MEN_0, M_X ,  MT_X /*,CSR.S*/),
    CSRRCI  ->  List(Y, BR_N  , OP1_X  , OP2_IMZ , ALU_COPY1, WB_CSR, REN_1, MEN_0, M_X ,  MT_X /*,CSR.C*/),
    CSRRW   ->  List(Y, BR_N  , OP1_RS1, OP2_X   , ALU_COPY1, WB_CSR, REN_1, MEN_0, M_X ,  MT_X /*,CSR.W*/),
    CSRRS   ->  List(Y, BR_N  , OP1_RS1, OP2_X   , ALU_COPY1, WB_CSR, REN_1, MEN_0, M_X ,  MT_X /*,CSR.S*/),
    CSRRC   ->  List(Y, BR_N  , OP1_RS1, OP2_X   , ALU_COPY1, WB_CSR, REN_1, MEN_0, M_X ,  MT_X /*,CSR.C*/),

    ECALL   ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.I*/),
    //MRET    ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.I*/),
    //DRET    ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.I*/),
    EBREAK  ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.I*/),
    //WFI     ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    // implemented as a NOP
    FENCE_I ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_0, M_X  , MT_X /*,CSR.N*/),
    FENCE   ->  List(Y, BR_N  , OP1_X  , OP2_X  ,  ALU_X    , WB_X  , REN_0, MEN_1, M_X  , MT_X /*,CSR.N*/)
    // we are already sequentially consistent, so no need to honor the fence instruction
    )
}


// Internal Control Signal Bundle(ALU ctrl, memory ctrl, etc)
// from Rocket chip Decode.scala
class IntCtrlSigs extends Bundle {
    val legal:      Bool = Bool()
    val br_type:    UInt = Bits(BR_X.getWidth.W)

    val alu_op1:    UInt = Bits(OP1_X.getWidth.W)
    val alu_op2:    UInt = Bits(OP2_X.getWidth.W)
    val alu_func:   UInt = Bits(ALU_X.getWidth.W)
    
    val wb_sel:     UInt = Bits(WB_X.getWidth.W)
    val rf_wen:     Bool = Bool()
    val mem_en:     Bool = Bool()

    val mem_wr:     UInt = Bits(M_SZ)
    val mask_type:  UInt = Bits(MT_SZ)

    def default: List[BitPat] = {
        List(X, BR_X, OP1_X, OP2_X, ALU_X, WB_X, REN_X, MEN_X, M_X, MT_X /*CSR.N*/)
    }

    //noinspection ScalaStyle
    def decode(
        inst: UInt,
        table: Iterable[(BitPat, List[BitPat])]
        ): IntCtrlSigs =
    {
        val decoder: Seq[UInt] = {
            DecodeLogic(inst, default, mappingIn = table)
        }

        val sigs = {
            Seq(legal, br_type, alu_op1, alu_op2, alu_func, wb_sel, rf_wen, mem_en, mem_wr, mask_type)
        }
        
        (sigs zip decoder).foreach({case (s,d) => s := d })

        this // return (this)
    }
}

object DecodeLogic {
    def apply(addr: UInt, default: Seq[BitPat], mappingIn: Iterable[(BitPat, Seq[BitPat])]): Seq[UInt] = {
        val mapping = ArrayBuffer.fill(default.size)(ArrayBuffer[(BitPat, BitPat)]())

        for ((key: BitPat, values: Seq[BitPat]) <- mappingIn)
            (values zipWithIndex)
              .foreach { case (value, i) => mapping(i) += key.->(value) }

        for ((thisDefault, thisMapping) <- default zip mapping)
            yield apply(addr, thisDefault, thisMapping)
    }
    
    def apply(addr: UInt, default: BitPat, mapping: Iterable[(BitPat, BitPat)]): UInt = {
        MuxCase(default.value.U, mapping.map{
            case (instBitPat, ctrlSigBitPat) => (addr === instBitPat) -> ctrlSigBitPat.value.U }.toSeq)
    }
}
//noinspection ScalaStyle
object ImmGen {
    def apply(sel: UInt, inst: UInt): SInt = {
        val sign = Mux(sel === IMM_Z, 0.S, inst(31).asSInt)
        val b30_20 = Mux(sel === IMM_U, inst(30,20).asSInt, sign)
        val b19_12 = Mux(sel =/= IMM_U && sel =/= IMM_J, sign, inst(19,12).asSInt)
        val b11 = Mux(sel === IMM_U || sel === IMM_Z, 0.S,
            Mux(sel === IMM_J, inst(20).asSInt,
                Mux(sel === IMM_B, inst(7).asSInt, sign)))
        val b10_5 = Mux(sel === IMM_U || sel === IMM_Z, 0.U, inst(30,25))
        val b4_1 = Mux(sel === IMM_U, 0.U,
            Mux(sel === IMM_S || sel === IMM_B, inst(11,8),
                Mux(sel === IMM_Z, inst(19,16), inst(24,21))))
        val b0 = Mux(sel === IMM_S, inst(7),
            Mux(sel === IMM_I, inst(20),
                Mux(sel === IMM_Z, inst(15), 0.U)))

        Cat(sign, b30_20, b19_12, b11, b10_5, b4_1, b0).asSInt
    }
}
