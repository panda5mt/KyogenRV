#!/usr/bin/env python3
# -*- coding: utf8 -*-
import os
import platform
import subprocess

old_path = os.getcwd()
dir_path = os.getcwd() +'/tests/share/riscv-tests/isa/'
proc = subprocess.run('rm -rf *.bin *.hex', shell=True, text=True, cwd=dir_path)
files = [path for path in os.listdir(dir_path)]

files_in = [s for s in files if 'rv32ui' in s]  # select rv32ui*.* file
files_in2 = [s for s in files if 'rv32mi' in s] # select rv32mi*.* file
files_in.extend(files_in2)
files_in = [s for s in files_in if '.dump' not in s] # exclude *.dump file
# files_in = [rv32mi* and rv32ui* and not in *.dump]


for item in files_in:
    str1='riscv64-unknown-elf-objcopy --gap-fill 0 -O binary '+item+' '+item+".bin"
    if platform.system() == 'Darwin': # macOS?
        str2 = 'god -An -v -tx4 -w4 '+item+'.bin > '+item+'.hex'
    else:   # Linux or WSL?
        str2 = 'od -An -v -tx4 -w4 '+item+'.bin > '+item+'.hex'
    proc = subprocess.run(str1, shell=True, text=True, cwd=dir_path)
    proc = subprocess.run(str2, shell=True, text=True, cwd=dir_path)
    print(str1)
    print(str2)

proc = subprocess.run('rm -rf *.bin', shell=True, text=True, cwd=dir_path)
str3 = 'mv *.hex '+old_path+'/src/sw/'
print(str3)
proc = subprocess.run(str3, shell=True, text=True, cwd=dir_path)