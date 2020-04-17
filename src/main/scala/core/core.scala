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
            poke(c.io.sw.halt, true.B)
            poke(c.io.sw.rw, true.B)
            for (addr <- 0 to 24){    
                poke(c.io.sw.wAddr, addr)
                poke(c.io.sw.wData, addr)
                step(1)
            }
            poke(c.io.sw.rw, false.B)
            poke(c.io.sw.halt, false.B)
            for (addr <- 0 to 50){
                step(1)
                println(s"addr = ${peek(c.io.r_ach.addr)},data = ${peek(c.io.sw.data)} ")
                
            }
        }
    }
}


class Cpu extends Module {
    val io = IO(new HostIf)
    val memory = Module(new IMem)
    


    // initialization    
    val r_addr  = RegInit(0.U(32.W))
    val r_data  = RegInit(0.U(32.W))    
    val r_req   = RegInit(true.B)       // fetch signal
    val r_rw    = RegInit(false.B)
    val r_ack   = RegInit(false.B)

    val w_req   = RegInit(false.B)
    val w_ack   = RegInit(false.B)
    val w_addr  = RegInit(0.U(32.W))
    val w_data  = RegInit(0.U(32.W)) 
    
    when (io.sw.halt === false.B){     
        when(r_ack === true.B){
            r_addr := r_addr + 4.U(32.W)    // increase program counter
        }/*.otherwise {               // r_ack == false
            r_addr := r_addr        // stop program counter
            r_req := true.B
        }*/
    }.otherwise { // halt mode
        when(io.sw.rw === true.B){          // external Controller
                // enable Write Operation
                w_addr := io.sw.wData //w_addr + 4.U(32.W)
                w_data := io.sw.wData
                w_req  := true.B
        }
    }
    // for test
    io.sw.data  := r_data
    io.r_ach.addr := r_addr
    io.r_ach.req  := r_req

    // read process
    r_ack  := memory.io.r_dch.ack
    r_data := memory.io.r_dch.data 
    
    memory.io.r_ach.req  := io.r_ach.req
    //memory.io.r_ach.addr := io.r_ach.addr
    memory.io.r_ach.addr := r_addr
    
    
    // write process
    io.w_ach.addr := w_addr
    io.w_dch.data := w_data
    io.w_ach.req := w_req
    //io.w_dch.ack := w_ack

    w_ack := memory.io.w_dch.ack
    
    memory.io.w_ach.req := io.w_ach.req
    memory.io.w_ach.addr := io.w_ach.addr
    memory.io.w_dch.data := io.w_dch.data
    
}

object kyogenrv extends App {
    chisel3.Driver.execute(args, () => new Cpu())
}

