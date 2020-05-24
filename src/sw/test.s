# sample assemble file

_start0:
    addi x29, x0, 10    # x29 = x0 + 10 = 10
    addi x31, x29, 0xAA # x31 = x29 + 0xAA = 180 (= 0xB4)
_label1:
    addi  x1,  x0, 1    # x1 = x0 + 1 = 1
    addi  x2,  x0, 2    # x2 = x0 + 2 = 2
    addi  x3,  x0, 3    # x3 = x0 + 3 = 3
    addi  x4,  x0, 4    # x4 = x0 + 4 = 4
    addi  x5,  x0, 5    # x5 = x0 + 5 = 5
    addi  x6,  x0, 6    # x6 = x0 + 6 = 6
    addi  x7,  x6, 7    # x7 = x6 + 7 = 13 (= 0x0D)
    addi  x8,  x0, 8    # x8 = x0 + 8 = 8
    jal   x4,  _label4  # x4 => address(_label2), jump _label4
_label2:
    addi  x9, x0, 9     # x9 = 9
    addi x10, x0, 10    # x10= 0x0A
    addi x11, x0, 11    # x11= 0x0B
_label3:
    jalr  x0, x5,0      # jump to x5 (= _label5)
_label4:
    addi x12, x0, 12      # x12= 0x0C
    jalr x5,  x4, 4      # x5 => _label5, jump x4+4 (= _label2+4)
_label5:
    jal  x0, _label5    # forever loop
    nop
