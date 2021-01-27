    .section .text.init;
    .global _start
_start:
    addi    x1, x0, 0x18        # <0x00>
    csrrw   x0, mtvec, x1       # <0x04> : mtvec = <0x18>
    lui    sp, 0x08
    call main
    j .

    .global dummy
dummy:
    ret

_expr:
    call __expr
    j .
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
