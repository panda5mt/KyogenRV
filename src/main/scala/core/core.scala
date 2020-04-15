package core

import chisel3._
import chisel3.util._
import chisel3.Bool

import bus.HostIf
import bus.SlaveIf

import mem.IMem

class Cpu extends Module {
    val io = IO(new HostIf)

    // initialization
    val i_addr  = RegInit(0.U(32.W))
    val i_data  = RegInit(0.U(32.W))    
    val i_ena   = RegInit(true.B)       // fetch signal
    //val i_rw    = RegInit(false.B)      // Read-Only=false.B

    when(io.dch.ack){
        i_addr := i_addr + 4.U(32.W)    // program counter
        i_data := io.dch.data 
    }

    //io.ach.rw    := i_rw  
    io.ach.addr  := i_addr
    io.ach.req   := i_ena


    val memory = Module(new IMem)

    memory.io.r_ach.req  := io.ach.req
    memory.io.r_ach.addr := io.ach.addr
    // memory.io.r_dch.ack  <> io.dch.ack
     

}

object kyogenrv extends App {
    chisel3.Driver.execute(args, () => new Cpu())
}

