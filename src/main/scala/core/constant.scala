// See README.md for license details.
package core

import chisel3._
import chisel3.util._

object ScalarOpConstants {
   // Control Signals
   def Y:UInt = 1.U(1.W)
   def N:UInt = 0.U(1.W)
   def X:UInt = 0.U(1.W)

   // PC Select Signal
   def PC_4:UInt = 0.U(3.W) // PC + 4
   def PC_BR:UInt = 1.U(3.W) // branch_target
   def PC_J:UInt = 2.U(3.W) // jump_target
   def PC_JR:UInt = 3.U(3.W) // jump_reg_target
   def PC_EXC:UInt = 4.U(3.W) // exception

   // Branch Type
   def BR_N:UInt = 0.U(4.W) // Next
   def BR_NE:UInt = 1.U(4.W) // Branch on NotEqual
   def BR_EQ:UInt = 2.U(4.W) // Branch on Equal
   def BR_GE:UInt = 3.U(4.W) // Branch on Greater/Equal
   def BR_GEU:UInt = 4.U(4.W) // Branch on Greater/Equal Unsigned
   def BR_LT:UInt = 5.U(4.W) // Branch on Less Than
   def BR_LTU:UInt = 6.U(4.W) // Branch on Less Than Unsigned
   def BR_J:UInt = 7.U(4.W) // Jump
   def BR_JR:UInt = 8.U(4.W) // Jump Register
   def BR_X:UInt = 0.U(4.W)

   // RS1 Operand Select Signal
   def OP1_RS1:UInt = 0.U(2.W) // Register Source #1
   def OP1_IMU:UInt = 1.U(2.W) // immediate, U-type
   def OP1_IMZ:UInt = 2.U(2.W) // Zero-extended rs1 field of inst, for CSRI instructions
   def OP1_X:UInt = 0.U(2.W)

   // RS2 Operand Select Signal
   def OP2_RS2:UInt = 0.U(2.W) // Register Source #2
   def OP2_IMI:UInt = 1.U(2.W) // immediate, I-type
   def OP2_IMS:UInt = 2.U(2.W) // immediate, S-type
   def OP2_PC :UInt = 3.U(2.W) // PC
   def OP2_X  :UInt = 0.U(2.W)

   // Register File Write Enable Signal
   def REN_0:UInt = "b0".U
   def REN_1:UInt = "b1".U
   def REN_X:UInt = "b0".U

   // Writeback Select Signal
   def WB_ALU:UInt = 0.U(2.W)
   def WB_MEM:UInt = 1.U(2.W)
   def WB_PC4:UInt = 2.U(2.W)
   def WB_CSR:UInt = 3.U(2.W)
   def WB_X:UInt = 0.U(2.W)// 0.U(2.W)
}


object MemoryOpConstants
{
   // Memory Function Type (Read,Write,Fence) Signal
   def MWR_R  :UInt = 0.U(2.W)
   def MWR_W  :UInt = 1.U(2.W)
   def MWR_F  :UInt = 2.U(2.W)
   def MWR_X: BitPat = BitPat("b??")

   // Memory Enable Signal
   def MEN_0  :UInt = "b0".U
   def MEN_1  :UInt = "b1".U
   def MEN_X: UInt = "b0".U

   // Memory Mask Type Signal
   def MSK_B  :UInt = 0.U(3.W)
   def MSK_BU :UInt = 1.U(3.W)
   def MSK_H  :UInt = 2.U(3.W)
   def MSK_HU :UInt = 3.U(3.W)
   def MSK_W  :UInt = 4.U(3.W)
   def MSK_X: BitPat =  BitPat("b???") //4.U(3.W)


   // Cache Flushes & Sync Primitives
   def M_N     :UInt = 0.U(3.W)
   def M_SI    :UInt = 1.U(3.W)   // synch instruction stream
   def M_SD    :UInt = 2.U(3.W)   // synch data stream
   def M_FA    :UInt = 3.U(3.W)   // flush all caches
   def M_FD    :UInt = 4.U(3.W)   // flush data cache

   // Memory Functions (read, write, fence)
   def MT_READ :UInt = 0.U(2.W)
   def MT_WRITE:UInt = 1.U(2.W)
   def MT_FENCE:UInt = 2.U(2.W)


   val MT_SZ = 3.W
   def MT_X:BitPat = BitPat("b???") // 0.U(3.W)
   def MT_B :UInt = 1.U(3.W)
   def MT_H :UInt = 2.U(3.W)
   def MT_W :UInt = 3.U(3.W)
   def MT_D :UInt = 4.U(3.W)
   def MT_BU:UInt = 5.U(3.W)
   def MT_HU:UInt = 6.U(3.W)
   def MT_WU:UInt = 7.U(3.W)

   val M_SZ  = 1.W
   def M_X  :UInt = "b0".U(1.W)
   def M_XRD:UInt = "b0".U(1.W) // int load
   def M_XWR:UInt = "b1".U(1.W) // int store


   def DPORT  = 0
   def IPORT  = 1
}