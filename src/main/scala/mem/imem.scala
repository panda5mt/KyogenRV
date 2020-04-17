package mem

import chisel3._
import chisel3.util._
import chisel3.Bool

import bus.SlaveIf

class IMem extends Module {
    val io = IO(new SlaveIf)

    // initialization
    val mem     = SyncReadMem(256, UInt(32.W))

    val i_ack   = RegInit(true.B)
    val i_req   = RegInit(false.B)
    //val i_data  = RegInit(0.U(32.W))
    
    val w_ack   = RegInit(false.B)
    
    // read operation
    i_req           :=io.r_ach.req 
    io.r_dch.data   := mem.read(io.r_ach.addr)
    i_ack           := i_req   
    io.r_dch.ack    := i_ack

    // write operation
    when(io.w_ach.req === true.B) {
        mem.write(io.w_ach.addr,io.w_dch.data)
        w_ack := true.B    
    }

    io.w_dch.ack    := w_ack
}

