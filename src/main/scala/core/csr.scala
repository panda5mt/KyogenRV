// See README.md for license details.

package core

import chisel3._
import chisel3.internal.firrtl.Width
import chisel3.util._

import scala.collection.immutable._

object CSR {
  // commands
  val SZ: Width = 3.W
  val N: UInt = 0.U(SZ)
  val W: UInt = 1.U(SZ)
  val S: UInt = 2.U(SZ)
  val C: UInt = 3.U(SZ)
  val P: UInt = 4.U(SZ)

}


object PRIV {
  val SZ: Width = 2.W
  val U: UInt = 0.U(SZ)  // User Mode
  val S: UInt = 1.U(SZ)  // SV mode
  val H: UInt = 2.U(SZ)  // Reserved (ex-"HV mode")
  val M: UInt = 3.U(SZ)  // Machine Mode
}

object CsrAddr {
  val SZ:         Width = 12.W
  // User-level
  val cycle:      UInt = 0xc00.U(SZ)
  val time:       UInt = 0xc01.U(SZ)
  val instret:    UInt = 0xc02.U(SZ)
  val cycleh:     UInt = 0xc80.U(SZ)
  val timeh:      UInt = 0xc81.U(SZ)
  val instreth:   UInt = 0xc82.U(SZ)

  // Supervisor-level
  val cyclew:     UInt = 0x900.U(SZ)
  val timew:      UInt = 0x901.U(SZ)
  val instretw:   UInt = 0x902.U(SZ)
  val cyclehw:    UInt = 0x980.U(SZ)
  val timehw:     UInt = 0x981.U(SZ)
  val instrethw:  UInt = 0x982.U(SZ)
  
  // Machine-level
  // Infomation reg
  val mcpuid:     UInt = 0xf00.U(SZ)
  val mvendorid:  UInt = 0xf11.U(SZ)
  val marchid:    UInt = 0xf12.U(SZ)
  val mimpid:     UInt = 0xf13.U(SZ)
  val mhartid:    UInt = 0xf14.U(SZ)
  
  // Machine Trap Setup
  val mstatus:    UInt = 0x300.U(SZ)
  val misa:       UInt = 0x301.U(SZ)
  val medeleg:    UInt = 0x302.U(SZ)
  val mideleg:    UInt = 0x303.U(SZ)
  val mie:        UInt = 0x304.U(SZ)
  val mtvec:      UInt = 0x305.U(SZ)

  val mtimecmp:   UInt = 0x321.U(SZ)
  
  // Timers and Counters
  val mtime:      UInt = 0x701.U(SZ)
  val mtimeh:     UInt = 0x741.U(SZ)
  // Machine Trap Handling
  val mscratch:   UInt = 0x340.U(SZ)
  val mepc:       UInt = 0x341.U(SZ)
  val mcause:     UInt = 0x342.U(SZ)
  val mbadaddr:   UInt = 0x343.U(SZ)
  val mip:        UInt = 0x344.U(SZ)

  // HITF
  val mtohost:    UInt = 0x780.U(SZ)
  val mfromhost:  UInt = 0x781.U(SZ)

  val regs: Seq[UInt] = List(
      cycle, time, instret, cycleh, timeh, instreth,
      cyclew, timew, instretw, cyclehw, timehw, instrethw,
      mcpuid, mimpid, mhartid, mtvec, medeleg, mie,
      mtimecmp, mtime, mtimeh, mscratch, mepc, mcause, mbadaddr, mip,
      mtohost, mfromhost, mstatus
  )
}

object Cause {
  val InstAddrMisaligned:   UInt = 0.U
  val IllegalInst:          UInt = 2.U
  val Breakpoint:           UInt = 3.U
  val LoadAddrMisaligned:   UInt = 4.U
  val StoreAddrMisaligned:  UInt = 6.U
  val Ecall:                UInt = 8.U
  val ExtInterrupt:         UInt = 8.U
}

class CsrIO extends Bundle {

  val addr: UInt = Input(UInt(32.W))    // csr_addr
  val in:   UInt = Input(UInt(32.W))    // rs1 or imm_z
  val out:  UInt = Output(UInt(32.W))   // csrdata -> rd
  val cmd:  UInt = Input(UInt(32.W))    // csr_cmd
  val rs1_addr: UInt = Input(UInt(32.W))  // rs1 addr


  // Excpetion
  val interrupt_sig: Bool = Input(Bool())
  val pc:   UInt = Input(UInt(32.W))
  val pc_invalid: Bool = Input(Bool())  // stall || inst_kill_branch || pc === 0.U
  val stall: Bool = Input(Bool())
  val expt: Bool = Output(Bool())
  val evec: UInt = Output(UInt(32.W))
  val epc:  UInt = Output(UInt(32.W))
  val inst: UInt = Input(UInt(32.W))    // RV32I instruction
}

class CSR extends Module {
  val io: CsrIO = IO(new CsrIO)

