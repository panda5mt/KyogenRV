    .section .text.init;
    .globl _start
_start:
    lui    sp, 0x07
    call main
    j .

    .global dummy
dummy:
    ret

    .global put32
put32:
    sw x11,(x10)
    ret


