// See README.md for license details.
package core

import chisel3._
import chisel3.util._
import chisel3.Bool

object ALU {
    // ALU Operation Signal
    def ALU_ADD     = 1.U(4.W)
    def ALU_SUB     = 2.U(4.W)
    def ALU_SLL     = 3.U(4.W)
    def ALU_SRL     = 4.U(4.W)
    def ALU_SRA     = 5.U(4.W)
    def ALU_AND     = 6.U(4.W)
    def ALU_OR      = 7.U(4.W)
    def ALU_XOR     = 8.U(4.W)
    def ALU_SLT     = 9.U(4.W)
    def ALU_SLTU    = 10.U(4.W)
    def ALU_COPY1   = 11.U(4.W)
    def ALU_X       = 0.U(4.W) // BitPat("b????")
}

import ALU._

class ALU extends Module {
    val io = IO (new Bundle
    {
        val op1     = Input(UInt(32.W))
        val op2     = Input(UInt(32.W))
        val alu_op  = Input(UInt(4.W))
        val out     = Output(UInt(32.W))
    })
    val shamt = io.op2(4,0).asUInt
    val w_out = Wire(UInt(32.W))

    w_out := MuxLookup(io.alu_op, io.op2, Seq(
        ALU_ADD  -> (io.op1 + io.op2),
        ALU_SUB  -> (io.op1 - io.op2),
        ALU_SRA  -> (io.op1.asSInt >> shamt).asUInt,
        ALU_SRL  -> (io.op1 >> shamt),
        ALU_SLL  -> (io.op1 << shamt),
        ALU_SLT  -> (io.op1.asSInt < io.op2.asSInt),
        ALU_SLTU -> (io.op1 < io.op2),
        ALU_AND  -> (io.op1 & io.op2),
        ALU_OR   -> (io.op1 | io.op2),
        ALU_XOR  -> (io.op1 ^ io.op2),
        ALU_COPY1 -> io.op1))
    
    io.out := w_out
}