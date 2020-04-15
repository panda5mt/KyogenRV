package bus

import chisel3._
import chisel3.util._
import chisel3.Bool

// bus ctrl
class CtrlSwChannel extends Bundle {
    val halt = Input(Bool())    // CPU or TraceMaster halt
    val rw   = Output(Bool())   // indicate Memory-Mapped read(false)/Write(true) SW 
    val data = Output(UInt(32.W)) // for test: memory dump
}

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
    val sw  = new CtrlSwChannel
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