// See README.md for license details.
package core
import chisel3.iotesters
import chisel3.iotesters.ChiselFlatSpec
//noinspection ScalaStyle
class TestCoreAll extends ChiselFlatSpec {
	"rv32ui-p-bltu.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-bltu.hex")
		}) should be (true)
	}
	"rv32ui-p-xori.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-xori.hex")
		}) should be (true)
	}
	"rv32ui-p-blt.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-blt.hex")
		}) should be (true)
	}
	"rv32ui-p-add.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-add.hex")
		}) should be (true)
	}
	"rv32ui-p-and.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-and.hex")
		}) should be (true)
	}
	"rv32ui-p-srli.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-srli.hex")
		}) should be (true)
	}
	"rv32ui-p-sub.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sub.hex")
		}) should be (true)
	}
	"rv32ui-p-sh.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sh.hex")
		}) should be (true)
	}
	"rv32ui-p-srai.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-srai.hex")
		}) should be (true)
	}
	"rv32ui-p-srl.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-srl.hex")
		}) should be (true)
	}
	"rv32ui-p-or.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-or.hex")
		}) should be (true)
	}
	"rv32ui-p-lbu.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-lbu.hex")
		}) should be (true)
	}
	"rv32ui-p-bge.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-bge.hex")
		}) should be (true)
	}
	"rv32ui-p-lhu.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-lhu.hex")
		}) should be (true)
	}
	"rv32ui-p-lh.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-lh.hex")
		}) should be (true)
	}
	"rv32ui-p-jal.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-jal.hex")
		}) should be (true)
	}
	"rv32ui-p-slt.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-slt.hex")
		}) should be (true)
	}
	"rv32ui-p-bne.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-bne.hex")
		}) should be (true)
	}
	"rv32ui-p-sltiu.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sltiu.hex")
		}) should be (true)
	}
	"rv32ui-p-beq.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-beq.hex")
		}) should be (true)
	}
	"rv32ui-p-slli.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-slli.hex")
		}) should be (true)
	}
	"rv32ui-p-slti.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-slti.hex")
		}) should be (true)
	}
	"rv32ui-p-sltu.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sltu.hex")
		}) should be (true)
	}
	"rv32ui-p-fence_i.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-fence_i.hex")
		}) should be (true)
	}
	"rv32ui-p-sb.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sb.hex")
		}) should be (true)
	}
	"rv32ui-p-xor.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-xor.hex")
		}) should be (true)
	}
	"rv32ui-p-andi.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-andi.hex")
		}) should be (true)
	}
	"rv32ui-p-addi.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-addi.hex")
		}) should be (true)
	}
	"rv32ui-p-sw.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sw.hex")
		}) should be (true)
	}
	"rv32ui-p-auipc.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-auipc.hex")
		}) should be (true)
	}
	"rv32ui-p-lui.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-lui.hex")
		}) should be (true)
	}
	"rv32ui-p-simple.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-simple.hex")
		}) should be (true)
	}
	"rv32ui-p-sra.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sra.hex")
		}) should be (true)
	}
	"rv32ui-p-lb.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-lb.hex")
		}) should be (true)
	}
	"rv32ui-p-bgeu.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-bgeu.hex")
		}) should be (true)
	}
	"rv32ui-p-lw.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-lw.hex")
		}) should be (true)
	}
	"rv32ui-p-sll.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-sll.hex")
		}) should be (true)
	}
	"rv32ui-p-jalr.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-jalr.hex")
		}) should be (true)
	}
	"rv32ui-p-ori.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32ui-p-ori.hex")
		}) should be (true)
	}
	"rv32mi-p-mcsr.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-mcsr.hex")
		}) should be (true)
	}
	"rv32mi-p-illegal.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-illegal.hex")
		}) should be (true)
	}
	"rv32mi-p-shamt.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-shamt.hex")
		}) should be (true)
	}
	"rv32mi-p-scall.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-scall.hex")
		}) should be (true)
	}
	"rv32mi-p-ma_addr.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-ma_addr.hex")
		}) should be (true)
	}
	"rv32mi-p-breakpoint.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-breakpoint.hex")
		}) should be (true)
	}
	"rv32mi-p-csr.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-csr.hex")
		}) should be (true)
	}
	"rv32mi-p-ma_fetch.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-ma_fetch.hex")
		}) should be (true)
	}
	"rv32mi-p-sbreak.hex test using Driver.execute" should "be pass test." in {
		iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
			CpuBusTester(c, "src/sw/rv32mi-p-sbreak.hex")
		}) should be (true)
	}
}
