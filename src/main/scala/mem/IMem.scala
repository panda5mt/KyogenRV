// See README.md for license details.
package mem

import chisel3._
import chisel3.Bool

import bus.SlaveIf_Inst

class IMem extends Module {
    val io: SlaveIf_Inst = IO(new SlaveIf_Inst)

    // initialization
    //val mem = SyncReadMem(1024, UInt(32.W))
    val mem: Mem[UInt] = Mem(1024, UInt(32.W))

    val i_ack: Bool = RegInit(false.B)
    val i_req: Bool = RegInit(false.B)
    //val i_data  = RegInit(0.U(32.W))
    
    val w_ack: Bool = RegInit(false.B)
    
    // read operation
    i_req               :=io.r_imem_add.req
    io.r_imem_dat.data  := mem.read(io.r_imem_add.addr)
    //i_ack             := i_req
    io.r_imem_dat.ack   := i_ack
    when(io.r_imem_add.req === true.B) {
        i_ack := true.B
    }.otherwise(
        i_ack := false.B
    )

    // write operation
    when(io.w_imem_add.req === true.B) {
        mem.write(io.w_imem_add.addr,io.w_imem_dat.data)
        w_ack           := true.B
    }

    io.w_imem_dat.ack   := w_ack
}

