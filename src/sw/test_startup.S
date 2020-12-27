_start:
        lui     sp, 0x8
        jal     ra, _main
        j       .

_dummy:
        nop
        ret

_put32:
        sw      a1,0(a0)
        ret

_main:
        addi    sp,sp,-48 # 7fd0 <_end+0x7f30>
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        li      a1,85
        lui     a0,0x8
        jal     ra,_put32
        sw      zero,-20(s0)
        j       0x5c              # <main+0x40>
        lw      a0,-20(s0)
        jal     ra,_dummy
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
        lw      a4,-20(s0)
        li      a5,1999
        bgeu    a5,a4,0x48 #<main+0x2c>
        li      a1,170
        lui     a0,0x8
        jal     ra,_put32
        sw      zero,-20(s0)
        j       0x90              #<main+0x74>
        lw      a0,-20(s0)
        jal     ra,_dummy
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
        lw      a4,-20(s0)
        li      a5,1999
        bgeu    a5,a4,0x7c #<main+0x60>
        j       0x34 #<main+0x18>
