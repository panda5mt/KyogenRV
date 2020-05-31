
_label1:
        lui     x1,  0x08           # x1 = 0x08 << 12
        addi    x1,  x1, 0x04       # x1 = x1 + 0x04 = 0x8004
        addi    x2,  x1, 0x00      #  x2 = x1 (WBステージに反映されるのを待てない

        sw      x2, 12(x31)        #  EXステージで ↑ のx2を取り込まないといけない
        lw      x3, 12(x31)        #  x3 => 0x8004になっているべき


        addi    x4, x0, 0xAA       # x4 = 0xAA
        sw      x4, 12(x31)        # dmem[x31 + 12] = x4 = 0xAA
        lw      x5, 12(x31)        # x5 = 0xAA

        beq    x4, x5, _label2
        addi    x10, x0, 0x44
        addi    x11, x0, 0x55



 _label2:
        jal x0, _label2
