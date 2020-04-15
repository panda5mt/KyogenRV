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
            //poke(c.io.r_dch.ack, true.B)
            step(10)
            println(s"addr = ${peek(c.io.r_ach.addr)},data = ${peek(c.io.sw.data)} ")
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
    val i_ack   = RegInit(false.B)
    when (io.sw.halt === false.B){    
        when(i_ack === true.B){
            i_addr := i_addr + 4.U(32.W)    // program counter
        }
    }
    // for test
    io.sw.data  := i_data
    io.sw.rw    := i_rw  
    io.r_ach.addr := i_addr
    io.r_ach.req  := i_ena

    i_ack  := memory.io.r_dch.ack
    i_data := memory.io.r_dch.data 
    
    memory.io.r_ach.req  := io.r_ach.req
    memory.io.r_ach.addr := io.r_ach.addr
     

}

object kyogenrv extends App {
    chisel3.Driver.execute(args, () => new Cpu())
}

