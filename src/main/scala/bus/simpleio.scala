// See README.md for license details.
package bus

import chisel3.{Bool, _}

// bus ctrl
class CtrlSwChannel extends Bundle {
    val halt: Bool = Input(Bool())         // CPU or TraceMaster halt

    val r_add: UInt = Output(UInt(32.W))    // for debug: address dump
    val r_dat: UInt = Output(UInt(32.W))    // for test: memory dump

    val w_add: UInt = Input(UInt(32.W))     // for test: write address
    val w_dat: UInt = Input(UInt(32.W))     // for test: write data

    val g_add: UInt = Input(UInt(32.W))     // General register address (0 to 31)
    val g_dat: UInt = Output(UInt(32.W))    // General register data

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
class HostIf_Inst extends Bundle {
    // Instruction Memory
    // IO definition
    val r_imem_add: AddressChannel = new AddressChannel
    val r_imem_dat: DataChannel = Flipped(new DataChannel)    // flipped I/O
    // write operation
    val w_imem_add: AddressChannel = new AddressChannel
    val w_imem_dat: wDataChannel = new wDataChannel

    // debug if
    val sw: CtrlSwChannel = new CtrlSwChannel
}

class HostIf_Data extends Bundle {
    // data Memory
    // IO definition
    val r_dmem_add: AddressChannel   = new AddressChannel
    val r_dmem_dat: DataChannel      = Flipped(new DataChannel)    // flipped I/O
    // write operation
    val w_dmem_add: AddressChannel   = new AddressChannel
    val w_dmem_dat: wDataChannel     = new wDataChannel
}

// Memory-Mapped Slave IF
// Slave :read/Write(IMem)
// Slave :read/Write(Dmem)
class SlaveIf_Inst extends Bundle {
    // IO definition
    // read operation
    val r_imem_add: AddressChannel = Flipped(new AddressChannel) // flipped I/O
    val r_imem_dat: DataChannel = new DataChannel
    // write operation
    val w_imem_add: AddressChannel = Flipped(new AddressChannel) // flipped I/O
    val w_imem_dat: wDataChannel = Flipped(new wDataChannel)
}

class SlaveIf_Data extends Bundle {
    // data Memory
    // IO definition
    val r_dmem_add: AddressChannel   = Flipped(new AddressChannel)
    val r_dmem_dat: DataChannel      = new DataChannel    // flipped I/O
    // write operation
    val w_dmem_add: AddressChannel   = Flipped(new AddressChannel)
    val w_dmem_dat: wDataChannel     = Flipped(new wDataChannel)
}

class TestIf extends Bundle {
    val sw: CtrlSwChannel = new CtrlSwChannel
}