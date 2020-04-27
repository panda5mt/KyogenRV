package core

import chisel3._
import chisel3.util._
import chisel3.Bool

import chisel3.util.ImplicitConversions._
import scala.collection.mutable.ArrayBuffer

object ScalarOpConstants
{
//************************************
// Control Signals

def Y    = 1.U(1.W)
def N    = 0.U(1.W)
def X    = BitPat("b?")

// PC Select Signal
def PC_4   = 0.U(3.W)  // PC + 4
def PC_BR  = 1.U(3.W)  // branch_target
def PC_J   = 2.U(3.W)  // jump_target
def PC_JR  = 3.U(3.W)  // jump_reg_target
def PC_EXC = 4.U(3.W)  // exception

// Branch Type
def BR_N   = 0.U(4.W)  // Next
def BR_NE  = 1.U(4.W)  // Branch on NotEqual
def BR_EQ  = 2.U(4.W)  // Branch on Equal
def BR_GE  = 3.U(4.W)  // Branch on Greater/Equal
def BR_GEU = 4.U(4.W)  // Branch on Greater/Equal Unsigned
def BR_LT  = 5.U(4.W)  // Branch on Less Than
def BR_LTU = 6.U(4.W)  // Branch on Less Than Unsigned
def BR_J   = 7.U(4.W)  // Jump
def BR_JR  = 8.U(4.W)  // Jump Register
def BR_X   = BitPat("b????")//0.U(4.W)

// RS1 Operand Select Signal
def OP1_RS1 = 0.U(2.W) // Register Source #1
def OP1_IMU = 1.U(2.W) // immediate, U-type
def OP1_IMZ = 2.U(2.W) // Zero-extended rs1 field of inst, for CSRI instructions
def OP1_X   = BitPat("b??")//0.U(2.W)

// RS2 Operand Select Signal
def OP2_RS2 = 0.U(2.W) // Register Source #2
def OP2_IMI = 1.U(2.W) // immediate, I-type
def OP2_IMS = 2.U(2.W) // immediate, S-type
def OP2_PC  = 3.U(2.W) // PC
def OP2_X   = BitPat("b??")//0.U(2.W)

// Register File Write Enable Signal
def REN_0   = "b0".U
def REN_1   = "b1".U
def REN_X   = BitPat("b?")//"b0".U

// Writeback Select Signal
def WB_ALU  = 0.U(2.W)
def WB_MEM  = 1.U(2.W)
def WB_PC4  = 2.U(2.W)
def WB_CSR  = 3.U(2.W)
def WB_X    = BitPat("b??")// 0.U(2.W)

// Memory Function Type (Read,Write,Fence) Signal
def MWR_R   = 0.U(2.W)
def MWR_W   = 1.U(2.W)
def MWR_F   = 2.U(2.W)
def MWR_X   = BitPat("b??") //0.U(2.W)

// Memory Enable Signal
def MEN_0   = "b0".U
def MEN_1   = "b1".U
def MEN_X   =  BitPat("b?")//"b0".U

// Memory Mask Type Signal
def MSK_B   = 0.U(3.W)
def MSK_BU  = 1.U(3.W)
def MSK_H   = 2.U(3.W)
def MSK_HU  = 3.U(3.W)
def MSK_W   = 4.U(3.W)
def MSK_X   =  BitPat("b???") //4.U(3.W)


// Cache Flushes & Sync Primitives
def M_N      = 0.U(3.W)
def M_SI     = 1.U(3.W)   // synch instruction stream
def M_SD     = 2.U(3.W)   // synch data stream
def M_FA     = 3.U(3.W)   // flush all caches
def M_FD     = 4.U(3.W)   // flush data cache

// Memory Functions (read, write, fence)
def MT_READ  = 0.U(2.W)
def MT_WRITE = 1.U(2.W)
def MT_FENCE = 2.U(2.W)

}

object MemoryOpConstants
{
   val MT_SZ = 3.W
   def MT_X  = BitPat("b???")// 0.U(3.W)
   def MT_B  = 1.U(3.W)
   def MT_H  = 2.U(3.W)
   def MT_W  = 3.U(3.W)
   def MT_D  = 4.U(3.W)
   def MT_BU = 5.U(3.W)
   def MT_HU = 6.U(3.W)
   def MT_WU = 7.U(3.W)

   val M_SZ  = 1.W
   def M_X   = "b0".U(1.W)
   def M_XRD = "b0".U(1.W) // int load
   def M_XWR = "b1".U(1.W) // int store


   def DPORT = 0
   def IPORT = 1
}