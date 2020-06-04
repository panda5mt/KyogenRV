// See README.md for license details.
package core

import chisel3._
import chisel3.iotesters._
import chisel3.util._

import chisel3.Clock

import scala.io.{BufferedSource, Source}
import _root_.core.ScalarOpConstants._
import MemoryOpConstants._
import bus.{HostIf, TestIf}
import mem._

//noinspection ScalaStyle
class Cpu extends Module {
    val io: HostIf = IO(new HostIf)

    val invClock: Clock = Wire(new Clock)
    invClock := (~clock.asUInt()(0)).asBool.asClock()
    // ------- START: pipeline registers --------
    // program counter init
    val pc_ini: UInt = "h0000_0000".U(32.W)         // pc start address
    val npc_ini: UInt =  pc_ini + 4.U(32.W)     // pc next
    val inst_nop: UInt = Instructions.NOP             // NOP instruction (addi x0, x0, 0)
    val nop_ctrl: IntCtrlSigs = Wire(new IntCtrlSigs).decode(inst_nop, (new IDecode).table)

    // IF stage

    // ID stage pipeline register
    val id_inst: UInt = RegInit(inst_nop)
    val id_pc: UInt = RegInit( pc_ini)
    val id_npc: UInt = RegInit( npc_ini)

    // EX stage pipeline register
    val ex_pc: UInt = RegInit( pc_ini)
    val ex_npc: UInt = RegInit( npc_ini)
    val ex_inst: UInt = RegInit(inst_nop)
    val ex_ctrl: IntCtrlSigs = RegInit(nop_ctrl)
    val ex_reg_raddr: Vec[UInt] = RegInit(VecInit(0.U(5.W), 0.U(5.W)))
    val ex_reg_waddr: UInt = RegInit(0.U(5.W))
    val ex_rs: Vec[UInt] = RegInit(VecInit(0.U(32.W), 0.U(32.W)))

    // MEM stage pipeline register
    val mem_pc: UInt = RegInit( pc_ini)
    val mem_npc: UInt = RegInit( npc_ini)
    //val mem_inst: UInt = RegInit(inst_nop)
    val mem_ctrl: IntCtrlSigs = RegInit(nop_ctrl)
    val mem_imm: SInt = RegInit(0.S(32.W))
    val mem_reg_waddr: UInt = RegInit(0.U(5.W))
    val mem_rs: Vec[UInt] = RegInit(VecInit(0.U(32.W), 0.U(32.W)))
    val mem_alu_out: UInt = RegInit(0.U(32.W))
    val mem_alu_cmp_out: Bool = RegInit(false.B)

    // WB stage pipeline register
    //val wb_pc: UInt = RegInit( pc_ini)
    val wb_npc: UInt = RegInit( npc_ini)
    val wb_ctrl: IntCtrlSigs = RegInit(nop_ctrl)
    //val wb_reg_raddr: Vec[UInt] = RegInit(VecInit(0.U(5.W), 0.U(5.W)))
    val wb_reg_waddr: UInt = RegInit(0.U(5.W))
    val wb_alu_out: UInt = RegInit(0.U(32.W))
    val wb_dmem_read_data: UInt = RegInit(0.U(32.W))
    val wb_dmem_read_ack: Bool = RegInit(false.B)

    // stall control
    val stall: Bool = Wire(Bool())

    // branch control
    val jump_bubble: Bool = Wire(Bool())
    // ------- END: pipeline registers --------



    // Program Counter 
    val pc_cntr: UInt = RegInit(0.U(32.W))      // pc
    val npc: UInt = pc_cntr + 4.U(32.W)         // next pc counter
    
    //val r_data: UInt = RegInit(0.U(32.W))
    val r_req:  Bool = RegInit(true.B)          // fetch signal
    //val r_rw: Bool = RegInit(false.B)
    val r_ack:  Bool = RegInit(false.B)

