package core

import chisel3._
import chisel3.util._
import chisel3.Bool
import Instructions._
// ID-Stage
class ElementOfInstruction extends Bundle{
    //val inst    = UInt(32.W)
    val op      = UInt(7.W)         // opcode
    val fct3    = UInt(3.W)         // funct3
    val rd      = UInt(5.W)         // rd or imm[4:0] 
    val rs1     = UInt(5.W)         // rs
    val rs2     = UInt(5.W)         // or shamt 
    val imm115  = UInt(7.W)         //  
    val imm     = UInt(12.W)        // imm[11:0]
}

class CDecoder(x: UInt){

    def inst(
        op:     UInt = x(6, 0),
        fct3:   UInt = x(14, 12),
        rd:     UInt = x(11, 7),
        rs1:    UInt = x(19, 15),
        rs2:    UInt = x(24, 20),
        imm115: UInt = x(31, 25),
        imm:    UInt = x(31, 20)) = 
    {
        val res = Wire(new ElementOfInstruction)
        res.op      := op
        res.fct3    := fct3
        res.rd      := rd
        res.rs1     := rs1
        res.rs2     := rs2
        res.imm115  := imm115
        res.imm     := imm
        res // return (res)
    }

}

class IDModule extends Module{
    val io = IO(new Bundle {
        val inst = Input(UInt(32.W))
        val dec = Output(new ElementOfInstruction)
  })
  io.dec := new CDecoder(io.inst).inst(io.inst)
}

// Internal Control Signal Bundle(ALU ctrl, memory ctrl, etc)
class InstCodeToCtrlSig extends Bundle {
    val alu_func    = UInt(4.W)
    val alu_in1     = UInt(64.W)
    val alu_in2     = UInt(64.W)

}
