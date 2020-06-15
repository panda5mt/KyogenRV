_label0:
        addi    x1, x0, 0x10
        csrrw   x0, mtvec, x1       # mtvec = <0x10>
        jal     x0, _label1         # jump _label1

_label_expc:                        # <0x10>
        addi    x2, x0, 0xBB        # x2 = 0xBB
        csrr    x3, mepc            # x3 = return address
        jal     x0, _label_expc

_label1:
        addi    x4,  x0, 0x04       #  x2 = 0x04
        ecall                       # <0x20>

_label2:
        jal     x0, _label2         # <0x24>

