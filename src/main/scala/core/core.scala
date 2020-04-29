// See README.md for license details.
package core

import chisel3._
import chisel3.util._

import bus.HostIf
import bus.TestIf

import mem.IMem
import ScalarOpConstants._

/// Test modules //////
import chisel3.iotesters 
import chisel3.iotesters.PeekPokeTester
///////////////////////
import util._

object Test extends App {
    iotesters.Driver.execute(args, () => new CpuBus()){
        c => new PeekPokeTester(c) {
            var memarray = Array(
            0x00000000L, //
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
            for (addr <- 0 to (memarray.length * 4 - 1) by 4){
                poke(c.io.sw.w_ad, addr)
                poke(c.io.sw.w_da, memarray(addr/4))
                println(f"write: addr = 0x${addr}%08X, data = 0x${memarray(addr/4)}%08X")
                step(1)
            }
            step(1)
            println("---------------------------------------------------------")
            poke(c.io.sw.w_pc, 0)   // restart pc address
            step(1)                 // fetch pc
            poke(c.io.sw.halt, false.B)
            step(1)
            step(1)

            for (lp <- 0 to (memarray.length - 1) by 1){
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



class Cpu extends Module {
    val io = IO(new HostIf)
    
    // initialization
    val r_addr  = RegInit(0.U(32.W))
    val r_data  = RegInit(0.U(32.W))
    val r_req   = RegInit(true.B)       // fetch signal
    val r_rw    = RegInit(false.B)
    val r_ack   = RegInit(false.B)

    val w_req   = RegInit(true.B)
    val w_ack   = RegInit(false.B)
    val w_addr  = RegInit(0.U(32.W))
    val w_data  = RegInit(0.U(32.W))
    
    //val g_addr  = RegInit(0.U(32.W))
    val rv32i_reg   = RegInit(VecInit(Seq.fill(32)(0.U(32.W)))) // x0 - x31:All zero initialized
   
    when (io.sw.halt === false.B){
        when(r_ack === true.B){
            r_addr := r_addr + 4.U(32.W)    // increase program counter
            w_req  := false.B
        }
    }.otherwise { // halt mode
        // enable Write Operation
        w_addr := io.sw.w_ad //w_addr + 4.U(32.W)
        w_data := io.sw.w_da
        w_req  := true.B
        r_addr := io.sw.w_pc
    }

    // ID Module instance
    val idm = Module(new IDModule)
    idm.io.imem := r_data // instruction decode
    val id_ctrl = Wire(new IntCtrlSigs).decode(idm.io.inst.bits,(new IDecode).table)

    // ALU OP1 selector
    val ex_op1 = MuxLookup(id_ctrl.alu_op1, 0.U(32.W),
        Seq(
            OP1_RS1 -> rv32i_reg(idm.io.inst.rs1),
            OP1_IMU -> 0.U(32.W),   // DUMMY
            OP1_IMZ -> 0.U(32.W)    // DUMMY
        )
    )
    // ALU OP2 selector
    val ex_op2 = MuxLookup(id_ctrl.alu_op2, 0.U(32.W),
        Seq(
            OP2_RS2 -> rv32i_reg(idm.io.inst.rs2),
            OP2_IMI -> idm.io.inst.imm,
            OP2_IMS -> 0.U(32.W)    // DUMMY
        )
    )

    import ALU._
    val alu = Module(new ALU)
    alu.io.alu_op := id_ctrl.alu_func
    alu.io.op1 := ex_op1
    alu.io.op2 := ex_op2


    // register write
    val rf_wen = id_ctrl.rf_wen     // register write enable flag
    val rd_addr = idm.io.inst.rd    // destination register

    when (rf_wen === REN_1){
        when (rd_addr =/= 0.U){
            rv32i_reg(rd_addr) := alu.io.out
        }.otherwise { // rd_addr = 0
            rv32i_reg(0.U) := 0.U(32.W)
        }  
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
    val io      = IO(new TestIf)
  
    val sw_halt     = RegInit(true.B)       // input
    val sw_data     = RegInit(0.U(32.W))    // output
    val sw_addr     = RegInit(0.U(32.W))    // output
    val sw_rw       = RegInit(false.B)      // input
    val sw_wdata    = RegInit(0.U(32.W))    // input
    val sw_waddr    = RegInit(0.U(32.W))    // input
    
    val w_pc        = RegInit(0.U(32.W))

    val sw_gaddr    = RegInit(0.U(32.W))    // general geg.(x0 to x31)
    
    val cpu     = Module(new Cpu)
    val memory  = Module(new IMem)
    
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

    cpu.io.sw.halt  := sw_halt
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