    val w_req:  Bool = RegInit(true.B)
    val w_ack:  Bool = RegInit(false.B)
    val w_addr: UInt = RegInit(0.U(32.W))
    val w_data: UInt = RegInit(0.U(32.W))

    io.r_dmem_add.req   := RegInit(false.B)
    io.r_dmem_add.addr   := RegInit(0.U(32.W))

    // -------- START: IF stage -------
    io.r_imem_add.addr   := pc_cntr
    io.r_imem_add.req    := true.B
    // -------- END: IF stage --------



    // -------- START: ID stage --------
    // iotesters: id_pc, id_inst
    when (!stall && !jump_bubble) {
        id_pc := pc_cntr
        id_npc := npc
        id_inst := io.r_imem_dat.data// r_data
    } .elsewhen(jump_bubble) {
        id_pc :=  pc_ini
        id_npc :=  npc_ini
        id_inst := inst_nop
    }

    val idm: IDModule = Module(new IDModule)
    idm.io.imem := id_inst

    // instruction decode
    val id_ctrl: IntCtrlSigs = Wire(new IntCtrlSigs).decode(idm.io.inst.bits,(new IDecode).table)

    // get rs1,rs2,rd address(x0 - x31)
    val id_raddr1: UInt = idm.io.inst.rs1
    val id_raddr2: UInt = idm.io.inst.rs2
    val id_raddr: IndexedSeq[UInt] = IndexedSeq(id_raddr1, id_raddr2) // rs1,2 :treat as 64bit-Addressed SRAM
    val id_waddr: UInt = idm.io.inst.rd // rd

    // read register data
    val reg_f: RegRAM = new RegRAM
    val id_rs: IndexedSeq[UInt] = id_raddr.map(reg_f.read)

    // judge if stall needed
    withClock(invClock) {
        var mem_stall: Bool = RegInit(false.B)
        when (ex_ctrl.mem_wr === M_XRD) {
            mem_stall := true.B
        } .elsewhen(io.r_dmem_dat.ack === true.B) {
            mem_stall := false.B
        }

        stall := ((ex_reg_waddr === id_raddr(0) || ex_reg_waddr === id_raddr(1)) &&
          (ex_ctrl.mem_en === MEN_1) && (ex_ctrl.mem_wr === M_XRD)) || mem_stall
        io.sw.r_stall_sig := stall //mem_ctrl.br_type//
    }
    // -------- END: ID stage --------



    // -------- START: EX Stage --------
    when (!stall && !jump_bubble) {
        ex_pc := id_pc
        ex_npc := id_npc
        ex_ctrl := id_ctrl
        ex_inst := idm.io.inst.bits
        ex_reg_raddr := id_raddr
        ex_reg_waddr := id_waddr
        ex_rs := id_rs
    } .otherwise {
        ex_pc :=  pc_ini
        ex_npc :=  npc_ini
        ex_ctrl := nop_ctrl
        ex_inst := inst_nop
        ex_reg_raddr := VecInit(0.U, 0.U)
        ex_reg_waddr := 0.U
        ex_rs := VecInit(0.U, 0.U)
    }

    val ex_imm: SInt = ImmGen(ex_ctrl.imm_type, ex_inst)

    val ex_reg_rs1_bypass: UInt = MuxCase(ex_rs(0), Seq(
        (ex_reg_raddr(0) =/= 0.U && ex_reg_raddr(0) === mem_reg_waddr && mem_ctrl.rf_wen === REN_1) -> mem_alu_out,
        (ex_reg_raddr(0) =/= 0.U && ex_reg_raddr(0) === wb_reg_waddr && wb_ctrl.rf_wen === REN_1 && wb_ctrl.mem_en === MEN_1) -> io.r_dmem_dat.data,
        (ex_reg_raddr(0) =/= 0.U && ex_reg_raddr(0) === wb_reg_waddr && ex_ctrl.rf_wen === REN_0 && ex_ctrl.mem_en === MEN_1) -> wb_alu_out
    ))
    val ex_reg_rs2_bypass: UInt = MuxCase(ex_rs(1), Seq(
        (ex_reg_raddr(1) =/= 0.U && ex_reg_raddr(1) === mem_reg_waddr && mem_ctrl.rf_wen === REN_1) -> mem_alu_out,
        (ex_reg_raddr(1) =/= 0.U && ex_reg_raddr(1) === wb_reg_waddr && wb_ctrl.rf_wen === REN_1 && wb_ctrl.mem_en === MEN_1) -> io.r_dmem_dat.data,
        (ex_reg_raddr(1) =/= 0.U && ex_reg_raddr(1) === wb_reg_waddr && ex_ctrl.rf_wen === REN_0 && ex_ctrl.mem_en === MEN_1) -> wb_alu_out
    ))

