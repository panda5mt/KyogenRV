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

    
    // read operation
    io.r_dch.data  := mem.read(io.r_ach.addr)
    io.r_dch.ack   := i_ack


    // write operation
    // when(io.w_ach.req) {
    //     mem.write(io.w_ach.addr,io.w_dch.data)
    //     //io.w_dch.ack := true.B
    // }
}

