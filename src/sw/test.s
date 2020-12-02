#_label0:
#        addi    x1, x0, 0x18        # <0x00>
#        csrrw   x0, mtvec, x1       # <0x04> : mtvec = <0x18>
#        lui     x1, 0x01
#        srli    x1, x1, 1
#        csrrw   x0, mie, x1         # enable external interrupt(mie.mtie = 1)
#        jal     x0, _label1         # jump _label1

#_label_expc:
#        addi    x2, x0, 0xAA        # <0x18>
#        csrr    x3, mepc            #
#        csrr    x4, mcause          #
#        jal     x0, _label_expc     # <0x24> : loop

#_label1:
#        addi    x5,  x0, 0xBB       # <0x28>
#_label2:
#        addi    x6,  x0, 0xCC       # <0x2C>
#        jal     x0, _label2         # <0x30>

###########
#        lui     x1, 0x02        # x1=0x2000
#        li      x2, 0xAA        # x2 = 0xAA
#        sw      x2, 0(x1)       # dmem[0x2000] = 0xAA
#        lw      x3, 0(x1)       # x3 = dmem[0x2000]
#        addi    x3, x3, 1       # x3 = x3 + 1
#        sw      x3, 0(x1)       # dmem[0x2000] = x3
#_loop:
#        jal     x0, _loop       # loop

        li      x3,     2           # <0x00>
        li      x1,     0           # <0x04>
        li      x2,     1           # <0x08>
        bltu    x1,     x2, _loop2  # <0x0C>
        bne     x0,     x3, _fail   # <0x10>
 _loop1:
        bne     x0,     x3, _next   # <0x14>
 _loop2:
        bltu    x1,     x2, _loop1  # <0x18>
        bne     x0,     x3, _fail   # <0x1c>

_next:
        li      x4,     0x1AA       # <0x20>
_fail:
        jal     x0,     _fail       # <0x24>

