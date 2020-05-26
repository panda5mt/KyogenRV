# sample assemble file

_label1:
     addi x13,  x0, 10       # x13 = 10
     addi x14,  x0, 4        # x14 = 4
     bge  x13, x14, _label2  # if(x13 >= x14) jump to label2
     addi x15,  x0, 0xAA
     addi x16,  x0, 0xBB

 _label2:
     jal   x1,  _label4      # x1 = label3

 _label3:
     addi x4,  x0, 0xAA
     jal  x0, _label3

 _label4:
     addi x2,  x0, 2
     jalr x3,  x1, -4         # x3 = label5, jump label3

_label5:
    jal  x0, _label5
    nop