    // ALU OP1 selector
    val ex_op1: UInt = MuxLookup(key = ex_ctrl.alu_op1, default = 0.U(32.W),
        mapping = Seq(
            OP1_RS1 -> ex_reg_rs1_bypass,
            OP1_PC  -> ex_pc, // PC = pc_cntr-4.U
            OP1_X   -> 0.U(32.W)
        )
    )

    // ALU OP2 selector
    val ex_op2: UInt = MuxLookup(key = ex_ctrl.alu_op2, default = 0.U(32.W),
        mapping = Seq(
            OP2_RS2 -> ex_reg_rs2_bypass,
            OP2_IMM -> ex_imm.asUInt, // IMM
            OP2_X -> 0.U(32.W)
        )
    )

    val alu: ALU    = Module(new ALU)
    alu.io.alu_op   := ex_ctrl.alu_func
    alu.io.op1      := ex_op1
    alu.io.op2      := ex_op2

    // iotesters
    io.sw.r_ex_raddr1 := ex_reg_raddr(0)
    io.sw.r_ex_raddr2 := ex_reg_raddr(1)
    io.sw.r_ex_rs1 := ex_reg_rs1_bypass//ex_rs(0)
    io.sw.r_ex_rs2 := ex_reg_rs2_bypass//ex_rs(1)
    io.sw.r_ex_imm := ex_imm.asUInt
    // -------- END: EX Stage --------



    // -------- START: MEM Stage --------
    when (!jump_bubble) {
        mem_pc := ex_pc
        mem_npc := ex_npc
        mem_ctrl := ex_ctrl
        mem_reg_waddr := ex_reg_waddr
        mem_imm := ex_imm
        mem_rs(0) := ex_reg_rs1_bypass
        mem_rs(1) := ex_reg_rs2_bypass
        mem_alu_out := alu.io.out
        mem_alu_cmp_out := alu.io.cmp_out
    } .otherwise {
        mem_pc :=  pc_ini
        mem_npc :=  npc_ini
        mem_ctrl := nop_ctrl
        mem_reg_waddr := 0.U
        mem_imm := 0.S
        mem_rs := VecInit(0.U, 0.U)
        mem_alu_out := 0.U
        mem_alu_cmp_out := false.B
    }

    val r_dmem_data: UInt = RegInit(0.U(32.W))
    r_dmem_data := io.r_dmem_dat.data

    // iotesters
    io.sw.r_mem_alu_out := mem_alu_out

    //dmem connection
    io.w_dmem_add.addr := mem_alu_out
    io.w_dmem_add.req  := (mem_ctrl.mem_wr === M_XWR)

    io.r_dmem_add.addr := mem_alu_out
    io.r_dmem_add.req  := (mem_ctrl.mem_wr === M_XRD)

    //todo: send cpubus data size
    // *************
    io.w_dmem_dat.data := mem_rs(1)



    // bubble logic
    jump_bubble := (
      ((mem_ctrl.br_type > 2.U) && mem_alu_cmp_out) || (mem_ctrl.br_type === BR_JR) || (mem_ctrl.br_type === BR_J)
    )

    // -------- END: MEM Stage --------

