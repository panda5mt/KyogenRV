package core

import chisel3._
import chisel3.util._
import chisel3.Bool

import bus.HostIf
import bus.SlaveIf

import mem._
import mem.IMem

/// Test modules //////
import chisel3.iotesters 
import chisel3.iotesters.PeekPokeTester
///////////////////////
object Test extends App {
    iotesters.Driver.execute(args, () => new Cpu()){
        c => new PeekPokeTester(c) {
            poke(c.io.sw.halt, false.B)
            step(10)
            println(s"addr = ${peek(c.io.ach.addr)},data = ${peek(c.io.sw.data)} ")
        }
    }
}


class Cpu extends Module {
    val io = IO(new HostIf)
    val memory = Module(new IMem)
    


    // initialization    
    val i_addr  = RegInit(0.U(32.W))
    val i_data  = RegInit(0.U(32.W))    
    val i_ena   = RegInit(true.B)       // fetch signal
    val i_rw    = RegInit(false.B)
    
    when (io.sw.halt === false.B){    
       // when(io.dch.ack){
            i_addr := i_addr + 4.U(32.W)    // program counter
        //}
    }
    // for test
    io.sw.data  := i_data
    io.sw.rw    := i_rw  
    io.ach.addr := i_addr
    io.ach.req  := i_ena
    i_data := memory.io.r_dch.data 
    
    memory.io.r_ach.req  := io.ach.req
    memory.io.r_ach.addr := io.ach.addr
     

}

object kyogenrv extends App {
    chisel3.Driver.execute(args, () => new Cpu())
}

