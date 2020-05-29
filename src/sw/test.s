_label1:
        addi x13,  x0, 10       # x13 = 10
        addi x14,  x0, 14        # x14 = 14
        addi x15,  x0, 0xDD
        addi x16,  x0, 0xBB  # 書き込まれるのはWBステージ
        nop
        nop
        sw x16, 12(x31)     #   書き込みが発生するのはMEMステージ(wbステージのアドレスがidステージで存在したらストール)
        lw x17, 12(x31)
        nop
        nop
        nop