    // -------- START: WB Stage --------
    wb_npc := mem_npc
    wb_ctrl := mem_ctrl
    wb_reg_waddr := mem_reg_waddr
    wb_alu_out := mem_alu_out
    wb_dmem_read_ack := io.r_dmem_dat.ack
    wb_dmem_read_data := io.r_dmem_dat.data



    withClock(invClock) {
        val rf_wen: Bool = wb_ctrl.rf_wen // register write enable flag
        val rf_waddr: UInt = wb_reg_waddr
        val rf_wdata: UInt = MuxLookup(wb_ctrl.wb_sel, wb_alu_out, //wb_ctrl.wb_sel, 0.U(32.W),
            Seq(
                WB_ALU -> wb_alu_out,   // wb_alu_out,
                WB_PC4 -> wb_npc,       // pc_cntr = pc + 4
                WB_CSR -> 0.U(32.W),
                WB_MEM -> wb_dmem_read_data //0.U(32.W),
            )
        )

        when(rf_wen === REN_1) {
            reg_f.write(rf_waddr, rf_wdata)
        }

        // iotesters
        io.sw.r_wb_alu_out := wb_alu_out
        io.sw.r_wb_rf_waddr := rf_waddr
        io.sw.r_wb_rf_wdata := rf_wdata
    }

    // -------- END: WB Stage --------


    // -------- START: PC update --------
    when (io.sw.halt === false.B){
        when(!stall) {
            w_req := false.B
            r_req := r_req
            pc_cntr := MuxCase(npc, Seq(
                ((mem_ctrl.br_type > 2.U) && mem_alu_cmp_out) -> (mem_pc + mem_imm.asUInt),
                (mem_ctrl.br_type === BR_J) -> mem_alu_out,//(mem_pc + mem_imm.asUInt),
                (mem_ctrl.br_type === BR_JR) -> mem_alu_out
            ))
        }
    }.otherwise { // halt mode
        // enable Write Operation
        w_addr := io.sw.w_add //w_addr + 4.U(32.W)
        w_data := io.sw.w_dat
        w_req  := true.B
        pc_cntr := io.sw.w_pc


    }

    // for imem test
    io.sw.r_dat  := io.r_imem_dat.data//r_data
    io.sw.r_add  := pc_cntr
    io.sw.r_pc   := id_pc//pc_cntr// program counter




      // write process
    io.w_imem_add.addr   := w_addr
    io.w_imem_dat.data   := w_data
    io.w_imem_add.req    := w_req

    // read process
    r_ack  := io.r_imem_dat.ack
    //r_data := io.r_imem_dat.data

    // x0 - x31
    val v_radd = IndexedSeq(io.sw.g_add,0.U) // treat as 64bit-Addressed SRAM
    when (io.sw.halt === true.B){
        val v_rs: IndexedSeq[UInt] = v_radd.map(reg_f.read)
        io.sw.g_dat := v_rs(0)
    }.otherwise{
        io.sw.g_dat := 0.U
    }
}

class CpuBus extends Module {
    val io: TestIf = IO(new TestIf)
  
    val sw_halt:    Bool = RegInit(true.B)       // input
    val sw_data:    UInt = RegInit(0.U(32.W))    // output
    val sw_addr:    UInt = RegInit(0.U(32.W))    // output
    val sw_rw:      Bool = RegInit(false.B)      // input
    val sw_wdata:   UInt = RegInit(0.U(32.W))    // input
    val sw_waddr:   UInt = RegInit(0.U(32.W))    // input
    
    val w_pc:       UInt = RegInit(0.U(32.W))

    val sw_gaddr:   UInt  = RegInit(0.U(32.W))    // general reg.(x0 to x31)
    
    val cpu:        Cpu = Module(new Cpu)
    val inst_mem:   IMem = Module(new IMem)
    val data_mem:   DMem = Module(new DMem)
    
    // Connect Test Module
    sw_halt     := io.sw.halt
    sw_data     := inst_mem.io.r_imem_dat.data
    sw_addr     := inst_mem.io.r_imem_add.addr

