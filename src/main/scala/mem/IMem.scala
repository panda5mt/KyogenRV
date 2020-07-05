// See README.md for license details.
package mem

import chisel3._
import bus.SlaveIf_Inst
import chisel3.util.Cat

//noinspection ScalaStyle
class IMem extends Module {
    val io: SlaveIf_Inst = IO(new SlaveIf_Inst)


    val i_ack: Bool = RegInit(false.B)
    val i_req: Bool = RegInit(false.B)

    val w_ack: Bool = RegInit(false.B)
    val byteenable: UInt = 15.U // byteenable = b1111 = all(32bits) are write-enable

    // initialization
    //val mem: Mem[UInt] = Mem(256*1024, UInt(32.W))
    val mem_3: Mem[UInt] = Mem(256*1024, UInt(8.W))
    val mem_2: Mem[UInt] = Mem(256*1024, UInt(8.W))
    val mem_1: Mem[UInt] = Mem(256*1024, UInt(8.W))
    val mem_0: Mem[UInt] = Mem(256*1024, UInt(8.W))

    val wdat_3: UInt = io.w_imem_dat.data(31,24)
    val wdat_2: UInt = io.w_imem_dat.data(23,16)
    val wdat_1: UInt = io.w_imem_dat.data(15, 8)
    val wdat_0: UInt = io.w_imem_dat.data( 7, 0)

    // read operation
    i_req               := io.r_imem_add.req
    io.w_imem_dat.ack   := w_ack
    io.r_imem_dat.data  := DontCare
    io.r_imem_dat.ack   := i_ack
    when(io.r_imem_add.req === true.B) {
        io.r_imem_dat.data  := Cat(
            mem_3.read(io.r_imem_add.addr),
            mem_2.read(io.r_imem_add.addr),
            mem_1.read(io.r_imem_add.addr),
            mem_0.read(io.r_imem_add.addr)
        )
        i_ack := true.B
        w_ack := false.B
    }.elsewhen(io.w_imem_add.req === true.B) {
        //mem.write(io.w_imem_add.addr, io.w_imem_dat.data)
        when(byteenable(3)){ mem_3.write(io.w_imem_add.addr, wdat_3) }
        when(byteenable(2)){ mem_2.write(io.w_imem_add.addr, wdat_2) }
        when(byteenable(1)){ mem_1.write(io.w_imem_add.addr, wdat_1) }
        when(byteenable(0)){ mem_0.write(io.w_imem_add.addr, wdat_0) }
        mem_0.write(io.w_imem_add.addr, wdat_0)
        w_ack := true.B
        i_ack := false.B
    }.otherwise{
        w_ack := false.B
        i_ack := false.B
    }
}

