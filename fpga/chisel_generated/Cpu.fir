;buildInfoPackage: chisel3, version: 3.2.4, scalaVersion: 2.12.10, sbtVersion: 1.3.2
circuit Cpu : 
  module IMem : 
    input clock : Clock
    input reset : Reset
    output io : {flip r_ach : {req : UInt<1>, addr : UInt<32>}, r_dch : {ack : UInt<1>, data : UInt<32>}}
    
    smem mem : UInt<32>[256] @[imem.scala 13:30]
    reg i_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[imem.scala 14:26]
    node _T = bits(io.r_ach.addr, 7, 0) @[imem.scala 18:31]
    read mport _T_1 = mem[_T], clock @[imem.scala 18:31]
    io.r_dch.data <= _T_1 @[imem.scala 18:20]
    io.r_dch.ack <= i_ack @[imem.scala 19:20]
    
  module Cpu : 
    input clock : Clock
    input reset : UInt<1>
    output io : {ach : {req : UInt<1>, addr : UInt<32>}, flip dch : {ack : UInt<1>, data : UInt<32>}, sw : {flip halt : UInt<1>, rw : UInt<1>, data : UInt<32>}}
    
    inst memory of IMem @[core.scala 30:24]
    memory.clock <= clock
    memory.reset <= reset
    reg i_addr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 35:26]
    reg i_data : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 36:26]
    reg i_ena : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[core.scala 37:26]
    reg i_rw : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 38:26]
    node _T = eq(io.sw.halt, UInt<1>("h00")) @[core.scala 40:22]
    when _T : @[core.scala 40:34]
      node _T_1 = add(i_addr, UInt<32>("h04")) @[core.scala 42:30]
      node _T_2 = tail(_T_1, 1) @[core.scala 42:30]
      i_addr <= _T_2 @[core.scala 42:20]
      skip @[core.scala 40:34]
    io.sw.data <= i_data @[core.scala 46:17]
    io.sw.rw <= i_rw @[core.scala 47:17]
    io.ach.addr <= i_addr @[core.scala 48:17]
    io.ach.req <= i_ena @[core.scala 49:17]
    i_data <= memory.io.r_dch.data @[core.scala 50:12]
    memory.io.r_ach.req <= io.ach.req @[core.scala 52:26]
    memory.io.r_ach.addr <= io.ach.addr @[core.scala 53:26]
    
