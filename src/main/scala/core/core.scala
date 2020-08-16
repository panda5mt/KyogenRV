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
class KyogenRVCpu extends Module {
    val io: HostIf = IO(new HostIf)

    val invClock: Clock = Wire(new Clock)
    invClock := (~clock.asUInt()(0)).asBool.asClock() // Clock reversed
    def risingEdge(x: Bool): Bool = x && !RegNext(x)

    // ------- START: pipeline registers --------
    // program counter init
    val pc_ini: UInt = PC_INITS.PC_START.U(32.W) // pc start address
    val npc_ini: UInt = pc_ini + 4.U(32.W) // pc next
    val inst_nop: UInt = Instructions.NOP // NOP instruction (addi x0, x0, 0)
    val nop_ctrl: IntCtrlSigs = Wire(new IntCtrlSigs).decode(inst_nop, (new IDecode).table)

    // IF stage pipeline register
    // -> none

    // ID stage pipeline register
    val id_inst: UInt = RegInit(inst_nop)
    val id_pc: UInt = RegInit(pc_ini)
    val id_npc: UInt = RegInit(npc_ini)
    //val id_csr_addr: UInt = RegInit(0.U)

    // EX stage pipeline register
    val ex_pc: UInt = RegInit(pc_ini)
    val ex_npc: UInt = RegInit(npc_ini)
    val ex_inst: UInt = RegInit(inst_nop)
    val ex_ctrl: IntCtrlSigs = RegInit(nop_ctrl)
    val ex_reg_raddr: Vec[UInt] = RegInit(VecInit(0.U(5.W), 0.U(5.W)))
    val ex_reg_waddr: UInt = RegInit(0.U(5.W))
    val ex_rs: Vec[UInt] = RegInit(VecInit(0.U(32.W), 0.U(32.W)))
    val ex_csr_addr: UInt = RegInit(0.U(32.W))
    val ex_csr_cmd: UInt = RegInit(0.U(32.W))
    val ex_b_check: Bool = RegInit(false.B) // branch check
    val ex_j_check: Bool = RegInit(false.B) // jump check

    // MEM stage pipeline register
    val mem_pc: UInt = RegInit(pc_ini)
    val mem_npc: UInt = RegInit(npc_ini)
    val mem_ctrl: IntCtrlSigs = RegInit(nop_ctrl)
    val mem_imm: SInt = RegInit(0.S(32.W))
    val mem_reg_waddr: UInt = RegInit(0.U(5.W))
    val mem_rs: Vec[UInt] = RegInit(VecInit(0.U(32.W), 0.U(32.W)))
    val mem_alu_out: UInt = RegInit(0.U(32.W))
    val mem_alu_cmp_out: Bool = RegInit(false.B)
    val mem_csr_addr: UInt = RegInit(0.U(32.W))
    val mem_csr_data: UInt = RegInit(0.U(32.W))

    // WB stage pipeline register
    val wb_npc: UInt = RegInit(npc_ini)
    val wb_ctrl: IntCtrlSigs = RegInit(nop_ctrl)
    val wb_reg_waddr: UInt = RegInit(0.U(5.W))
    val wb_alu_out: UInt = RegInit(0.U(32.W))
    val wb_dmem_read_data: UInt = RegInit(0.U(32.W))
    val wb_dmem_read_ack: Bool = RegInit(false.B)
    val wb_csr_addr: UInt = RegInit(0.U(32.W))
    val wb_csr_data: UInt = RegInit(0.U(32.W))

    // stall control
    val stall: Bool = Wire(Bool())
    //val csr_stall: Bool = Wire(Bool())

    // branch control
    val inst_kill: Bool = Wire(Bool())
    val inst_kill_branch: Bool = Wire(Bool())

    // waitrequest control
    val waitrequest: Bool = RegInit(false.B)

    // ------- END: pipeline registers --------

    // Program Counter 
    val pc_cntr: UInt = RegInit(0.U(32.W)) // pc
    val npc: UInt = pc_cntr + 4.U(32.W) // next pc counter

