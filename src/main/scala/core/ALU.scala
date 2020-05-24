// See README.md for license details.
package core

import chisel3._
import chisel3.util._

object ALU {
    def ALU_ADD:    UInt = 0.U(5.W)
    def ALU_SLL:    UInt = 1.U(5.W)
    def ALU_SEQ:    UInt = 2.U(5.W)
    def ALU_SNE:    UInt = 3.U(5.W)
    def ALU_XOR:    UInt = 4.U(5.W)
    def ALU_SRL:    UInt = 5.U(5.W)
    def ALU_OR:     UInt = 6.U(5.W)
    def ALU_AND:    UInt = 7.U(5.W)
    def ALU_SUB:    UInt = 8.U(5.W)
    def ALU_SRA:    UInt = 9.U(5.W)
    def ALU_SLT:    UInt = 10.U(5.W)
    def ALU_SGE:    UInt = 11.U(5.W)
    def ALU_SLTU:   UInt = 12.U(5.W)
    def ALU_SGEU:   UInt = 13.U(5.W)
    def ALU_COPY1:  UInt = 14.U(5.W)
    def ALU_COPY2:  UInt = 15.U(5.W)
    def ALU_X:      UInt = 0.U(5.W) // BitPat("b????")

}

import ALU._

//noinspection ScalaStyle
class ALU extends Module {
    val io = IO {
        new Bundle {
            val op1: UInt = Input(UInt(32.W))
            val op2: UInt = Input(UInt(32.W))
            val alu_op: UInt = Input(UInt(5.W))
            val out: UInt = Output(UInt(32.W))
            val cmp_out = Output(Bool())
        }
    }
    val shamt: UInt = io.op2(4,0).asUInt
    val w_out: UInt = Wire(UInt(32.W))
    val w_cmp: Bool = Wire(Bool())

    w_out := MuxLookup(io.alu_op, io.op2, Seq(
        ALU_ADD     -> (io.op1 + io.op2),
        ALU_SLL     -> (io.op1 << shamt),
        ALU_SEQ     -> (io.op1 === io.op2),
        ALU_SNE     -> (io.op1 =/= io.op2),
        ALU_XOR     -> (io.op1 ^ io.op2),
        ALU_SRL     -> (io.op1 >> shamt),
        ALU_OR      -> (io.op1 | io.op2),
        ALU_AND     -> (io.op1 & io.op2),
        ALU_SUB     -> (io.op1 - io.op2),
        ALU_SRA     -> (io.op1.asSInt >> shamt).asUInt,
        ALU_SLT     -> (io.op1.asSInt < io.op2.asSInt),
        ALU_SGE     -> (io.op1.asSInt >= io.op2.asSInt),
        ALU_SLTU    -> (io.op1 < io.op2),
        ALU_SGEU    -> (io.op1 >= io.op2),
        ALU_COPY1   -> io.op1,
        ALU_COPY2   -> io.op2)).asUInt()

    w_cmp := w_out(0)

    io.out := w_out
    io.cmp_out := w_cmp


}