// See README.md for license details.
package core

import bus.{HostIf, TestIf}
import chisel3._
import chisel3.util._
import _root_.core.ScalarOpConstants._
import mem.IMem

import scala.io.{BufferedSource, Source}

/// Test modules /////
import chisel3.iotesters
import chisel3.iotesters.PeekPokeTester
//////////////////////

object Test extends App {
    iotesters.Driver.execute(args, () => new CpuBus()){
        c => new PeekPokeTester(c) {
            // read from binary file
            val s: BufferedSource = Source.fromFile("src/sw/test.hex")
            var buffs :Array[String] = _
            try {
                buffs = s.getLines.toArray
            } finally {
                s.close()
            }
            step(1)
            poke(c.io.sw.halt, true.B)
            step(1)

            for (addr <- 0 until buffs.length * 4 by 4){
                val mem_val = buffs(addr/4).replace(" ", "")
                val mem = Integer.parseUnsignedInt(mem_val,16)

                poke(c.io.sw.w_ad, addr)
                poke(c.io.sw.w_da, mem)
                println(f"write: addr = 0x$addr%08X, data = 0x$mem%08X")
                step(1)
            }

            step(1)
            println("---------------------------------------------------------")
            poke(c.io.sw.w_pc, 0)   // restart pc address
            step(1)                 // fetch pc
            poke(c.io.sw.halt, false.B)
            step(1)
            step(1)

            //for (lp <- memarray.indices by 1){
            for (_ <- 0 until 100 by 1){
                val a = peek(c.io.sw.addr)
                val d = peek(c.io.sw.data)

                println(f"read : addr = 0x$a%08X, data = 0x$d%08X") //peek(c.io.sw.data)
                step(1)
            }

            step(1)
            println("---------------------------------------------------------")
            poke(c.io.sw.halt, true.B)
            step(1)
            step(1)
            for (lp <- 0 to 31 by 1){

                poke(c.io.sw.g_ad, lp)
                step(1)
                val d = peek(c.io.sw.g_da)

                println(f"read : x$lp%2d = 0x$d%08X") //peek(c.io.sw.data)
                step(1)
            }
        }
    }
}



//noinspection ScalaStyle
class Cpu extends Module {
    val io: HostIf = IO(new HostIf)
    
    // initialization
    val r_addr: UInt = RegInit(0.U(32.W))    // pc
    val r_data: UInt = RegInit(0.U(32.W))
    val r_req:  Bool = RegInit(true.B)       // fetch signal
    val r_rw:   Bool = RegInit(false.B)
    val r_ack:  Bool = RegInit(false.B)

    val w_req:  Bool = RegInit(true.B)
    val w_ack:  Bool = RegInit(false.B)
    val w_addr: UInt = RegInit(0.U(32.W))
    val w_data: UInt = RegInit(0.U(32.W))
    
    //val g_addr  = RegInit(0.U(32.W))
    val rv32i_reg: Vec[UInt] = {
        RegInit(VecInit(Seq.fill(32)(0.U(32.W))))
    } // x0 - x31:All zero initialized

    val next_inst_is_valid: Bool = RegInit(true.B) //

    // ID Module instance
    val idm: IDModule = Module(new IDModule)

    // instruction decode
    idm.io.imem := Mux(next_inst_is_valid, r_data, 0.U(32.W)) // if (command.type == branch) next.command = invalid
    val id_ctrl: IntCtrlSigs = Wire(new IntCtrlSigs).decode(idm.io.inst.bits,(new IDecode).table)

    // ALU OP1 selector
    val ex_op1: UInt = MuxLookup(id_ctrl.alu_op1, 0.U(32.W),
        Seq(
            OP1_RS1 -> rv32i_reg(idm.io.inst.rs1),
            OP1_IMU -> (idm.io.inst bits(31, 12)),   // immediate, U-type(insts_code[31:12])
            OP1_IMZ -> 0.U(32.W),   // zero-extended rs1 field, CSRI insts
            OP1_X   -> 0.U(32.W)
        )
    )
    // ALU OP2 selector
    val ex_op2: UInt = MuxLookup(id_ctrl.alu_op2, 0.U(32.W),
        Seq(
            OP2_RS2 -> rv32i_reg(idm.io.inst.rs2),
            OP2_IMI -> (idm.io.inst bits(31, 20)),
            OP2_IMS -> Cat(idm.io.inst bits(31, 25), idm.io.inst bits(11, 7)),    // immediate, S-type
            OP2_PC  -> r_addr,  //0.U(32.W),
            OP2_X   -> 0.U(32.W)
        )
    )

    val alu: ALU    = Module(new ALU)
    alu.io.alu_op   := id_ctrl.alu_func
    alu.io.op1      := ex_op1
    alu.io.op2      := ex_op2

     // register write
    val rf_wen: Bool = id_ctrl.rf_wen     // register write enable flag
    val rd_addr:UInt = idm.io.inst.rd    // destination register
    val rd_val: UInt = MuxLookup(id_ctrl.wb_sel, 0.U(32.W),
        Seq(
            WB_ALU -> alu.io.out,
            WB_PC4 -> r_addr,           //r_addr = pc + 4
            WB_CSR -> 0.U(32.W),
            WB_MEM -> 0.U(32.W),
            WB_X   -> 0.U(32.W)
        )
    )

