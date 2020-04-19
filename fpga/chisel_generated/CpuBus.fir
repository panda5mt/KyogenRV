;buildInfoPackage: chisel3, version: 3.2.4, scalaVersion: 2.12.10, sbtVersion: 1.3.2
circuit CpuBus : 
  module Cpu : 
    input clock : Clock
    input reset : Reset
    output io : {r_ach : {req : UInt<1>, addr : UInt<32>}, flip r_dch : {ack : UInt<1>, data : UInt<32>}, w_ach : {req : UInt<1>, addr : UInt<32>}, w_dch : {flip ack : UInt<1>, data : UInt<32>}, sw : {flip halt : UInt<1>, flip rw : UInt<1>, addr : UInt<32>, data : UInt<32>, flip wData : UInt<32>, flip wAddr : UInt<32>}}
    
    reg r_addr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 44:26]
    reg r_data : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 45:26]
    reg r_req : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[core.scala 46:26]
    reg r_rw : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 47:26]
    reg r_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 48:26]
    reg w_req : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 50:26]
    reg w_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 51:26]
    reg w_addr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 52:26]
    reg w_data : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 53:26]
    node _T = eq(io.sw.halt, UInt<1>("h00")) @[core.scala 55:22]
    when _T : @[core.scala 55:34]
      node _T_1 = eq(r_ack, UInt<1>("h01")) @[core.scala 56:20]
      when _T_1 : @[core.scala 56:31]
        node _T_2 = add(r_addr, UInt<32>("h04")) @[core.scala 57:30]
        node _T_3 = tail(_T_2, 1) @[core.scala 57:30]
        r_addr <= _T_3 @[core.scala 57:20]
        skip @[core.scala 56:31]
      skip @[core.scala 55:34]
    else : @[core.scala 59:17]
      node _T_4 = eq(io.sw.rw, UInt<1>("h01")) @[core.scala 60:23]
      when _T_4 : @[core.scala 60:34]
        w_addr <= io.sw.wAddr @[core.scala 62:24]
        w_data <= io.sw.wData @[core.scala 63:24]
        w_req <= UInt<1>("h01") @[core.scala 64:24]
        r_addr <= UInt<32>("h00") @[core.scala 65:24]
        skip @[core.scala 60:34]
      skip @[core.scala 59:17]
    io.sw.data <= r_data @[core.scala 69:21]
    io.sw.addr <= r_addr @[core.scala 70:21]
    io.r_ach.addr <= r_addr @[core.scala 72:21]
    io.r_ach.req <= r_req @[core.scala 73:21]
    io.w_ach.addr <= w_addr @[core.scala 76:21]
    io.w_dch.data <= w_data @[core.scala 77:21]
    io.w_ach.req <= w_req @[core.scala 78:21]
    r_ack <= io.r_dch.ack @[core.scala 82:12]
    r_data <= io.r_dch.data @[core.scala 83:12]
    
  module IMem : 
    input clock : Clock
    input reset : Reset
    output io : {flip r_ach : {req : UInt<1>, addr : UInt<32>}, r_dch : {ack : UInt<1>, data : UInt<32>}, flip w_ach : {req : UInt<1>, addr : UInt<32>}, flip w_dch : {flip ack : UInt<1>, data : UInt<32>}}
    
    smem mem : UInt<32>[10485760] @[imem.scala 13:30]
    reg i_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[imem.scala 15:26]
    reg i_req : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[imem.scala 16:26]
    reg w_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[imem.scala 19:26]
    i_req <= io.r_ach.req @[imem.scala 22:21]
    node _T = bits(io.r_ach.addr, 23, 0) @[imem.scala 23:32]
    read mport _T_1 = mem[_T], clock @[imem.scala 23:32]
    io.r_dch.data <= _T_1 @[imem.scala 23:21]
    i_ack <= i_req @[imem.scala 24:21]
    io.r_dch.ack <= i_ack @[imem.scala 25:21]
    node _T_2 = eq(io.w_ach.req, UInt<1>("h01")) @[imem.scala 28:23]
    when _T_2 : @[imem.scala 28:35]
      node _T_3 = bits(io.w_ach.addr, 23, 0)
      write mport _T_4 = mem[_T_3], clock
      _T_4 <= io.w_dch.data
      skip @[imem.scala 28:35]
    io.w_dch.ack <= w_ack @[imem.scala 33:21]
    
  module CpuBus : 
    input clock : Clock
    input reset : UInt<1>
    output io : {sw : {flip halt : UInt<1>, flip rw : UInt<1>, addr : UInt<32>, data : UInt<32>, flip wData : UInt<32>, flip wAddr : UInt<32>}}
    
    reg sw_halt : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[core.scala 94:30]
    reg sw_data : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 95:30]
    reg sw_addr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 96:30]
    reg sw_rw : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 97:30]
    reg sw_wdata : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 98:30]
    reg sw_waddr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 99:30]
    inst cpu of Cpu @[core.scala 102:25]
    cpu.clock <= clock
    cpu.reset <= reset
    inst memory of IMem @[core.scala 103:25]
    memory.clock <= clock
    memory.reset <= reset
    sw_halt <= io.sw.halt @[core.scala 106:17]
    sw_data <= cpu.io.sw.data @[core.scala 107:17]
    sw_addr <= cpu.io.sw.addr @[core.scala 108:17]
    sw_rw <= io.sw.rw @[core.scala 109:17]
    sw_wdata <= io.sw.wData @[core.scala 110:17]
    sw_waddr <= io.sw.wAddr @[core.scala 111:17]
    io.sw.data <= sw_data @[core.scala 113:17]
    cpu.io.sw.halt <= sw_halt @[core.scala 114:21]
    cpu.io.sw.rw <= sw_rw @[core.scala 115:21]
    cpu.io.sw.wData <= sw_wdata @[core.scala 116:21]
    cpu.io.sw.wAddr <= sw_waddr @[core.scala 117:21]
    io.sw.addr <= sw_addr @[core.scala 119:21]
    memory.io.r_ach.req <= cpu.io.r_ach.req @[core.scala 122:26]
    memory.io.r_ach.addr <= cpu.io.r_ach.addr @[core.scala 123:26]
    cpu.io.r_dch.data <= memory.io.r_dch.data @[core.scala 124:25]
    cpu.io.r_dch.ack <= memory.io.r_dch.ack @[core.scala 125:25]
    memory.io.w_ach.req <= cpu.io.w_ach.req @[core.scala 128:29]
    memory.io.w_ach.addr <= cpu.io.w_ach.addr @[core.scala 129:29]
    memory.io.w_dch.data <= cpu.io.w_dch.data @[core.scala 130:29]
    cpu.io.w_dch.ack <= memory.io.w_dch.ack @[core.scala 131:29]
    
