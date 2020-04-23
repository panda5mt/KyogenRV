package core

import chisel3._
import chisel3.util._
import chisel3.Bool
import chisel3.Printable

import bus.HostIf
import bus.SlaveIf
import bus.TestIf

import mem._
import mem.IMem

/// Test modules //////
import chisel3.iotesters 
import chisel3.iotesters.PeekPokeTester
///////////////////////
object Test extends App {
    iotesters.Driver.execute(args, () => new CpuBus()){
        c => new PeekPokeTester(c) {
            var memarray = Array(
               0x00000000L,
               0x00000093L,
               0x00100113L,
               0x00200193L,
               0x00300213L,
               0x00400293L,
               0x00500313L,
               0x00000000L
                
            )
            step(1)
            poke(c.io.sw.halt, true.B)
            step(1)
            for (addr <- 0 to (memarray.length * 4 - 1) by 4){    
                poke(c.io.sw.wAddr, addr)
                poke(c.io.sw.wData, memarray(addr/4))
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

                poke(c.io.sw.gAddr, lp)
                step(1)
                val d = peek(c.io.sw.gData)

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
        w_addr := io.sw.wAddr //w_addr + 4.U(32.W)
        w_data := io.sw.wData
        w_req  := true.B
        r_addr := io.sw.w_pc//0.U(32.W)
    }
    //addi    rd rs1 imm12           14..12=0 6..2=0x04 1..0=3
    when (r_data === BitPat("b????_????_????_????_?000_????_?001_0011")){   //ADDI
        //ex: x1 = x1 + 1 : "b0000_0000_0001_0000_1000_0000_1001_0011"= h00108093
        // ADDI = imm12=[31:20], src=[19:15], funct3=[14:12], rd=[11:7], opcode=[6:0]
        //rv32i_reg(r_data(11,7)) = rv32i_reg(r_data(19,15) + rv32i_reg(r_data(31,20)))

        val dest = r_data(11,7)
        val imm  = r_data(31,20)
        val src  = r_data(19,15)
        val dsrc = rv32i_reg(src)
        val sum  = dsrc + imm
        rv32i_reg(dest) :=  sum
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
    io.sw.gData := rv32i_reg(io.sw.gAddr)


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
    
    sw_wdata    := io.sw.wData // data to write memory
    sw_waddr    := io.sw.wAddr
    sw_gaddr    := io.sw.gAddr 

    io.sw.data  := sw_data
    io.sw.addr  := sw_addr
    
    io.sw.gData := cpu.io.sw.gData
    io.sw.r_pc  := cpu.io.sw.r_pc

    w_pc        := io.sw.w_pc

    cpu.io.sw.halt  := sw_halt
    cpu.io.sw.wData := sw_wdata
    cpu.io.sw.wAddr := sw_waddr
    cpu.io.sw.gAddr := sw_gaddr
    cpu.io.sw.w_pc  := w_pc

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

