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
                0x11000000L,
                0x11000001L,
                0x11000002L,
                0x11000003L,
                0x11000004L,
                0x11000005L,
                0x11000006L,
                0x11000007L,
                0x11000008L,
                0x11000009L,
                0x1100000AL,
                0x1100000BL,
                0x1100000CL,
                0x1100000DL,
                0x1100000EL,
                0x1100000FL,
                0x11000010L,
                0x11000011L,
                0x11000012L,
                0x11000013L,
                0x11000014L,
                0x11000015L,
                0x11000016L,
                0x11000017L,
                0x11000018L,
                0x11000019L,
                0x1100001AL,
                0x1100001BL,
                0x1100001CL,
                0x1100001DL,
                0x1100001EL,
                0x1100001FL,
                
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
            poke(c.io.sw.halt, false.B)
            step(1)
            step(1)
            
            for (lp <- 0 to (memarray.length - 1) by 1){
                val a = peek(c.io.sw.addr)
                val d = peek(c.io.sw.data)

                println(f"read : addr = 0x$a%08X, data = 0x$d%08X") //peek(c.io.sw.data)
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
    
    when (io.sw.halt === false.B){     
        when(r_ack === true.B){
            r_addr := r_addr + 4.U(32.W)    // increase program counter
        }
    }.otherwise { // halt mode
        // enable Write Operation
        w_addr := io.sw.wAddr //w_addr + 4.U(32.W)
        w_data := io.sw.wData
        w_req  := true.B
        r_addr := 0.U(32.W)

    }
    // for test
    io.sw.data      := r_data
    io.sw.addr      := r_addr

    io.r_ach.addr   := r_addr
    io.r_ach.req    := r_req
    
    // write process
    io.w_ach.addr   := w_addr
    io.w_dch.data   := w_data
    io.w_ach.req    := w_req
    //io.w_dch.ack := w_ack
    
    // read process
    r_ack  := io.r_dch.ack
    r_data := io.r_dch.data 
    

}

class CpuBus extends Module {
    val io      = IO(new TestIf)
  
    val sw_halt     = RegInit(true.B)       // input
    val sw_data     = RegInit(0.U(32.W))    // output
    val sw_addr     = RegInit(0.U(32.W))    // output
    val sw_rw       = RegInit(false.B)      // input
    val sw_wdata    = RegInit(0.U(32.W))    // input
    val sw_waddr    = RegInit(0.U(32.W))    // input

   
    val cpu     = Module(new Cpu)
    val memory  = Module(new IMem)
    
    // Connect Test Module
    sw_halt     := io.sw.halt  //:= io.sw.halt
    sw_data     := memory.io.r_dch.data//cpu.io.sw.data
    sw_addr     := memory.io.r_ach.addr//cpu.io.sw.addr
    //sw_rw       := io.sw.rw
    sw_wdata    := io.sw.wData //:= io.sw.wData  // data to write memory
    sw_waddr    := io.sw.wAddr //:= io.sw.wAddr

    io.sw.data  := sw_data
    io.sw.addr  := sw_addr
    
    cpu.io.sw.halt  := sw_halt
    //cpu.io.sw.rw    := sw_rw
    cpu.io.sw.wData := sw_wdata
    cpu.io.sw.wAddr := sw_waddr


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