    // imem
    sw_wdata    := io.sw.w_dat // data to write inst_mem
    sw_waddr    := io.sw.w_add
    sw_gaddr    := io.sw.g_add
    io.sw.r_dat := sw_data
    io.sw.r_add := sw_addr

    // dmem
//    io.sw.r_dadd := cpu.io.sw.r_dadd
//    io.sw.r_ddat := cpu.io.sw.r_ddat




    io.sw.g_dat := cpu.io.sw.g_dat
    io.sw.r_pc  := cpu.io.sw.r_pc

    // IOTESTERS: EX Stage
//    io.sw.r_ex_alu_op   := cpu.io.sw.r_ex_alu_op
//    io.sw.r_ex_alu_op1  := cpu.io.sw.r_ex_alu_op1
//    io.sw.r_ex_alu_op2  := cpu.io.sw.r_ex_alu_op2
    io.sw.r_ex_raddr1   := cpu.io.sw.r_ex_raddr1
    io.sw.r_ex_raddr2   := cpu.io.sw.r_ex_raddr2
    io.sw.r_ex_rs1      := cpu.io.sw.r_ex_rs1
    io.sw.r_ex_rs2      := cpu.io.sw.r_ex_rs2
    io.sw.r_ex_imm      := cpu.io.sw.r_ex_imm

    //IOTESTERS: MEM Stage
    io.sw.r_mem_alu_out := cpu.io.sw.r_mem_alu_out

    //IOTESTERS: WB Stage
    io.sw.r_wb_alu_out := cpu.io.sw.r_wb_alu_out
    io.sw.r_wb_rf_wdata := cpu.io.sw.r_wb_rf_wdata
    io.sw.r_wb_rf_waddr := cpu.io.sw.r_wb_rf_waddr

    //IOTESTERS: STALL
    io.sw.r_stall_sig := cpu.io.sw.r_stall_sig

    w_pc        := io.sw.w_pc

    cpu.io.sw.halt  := sw_halt
    cpu.io.sw.w_dat := sw_wdata
    cpu.io.sw.w_add := sw_waddr
    cpu.io.sw.g_add := sw_gaddr
    cpu.io.sw.w_pc  := w_pc



    // Read inst_mem
    inst_mem.io.r_imem_add.req  <> cpu.io.r_imem_add.req
    inst_mem.io.r_imem_add.addr <> cpu.io.r_imem_add.addr
    cpu.io.r_imem_dat.data      <> inst_mem.io.r_imem_dat.data
    cpu.io.r_imem_dat.ack       <> inst_mem.io.r_imem_dat.ack

    // write inst_mem
    inst_mem.io.w_imem_add.req   <> cpu.io.w_imem_add.req
    inst_mem.io.w_imem_add.addr  <> cpu.io.w_imem_add.addr
    inst_mem.io.w_imem_dat.data  <> cpu.io.w_imem_dat.data
    cpu.io.w_imem_dat.ack        <> inst_mem.io.w_imem_dat.ack

    // Read data_mem
    data_mem.io.r_dmem_add.req  <> cpu.io.r_dmem_add.req
    data_mem.io.r_dmem_add.addr <> cpu.io.r_dmem_add.addr
    cpu.io.r_dmem_dat.data      <> data_mem.io.r_dmem_dat.data
    cpu.io.r_dmem_dat.ack       <> data_mem.io.r_dmem_dat.ack

    // write data_mem
    data_mem.io.w_dmem_add.req   <> cpu.io.w_dmem_add.req
    data_mem.io.w_dmem_add.addr  <> cpu.io.w_dmem_add.addr
    data_mem.io.w_dmem_dat.data  <> cpu.io.w_dmem_dat.data
    cpu.io.w_dmem_dat.ack        <> data_mem.io.w_dmem_dat.ack

}
//noinspection ScalaStyle
// x0 - x31
class RegRAM {
    val ram: Mem[UInt] = Mem(32, UInt(32.W))
    // read process
    def read(addr: UInt): UInt = {
        Mux(addr === 0.U, 0.U, ram(addr))
    }
    // write process
    def write(addr:UInt, data:UInt): WhenContext = {
        when((addr > 0.U) && (addr < 32.U)) {
            ram(addr) := data
        }
    }
}