    //val r_data: UInt = RegInit(0.U(32.W))
    val r_req: Bool = RegInit(true.B) // fetch signal
    //val r_rw: Bool = RegInit(false.B)
    //val r_ack: Bool = RegInit(false.B)

    val w_req: Bool = RegInit(true.B)
    val w_ack: Bool = RegInit(false.B)
    val w_addr: UInt = RegInit(0.U(32.W))
    val w_data: UInt = RegInit(0.U(32.W))

    //io.r_dmem_dat.req := RegInit(false.B)
    io.dmem_add.addr := RegInit(0.U(32.W))


    // -------- START: IF stage -------
    //io.r_imem_add.addr := pc_cntr

    val imem_read_sig: Bool = RegNext(!io.w_imem_dat.req, false.B)
    io.r_imem_dat.req := imem_read_sig

    //delay_stall is "cheat" logic to ready memory mapped logic.
    // stall 3 or 4 clock after reset.
    val delay_stall: UInt = RegInit(0.U(2.W))
    when(imem_read_sig === true.B) {
        when(delay_stall =/= 3.U) {
            delay_stall := delay_stall + 1.U
        }
    }.otherwise {
        delay_stall := 0.U(2.W)
    }


    // -------- END: IF stage --------

    //val id_valid = (io.r_imem_dat.ack)

    // -------- START: ID stage --------
    // iotesters: id_pc, id_inst
    when(!stall && !inst_kill) {
        id_pc := pc_cntr
        id_npc := npc
        id_inst := io.r_imem_dat.data
    }.elsewhen(inst_kill) {
        id_pc := pc_ini
        id_npc := npc_ini
        id_inst := inst_nop
    }

    val idm: IDModule = Module(new IDModule)
    idm.io.imem := id_inst


    // instruction decode
    val id_ctrl: IntCtrlSigs = Wire(new IntCtrlSigs).decode(idm.io.inst.bits, (new IDecode).table)

    // get rs1,rs2,rd address(x0 - x31)
    val id_raddr1: UInt = idm.io.inst.rs1
    val id_raddr2: UInt = idm.io.inst.rs2
    val id_raddr: IndexedSeq[UInt] = IndexedSeq(id_raddr1, id_raddr2) // rs1,2 :treat as 64bit-Addressed SRAM
    val id_waddr: UInt = idm.io.inst.rd // rd
    val id_csr_addr: UInt = idm.io.inst.csr // csr address

    // read register data
    val reg_f: RegRAM = new RegRAM
    val id_rs: IndexedSeq[UInt] = id_raddr.map(reg_f.read)

    // program counter check
    val pc_invalid: Bool = inst_kill_branch || (ex_pc === pc_ini)

    // external interrupt signal
    val interrupt_sig: Bool = RegInit(false.B)
    interrupt_sig := io.sw.w_interrupt_sig

    val csr: CSR = Module(new CSR)

    // judge if stall needed
    withClock(invClock) {
        val mem_stall: Bool = RegInit(false.B)
        when(mem_ctrl.mem_wr === M_XRD) {
            mem_stall := true.B
        }.elsewhen(wb_dmem_read_ack === true.B) {
            mem_stall := false.B
        }

        //waitrequest := io.sw.w_waitrequest_sig

        stall := ((ex_reg_waddr === id_raddr(0) || ex_reg_waddr === id_raddr(1)) &&
          (ex_ctrl.mem_wr === M_XRD)) || mem_stall || (delay_stall =/= 3.U) || io.sw.w_waitrequest_sig

        io.sw.r_stall_sig := stall

    }
    // -------- END: ID stage --------


