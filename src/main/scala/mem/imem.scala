package mem

import chisel3._
import chisel3.util._
import chisel3.Bool

import bus.SlaveIf

class IMem extends Module {
    val io = IO(new SlaveIf)

    // initialization
    val memory = Mem(256, UInt(32.W))
    val i_ack  = RegInit(true.B)

    
    // read operation
    io.r_dch.data  := memory(io.r_ach.addr)
    io.r_dch.ack   := i_ack

    // write operation
//     when(io.w_ach.req) {
//         memory(io.w_ach.addr) := io.w_dch.data
//         io.w_dch.ack := true.B
//     }.otherwise {
//         io.w_dch.ack := false.B
//     }
}

