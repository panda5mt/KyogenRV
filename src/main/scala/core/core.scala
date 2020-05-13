// See README.md for license details.
package core

import chisel3._
import chisel3.iotesters._
import chisel3.util._
import scala.io.{BufferedSource, Source}

import _root_.core.ScalarOpConstants._
import bus.{HostIf, TestIf}
import mem._



//noinspection ScalaStyle
class Cpu extends Module {
    val io: HostIf = IO(new HostIf)
    
    // initialization
    val pc_cntr: UInt = RegInit(0.U(32.W))    // pc
    val r_data: UInt = RegInit(0.U(32.W))
    val r_req:  Bool = RegInit(true.B)       // fetch signal
    val r_rw:   Bool = RegInit(false.B)
    val r_ack:  Bool = RegInit(false.B)

    val w_req:  Bool = RegInit(true.B)
    val w_ack:  Bool = RegInit(false.B)
    val w_addr: UInt = RegInit(0.U(32.W))
    val w_data: UInt = RegInit(0.U(32.W))

    val next_inst_is_valid: Bool = RegInit(true.B) //

    // ID Module instance
    val idm: IDModule = Module(new IDModule)

    val imm_i:   SInt = ImmGen(IMM_I,idm.io.inst.bits)
    val imm_u:   SInt = ImmGen(IMM_U,idm.io.inst.bits)
    val imm_s:   SInt = ImmGen(IMM_S,idm.io.inst.bits)
    val imm_j:   SInt = ImmGen(IMM_J,idm.io.inst.bits)
    val imm_b:   SInt = ImmGen(IMM_B,idm.io.inst.bits)
    // register (x0 - x31)
    val val_raddr12 = IndexedSeq(idm.io.inst.rs1,idm.io.inst.rs2) // treat as 64bit-Addressed SRAM
    val gram = new RegRAM
    val val_rs: IndexedSeq[UInt] = val_raddr12.map(gram.read _)
    
    // instruction decode
    idm.io.imem := Mux(next_inst_is_valid, r_data, 0.U(32.W)) // if (command.type == branch) next.command = invalid
    val id_ctrl: IntCtrlSigs = Wire(new IntCtrlSigs).decode(idm.io.inst.bits,(new IDecode).table)

    // ALU OP1 selector
    val ex_op1: UInt = MuxLookup(key = id_ctrl.alu_op1, default = 0.U(32.W),
        mapping = Seq(
            OP1_RS1 -> val_rs(0).asUInt(),
            OP1_PC  -> (pc_cntr - 4.U), // PC = pc_cntr-4.U
            OP1_X -> 0.U(32.W)
        )
    )
    // ALU OP2 selector
    val ex_op2: UInt = MuxLookup(key = id_ctrl.alu_op2, default = 0.U(32.W),
        mapping = Seq(
            OP2_RS2 -> val_rs(1).asUInt,
            OP2_IMI -> imm_i.asUInt,
            OP2_IMS -> imm_s.asUInt, // immediate, S-type
            OP2_IMU -> imm_u.asUInt, // immediate, U-type(insts_code[31:12])
            OP2_IMJ -> imm_j.asUInt, // IMM J-type
            OP2_IMZ -> 0.U(32.W), // zero-extended rs1 field, CSRI insts
            OP2_X -> 0.U(32.W)
        )
    )

    val alu: ALU    = Module(new ALU)
    alu.io.alu_op   := id_ctrl.alu_func
    alu.io.op1      := ex_op1
    alu.io.op2      := ex_op2

     // register write back
    val rf_wen: Bool = id_ctrl.rf_wen     // register write enable flag
    val rd_addr:UInt = idm.io.inst.rd    // destination register
    val rd_val: UInt = MuxLookup(id_ctrl.wb_sel, 0.U(32.W),
        Seq(
            WB_ALU -> alu.io.out,
            WB_PC4 -> pc_cntr,           //pc_cntr = pc + 4
            WB_CSR -> 0.U(32.W),
            WB_MEM -> 0.U(32.W),
            WB_X   -> 0.U(32.W)
        )
    )
    when (cond = rf_wen){ gram.write(rd_addr, rd_val) }

//    when (rf_wen === REN_1){ // register write enable?
//        when (rd_addr =/= 0.U && rd_addr < 32.U){
//            rv32i_reg(rd_addr) := rd_val
//        }.otherwise { // rd_addr = 0
//            rv32i_reg(0.U) := 0.U(32.W)
//        }
//    }
    

