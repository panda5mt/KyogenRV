// See README.md for license details.
package mem

import chisel3._
import chisel3.Bool
import bus.SlaveIf_Data
import chisel3.util.Cat

//noinspection ScalaStyle
class DMem extends Module {
  val io: SlaveIf_Data = IO(new SlaveIf_Data)

  val i_ack: Bool = RegInit(false.B)
  val i_req: Bool = RegInit(false.B)

  val w_ack: Bool = RegInit(false.B)
  val byteenable: UInt = io.w_dmem_dat.byteenable

  // initialization
  //val mem: Mem[UInt] = Mem(256*1024, UInt(32.W))
  val mem_3: Mem[UInt] = Mem(256*1024, UInt(8.W))
  val mem_2: Mem[UInt] = Mem(256*1024, UInt(8.W))
  val mem_1: Mem[UInt] = Mem(256*1024, UInt(8.W))
  val mem_0: Mem[UInt] = Mem(256*1024, UInt(8.W))

  val wdat_3: UInt = io.w_dmem_dat.data(31,24)
  val wdat_2: UInt = io.w_dmem_dat.data(23,16)
  val wdat_1: UInt = io.w_dmem_dat.data(15, 8)
  val wdat_0: UInt = io.w_dmem_dat.data( 7, 0)

  val addr_align: UInt = (io.r_dmem_add.addr >> 2).asUInt()

  // read operation
  i_req               := io.r_dmem_add.req
  io.w_dmem_dat.ack   := w_ack
  io.r_dmem_dat.data  := DontCare
  io.r_dmem_dat.ack   := i_ack
  when(io.r_dmem_add.req === true.B) {
    io.r_dmem_dat.data  := Cat(
      mem_3.read(addr_align),
      mem_2.read(addr_align),
      mem_1.read(addr_align),
      mem_0.read(addr_align)
    )
    i_ack := true.B
    w_ack := false.B
  }.elsewhen(io.w_dmem_add.req === true.B) {
    //mem.write(io.w_dmem_add.addr, io.w_dmem_dat.data)
    when(byteenable(3)){ mem_3.write(addr_align, wdat_3) }
    when(byteenable(2)){ mem_2.write(addr_align, wdat_2) }
    when(byteenable(1)){ mem_1.write(addr_align, wdat_1) }
    when(byteenable(0)){ mem_0.write(addr_align, wdat_0) }
    //mem_0.write(addr_align, wdat_0)
    w_ack := true.B
    i_ack := false.B
  }.otherwise{
    w_ack := false.B
    i_ack := false.B
  }
}

