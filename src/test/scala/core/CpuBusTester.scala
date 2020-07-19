// See README.md for license details.
package core
import chisel3.iotesters.PeekPokeTester

import scala.io.{BufferedSource, Source}
import java.util.Calendar

import java.io.{BufferedWriter, FileWriter ,PrintWriter}

case class CpuBusTester(c: CpuBus, hexname: String, logname: String) extends PeekPokeTester(c) {
  // read from binary file
  val s: BufferedSource = Source.fromFile(hexname)
  var buffs: Array[String] = _
  try {
    buffs = s.getLines.toArray
  } finally {
    s.close()
  }
  step(1)
  poke( c.io.sw.halt, value = 1)
  step(1)

  var pw = new PrintWriter(new BufferedWriter(new FileWriter(logname)), true)

  for (addr <- 0 until buffs.length * 4 by 4) {
    val mem_val = buffs(addr / 4).replace(" ", "")
    val mem = Integer.parseUnsignedInt(mem_val, 16)

    poke(signal = c.io.sw.w_add, value = addr)
    step(1)
    poke(signal = c.io.sw.w_dat, value = mem)
    pw.println(f"write: addr = 0x$addr%04X,\tdata = 0x$mem%08X")
    step(1)
  }

  step(1)
  pw.println(f"---------------------------------------------------------")
  poke(signal = c.io.sw.w_pc, value = 0) // restart pc address
  step(1) // fetch pc
  poke(signal = c.io.sw.halt, value = 0)
  step(2)
  pw.println(f"count\tINST\t\t| EX STAGE:rs1 ,\t\t\trs2 ,\t\timm\t\t\t| MEM:ALU out\t| WB:ALU out, rd\t\t\t\tstall")

  //for (lp <- memarray.indices by 1){
  for (lp <- 0 until 800 by 1) {
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
    // if you need fire external interrupt signal uncomment below
    if(lp == 96){
      poke(signal = c.io.sw.w_interrupt_sig, value = 1)
    }
    else{
      poke(signal = c.io.sw.w_interrupt_sig, value = 0)
    }
    step(1)
    pw.println(f"0x$a%04X,\t0x$d%08X\t| x($exraddr1)=>0x$exrs1%08X, x($exraddr2)=>0x$exrs2%08X,\t0x$eximm%08X\t| 0x$memaluo%08X\t| 0x$wbaluo%08X, x($wbaddr%d)\t<= 0x$wbdata%08X, $stallsig%x") //peek(c.io.sw.data)

  }
  step(1)
  pw.println("---------------------------------------------------------")

  poke(signal = c.io.sw.halt, value = 1)
  step(2)
  poke(signal = c.io.sw.g_add, value = 3)                 // select x3 register (gp)
  step(1)
  val d: BigInt = peek(signal = c.io.sw.g_dat)
  step(1)
  if (d == 1) {                                           // if(x3 == 1) then PASS else FAIL
    pw.println(f"$hexname%s PASS: simulation finished.")
  } else {
    pw.println(f"$hexname%s FAIL: simulation finished.")
  }
  pw.println(f"simulation finished at " + Calendar.getInstance().getTime())
  pw.close()
  expect(c.io.sw.g_dat, expected = 1)

}