    // -------- START: EX Stage --------
    when(!stall && !inst_kill) {
        ex_pc := id_pc
        ex_npc := id_npc
        ex_ctrl := id_ctrl
        ex_inst := idm.io.inst.bits
        ex_reg_raddr := id_raddr
        ex_reg_waddr := id_waddr
        ex_rs := id_rs
        ex_csr_addr := id_csr_addr
        ex_csr_cmd := id_ctrl.csr_cmd
        ex_j_check := (id_ctrl.br_type === BR_J) || (id_ctrl.br_type === BR_JR)
        ex_b_check := (id_ctrl.br_type > 3.U)
    }.otherwise {
        ex_pc := pc_ini
        ex_npc := npc_ini
        ex_ctrl := nop_ctrl
        ex_inst := inst_nop
        ex_reg_raddr := VecInit(0.U, 0.U)
        ex_reg_waddr := 0.U
        ex_rs := VecInit(0.U, 0.U)
        ex_csr_addr := 0.U
        ex_csr_cmd := 0.U
        ex_j_check := false.B
        ex_b_check := false.B
    }

    val ex_imm: SInt = ImmGen(ex_ctrl.imm_type, ex_inst)
    // forwarding logic
    val ex_reg_rs1_bypass: UInt = Wire(UInt(32.W))
    val ex_reg_rs2_bypass: UInt = Wire(UInt(32.W))
    val ex_op1: UInt = Wire(UInt(32.W))
    val ex_op2: UInt = Wire(UInt(32.W))
    val alu: ALU = Module(new ALU)

    ex_reg_rs1_bypass := MuxCase(ex_rs(0), Seq(
        (ex_reg_raddr(0) =/= 0.U && ex_reg_raddr(0) === mem_reg_waddr && mem_ctrl.csr_cmd =/= CSR.N) -> mem_csr_data,
        (ex_reg_raddr(0) =/= 0.U && ex_reg_raddr(0) === mem_reg_waddr && mem_ctrl.rf_wen === REN_1) -> mem_alu_out,
        (ex_reg_raddr(0) =/= 0.U && ex_reg_raddr(0) === wb_reg_waddr && wb_ctrl.rf_wen === REN_1 && wb_ctrl.mem_en === MEN_1 && wb_ctrl.csr_cmd === CSR.N) -> io.r_dmem_dat.data,
        (ex_reg_raddr(0) =/= 0.U && ex_reg_raddr(0) === wb_reg_waddr && wb_ctrl.rf_wen === REN_1 && wb_ctrl.mem_en === MEN_0 && wb_ctrl.csr_cmd === CSR.N) -> wb_alu_out,
        (ex_reg_raddr(0) =/= 0.U && ex_reg_raddr(0) === wb_reg_waddr && ex_ctrl.rf_wen === REN_0 && ex_ctrl.mem_en === MEN_1) -> wb_alu_out,
        (ex_reg_raddr(0) =/= 0.U && ex_reg_raddr(0) === wb_reg_waddr && wb_ctrl.rf_wen === REN_1 && wb_ctrl.csr_cmd =/= CSR.N) -> wb_csr_data


    ))
    ex_reg_rs2_bypass := MuxCase(ex_rs(1), Seq(
        (ex_reg_raddr(1) =/= 0.U && ex_reg_raddr(1) === mem_reg_waddr && mem_ctrl.csr_cmd =/= CSR.N) -> mem_csr_data,
        (ex_reg_raddr(1) =/= 0.U && ex_reg_raddr(1) === mem_reg_waddr && mem_ctrl.rf_wen === REN_1) -> mem_alu_out,
        (ex_reg_raddr(1) =/= 0.U && ex_reg_raddr(1) === wb_reg_waddr && wb_ctrl.rf_wen === REN_1 && wb_ctrl.mem_en === MEN_1 && wb_ctrl.csr_cmd === CSR.N) -> io.r_dmem_dat.data,
        (ex_reg_raddr(1) =/= 0.U && ex_reg_raddr(1) === wb_reg_waddr && wb_ctrl.rf_wen === REN_1 && wb_ctrl.mem_en === MEN_0 && wb_ctrl.csr_cmd === CSR.N) -> wb_alu_out,
        (ex_reg_raddr(1) =/= 0.U && ex_reg_raddr(1) === wb_reg_waddr && ex_ctrl.rf_wen === REN_0 && ex_ctrl.mem_en === MEN_1) -> wb_alu_out,
        (ex_reg_raddr(1) =/= 0.U && ex_reg_raddr(1) === wb_reg_waddr && wb_ctrl.rf_wen === REN_1 && wb_ctrl.csr_cmd =/= CSR.N) -> wb_csr_data
    ))

