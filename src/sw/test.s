_label0:
        addi    x1, x0, 0x0C
        csrrw   x0, mtvec, x1       # mtvec = <0x0C>
        jal     x0, _label1         # jump _label1

_label_expc:
        addi    x2, x0, 0xBB        # <0x0C>
        csrr    x3, mepc            # x2 = 0xBB
        csrr    x4, mcause          # x3 = return address
        jal     x0, _label_expc

_label1:
        addi    x4,  x0, 0x04       #  x2 = 0x04
        ecall                       # <0x20>

_label2:
        jal     x0, _label2         # <0x24>

