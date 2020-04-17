;buildInfoPackage: chisel3, version: 3.2.4, scalaVersion: 2.12.10, sbtVersion: 1.3.2
circuit Cpu : 
  module IMem : 
    input clock : Clock
    input reset : Reset
    output io : {flip r_ach : {req : UInt<1>, addr : UInt<32>}, r_dch : {ack : UInt<1>, data : UInt<32>}, flip w_ach : {req : UInt<1>, addr : UInt<32>}, flip w_dch : {flip ack : UInt<1>, data : UInt<32>}}
    
    smem mem : UInt<32>[256] @[imem.scala 13:30]
    reg i_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[imem.scala 15:26]
    reg i_req : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[imem.scala 16:26]
    reg w_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[imem.scala 19:26]
    i_req <= io.r_ach.req @[imem.scala 22:21]
    node _T = bits(io.r_ach.addr, 7, 0) @[imem.scala 23:32]
    read mport _T_1 = mem[_T], clock @[imem.scala 23:32]
    io.r_dch.data <= _T_1 @[imem.scala 23:21]
    i_ack <= i_req @[imem.scala 24:21]
    io.r_dch.ack <= i_ack @[imem.scala 25:21]
    node _T_2 = eq(io.w_ach.req, UInt<1>("h01")) @[imem.scala 28:23]
    when _T_2 : @[imem.scala 28:35]
      node _T_3 = bits(io.w_ach.addr, 7, 0)
      write mport _T_4 = mem[_T_3], clock
      _T_4 <= io.w_dch.data
      w_ack <= UInt<1>("h01") @[imem.scala 30:15]
      skip @[imem.scala 28:35]
    io.w_dch.ack <= w_ack @[imem.scala 33:21]
    
  module Cpu : 
    input clock : Clock
    input reset : UInt<1>
    output io : {r_ach : {req : UInt<1>, addr : UInt<32>}, flip r_dch : {ack : UInt<1>, data : UInt<32>}, w_ach : {req : UInt<1>, addr : UInt<32>}, w_dch : {flip ack : UInt<1>, data : UInt<32>}, sw : {flip halt : UInt<1>, flip rw : UInt<1>, data : UInt<32>, flip wData : UInt<32>, flip wAddr : UInt<32>}}
    
    inst memory of IMem @[core.scala 41:24]
    memory.clock <= clock
    memory.reset <= reset
    reg r_addr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 46:26]
    reg r_data : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 47:26]
    reg r_req : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[core.scala 48:26]
    reg r_rw : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 49:26]
    reg r_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 50:26]
    reg w_req : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 52:26]
    reg w_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 53:26]
    reg w_addr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 54:26]
    reg w_data : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 55:26]
    node _T = eq(io.sw.halt, UInt<1>("h00")) @[core.scala 57:22]
    when _T : @[core.scala 57:34]
      node _T_1 = eq(r_ack, UInt<1>("h01")) @[core.scala 58:20]
      when _T_1 : @[core.scala 58:31]
        node _T_2 = add(r_addr, UInt<32>("h04")) @[core.scala 59:30]
        node _T_3 = tail(_T_2, 1) @[core.scala 59:30]
        r_addr <= _T_3 @[core.scala 59:20]
        skip @[core.scala 58:31]
      skip @[core.scala 57:34]
    else : @[core.scala 65:17]
      node _T_4 = eq(io.sw.rw, UInt<1>("h01")) @[core.scala 66:23]
      when _T_4 : @[core.scala 66:34]
        w_addr <= io.sw.wData @[core.scala 68:24]
        w_data <= io.sw.wData @[core.scala 69:24]
        w_req <= UInt<1>("h01") @[core.scala 70:24]
        skip @[core.scala 66:34]
      skip @[core.scala 65:17]
    io.sw.data <= r_data @[core.scala 74:17]
    io.r_ach.addr <= r_addr @[core.scala 75:19]
    io.r_ach.req <= r_req @[core.scala 76:19]
    r_ack <= memory.io.r_dch.ack @[core.scala 79:12]
    r_data <= memory.io.r_dch.data @[core.scala 80:12]
    memory.io.r_ach.req <= io.r_ach.req @[core.scala 82:26]
    memory.io.r_ach.addr <= r_addr @[core.scala 84:26]
    io.w_ach.addr <= w_addr @[core.scala 88:19]
    io.w_dch.data <= w_data @[core.scala 89:19]
    io.w_ach.req <= w_req @[core.scala 90:18]
    w_ack <= memory.io.w_dch.ack @[core.scala 93:11]
    memory.io.w_ach.req <= io.w_ach.req @[core.scala 95:25]
    memory.io.w_ach.addr <= io.w_ach.addr @[core.scala 96:26]
    memory.io.w_dch.data <= io.w_dch.data @[core.scala 97:26]
    