    // ALU OP1 selector
    ex_op1 := MuxCase(0.U(32.W), Seq(
        (ex_ctrl.alu_op1 === OP1_RS1)   -> ex_reg_rs1_bypass,
        (ex_ctrl.alu_op1 === OP1_PC)    -> (ex_pc - 4.U), // PC = pc_cntr-4.U
        (ex_ctrl.alu_op1 === OP1_X)     -> 0.U(32.W)
    ))

    // ALU OP2 selector
    ex_op2 := MuxCase(0.U(32.W), Seq(
        (ex_ctrl.alu_op2 === OP2_RS2) -> ex_reg_rs2_bypass,
        (ex_ctrl.alu_op2 === OP2_IMM) -> ex_imm.asUInt, // IMM
        (ex_ctrl.alu_op2 ===OP2_X) -> 0.U(32.W)
    ))

    // ALU
    alu.io.alu_op := ex_ctrl.alu_func
    alu.io.op1 := ex_op1
    alu.io.op2 := ex_op2

    // CSR
    val csr_in: UInt = Mux(ex_ctrl.imm_type === IMM_Z, ex_imm.asUInt(),
        Mux(ex_reg_raddr(0) === mem_reg_waddr, Mux(mem_ctrl.csr_cmd =/= CSR.N, mem_csr_data, mem_alu_out),// todo: mem_alu_out -> (mem_)rf_wdata
            Mux(ex_reg_raddr(0) === wb_reg_waddr, Mux(wb_ctrl.csr_cmd =/= CSR.N, wb_csr_data, wb_alu_out),// todo: wb_alu_out -> (wb_)rf_wdata
                ex_reg_rs1_bypass.asUInt())
        )
    )
    //val csr_in: UInt = Mux(ex_ctrl.imm_type === IMM_Z, ex_imm.asUInt(),ex_reg_rs1_bypass)


    csr.io.pc           := ex_pc
    csr.io.addr         := ex_csr_addr
    csr.io.cmd          := ex_csr_cmd
    csr.io.in           := csr_in
    csr.io.inst         := ex_inst
    csr.io.mem_wr       := ex_ctrl.mem_wr
    csr.io.mask_type    := ex_ctrl.mask_type
    csr.io.alu_op1      := ex_op1
    csr.io.alu_op2      := ex_op2
    csr.io.legal        := (ex_ctrl.legal === true.B)
    csr.io.rs1_addr     := ex_inst(19, 15) //ex_rs(0)
    csr.io.stall        := stall
    csr.io.pc_invalid   := pc_invalid
    csr.io.j_check     := ex_j_check
    csr.io.b_check     := ex_b_check
    csr.io.interrupt_sig:= interrupt_sig
    //csr_stall ((ex_reg_waddr === id_raddr(0) || ex_reg_waddr === id_raddr(1)) && (ex_ctrl.csr_cmd =/= CSR.N)) && !csr.io.expt

    // iotesters
    io.sw.r_ex_raddr1   := ex_reg_raddr(0)
    io.sw.r_ex_raddr2   := ex_reg_raddr(1)
    io.sw.r_ex_rs1      := ex_reg_rs1_bypass//ex_rs(0)
    io.sw.r_ex_rs2      := ex_reg_rs2_bypass//ex_rs(1)
    io.sw.r_ex_imm      := ex_imm.asUInt
    // -------- END: EX Stage --------