    // Branch type selector
    val pc_incl: UInt = MuxLookup(key = id_ctrl.br_type, default = 0.U(32.W),
        mapping = Seq(
            BR_N   -> (pc_cntr + 4.U(32.W)), // Next
            BR_NE  -> Mux(val_rs(0) =/= val_rs(1),              rd_val, pc_cntr + 4.U(32.W)),  // Branch on NotEqual
            BR_EQ  -> Mux(val_rs(0) === val_rs(1),              rd_val, pc_cntr + 4.U(32.W)), // Branch on Equal
            BR_GE  -> Mux(val_rs(0) >= val_rs(1),               rd_val, pc_cntr + 4.U(32.W)), // Branch on Greater/Equal
            BR_GEU -> Mux(val_rs(0).asUInt >= val_rs(1).asUInt, rd_val, pc_cntr + 4.U(32.W)), // Branch on Greater/Equal Unsigned
            BR_LT  -> Mux(val_rs(0) < val_rs(1),                rd_val, pc_cntr + 4.U(32.W)), // Branch on Less Than
            BR_LTU -> Mux(val_rs(0).asUInt < val_rs(1).asUInt,  rd_val, pc_cntr + 4.U(32.W)), // Branch on Less Than Unsigned
            BR_JR  -> alu.io.out,//(val_rs(0) + imm_i).asUInt, //JALR: rs1 + imm
            BR_J   -> alu.io.out,//(pc_cntr - 4.U + imm_j.asUInt), //JAL:pc += imm
            BR_X   -> (pc_cntr + 4.U(32.W))//0.U(32.W) //
    ))

    // bubble logic
    next_inst_is_valid := true.B
    switch (id_ctrl.br_type) {

        is( BR_NE ) {
            when(val_rs(0) =/= val_rs(1)) {
                next_inst_is_valid.:=(false.B)} // NEQ = true: bubble next inst & branch
            .otherwise {
                next_inst_is_valid.:=(true.B) }
        }
        is( BR_EQ ) {
            when(val_rs(0) === val_rs(1)) {
                next_inst_is_valid.:=(false.B)}  // EQ = true: bubble next inst & branch
            .otherwise {
                next_inst_is_valid.:=(true.B) }
        }
        is( BR_GE ) {
            when(val_rs(0) > val_rs(1)) {
                next_inst_is_valid.:=(false.B)} // GE = true: bubble next inst & branc
            .otherwise {
                next_inst_is_valid.:=(true.B) }
        }
        is( BR_GEU ) {
            when(val_rs(0).asUInt > val_rs(1).asUInt) {
                next_inst_is_valid.:=(false.B)} // GE = true: bubble next inst & branch
            .otherwise {
                next_inst_is_valid.:=(true.B) }
        }
        is( BR_LT ) {
            when(val_rs(0) < val_rs(1)){
                next_inst_is_valid.:=(false.B)} // LT = true: bubble next inst & branch
            .otherwise {
                next_inst_is_valid.:=(true.B) }
        }
        is( BR_LTU ) {
            when(val_rs(0).asUInt() < val_rs(1).asUInt) {
                next_inst_is_valid.:=(false.B)} // LT = true: bubble next inst & branch
            .otherwise {
                next_inst_is_valid.:=(true.B) }
        }
        is( BR_J  ) { next_inst_is_valid.:=(false.B) }  // JAL
        is( BR_JR ) { next_inst_is_valid.:=(false.B) }  // JALR
    }


