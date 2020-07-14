// See README.md for license details.
package core
import chisel3.iotesters
import chisel3.iotesters.ChiselFlatSpec


//noinspection ScalaStyle
class TestCore extends ChiselFlatSpec {
  "Basic test using Driver.execute" should "be used as an alternative way to run specification" in {
    iotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {
      CpuBusTester(c, "src/sw/rv32ui-p-add.hex")
    })should be (true)
  }
}