    // -------- START: MEM Stage --------
    when (!inst_kill) {
        mem_pc          := ex_pc
        mem_npc         := ex_npc
        mem_ctrl        := ex_ctrl
        mem_reg_waddr   := ex_reg_waddr
        mem_imm         := ex_imm
        mem_rs(0)       := ex_reg_rs1_bypass
        mem_rs(1)       := ex_reg_rs2_bypass
        mem_alu_out     := alu.io.out
        mem_alu_cmp_out := alu.io.cmp_out
        mem_csr_addr    := ex_csr_addr
        mem_csr_data    := csr.io.out

    } .otherwise {
        mem_pc          :=  pc_ini
        mem_npc         :=  npc_ini
        mem_ctrl        := nop_ctrl
        mem_reg_waddr   := 0.U
        mem_imm         := 0.S
        mem_rs          := VecInit(0.U, 0.U)
        mem_alu_out     := 0.U
        mem_alu_cmp_out := false.B
        mem_csr_addr    := 0.U
        mem_csr_data    := 0.U
    }

    // iotesters
    io.sw.r_mem_alu_out := mem_alu_out

    //dmem connection
    when (io.sw.halt === false.B) { // CPU active
        //io.w_dmem_add.addr          := mem_alu_out
        io.dmem_add.addr            := mem_alu_out
        io.w_dmem_dat.req           := (mem_ctrl.mem_wr === M_XWR)
        io.w_dmem_dat.data          := DontCare
        io.r_dmem_dat.req           := (mem_ctrl.mem_wr === M_XRD)

    }.otherwise{    // CPU halt
        // dmem connection
        io.dmem_add.addr          := io.sw.w_add
        io.w_dmem_dat.data          := io.sw.w_dat
        io.w_dmem_dat.req           := true.B
        io.w_dmem_dat.byteenable    := 15.U
        //io.r_dmem_add.addr          := 0.U
        io.r_dmem_dat.req           := false.B

    }

    // send bus write size
    io.w_dmem_dat.byteenable := DontCare
    //  mem_rs(1)
    when(mem_ctrl.mem_wr === M_XWR) {
        when(mem_ctrl.mask_type === MT_B) { // byte write
            switch(mem_alu_out(1, 0)){
                is("b00".U){
                    io.w_dmem_dat.byteenable := "b0001".U
                    io.w_dmem_dat.data := mem_rs(1)
                }
                is("b01".U){
                    io.w_dmem_dat.byteenable := "b0010".U
                    io.w_dmem_dat.data := mem_rs(1) << 8.U
                }
                is("b10".U){
                    io.w_dmem_dat.byteenable := "b0100".U
                    io.w_dmem_dat.data := mem_rs(1) << 16.U
                }
                is("b11".U){
                    io.w_dmem_dat.byteenable := "b1000".U
                    io.w_dmem_dat.data := mem_rs(1) << 24.U
                }
            }
        }.elsewhen(mem_ctrl.mask_type === MT_H) {
            switch(mem_alu_out(1, 0)){
                is("b00".U){
                    io.w_dmem_dat.byteenable := "b0011".U
                    io.w_dmem_dat.data := mem_rs(1)
                }
                is("b10".U){
                    io.w_dmem_dat.byteenable := "b1100".U
                    io.w_dmem_dat.data := (mem_rs(1) << 16.U)
                }
            }
        }.otherwise { // MT_W
            io.w_dmem_dat.byteenable := "b1111".U
            io.w_dmem_dat.data := mem_rs(1)
        }
    }.otherwise{
        io.w_dmem_dat.byteenable    := 15.U
    }

    // bubble logic
    inst_kill_branch := (
      ((mem_ctrl.br_type > 3.U) && mem_alu_cmp_out) || // branch
        (mem_ctrl.br_type === BR_JR) || // jalr
        (mem_ctrl.br_type === BR_J) || // jal
        (mem_ctrl.br_type === BR_RET) // mret / sret
      )
    inst_kill := (inst_kill_branch || csr.io.expt)
    // -------- END: MEM Stage --------

    // -------- START: WB Stage --------
    wb_npc := mem_npc
    wb_ctrl := mem_ctrl
    wb_reg_waddr := mem_reg_waddr
    wb_alu_out := mem_alu_out
    wb_dmem_read_ack := io.r_dmem_dat.ack
    //wb_dmem_read_data := io.r_dmem_dat.data
    wb_csr_addr := mem_csr_addr
    wb_csr_data := mem_csr_data