  // variables
  val wdata: UInt = MuxLookup(io.cmd, 0.U, Seq(
    CSR.W -> io.in,
    CSR.S -> (io.out | io.in),
    CSR.C -> (io.out.asUInt() & (~io.in).asUInt())
  ))
  val csr_addr: UInt = io.addr

  val rs1_addr: UInt = io.rs1_addr

  // user counters
  val time:     UInt = RegInit(0.U(32.W))
  val timeh:    UInt = RegInit(0.U(32.W))
  val cycle:    UInt = RegInit(0.U(32.W))
  val cycleh:   UInt = RegInit(0.U(32.W))
  val instret:  UInt = RegInit(0.U(32.W))
  val instreth: UInt = RegInit(0.U(32.W))
  
  val mcpuid:   UInt = Cat(0.U(2.W) /* RV32I */, 0.U((32-28).W),
    (1 << ('I' - 'A') /* Base ISA */|
      1 << ('U' - 'A') /* User Mode */).U(26.W))
  val mimpid:   UInt = 0.U(32.W) // not implemented
  val mhartid:  UInt = 0.U(32.W) // only one hart
  
  // interrupt enable stack
  val PRV:    UInt = RegInit(PRIV.M)
  val PRV1:   UInt = RegInit(PRIV.M)
  val PRV2:   UInt = 0.U(2.W)
  val PRV3:   UInt = 0.U(2.W)
  val IE:     Bool = RegInit(false.B)
  val IE1:    Bool = RegInit(false.B)
  val IE2:    Bool = false.B
  val IE3:    Bool = false.B

  // virtualization management field
  val VM:       UInt = 0.U(5.W)

  // memory privilege
  val MPRV: Bool = false.B

  // extention context status
  val XS:       UInt = 0.U(2.W)
  val FS:       UInt = 0.U(2.W)
  val SD:       UInt = 0.U(1.W)
  val mstatus:  UInt = Cat(SD, 0.U((32-23).W), VM, MPRV, XS, FS, PRV3, IE3, PRV2, IE2, PRV1, IE1, PRV, IE)
  val mtvec:    UInt = RegInit(PC_INITS.PC_EVEC.U(32.W)) // see constant.scala
  val medeleg:  UInt = 0x0.U(32.W)
  
  // interrupt registers
  val MTIP: Bool = RegInit(false.B)
  val HTIP: Bool = false.B
  val STIP: Bool = false.B

  val MEIE: Bool = RegInit(false.B)
  val MTIE: Bool = RegInit(false.B)
  val HTIE: Bool = false.B
  val STIE: Bool = false.B

  val MEIP: Bool = RegInit(false.B)
  val MSIP: Bool = RegInit(false.B)
  val HSIP: Bool = false.B
  val SSIP: Bool = false.B
  val MSIE: Bool = RegInit(false.B)
  val HSIE: Bool = false.B
  val SSIE: Bool = false.B
  val mip:  UInt = Cat(0.U((32-12).W), MEIP, false.B, false.B, false.B,MTIP, HTIP, STIP, false.B, MSIP, HSIP, SSIP, false.B)
  val mie:  UInt = Cat(0.U((32-12).W), MEIE, false.B, false.B, false.B, MTIE, HTIE, STIE, false.B, MSIE, HSIE, SSIE, false.B)
  
  val mtimecmp:   UInt = Reg(UInt(32.W))
  val mscratch:   UInt = Reg(UInt(32.W))
  
  val mepc:       UInt = Reg(UInt(32.W))
  val mcause:     UInt = Reg(UInt(32.W))
  val mbadaddr:   UInt = Reg(UInt(32.W))
  
  val mtohost:    UInt = RegInit(0.U(32.W))
  val mfromhost:  UInt = Reg(UInt(32.W))

  // count if pc is valid
  val valid_pc: UInt = RegInit(0.U(32.W))

  val csrFile: Seq[(BitPat, UInt)] = Seq(
      BitPat(CsrAddr.cycle)     -> cycle,
      BitPat(CsrAddr.time)      -> time,
      BitPat(CsrAddr.instret)   -> instret,
      BitPat(CsrAddr.cycleh)    -> cycleh,
      BitPat(CsrAddr.timeh)     -> timeh,
      BitPat(CsrAddr.instreth)  -> instreth,
      BitPat(CsrAddr.cyclew)    -> cycle,
      BitPat(CsrAddr.timew)     -> time,
      BitPat(CsrAddr.instretw)  -> instret,
      BitPat(CsrAddr.cyclehw)   -> cycleh,
      BitPat(CsrAddr.timehw)    -> timeh,
      BitPat(CsrAddr.instrethw) -> instreth,
      BitPat(CsrAddr.mcpuid)    -> mcpuid,
      BitPat(CsrAddr.mimpid)    -> mimpid,
      BitPat(CsrAddr.mhartid)   -> mhartid,
      BitPat(CsrAddr.mtvec)     -> mtvec,
      BitPat(CsrAddr.medeleg)   -> medeleg,
      BitPat(CsrAddr.mie)       -> mie,
      BitPat(CsrAddr.mtimecmp)  -> mtimecmp,
      BitPat(CsrAddr.mtime)     -> time,
      BitPat(CsrAddr.mtimeh)    -> timeh,
      BitPat(CsrAddr.mscratch)  -> mscratch,
      BitPat(CsrAddr.mepc)      -> mepc,
      BitPat(CsrAddr.mcause)    -> mcause,
      BitPat(CsrAddr.mbadaddr)  -> mbadaddr,
      BitPat(CsrAddr.mip)       -> mip,
      BitPat(CsrAddr.mstatus)   -> mstatus
  )