    when (rf_wen === REN_1){ // register write enable?
        when (rd_addr =/= 0.U && rd_addr < 32.U){
            rv32i_reg(rd_addr) := rd_val
        }.otherwise { // rd_addr = 0
            rv32i_reg(0.U) := 0.U(32.W)
        }
    }

    // Branch type selector
    val imm_j:  UInt = Cat(idm.io.inst bits 31, idm.io.inst bits(19, 12), idm.io.inst bits 20, idm.io.inst bits(30, 21))
    val rel_pc: UInt = Mux(idm.io.inst bits 31, (imm_j - 0xfffff.U(32.W) - 1.U) * 2.U, imm_j * 2.U) // two's complement
    val pc_incl:UInt = MuxLookup(key = id_ctrl.br_type, default = 0.U(32.W),
        mapping = Seq(
            BR_N -> (r_addr + 4.U(32.W)), // Next
            BR_NE -> 0.U(32.W), // Branch on NotEqual
            BR_EQ -> 0.U(32.W), // Branch on Equal
            BR_GE -> 0.U(32.W), // Branch on Greater/Equal
            BR_GEU -> 0.U(32.W), // Branch on Greater/Equal Unsigned
            BR_LT -> 0.U(32.W), // Branch on Less Than
            BR_LTU -> 0.U(32.W), // Branch on Less Than Unsigned
            BR_J -> (r_addr - 4.U + rel_pc), // Jump(pc += imm(J-type))
            BR_JR -> alu.io.out, //(alu.io.op1 + alu.io.op2), // Jump Register (rs1 + imm(I-type))
            BR_X -> 0.U(32.W) //
        )
    )


    when (id_ctrl.br_type =/= BR_N){        // if(now.inst == branch) { next.inst = invalid } (bubble)
        next_inst_is_valid := false.B
    }.otherwise(
        next_inst_is_valid := true.B
    )

    when (io.sw.halt === false.B){
        when(r_ack === true.B){
            w_req := false.B
            r_addr := pc_incl // increase or jump program counter
        }.otherwise {
            r_req   := true.B
            r_addr  := 0.U(32.W)
        }
    }.otherwise { // halt mode
        // enable Write Operation
        w_addr := io.sw.w_ad //w_addr + 4.U(32.W)
        w_data := io.sw.w_da
        w_req  := true.B
        r_addr := io.sw.w_pc
    }

    // for test
    io.sw.data      := r_data
    io.sw.addr      := r_addr
    io.sw.r_pc      := r_addr // program counter

    io.r_ach.addr   := r_addr
    io.r_ach.req    := r_req
    
    // write process
    io.w_ach.addr   := w_addr
    io.w_dch.data   := w_data
    io.w_ach.req    := w_req
    
    //w_pc    := io.sw.w_pc
    
    // read process
    r_ack  := io.r_dch.ack
    r_data := io.r_dch.data

    // x0 - x31
    io.sw.g_da := rv32i_reg(io.sw.g_ad)


}

class CpuBus extends Module {
    val io: TestIf = IO(new TestIf)
  
    val sw_halt:    Bool = RegInit(true.B)       // input
    val sw_data:    UInt = RegInit(0.U(32.W))    // output
    val sw_addr:    UInt = RegInit(0.U(32.W))    // output
    val sw_rw:      Bool = RegInit(false.B)      // input
    val sw_wdata:   UInt = RegInit(0.U(32.W))    // input
    val sw_waddr:   UInt = RegInit(0.U(32.W))    // input
    
    val w_pc:       UInt = RegInit(0.U(32.W))

    val sw_gaddr:   UInt  = RegInit(0.U(32.W))    // general reg.(x0 to x31)
    
    val cpu:        Cpu = Module(new Cpu)
    val memory:     IMem = Module(new IMem)
    
    // Connect Test Module
    sw_halt     := io.sw.halt
    sw_data     := memory.io.r_dch.data
    sw_addr     := memory.io.r_ach.addr
    
    sw_wdata    := io.sw.w_da // data to write memory
    sw_waddr    := io.sw.w_ad
    sw_gaddr    := io.sw.g_ad

    io.sw.data  := sw_data
    io.sw.addr  := sw_addr
    
    io.sw.g_da  := cpu.io.sw.g_da
    io.sw.r_pc  := cpu.io.sw.r_pc

    w_pc        := io.sw.w_pc

    cpu.io.sw.halt := sw_halt
    cpu.io.sw.w_da := sw_wdata
    cpu.io.sw.w_ad := sw_waddr
    cpu.io.sw.g_ad := sw_gaddr
    cpu.io.sw.w_pc := w_pc

    // Read memory
    memory.io.r_ach.req     <> cpu.io.r_ach.req
    memory.io.r_ach.addr    <> cpu.io.r_ach.addr
    cpu.io.r_dch.data       <> memory.io.r_dch.data
    cpu.io.r_dch.ack        <> memory.io.r_dch.ack

    // write memory
    memory.io.w_ach.req     <> cpu.io.w_ach.req
    memory.io.w_ach.addr    <> cpu.io.w_ach.addr
    memory.io.w_dch.data    <> cpu.io.w_dch.data
    cpu.io.w_dch.ack        <> memory.io.w_dch.ack

}

object kyogenrv extends App {
    chisel3.Driver.execute(args, () => new CpuBus())
}