    when(mem_ctrl.mem_wr === M_XRD) {
        when(mem_ctrl.mask_type === MT_B) { // byte read
            switch(mem_alu_out(1, 0)){
                is("b00".U){ wb_dmem_read_data := Cat(Fill(24, io.r_dmem_dat.data(7)), io.r_dmem_dat.data( 7, 0)) }
                is("b01".U){ wb_dmem_read_data := Cat(Fill(24, io.r_dmem_dat.data(15)),io.r_dmem_dat.data(15, 8)) }
                is("b10".U){ wb_dmem_read_data := Cat(Fill(24, io.r_dmem_dat.data(23)),io.r_dmem_dat.data(23,16)) }
                is("b11".U){ wb_dmem_read_data := Cat(Fill(24, io.r_dmem_dat.data(31)),io.r_dmem_dat.data(31,24)) }
            }
        }.elsewhen(mem_ctrl.mask_type === MT_BU) { // byte read unsigned
            switch(mem_alu_out(1, 0)){
                is("b00".U){ wb_dmem_read_data := Cat(0.U(24.W), io.r_dmem_dat.data( 7, 0)) }
                is("b01".U){ wb_dmem_read_data := Cat(0.U(24.W), io.r_dmem_dat.data(15, 8)) }
                is("b10".U){ wb_dmem_read_data := Cat(0.U(24.W), io.r_dmem_dat.data(23,16)) }
                is("b11".U){ wb_dmem_read_data := Cat(0.U(24.W), io.r_dmem_dat.data(31,24)) }
            }
        }.elsewhen(mem_ctrl.mask_type === MT_H) {
            switch(mem_alu_out(1, 0)){
                is("b00".U){ wb_dmem_read_data := Cat(Fill(16, io.r_dmem_dat.data(15)), io.r_dmem_dat.data( 15, 0)) }
                is("b10".U){ wb_dmem_read_data := Cat(Fill(16, io.r_dmem_dat.data(31)), io.r_dmem_dat.data( 31, 16)) }
                // others
                is("b01".U){ wb_dmem_read_data := 0.U }
                is("b11".U){ wb_dmem_read_data := 0.U }
            }
        }.elsewhen(mem_ctrl.mask_type === MT_HU) {
            switch(mem_alu_out(1, 0)){
                is("b00".U){ wb_dmem_read_data := Cat(0.U(16.W), io.r_dmem_dat.data( 15, 0 )) }
                is("b10".U){ wb_dmem_read_data := Cat(0.U(16.W), io.r_dmem_dat.data( 31, 16)) }
                // others
                is("b01".U){ wb_dmem_read_data := 0.U }
                is("b11".U){ wb_dmem_read_data := 0.U }
            }
        }.otherwise {
            wb_dmem_read_data := io.r_dmem_dat.data
        }
    }.otherwise {
        wb_dmem_read_data := io.r_dmem_dat.data
    }



    withClock(invClock) {
        val rf_wen: Bool = wb_ctrl.rf_wen // register write enable flag
        val rf_waddr: UInt = wb_reg_waddr
        val rf_wdata: UInt = MuxCase(wb_alu_out, Seq(
            (wb_ctrl.wb_sel === WB_ALU) -> wb_alu_out,   // wb_alu_out,
            (wb_ctrl.wb_sel === WB_PC4) -> wb_npc,       // pc_cntr = pc + 4
            (wb_ctrl.wb_sel === WB_CSR) -> wb_csr_data,
            (wb_ctrl.wb_sel === WB_MEM) -> wb_dmem_read_data //0.U(32.W),
        ))

        when(rf_wen === REN_1) {
            reg_f.write(rf_waddr, rf_wdata)
        }

        // iotesters
        io.sw.r_wb_alu_out  := wb_alu_out
        io.sw.r_wb_rf_waddr := rf_waddr
        io.sw.r_wb_rf_wdata := rf_wdata
    }
    // -------- END: WB Stage --------


