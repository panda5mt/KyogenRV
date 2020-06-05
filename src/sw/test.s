
_label1:
        lui     x1,  0x08           # x1 = 0x08 << 12
        addi    x1,  x1, 0x04       # x1 = x1 + 0x04 = 0x8004
        addi    x2,  x1, 0x00       #  x2 = x1

        sw      x2, 12(x31)         #  dmem[x31 + 12] = x2 = 0x8004
        lw      x3, 12(x31)         #  x3 = dmem[x31 + 12] => 0x8004


        addi    x4, x0, 0xAA        # x4 = 0xAA
        sw      x4, 12(x31)         # dmem[x31 + 12] = x4 = 0xAA
        lw      x5, 12(x31)         # x5 = dmem[x31 + 12] = 0xAA


        beq     x4, x5,  _label2    # if(x4 == x5) goto _label2
        addi    x10, x0, 0x44
        addi    x11, x0, 0x55

 _label2:
        lw      x6, 12(x31)
        sw      x6, 11(x31)
        nop
        lw      x7, 11(x31)
        jal     x20, _label2