    when (io.sw.halt === false.B){
        when(r_ack === true.B){
            w_req   := false.B
            r_req   := r_req
            pc_cntr  := pc_incl // increase or jump program counter
        }.otherwise {
            w_req   := false.B
            r_req   := true.B
            pc_cntr  := pc_cntr//0.U(32.W)
        }
    }.otherwise { // halt mode
        // enable Write Operation
        w_addr := io.sw.w_add //w_addr + 4.U(32.W)
        w_data := io.sw.w_dat
        w_req  := true.B
        pc_cntr := io.sw.w_pc
    }

    // for test
    io.sw.r_dat      := r_data
    io.sw.r_add      := pc_cntr
    io.sw.r_pc      := pc_cntr // program counter

    io.r_imem_add.addr   := pc_cntr
    io.r_imem_add.req    := r_req
    
    // write process
    io.w_imem_add.addr   := w_addr
    io.w_imem_dat.data   := w_data
    io.w_imem_add.req    := w_req
    
    //w_pc    := io.sw.w_pc
    
    // read process
    r_ack  := io.r_imem_dat.ack
    r_data := io.r_imem_dat.data

    // x0 - x31
    val v_radd = IndexedSeq(io.sw.g_add,0.U) // treat as 64bit-Addressed SRAM
    val v_rs: IndexedSeq[UInt] = v_radd.map(gram.read)
    io.sw.g_dat := v_rs(0)
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
    val memory:     IMem = Module(new IMem)
    
    // Connect Test Module
    sw_halt     := io.sw.halt
    sw_data     := memory.io.r_imem_dat.data
    sw_addr     := memory.io.r_imem_add.addr
    
    sw_wdata    := io.sw.w_dat // data to write memory
    sw_waddr    := io.sw.w_add
    sw_gaddr    := io.sw.g_add

    io.sw.r_dat  := sw_data
    io.sw.r_add  := sw_addr
    
    io.sw.g_dat  := cpu.io.sw.g_dat
    io.sw.r_pc  := cpu.io.sw.r_pc

    w_pc        := io.sw.w_pc

    cpu.io.sw.halt := sw_halt
    cpu.io.sw.w_dat := sw_wdata
    cpu.io.sw.w_add := sw_waddr
    cpu.io.sw.g_add := sw_gaddr
    cpu.io.sw.w_pc := w_pc

    // Read memory
    memory.io.r_imem_add.req     <> cpu.io.r_imem_add.req
    memory.io.r_imem_add.addr    <> cpu.io.r_imem_add.addr
    cpu.io.r_imem_dat.data       <> memory.io.r_imem_dat.data
    cpu.io.r_imem_dat.ack        <> memory.io.r_imem_dat.ack

    // write memory
    memory.io.w_imem_add.req     <> cpu.io.w_imem_add.req
    memory.io.w_imem_add.addr    <> cpu.io.w_imem_add.addr
    memory.io.w_imem_dat.data    <> cpu.io.w_imem_dat.data
    cpu.io.w_imem_dat.ack        <> memory.io.w_imem_dat.ack

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
        when(addr =/= 0.U) {
            ram(addr) := data
        }
    }
}

//noinspection ScalaStyle
object kyogenrv extends App {
    chisel3.Driver.execute(args, () => new Cpu())
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
                println(msg = f"write: r_add = 0x$addr%08X, data = 0x$mem%08X")
                step(1)
            }

            step(1)
            println(msg = "---------------------------------------------------------")
            poke(signal = c.io.sw.w_pc, value = 0) // restart pc address
            step(1) // fetch pc
            poke(signal = c.io.sw.halt, value = false.B)
            step(2)

            //for (lp <- memarray.indices by 1){
            for (_ <- 0 until 100 by 1) {

                val a = peek(signal = c.io.sw.r_add)
                val d = peek(signal = c.io.sw.r_dat)
                step(1)
                println(msg = f"read : addr = 0x$a%08X, data = 0x$d%08X") //peek(c.io.sw.data)

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

                println(msg = f"read : x$lp%2d = 0x$d%08X") //peek(c.io.sw.data)
                step(1)
            }
        }
    })
}
