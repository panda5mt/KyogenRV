// See README.md for license details.
package core

import chisel3._
import chisel3.util._

object ALU {
    // ALU Operation Signal
    def ALU_ADD:    UInt = 1.U(4.W)
    def ALU_SUB:    UInt = 2.U(4.W)
    def ALU_SLL:    UInt = 3.U(4.W)
    def ALU_SRL:    UInt = 4.U(4.W)
    def ALU_SRA:    UInt = 5.U(4.W)
    def ALU_AND:    UInt = 6.U(4.W)
    def ALU_OR:     UInt = 7.U(4.W)
    def ALU_XOR:    UInt = 8.U(4.W)
    def ALU_SLT:    UInt = 9.U(4.W)
    def ALU_SLTU:   UInt = 10.U(4.W)
    def ALU_COPY1:  UInt = 11.U(4.W)
    def ALU_COPY2:  UInt = 12.U(4.W)
    def ALU_X:      UInt = 0.U(4.W) // BitPat("b????")
}

import ALU._

//noinspection ScalaStyle
class ALU extends Module {
    val io = IO {
        new Bundle {
            val op1: UInt = Input(UInt(32.W))
            val op2: UInt = Input(UInt(32.W))
            val alu_op: UInt = Input(UInt(4.W))
            val out: UInt = Output(UInt(32.W))
        }
    }
    val shamt: UInt = io.op2(4,0).asUInt
    val w_out: UInt = Wire(UInt(32.W))

    w_out := MuxLookup(io.alu_op, io.op2, Seq(
        ALU_ADD     -> (io.op1 + io.op2),
        ALU_SUB     -> (io.op1 - io.op2),
        ALU_SRA     -> (io.op1.asSInt >> shamt).asUInt,
        ALU_SRL     -> (io.op1 >> shamt),
        ALU_SLL     -> (io.op1 << shamt),
        ALU_SLT     -> (io.op1.asSInt < io.op2.asSInt),
        ALU_SLTU    -> (io.op1 < io.op2),
        ALU_AND     -> (io.op1 & io.op2),
        ALU_OR      -> (io.op1 | io.op2),
        ALU_XOR     -> (io.op1 ^ io.op2),
        ALU_COPY1   -> io.op1,
        ALU_COPY2   -> io.op2))


    
    io.out := w_out
}