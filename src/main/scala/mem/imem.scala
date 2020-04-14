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
    io.r_insts_data.data  := memory(io.r_insts_addr.addr)
    io.r_insts_data.ack   := i_ack

    // write operation
//     when(io.w_insts_addr.req) {
//         memory(io.w_insts_addr.addr) := io.w_insts_data.data
//         io.w_insts_data.ack := true.B
//     }.otherwise {
//         io.w_insts_data.ack := false.B
//     }
}

