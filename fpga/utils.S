    .section .text.init;
    .globl start
start:
    lui    sp, 0x05
    call main
    j .

    .global dummy
dummy:
    ret

    .global put32
put32:
    sw x11,(x10)
    ret


