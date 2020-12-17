# Send 'hello world!' via UART(UART on address 0x8020)
    lui     x1, 0x08
    addi    x1, x1, 0x20    # x1 = 0x8020

    li      x2, 'h'
    jal     x20, _send
    li      x2, 'e'
    jal     x20, _send
    li      x2, 'l'
    jal     x20, _send
    li      x2, 'l'
    jal     x20, _send
    li      x2, 'o'
    jal     x20, _send
    li      x2, ' '
    jal     x20, _send
    li      x2, 'w'
    jal     x20, _send
    li      x2, 'o'
    jal     x20, _send
    li      x2, 'r'
    jal     x20, _send
    li      x2, 'l'
    jal     x20, _send
    li      x2, 'd'
    jal     x20, _send
    li      x2, '!'
    jal     x20, _send
    li      x2, '\r'
    jal     x20, _send
    li      x2, '\n'
    jal     x20, _send

_loop0:
    jal     x0, _loop0

_send:

    nop
_check_status:
    lw      x3, 8(x1) # x3 = status register
    andi    x3,x3,0x20
    beq     zero, x3, _check_status
    sw      x2, 4(x1)
    jalr    x0,  0(x20)



