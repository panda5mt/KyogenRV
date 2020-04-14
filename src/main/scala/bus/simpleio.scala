package bus

import chisel3._
import chisel3.util._
import chisel3.Bool

// address channel bundle
class AddressChannel extends Bundle {
    val req     = Output(Bool())        // request signal
    val addr    = Output(UInt(32.W))   // address (32bit)
}

// data channel bundle
class DataChannel extends Bundle {
    val ack = Output(Bool())        // data is available ack
    val data = Output(UInt(32.W))   // data (32bit)
}

// HOST :read only(IMem)
// HOST :read/Write(Dmem)
class HostIf extends Bundle {
    // IO definition
    val ach = new AddressChannel
    val dch = Flipped(new DataChannel) // reverse I/O
}

// Memory-Mapped Slave IF
// Slave :read/Write(IMem)
// Slave :read/Write(Dmem)
class SlaveIf extends Bundle {
    // IO definition
    // read operation
    val r_ach = Flipped(new AddressChannel) // reverse I/O
    val r_dch = new DataChannel	
    
    //val w_ach = Flipped(new AddressChannel) // reverse I/O
    //val w_dch = Flipped(new DataChannel)	

}