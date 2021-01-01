        li      x13, 0xAA
        lui     x12, 0x02
        nop
        sw      x13, 0(x12)
        nop
        nop
        nop


_label0:
        nop
        auipc	ra,0x2  # a4 = x14
        addi	ra,ra,-0x20      # 2000 <begin_signature>
        lw	    a4,0(ra)
_label1:
        jal x0, _label1




#    lui     x1, 0x08
#    li      x2, 0xAA
#    sw      x2, 0(x1)
#    lw      x3, 0(x1)
#    addi    x3, x3, 1
#    sw      x3, 0(x1)
#_loop1:
#    jal     x0, _loop1


