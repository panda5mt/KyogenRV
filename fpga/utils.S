    .global start
start:
    lui sp, 0x00004
    jal main
    j .

    .global dummy
dummy:
    ret

    .global put32
put32:
    sw x11,(x10)
    ret
    