#
# kyogenrv(RV32I) startup code
# github.com/panda5mt/KyogenRV/
#
#
    .section .text.init;
    .global _start
_start:
    li      x1, 0x18            # <0x00>
    csrrw   x0, mtvec, x1       # <0x04> : mtvec = <0x18>
    lui     sp, 0x09            # <0x08>
    call    main                # <0x0C>
    j .                         # <0x10>

    .global dummy
dummy:
    ret                         # <0x14>

_expr:
    call __expr                 # <0x18> : exception jump
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
