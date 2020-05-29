
_label1:
        addi    x15,  x0, 0xDD
        addi    x16,  x0, 0xBB      #  WBステージに反映されるのを待てない
        sw      x16, 12(x31)        #  EXステージで ↑ のx16を取り込まないといけない
        lw      x17, 12(x31)        #  x17 => 0xBBになっているべき
        nop
        nop
        nop
