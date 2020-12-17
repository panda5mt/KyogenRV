#!/usr/bin/env python3
# -*- coding: utf8 -*-
import os
import platform
import subprocess


def split_n(text, n):
    return [ text[i*n:i*n+n] for i in range(int(len(text)/n)) ]

def conv_hexlist(list):
    return [int(s, 16) for s in list]

old_path = os.getcwd()
dir_path = os.getcwd() +'/src/sw/'

asm_in_path = os.getcwd() + '/src/sw/'
hex_out_path = os.getcwd() + '/src/sw/'

#proc = subprocess.run('rm -rf *.bin *.hex', shell=True, universal_newlines=True, cwd=hex_out_path)
files = [path for path in os.listdir(dir_path)]
files_in = [s for s in files if '.s' in s]  # select *.s file

print('assemble all *.s files ...\r\n')

#open scala file for write test code

for item in files_in:
    splitname = item.split('.')[0]
    str = 'riscv64-unknown-elf-as -o ' + hex_out_path + splitname + '.elf  -c ' + asm_in_path + item
    proc = subprocess.run(str, shell=True, universal_newlines=True, cwd=asm_in_path)
    str = 'riscv64-unknown-elf-objcopy --gap-fill 0 -O binary ' + hex_out_path + splitname + '.elf ' + hex_out_path + splitname +'.bin'
    proc = subprocess.run(str, shell=True, universal_newlines=True, cwd=asm_in_path)
    if platform.system() == 'Darwin': # macOS?
        str = 'god -An -v -tx4 -w4 '+ hex_out_path + splitname + '.bin > ' + hex_out_path + splitname + '.hex'
    else:   # Linux or WSL?
        str = 'od -An -v -tx4 -w4 '+ hex_out_path + splitname + '.bin > ' + hex_out_path + splitname + '.hex'
    proc = subprocess.run(str, shell=True, universal_newlines=True, cwd=asm_in_path)


print('Generated non-intel hex files on '+hex_out_path+'\r\n')