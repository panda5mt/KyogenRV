;buildInfoPackage: chisel3, version: 3.2.4, scalaVersion: 2.12.10, sbtVersion: 1.3.2
circuit CpuBus : 
  module Cpu : 
    input clock : Clock
    input reset : Reset
    output io : {r_ach : {req : UInt<1>, addr : UInt<32>}, flip r_dch : {ack : UInt<1>, data : UInt<32>}, w_ach : {req : UInt<1>, addr : UInt<32>}, w_dch : {flip ack : UInt<1>, data : UInt<32>}, sw : {flip halt : UInt<1>, addr : UInt<32>, data : UInt<32>, flip wData : UInt<32>, flip wAddr : UInt<32>}}
    
    reg r_addr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 67:26]
    reg r_data : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 68:26]
    reg r_req : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[core.scala 69:26]
    reg r_rw : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 70:26]
    reg r_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 71:26]
    reg w_req : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[core.scala 73:26]
    reg w_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 74:26]
    reg w_addr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 75:26]
    reg w_data : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 76:26]
    node _T = eq(io.sw.halt, UInt<1>("h00")) @[core.scala 78:22]
    when _T : @[core.scala 78:34]
      node _T_1 = eq(r_ack, UInt<1>("h01")) @[core.scala 79:20]
      when _T_1 : @[core.scala 79:31]
        node _T_2 = add(r_addr, UInt<32>("h04")) @[core.scala 80:30]
        node _T_3 = tail(_T_2, 1) @[core.scala 80:30]
        r_addr <= _T_3 @[core.scala 80:20]
        skip @[core.scala 79:31]
      skip @[core.scala 78:34]
    else : @[core.scala 82:17]
      w_addr <= io.sw.wAddr @[core.scala 85:24]
      w_data <= io.sw.wData @[core.scala 86:24]
      w_req <= UInt<1>("h01") @[core.scala 87:24]
      r_addr <= UInt<32>("h00") @[core.scala 88:24]
      skip @[core.scala 82:17]
    io.sw.data <= r_data @[core.scala 92:21]
    io.sw.addr <= r_addr @[core.scala 93:21]
    io.r_ach.addr <= r_addr @[core.scala 95:21]
    io.r_ach.req <= r_req @[core.scala 96:21]
    io.w_ach.addr <= w_addr @[core.scala 99:21]
    io.w_dch.data <= w_data @[core.scala 100:21]
    io.w_ach.req <= w_req @[core.scala 101:21]
    r_ack <= io.r_dch.ack @[core.scala 105:12]
    r_data <= io.r_dch.data @[core.scala 106:12]
    
  module IMem : 
    input clock : Clock
    input reset : Reset
    output io : {flip r_ach : {req : UInt<1>, addr : UInt<32>}, r_dch : {ack : UInt<1>, data : UInt<32>}, flip w_ach : {req : UInt<1>, addr : UInt<32>}, flip w_dch : {flip ack : UInt<1>, data : UInt<32>}}
    
    cmem mem : UInt<32>[1024] @[imem.scala 14:22]
    reg i_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[imem.scala 16:26]
    reg i_req : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[imem.scala 17:26]
    reg w_ack : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[imem.scala 20:26]
    i_req <= io.r_ach.req @[imem.scala 23:21]
    node _T = bits(io.r_ach.addr, 9, 0) @[imem.scala 24:32]
    read mport _T_1 = mem[_T], clock @[imem.scala 24:32]
    io.r_dch.data <= _T_1 @[imem.scala 24:21]
    i_ack <= i_req @[imem.scala 25:21]
    io.r_dch.ack <= i_ack @[imem.scala 26:21]
    node _T_2 = eq(io.w_ach.req, UInt<1>("h01")) @[imem.scala 29:23]
    when _T_2 : @[imem.scala 29:35]
      node _T_3 = bits(io.w_ach.addr, 9, 0)
      write mport _T_4 = mem[_T_3], clock
      _T_4 <= io.w_dch.data
      skip @[imem.scala 29:35]
    io.w_dch.ack <= w_ack @[imem.scala 34:21]
    
  module CpuBus : 
    input clock : Clock
    input reset : UInt<1>
    output io : {sw : {flip halt : UInt<1>, addr : UInt<32>, data : UInt<32>, flip wData : UInt<32>, flip wAddr : UInt<32>}}
    
    reg sw_halt : UInt<1>, clock with : (reset => (reset, UInt<1>("h01"))) @[core.scala 117:30]
    reg sw_data : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 118:30]
    reg sw_addr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 119:30]
    reg sw_rw : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[core.scala 120:30]
    reg sw_wdata : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 121:30]
    reg sw_waddr : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[core.scala 122:30]
    inst cpu of Cpu @[core.scala 125:25]
    cpu.clock <= clock
    cpu.reset <= reset
    inst memory of IMem @[core.scala 126:25]
    memory.clock <= clock
    memory.reset <= reset
    sw_halt <= io.sw.halt @[core.scala 129:17]
    sw_data <= memory.io.r_dch.data @[core.scala 130:17]
    sw_addr <= memory.io.r_ach.addr @[core.scala 131:17]
    sw_wdata <= io.sw.wData @[core.scala 133:17]
    sw_waddr <= io.sw.wAddr @[core.scala 134:17]
    io.sw.data <= sw_data @[core.scala 136:17]
    io.sw.addr <= sw_addr @[core.scala 137:17]
    cpu.io.sw.halt <= sw_halt @[core.scala 139:21]
    cpu.io.sw.wData <= sw_wdata @[core.scala 141:21]
    cpu.io.sw.wAddr <= sw_waddr @[core.scala 142:21]
    memory.io.r_ach.req <= cpu.io.r_ach.req @[core.scala 146:29]
    memory.io.r_ach.addr <= cpu.io.r_ach.addr @[core.scala 147:29]
    cpu.io.r_dch.data <= memory.io.r_dch.data @[core.scala 148:29]
    cpu.io.r_dch.ack <= memory.io.r_dch.ack @[core.scala 149:29]
    memory.io.w_ach.req <= cpu.io.w_ach.req @[core.scala 152:29]
    memory.io.w_ach.addr <= cpu.io.w_ach.addr @[core.scala 153:29]
    memory.io.w_dch.data <= cpu.io.w_dch.data @[core.scala 154:29]
    cpu.io.w_dch.ack <= memory.io.w_dch.ack @[core.scala 155:29]
    
