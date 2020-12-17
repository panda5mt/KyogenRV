# Blink 8 LEDs on address 0x8000

        lui     x1, 0x08        # x1 = 0x8000
_loop0:
        csrr    x2, time        # x2 = time (oldtime)
        li      x3, 0xAA        # x3 = 0xAA
        sw      x3, 0(x1)       # dmem[x1] = x3 = 0xAA
_loop1:
        csrr    x4, time        # x4 = time (nowtime)
        sub     x5, x4, x2      # x5 = x4 - x2
        lui     x6, 0x2160      # x6 = 0x2160_000
        bltu    x5, x6, _loop1  # if(x5 < x6) then loop
_loop2:
        csrr    x2, time        # x2 = time (oldtime)
        li      x3, 0x55        # x3 = 0x55
        sw      x3, 0(x1)       # dmem[x1] = x3 = 0x55
_loop3:
        csrr    x4, time        # x4 = time (nowtime)
        sub     x5, x4, x2      # x5 = x4 - x2
        lui     x6, 0x2160      # x6 = 0x2160_000
        bltu    x5, x6, _loop3  # if(x5 < x6) then loop
        jal     x0, _loop0
