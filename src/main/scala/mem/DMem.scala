// See README.md for license details.
package mem

import chisel3._
import chisel3.Bool

import bus.SlaveIf_Data

//noinspection ScalaStyle
class DMem extends Module {
  val io: SlaveIf_Data = IO(new SlaveIf_Data)

  // initialization
  //val mem = SyncReadMem(1024, UInt(32.W))
  val mem: Mem[UInt] = Mem(1024, UInt(32.W))

  val i_ack: Bool = RegInit(false.B)
  val i_req: Bool = RegInit(false.B)
  //val i_data  = RegInit(0.U(32.W))

  val w_ack: Bool = RegInit(false.B)

  // read operation
  i_req               := io.r_dmem_add.req
  io.r_dmem_dat.data  := mem.read(io.r_dmem_add.addr)
  //i_ack          := i_req
  io.r_dmem_dat.ack   := i_ack
  when(io.r_dmem_add.req === true.B) {
    i_ack := true.B
  }.otherwise(
    i_ack := false.B
  )



  // write operation
  when(io.w_dmem_add.req === true.B) {
    mem.write(io.w_dmem_add.addr, io.w_dmem_dat.data)
    w_ack := true.B
  }.otherwise{
    w_ack := false.B
  }

  io.w_dmem_dat.ack    := w_ack
}

