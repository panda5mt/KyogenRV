
_label1:
        addi    x1,  x0, 0xAA
        addi    x2,  x0, 0xBB      #  WBステージに反映されるのを待てない
        sw      x2, 12(x31)        #  EXステージで ↑ のx2を取り込まないといけない
        lw      x3, 12(x31)        #  x3 => 0xBBになっているべき
        nop
        nop
        nop
