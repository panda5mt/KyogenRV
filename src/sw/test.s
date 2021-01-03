
        nop                                     #<0x00>
        lui     ra, 0x2                         #<0x04> ra = 0x2000
        addi    ra,ra,0x20                      #<0x08>

_label0:
        lui	sp,0x58213                          #<0x0C>
        addi	sp,sp,152                       #<0x10> 58213098 <_end+0x58211068>
        addi	ra,ra,-3                        #<0x14>
        sw	sp,7(ra)                            #<0x18>
        lui	    tp,0x2                          #<0x1C>
        addi	tp,tp,0x24                      #<0x20> 2024 <tdat10>
        lw	t0,0(tp)                            #<0x24>
        lui	t2,0x58213                          #<0x28>
        addi	t2,t2,152                       #<0x2C> 58213098 <_end+0x58211068>
        li	gp,11                               #<0x30>
        sw      t0,4(tp)
        bne     t0,t2,_fail                     #<0x38>

        lui     x31, 0xA                        #<0x3C> A000
        addi    x31, x31, 0xA0                  #<0x40> a0a0
_OK:
        jal     x0, _OK                         #<0x44>

_fail:

        jal     x0, _fail                       #<0x48>




#    lui     x1, 0x08
#    li      x2, 0xAA
#    sw      x2, 0(x1)
#    lw      x3, 0(x1)
#    addi    x3, x3, 1
#    sw      x3, 0(x1)
#_loop1:
#    jal     x0, _loop1


