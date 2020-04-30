// See README.md for license details.
package core

import bus.{HostIf, TestIf}
import chisel3._
import chisel3.util._
import _root_.core.ScalarOpConstants._
import mem.IMem

/// Test modules /////
import chisel3.iotesters
import chisel3.iotesters.PeekPokeTester
//////////////////////

object Test extends App {
    iotesters.Driver.execute(args, () => new CpuBus()){
        c => new PeekPokeTester(c) {
            var memarray: Array[Long] = Array(
            0x00000000L,
            0x00100093L, // addi x1,x0,1 (x1 = x0 + 1 = 1)
            0x00100113L, // addi x2,x0,1 (x2 = x0 + 1 = 1)
            0x00200193L, // addi x3,x0,2 (x3 = x0 + 2 = 2)
            0x00300213L, // addi x4,x0,3 (x4 = x0 + 3 = 3)
            0x00400293L, // addi x5,x0,4
            0x00500313L, // addi x6,x0,5
            0x00600393L, // addi x7,x0,6
            0x00700413L, // addi x8,x0,7
            0x00800493L, // addi x9,x0,8
            0x00900513L, // addi x10,x0,9
            0x00A00593L, // addi x11,x0,10 (x11 = 0 + 10 = 10)
            0x00259093L, // slli x1,x11,2 (x1 = x11 << 2 = 40)
            0x00B00613L, // addi x12,x0,11 (x12 = 11)
            0x00C581B3L, // add x3,x11,x12 (x3 = x11 + x12 = 10 + 11 = 21 = 0x15)
            0x00C00693L, // addi x13,x0,12
            0x00D00713L, // addi x14,x0,13
            0x00E00793L, // addi x15,x0,14
            0x00F00813L, // addi x16,x0,15
            0x01000893L, // addi x17,x0,16
            0x01100913L, // addi x18,x0,17
            0x01200993L, // addi x19,x0,18
            0x01300A13L, // addi x20,x0,19
            0x01400A93L, // addi x21,x0,20
            0x01500B13L, // addi x22,x0,21
            0x01600B93L, // addi x23,x0,22
            0x01700C13L, // addi x24,x0,23
            0x01800C93L, // addi x25,x0,24
            0x01900D13L, // addi x26,x0,25
            0x01A00D93L, // addi x27,x0,26
            0x01B00E13L, // addi x28,x0,27
            0x01C00E93L, // addi x29,x0,28
            0x01D00F13L, // addi x30,x0,29
            0x01E00F93L  // addi x31,x0,30
            )
            step(1)
            poke(c.io.sw.halt, true.B)
            step(1)
            for (addr <- 0 until memarray.length * 4 by 4){
                poke(c.io.sw.w_ad, addr)
                poke(c.io.sw.w_da, memarray(addr/4))
                println(f"write: addr = 0x$addr%08X, data = 0x${memarray(addr/4)}%08X")
                step(1)
            }
            step(1)
            println("---------------------------------------------------------")
            poke(c.io.sw.w_pc, 0)   // restart pc address
            step(1)                 // fetch pc
            poke(c.io.sw.halt, false.B)
            step(1)
            step(1)

            for (lp <- memarray.indices by 1){
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


    // ID Module instance
    val idm: IDModule = Module(new IDModule)
    idm.io.imem := r_data // instruction decode
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
            WB_PC4 -> (r_addr + 4.U(32.W)),           //pc + 4
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
    val pc_incl: UInt = MuxLookup(id_ctrl.br_type, 0.U(32.W),
        Seq(
            BR_N    -> 4.U(32.W), // Next
            BR_NE   -> 0.U(32.W), // Branch on NotEqual
            BR_EQ   -> 0.U(32.W), // Branch on Equal
            BR_GE   -> 0.U(32.W), // Branch on Greater/Equal
            BR_GEU  -> 0.U(32.W), // Branch on Greater/Equal Unsigned
            BR_LT   -> 0.U(32.W), // Branch on Less Than
            BR_LTU  -> 0.U(32.W), // Branch on Less Than Unsigned
            BR_J    -> Cat(idm.io.inst bits 31, idm.io.inst bits(19,12), idm.io.inst bits 20, idm.io.inst bits(30, 21)), // Jump
            BR_JR   -> 0.U(32.W), // Jump Register
            BR_X    -> 0.U(32.W)  //
        )
    )

    when (io.sw.halt === false.B){
        when(r_ack === true.B){
            w_req := false.B
            r_addr := r_addr + pc_incl // increase or jump program counter
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