    // -------- START: PC update --------
    when(io.sw.halt === false.B) {
        w_req := false.B
        when(!stall) {
            //r_req := r_req
            pc_cntr := MuxCase(npc, Seq(
                csr.io.expt -> csr.io.evec,
                (mem_ctrl.br_type === BR_RET) -> csr.io.epc,
                ((mem_ctrl.br_type > 3.U) && mem_alu_cmp_out) -> (mem_pc + mem_imm.asUInt),
                (mem_ctrl.br_type === BR_J) -> mem_alu_out,
                (mem_ctrl.br_type === BR_JR) -> mem_alu_out
            ))
        }
    }.otherwise { // halt mode
        // enable imem Write Operation
        w_addr := io.sw.w_add //w_addr + 4.U(32.W)
        w_data := io.sw.w_dat
        w_req := true.B
        pc_cntr := io.sw.w_pc
    }


    // for imem test
    io.sw.r_dat  := io.r_imem_dat.data
    io.sw.r_add  := pc_cntr
    io.sw.r_pc   := id_pc//pc_cntr      // program counter


    // address update
    when(w_req){    // write request
        io.imem_add.addr    := w_addr
    }.otherwise{
        io.imem_add.addr    := pc_cntr
    }

    // write process
    io.w_imem_dat.data   := w_data
    io.w_imem_dat.req    := w_req
    io.w_imem_dat.byteenable := 15.U

    // read process
    //r_ack  := io.r_imem_dat.ack
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
    
    val cpu:    KyogenRVCpu = Module(new KyogenRVCpu)
    val imem:   IMem = Module(new IMem)
    val dmem:   DMem = Module(new DMem)
    
    // Connect Test Module
    sw_halt     := io.sw.halt
    sw_data     := imem.io.r_imem_dat.data
    sw_addr     := imem.io.imem_add.addr

    // imem
    sw_wdata    := io.sw.w_dat // data to write imem
    sw_waddr    := io.sw.w_add
    sw_gaddr    := io.sw.g_add
    io.sw.r_dat := sw_data
    io.sw.r_add := sw_addr

    // dmem
    //    io.sw.r_dadd := cpu.io.sw.r_dadd
    //    io.sw.r_ddat := cpu.io.sw.r_ddat

    io.sw.g_dat <> cpu.io.sw.g_dat
    io.sw.r_pc  <> cpu.io.sw.r_pc

    // IOTESTERS: EX Stage
    io.sw.r_ex_raddr1   <> cpu.io.sw.r_ex_raddr1
    io.sw.r_ex_raddr2   <> cpu.io.sw.r_ex_raddr2
    io.sw.r_ex_rs1      <> cpu.io.sw.r_ex_rs1
    io.sw.r_ex_rs2      <> cpu.io.sw.r_ex_rs2
    io.sw.r_ex_imm      <> cpu.io.sw.r_ex_imm

    //IOTESTERS: MEM Stage
    io.sw.r_mem_alu_out <> cpu.io.sw.r_mem_alu_out

    //IOTESTERS: WB Stage
    io.sw.r_wb_alu_out  <> cpu.io.sw.r_wb_alu_out
    io.sw.r_wb_rf_wdata <> cpu.io.sw.r_wb_rf_wdata
    io.sw.r_wb_rf_waddr <> cpu.io.sw.r_wb_rf_waddr

    //IOTESTERS: STALL
    io.sw.r_stall_sig <> cpu.io.sw.r_stall_sig

    //IOTESTERS: External Interrupt Signal
    cpu.io.sw.w_interrupt_sig <> io.sw.w_interrupt_sig

    // WAITREQUEST
    cpu.io.sw.w_waitrequest_sig <> io.sw.w_waitrequest_sig

    w_pc        := io.sw.w_pc

    cpu.io.sw.halt  <> sw_halt
    cpu.io.sw.w_dat <> sw_wdata
    cpu.io.sw.w_add <> sw_waddr
    cpu.io.sw.g_add <> sw_gaddr
    cpu.io.sw.w_pc  := w_pc


