# sample assemble file


#   _label1:
#       addi  x1,  x0, 1        # x1 = x0 + 1 = 1
#       addi  x2,  x0, 2        # x2 = x0 + 2 = 2
#       addi  x3,  x0, 3        # x3 = x0 + 3 = 3
#       addi  x4,  x0, 4        # x4 = x0 + 4 = 4
#       addi  x5,  x0, 5        # x5 = x0 + 5 = 5
#       addi  x6,  x0, 6        # x6 = x0 + 6 = 6
#       addi  x7,  x6, 7        # x7 = x6 + 7 = 13 (= 0x0D)
#       addi  x8,  x0, 8        # x8 = x0 + 8 = 8
#       jal   x4,  _label4      # x4 => address(_label2), jump _label4
#   _label2:
#       addi  x9, x0, 9         # x9 = 9
#       addi x10, x0, 10        # x10= 0x0A
#       addi x11, x0, 11        # x11= 0x0B
#   _label3:
#       jalr  x0, x5,0          # jump to x5 (= _label5)
#   _label4:
#       addi x12, x0, 12        # x12= 0x0C
#       jalr x5,  x4, 4         # x5 => _label5, jump x4+4 (= _label2+4)
_label5:
    addi x13, x0 ,3         # x13 = 3
    addi x14, x0 ,2         # x14 = 3
    beq  x13, x14, _label6  # if(x13 == x14) jump to label6
    addi x15 ,x0 ,0xAA
    addi x16, x0, 0xBB
_label6:
    jal  x0, _label6        # forever loop
    nop
