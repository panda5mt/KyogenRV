_label0:
        lui     x1, 0x02        # 0x00
        addi    x2, x0, 0xAA    # 0x04
        sw      x2, 0(x1)       # 0x08
        lw      x3, 0(x1)       # 0x0C
        addi    x3, x3, 0x01    # 0x10
        sw      x3, 4(x1)       # 0x14
        lw      x4, 4(x1)       # 0x18
        nop
_label000:
        jal x0, _label000

#        addi    x1, x0, 0x18        # <0x00>
#        csrrw   x0, mtvec, x1       # <0x04> : mtvec = <0x18>
#        lui     x1, 0x01
#        srli    x1, x1, 1
#        csrrw   x0, mie, x1         # enable external interrupt(mie.mtie = 1)
#        jal     x0, _label1         # jump _label1
#
#_label_expc:
#        addi    x2, x0, 0xAA        # <0x18>
#        csrr    x3, mepc            #
#        csrr    x4, mcause          #
#        jal     x0, _label_expc     # <0x24> : loop
#
#_label1:
#        addi    x5,  x0, 0xBB       # <0x28>
#_label2:
#        addi    x6,  x0, 0xCC       # <0x2C>
#        jal     x0, _label2         # <0x30>
#