    // imem address connection
    imem.io.imem_add.addr           <> cpu.io.imem_add.addr

    // Read imem
    imem.io.r_imem_dat.req          <> cpu.io.r_imem_dat.req
    cpu.io.r_imem_dat.data          <> imem.io.r_imem_dat.data
    cpu.io.r_imem_dat.ack           <> imem.io.r_imem_dat.ack

    // write imem
    imem.io.w_imem_dat.req          <> cpu.io.w_imem_dat.req
    imem.io.w_imem_dat.data         <> cpu.io.w_imem_dat.data
    cpu.io.w_imem_dat.ack           <> imem.io.w_imem_dat.ack
    cpu.io.w_imem_dat.byteenable    <> imem.io.w_imem_dat.byteenable

    // Read dmem
    dmem.io.r_dmem_dat.req          <> cpu.io.r_dmem_dat.req
    dmem.io.dmem_add.addr           <> cpu.io.dmem_add.addr
    cpu.io.r_dmem_dat.data          <> dmem.io.r_dmem_dat.data
    cpu.io.r_dmem_dat.ack           <> dmem.io.r_dmem_dat.ack

    // write dmem
    dmem.io.w_dmem_dat.req          <> cpu.io.w_dmem_dat.req
    dmem.io.w_dmem_dat.data         <> cpu.io.w_dmem_dat.data
    cpu.io.w_dmem_dat.ack           <> dmem.io.w_dmem_dat.ack
    cpu.io.w_dmem_dat.byteenable    <> dmem.io.w_dmem_dat.byteenable

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
    val name = "KyogenRVCpu"

    (new stage.ChiselStage).execute(
        Array("-td=fpga/chisel_generated", s"-o=$name"),
        Seq(chisel3.stage.ChiselGeneratorAnnotation(
            () => new KyogenRVCpu())))
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
            poke(c.io.sw.w_waitrequest_sig, false.B)
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

            // external interrupt signal(true = rising edge, false = off)
            poke(signal = c.io.sw.w_interrupt_sig, value = false.B)

            // about 1000 cycle, we can finish 'riscv-tests'.
            // change parameters on your another projects.
            for (lp <- 0 until 1000 by 1) {
                val a           = peek(signal = c.io.sw.r_pc)   // pc count
                val d           = peek(signal = c.io.sw.r_dat)  // instruction
                val exraddr1    = peek(c.io.sw.r_ex_raddr1)     // rs1 address
                val exraddr2    = peek(c.io.sw.r_ex_raddr2)     // rs2 address
                val exrs1       = peek(c.io.sw.r_ex_rs1)        // rs1 data
                val exrs2       = peek(c.io.sw.r_ex_rs2)        // rs2 data
                val eximm       = peek(c.io.sw.r_ex_imm)        // imm
                val memaluo     = peek(c.io.sw.r_mem_alu_out)   // alu(MEM stage)
                val wbaluo      = peek(c.io.sw.r_wb_alu_out)    // alu(WB stage)
                val wbaddr      = peek(c.io.sw.r_wb_rf_waddr)   // write-back rd address
                val wbdata      = peek(c.io.sw.r_wb_rf_wdata)   // write-back rd data
                val stallsig    = peek(c.io.sw.r_stall_sig)     // stall signal
                // if you need fire external interrupt signal uncomment below
                if(lp == 96){
                    poke(signal = c.io.sw.w_interrupt_sig, value = true.B)
                }
                else{
                    poke(signal = c.io.sw.w_interrupt_sig, value = false.B)
                }

                step(1)
                println(msg = f"0x$a%04X,\t0x$d%08X\t| x($exraddr1)=>0x$exrs1%08X, x($exraddr2)=>0x$exrs2%08X,\t0x$eximm%08X\t| 0x$memaluo%08X\t| 0x$wbaluo%08X, x($wbaddr%d)\t<= 0x$wbdata%08X, $stallsig%x") //peek(c.io.sw.data)

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
