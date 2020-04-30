// See README.md for license details.
package bus

import chisel3._
import chisel3.util._
import chisel3.Bool

// bus ctrl
class CtrlSwChannel extends Bundle {
    val halt: Bool = Input(Bool())         // CPU or TraceMaster halt

    val addr: UInt = Output(UInt(32.W))    // for debug: address dump
    val data: UInt = Output(UInt(32.W))    // for test: memory dump
    val w_da: UInt = Input(UInt(32.W))     // for test: write data
    val w_ad: UInt = Input(UInt(32.W))     // for test: write address

    val g_ad: UInt = Input(UInt(32.W))     // General register address (0 to 31)
    val g_da: UInt = Output(UInt(32.W))    // General register data

    val r_pc: UInt = Output(UInt(32.W))    // Program Counter Read register
    val w_pc: UInt = Input(UInt(32.W))     // Program Counter Write register
}


// address channel bundle
class AddressChannel extends Bundle {
    val req: Bool = Output(Bool())        // request signal
    val addr: UInt = Output(UInt(32.W))   // address (32bit)
}

// data channel bundle
class DataChannel extends Bundle {
    val ack: Bool = Output(Bool())        // data is available ack
    val data: UInt = Output(UInt(32.W))   // data (32bit)
}

class wDataChannel extends Bundle {
    val ack: Bool = Input(Bool())        // data is available ack
    val data: UInt = Output(UInt(32.W))   // data (32bit)
}

// HOST :read only(IMem)
// HOST :read/Write(Dmem)
class HostIf extends Bundle {
    // IO definition
    val r_ach: AddressChannel = new AddressChannel
    val r_dch: DataChannel = Flipped(new DataChannel)    // flipped I/O
    // write operation
    val w_ach: AddressChannel = new AddressChannel
    val w_dch: wDataChannel = new wDataChannel
    // debug if
    val sw: CtrlSwChannel = new CtrlSwChannel
}

// Memory-Mapped Slave IF
// Slave :read/Write(IMem)
// Slave :read/Write(Dmem)
class SlaveIf extends Bundle {
    // IO definition
    // read operation
    val r_ach: AddressChannel = Flipped(new AddressChannel) // flipped I/O
    val r_dch: DataChannel = new DataChannel
    // write operation
    val w_ach: AddressChannel = Flipped(new AddressChannel) // flipped I/O
    val w_dch: wDataChannel = Flipped(new wDataChannel)
}

class TestIf extends Bundle {
    val sw: CtrlSwChannel = new CtrlSwChannel
}