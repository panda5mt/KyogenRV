;buildInfoPackage: chisel3, version: 3.2.4, scalaVersion: 2.12.10, sbtVersion: 1.3.2
circuit Cpu : 
  module IMem : 
    input clock : Clock
    input reset : Reset
    output io : {flip r_ach : {req : UInt<1>, addr : UInt<32>}, r_dch : {ack : UInt<1>, data : UInt<32>}}
    
    cmem memory : UInt<32>[256] @[imem.scala 13:21]
    reg i_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[imem.scala 14:25]
    node _T = bits(io.r_ach.addr, 7, 0) @[imem.scala 18:29]
    infer mport _T_1 = memory[_T], clock @[imem.scala 18:29]
    io.r_dch.data <= _T_1 @[imem.scala 18:20]
    io.r_dch.ack <= i_ack @[imem.scala 19:20]
    
  module Cpu : 
    input clock : Clock
    input reset : UInt<1>
    output io : {ach : {req : UInt<1>, addr : UInt<32>}, flip dch : {ack : UInt<1>, data : UInt<32>}}
    
    inst memory of IMem @[core.scala 14:24]
    memory.clock <= clock
    memory.reset <= reset
    reg i_addr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 17:26]
    reg i_data : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 18:26]
    reg i_ena : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[core.scala 19:26]
    when io.dch.ack : @[core.scala 22:21]
      node _T = add(i_addr, UInt<32>("h04")) @[core.scala 23:26]
      node _T_1 = tail(_T, 1) @[core.scala 23:26]
      i_addr <= _T_1 @[core.scala 23:16]
      i_data <= io.dch.data @[core.scala 24:16]
      skip @[core.scala 22:21]
    io.ach.addr <= i_addr @[core.scala 28:18]
    io.ach.req <= i_ena @[core.scala 29:18]
    memory.io.r_ach.req <= io.ach.req @[core.scala 32:26]
    memory.io.r_ach.addr <= io.ach.addr @[core.scala 33:26]
    