//noinspection ScalaStyle
object kyogenrv extends App {
    val name = "cpu"

    (new stage.ChiselStage).execute(
        Array("-td=fpga/chisel_generated", s"-o=$name"),
        Seq(chisel3.stage.ChiselGeneratorAnnotation(
            () => new Cpu())))
}

object Test extends App {
    iotesters.Driver.execute(args, () => new CpuBus())(testerGen = c => {
        new PeekPokeTester(c) {
            // read from binary file
            val s: BufferedSource = Source.fromFile("src/sw/test.hex")
            var buffs: Array[String] = _
            try {
                buffs = s.getLines.toArray
            } finally {
                s.close()
            }
            step(1)
            poke(signal = c.io.sw.halt, value = true.B)
            step(1)

            for (addr <- 0 until buffs.length * 4 by 4) {
                val mem_val = buffs(addr / 4).replace(" ", "")
                val mem = Integer.parseUnsignedInt(mem_val, 16)

                poke(signal = c.io.sw.w_add, value = addr)
                step(1)
                poke(signal = c.io.sw.w_dat, value = mem)
                println(msg = f"write: addr = 0x$addr%04X,\tdata = 0x$mem%08X")
                step(1)
            }

            step(1)
            println(msg = "---------------------------------------------------------")
            poke(signal = c.io.sw.w_pc, value = 0) // restart pc address
            step(1) // fetch pc
            poke(signal = c.io.sw.halt, value = false.B)
            step(2)
            println(msg = f"count\tINST\t\t| EX STAGE:rs1 ,\t\t\trs2 ,\t\timm\t\t\t| MEM:ALU out\t| WB:ALU out, rd\t\t\t\tstall")

            //for (lp <- memarray.indices by 1){
            for (_ <- 0 until 400 by 1) {

                val a = peek(signal = c.io.sw.r_pc)
                val d = peek(signal = c.io.sw.r_dat)
                val exraddr1 = peek(c.io.sw.r_ex_raddr1)
                val exraddr2 = peek(c.io.sw.r_ex_raddr2)
                val exrs1 = peek(c.io.sw.r_ex_rs1)
                val exrs2 = peek(c.io.sw.r_ex_rs2)
                val eximm = peek(c.io.sw.r_ex_imm)
                val memaluo = peek(c.io.sw.r_mem_alu_out)
                val wbaluo  = peek(c.io.sw.r_wb_alu_out)
                val wbaddr  = peek(c.io.sw.r_wb_rf_waddr)
                val wbdata  = peek(c.io.sw.r_wb_rf_wdata)
                val stallsig = peek(c.io.sw.r_stall_sig)
                step(1)
                println(msg = f"0x$a%04X,\t0x$d%08X\t| x($exraddr1)=>0x$exrs1%08X, x($exraddr2)=>0x$exrs2%08X,\t0x$eximm%08X\t| 0x$memaluo%08X\t| 0x$wbaluo%08X, x($wbaddr%d)\t<= 0x$wbdata%08X, $stallsig%d") //peek(c.io.sw.data)

            }

            step(1)
            println("---------------------------------------------------------")
            poke(signal = c.io.sw.halt, value = true.B)
            step(2)
            for (lp <- 0.U(32.W) to 31.U(32.W) by 1) {

                poke(signal = c.io.sw.g_add, value = lp)
                step(1)
                val d = {
                    peek(signal = c.io.sw.g_dat)
                }

                step(1)
                println(msg = f"read : x$lp%2d = 0x$d%08X ") //peek(c.io.sw.data)

            }
        }
    })
}
