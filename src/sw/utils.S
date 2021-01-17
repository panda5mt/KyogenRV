    .section .text.init;
    .global _start
_start:
    lui    sp, 0x08
    call main
    j .

    .global dummy
dummy:
    ret

    .global put32
put32:
    sw x11,(x10)
    ret

    .global get32
get32:
    lw x10,(x10)
    ret

    .global get_timel
get_timel:
    csrr    x10, time
    ret

    .global get_timeh
get_timeh:
    csrr    x10, timeh
    ret
