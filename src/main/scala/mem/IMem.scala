// See README.md for license details.
package mem

import chisel3._
import bus.SlaveIf_Inst

//noinspection ScalaStyle
class IMem extends Module {
    val io: SlaveIf_Inst = IO(new SlaveIf_Inst)

    // initialization
    //val mem = SyncReadMem(5120, UInt(32.W))
    val mem: Mem[UInt] = Mem(5120, UInt(32.W))
    //val mem: Mem[UInt] = Mem(256*1024, UInt(32.W))

    val i_ack: Bool = RegInit(false.B)
    val i_req: Bool = RegInit(false.B)

    val w_ack: Bool = RegInit(false.B)

    // read operation
    i_req               := io.r_imem_add.req
    io.w_imem_dat.ack   := w_ack
    io.r_imem_dat.data  := DontCare
    //i_ack          := i_req
    io.r_imem_dat.ack   := i_ack
    when(io.r_imem_add.req === true.B) {
        io.r_imem_dat.data  := mem.read(io.r_imem_add.addr)
        i_ack := true.B
        w_ack := false.B
    }.elsewhen(io.w_imem_add.req === true.B) {
        mem.write(io.w_imem_add.addr, io.w_imem_dat.data)
        w_ack := true.B
        i_ack := false.B
    }.otherwise{
        w_ack := false.B
        i_ack := false.B
    }

}