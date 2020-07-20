// See README.md for license details.
package core
import chisel3.iotesters
import chisel3.iotesters.ChiselFlatSpec
//noinspection ScalaStyle
class TestCoreAll extends ChiselFlatSpec {
	"rv32ui-p-bltu.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-bltu.hex", "src/sw/rv32ui-p-bltu_tester.log")
		}) should be (true)
	}
	"rv32ui-p-xori.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-xori.hex", "src/sw/rv32ui-p-xori_tester.log")
		}) should be (true)
	}
	"rv32ui-p-blt.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-blt.hex", "src/sw/rv32ui-p-blt_tester.log")
		}) should be (true)
	}
	"rv32ui-p-add.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-add.hex", "src/sw/rv32ui-p-add_tester.log")
		}) should be (true)
	}
	"rv32ui-p-and.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-and.hex", "src/sw/rv32ui-p-and_tester.log")
		}) should be (true)
	}
	"rv32ui-p-srli.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-srli.hex", "src/sw/rv32ui-p-srli_tester.log")
		}) should be (true)
	}
	"rv32ui-p-sub.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sub.hex", "src/sw/rv32ui-p-sub_tester.log")
		}) should be (true)
	}
	"rv32ui-p-sh.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sh.hex", "src/sw/rv32ui-p-sh_tester.log")
		}) should be (true)
	}
	"rv32ui-p-srai.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-srai.hex", "src/sw/rv32ui-p-srai_tester.log")
		}) should be (true)
	}
	"rv32ui-p-srl.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-srl.hex", "src/sw/rv32ui-p-srl_tester.log")
		}) should be (true)
	}
	"rv32ui-p-or.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-or.hex", "src/sw/rv32ui-p-or_tester.log")
		}) should be (true)
	}
	"rv32ui-p-lbu.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-lbu.hex", "src/sw/rv32ui-p-lbu_tester.log")
		}) should be (true)
	}
	"rv32ui-p-bge.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-bge.hex", "src/sw/rv32ui-p-bge_tester.log")
		}) should be (true)
	}
	"rv32ui-p-lhu.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-lhu.hex", "src/sw/rv32ui-p-lhu_tester.log")
		}) should be (true)
	}
	"rv32ui-p-lh.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-lh.hex", "src/sw/rv32ui-p-lh_tester.log")
		}) should be (true)
	}
	"rv32ui-p-jal.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-jal.hex", "src/sw/rv32ui-p-jal_tester.log")
		}) should be (true)
	}
	"rv32ui-p-slt.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-slt.hex", "src/sw/rv32ui-p-slt_tester.log")
		}) should be (true)
	}
	"rv32ui-p-bne.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-bne.hex", "src/sw/rv32ui-p-bne_tester.log")
		}) should be (true)
	}
	"rv32ui-p-sltiu.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sltiu.hex", "src/sw/rv32ui-p-sltiu_tester.log")
		}) should be (true)
	}
	"rv32ui-p-beq.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-beq.hex", "src/sw/rv32ui-p-beq_tester.log")
		}) should be (true)
	}
	"rv32ui-p-slli.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-slli.hex", "src/sw/rv32ui-p-slli_tester.log")
		}) should be (true)
	}
	"rv32ui-p-slti.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-slti.hex", "src/sw/rv32ui-p-slti_tester.log")
		}) should be (true)
	}
	"rv32ui-p-sltu.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sltu.hex", "src/sw/rv32ui-p-sltu_tester.log")
		}) should be (true)
	}
	"rv32ui-p-sb.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sb.hex", "src/sw/rv32ui-p-sb_tester.log")
		}) should be (true)
	}
	"rv32ui-p-xor.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-xor.hex", "src/sw/rv32ui-p-xor_tester.log")
		}) should be (true)
	}
	"rv32ui-p-andi.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-andi.hex", "src/sw/rv32ui-p-andi_tester.log")
		}) should be (true)
	}
	"rv32ui-p-addi.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-addi.hex", "src/sw/rv32ui-p-addi_tester.log")
		}) should be (true)
	}
	"rv32ui-p-sw.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sw.hex", "src/sw/rv32ui-p-sw_tester.log")
		}) should be (true)
	}
	"rv32ui-p-auipc.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-auipc.hex", "src/sw/rv32ui-p-auipc_tester.log")
		}) should be (true)
	}
	"rv32ui-p-lui.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-lui.hex", "src/sw/rv32ui-p-lui_tester.log")
		}) should be (true)
	}
	"rv32ui-p-simple.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-simple.hex", "src/sw/rv32ui-p-simple_tester.log")
		}) should be (true)
	}
	"rv32ui-p-sra.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sra.hex", "src/sw/rv32ui-p-sra_tester.log")
		}) should be (true)
	}
	"rv32ui-p-lb.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-lb.hex", "src/sw/rv32ui-p-lb_tester.log")
		}) should be (true)
	}
	"rv32ui-p-bgeu.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-bgeu.hex", "src/sw/rv32ui-p-bgeu_tester.log")
		}) should be (true)
	}
	"rv32ui-p-lw.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-lw.hex", "src/sw/rv32ui-p-lw_tester.log")
		}) should be (true)
	}
	"rv32ui-p-sll.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sll.hex", "src/sw/rv32ui-p-sll_tester.log")
		}) should be (true)
	}
	"rv32ui-p-jalr.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-jalr.hex", "src/sw/rv32ui-p-jalr_tester.log")
		}) should be (true)
	}
	"rv32ui-p-ori.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-ori.hex", "src/sw/rv32ui-p-ori_tester.log")
		}) should be (true)
	}
	"rv32mi-p-mcsr.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-mcsr.hex", "src/sw/rv32mi-p-mcsr_tester.log")
		}) should be (true)
	}
	"rv32mi-p-illegal.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-illegal.hex", "src/sw/rv32mi-p-illegal_tester.log")
		}) should be (true)
	}
	"rv32mi-p-shamt.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-shamt.hex", "src/sw/rv32mi-p-shamt_tester.log")
		}) should be (true)
	}
	"rv32mi-p-scall.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-scall.hex", "src/sw/rv32mi-p-scall_tester.log")
		}) should be (true)
	}
	"rv32mi-p-ma_addr.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-ma_addr.hex", "src/sw/rv32mi-p-ma_addr_tester.log")
		}) should be (true)
	}
	"rv32mi-p-breakpoint.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-breakpoint.hex", "src/sw/rv32mi-p-breakpoint_tester.log")
		}) should be (true)
	}
	"rv32mi-p-csr.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-csr.hex", "src/sw/rv32mi-p-csr_tester.log")
		}) should be (true)
	}
	"rv32mi-p-ma_fetch.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-ma_fetch.hex", "src/sw/rv32mi-p-ma_fetch_tester.log")
		}) should be (true)
	}
	"rv32mi-p-sbreak.hex tester using iotesters" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-sbreak.hex", "src/sw/rv32mi-p-sbreak_tester.log")
		}) should be (true)
	}
}
