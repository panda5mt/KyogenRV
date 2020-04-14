package core

import chisel3._
import chisel3.util._
import chisel3.Bool

import bus.HostIf
import bus.SlaveIf

import mem.IMem

class Cpu extends Module {
    val io = IO(new HostIf)
    val memory = Module(new IMem)

    // initialization
    val i_addr  = RegInit(0.U(32.W))
    val i_data  = RegInit(0.U(32.W))    
    val i_ena   = RegInit(true.B)       // fetch signal
    //val i_rw    = RegInit(false.B)      // Read-Only=false.B

    when(io.insts_data.ack){
        i_addr := i_addr + 4.U(32.W)    // program counter
        i_data := io.insts_data.data 
    }

    //io.insts_addr.rw    := i_rw  
    io.insts_addr.addr  := i_addr
    io.insts_addr.req   := i_ena


    memory.io.r_insts_addr.req  := io.insts_addr.req
    memory.io.r_insts_addr.addr := io.insts_addr.addr
    // memory.io.r_insts_data.ack  <> io.insts_data.ack
     

}

object kyogenrv extends App {
    chisel3.Driver.execute(args, () => new Cpu())
}