  io.out := Lookup(io.addr, 0.U, csrFile).asUInt()

  // Counters
  time := time + 1.U
  when(time.andR) { timeh := timeh + 1.U }
  cycle := cycle + 1.U
  when(cycle.andR) { cycleh := cycleh + 1.U }

//  when (time >= mtimecmp) {
//    MTIP := true.B
//  }

  MEIP := io.interrupt_sig // true => external interrupt

  //noinspection ScalaStyle
  val privValid:  Bool = csr_addr(9, 8) <= PRV
  val privInst:   Bool = io.cmd === CSR.P
  //val isTimerInt: Bool = MTIE && MTIP
  val isExtInt:   Bool = MEIP && MEIE
  val isEcall:    Bool = privInst && !csr_addr(0) && !csr_addr(8)
  val isEbreak:   Bool = privInst &&  csr_addr(0) && !csr_addr(8)
  val wen:        Bool = (io.cmd === CSR.W) || io.cmd(1) && (rs1_addr =/= 0.U)

  val isInstRet: Bool = (io.inst =/= Instructions.NOP) && (!io.expt || isEcall || isEbreak) && !io.stall
  when(isInstRet) { instret := instret + 1.U }
  when(isInstRet && instret.andR) { instreth := instreth + 1.U }


  io.expt := isEcall || isEbreak || isExtInt// exception
  io.evec := mtvec //+ (PRV << 6).asUInt()

  io.epc := mepc

  when(!io.pc_invalid) {
    valid_pc := io.pc >> 2 << 2
  }

  when(!io.stall) {
    when(io.expt) {
      when(isExtInt){
        mepc := valid_pc
      }.otherwise {
        mepc := io.pc >> 2 << 2
      }
      mcause := Mux(isEcall, Cause.Ecall + PRV,
        Mux(isExtInt, (BigInt(1) << (32 - 1)).asUInt | (Cause.ExtInterrupt + PRV).asUInt,
          Mux(isEbreak, Cause.Breakpoint,
            Cause.IllegalInst)))
      PRV := PRIV.M
      IE := false.B
      PRV1 := PRV
      IE1 := IE
      //when(iaddrInvalid || laddrInvalid || saddrInvalid) { mbadaddr := io.addr }
    }.elsewhen(wen) {
      when(csr_addr === CsrAddr.mstatus) {
        PRV1 := wdata(5, 4)
        IE1 := wdata(3)
        //PRV := wdata(2, 1)
        IE := wdata(0)
      }.elsewhen(csr_addr === CsrAddr.mip) {
        MTIP := wdata(7)
        MSIP := wdata(3)
      }.elsewhen(csr_addr === CsrAddr.mie) {
        MEIE := wdata(11)
        MTIE := wdata(7)
        MSIE := wdata(3)
      }.elsewhen(csr_addr === CsrAddr.mtime) {
        time := wdata
      }
      .elsewhen(csr_addr === CsrAddr.mtimeh) {
        timeh := wdata
      }
//      .elsewhen(csr_addr === CsrAddr.mtimecmp) {
//        mtimecmp := wdata
//        MTIP := false.B
//      }
      .elsewhen(csr_addr === CsrAddr.mtvec) {
        mtvec := wdata
      }
      .elsewhen(csr_addr === CsrAddr.mscratch) {
        mscratch := wdata
      }
      .elsewhen(csr_addr === CsrAddr.mepc) {
        mepc := wdata >> 2.U << 2.U
      }
      .elsewhen(csr_addr === CsrAddr.mcause) {
        mcause := wdata & (BigInt(1) << (32 - 1) | 0x0f).U
      } // cause12-16:reserved
      .elsewhen(csr_addr === CsrAddr.mbadaddr) {
        mbadaddr := wdata
      }
      .elsewhen(csr_addr === CsrAddr.mtohost) {
        mtohost := wdata
      }
      .elsewhen(csr_addr === CsrAddr.mfromhost) {
        mfromhost := wdata
      }
      .elsewhen(csr_addr === CsrAddr.cyclew) {
        cycle := wdata
      }
      .elsewhen(csr_addr === CsrAddr.timew) {
        time := wdata
      }
      .elsewhen(csr_addr === CsrAddr.instretw) {
        instret := wdata
      }
      .elsewhen(csr_addr === CsrAddr.cyclehw) {
        cycleh := wdata
      }
      .elsewhen(csr_addr === CsrAddr.timehw) {
        timeh := wdata
      }
      .elsewhen(csr_addr === CsrAddr.instrethw) {
        instreth := wdata
      }
    }
  }
}