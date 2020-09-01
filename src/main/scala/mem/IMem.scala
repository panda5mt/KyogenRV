// See README.md for license details.
package mem

import chisel3._
import chisel3.Bool
import bus.SlaveIf_Inst
import chisel3.util.Cat

//noinspection ScalaStyle
class IMem extends Module {
    val io: SlaveIf_Inst = IO(new SlaveIf_Inst)

    val r_ack: Bool = RegInit(false.B)
    val w_ack: Bool = RegInit(false.B)

    // data memory 0x2000 - 0x3000
    val valid_address: Bool = (io.imem_add.addr >= 0x0000.U) && (io.imem_add.addr <= 0x3000.U)
    //val w_valid_address: Bool = (io.w_imem_add.addr >= 0x0000.U) && (io.w_imem_add.addr <= 0x3000.U)
    val byteenable: UInt = io.w_imem_dat.byteenable

    val r_req: Bool = io.r_imem_dat.req && valid_address
    val w_req: Bool = io.w_imem_dat.req && valid_address

    // initialization
    //val mem: Mem[UInt] = Mem(256*1024, UInt(32.W))
    //  val mem_3: Mem[UInt] = Mem(0x3000, UInt(8.W))
    //  val mem_2: Mem[UInt] = Mem(0x3000, UInt(8.W))
    //  val mem_1: Mem[UInt] = Mem(0x3000, UInt(8.W))
    //  val mem_0: Mem[UInt] = Mem(0x3000, UInt(8.W))
    val mem_3: SyncReadMem[UInt] = SyncReadMem(0x3000, UInt(8.W))
    val mem_2: SyncReadMem[UInt] = SyncReadMem(0x3000, UInt(8.W))
    val mem_1: SyncReadMem[UInt] = SyncReadMem(0x3000, UInt(8.W))
    val mem_0: SyncReadMem[UInt] = SyncReadMem(0x3000, UInt(8.W))

    val wdat_3: UInt = io.w_imem_dat.data(31,24)
    val wdat_2: UInt = io.w_imem_dat.data(23,16)
    val wdat_1: UInt = io.w_imem_dat.data(15, 8)
    val wdat_0: UInt = io.w_imem_dat.data( 7, 0)

    val addr_align: UInt = Mux(r_req,(io.imem_add.addr >> 2).asUInt() - 0x0000.U,
        Mux(w_req,(io.imem_add.addr >> 2).asUInt() - 0x0000.U,
            0xffffffffL.U))


    io.w_imem_dat.ack   := w_ack
    io.r_imem_dat.data  := DontCare
    io.r_imem_dat.ack   := r_ack

    // read operation
    when(r_req === true.B) {
        when(byteenable === 15.U) {
            io.r_imem_dat.data  := Cat(
                mem_3.read(addr_align),
                mem_2.read(addr_align),
                mem_1.read(addr_align),
                mem_0.read(addr_align)
            )
        }.otherwise{
            io.r_imem_dat.data  := 0.U
        }
        r_ack := true.B
        w_ack := false.B
    }.elsewhen(w_req === true.B) {
        //mem.write(io.w_imem_add.addr, io.w_imem_dat.data)
        when(byteenable(3)){ mem_3.write(addr_align, wdat_3) }
        when(byteenable(2)){ mem_2.write(addr_align, wdat_2) }
        when(byteenable(1)){ mem_1.write(addr_align, wdat_1) }
        when(byteenable(0)){ mem_0.write(addr_align, wdat_0) }
        //mem_0.write(addr_align, wdat_0)
        w_ack := true.B
        r_ack := false.B
    }.otherwise{
        w_ack := false.B
        r_ack := false.B
    }
}

