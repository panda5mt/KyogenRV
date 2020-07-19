#!/usr/bin/env python3
# -*- coding: utf8 -*-
import os
import platform
import subprocess

old_path = os.getcwd()
dir_path = os.getcwd() +'/tests/share/riscv-tests/isa/'
test_gen_path = os.getcwd() + '/src/test/scala/core/TestCoreAll.scala'
proc = subprocess.run('rm -rf *.bin *.hex', shell=True, universal_newlines=True, cwd=dir_path)
files = [path for path in os.listdir(dir_path)]
header_text = '// See README.md for license details.\npackage core\n' \
              'import chisel3.iotesters\n' \
              'import chisel3.iotesters.ChiselFlatSpec\n' \
              '//noinspection ScalaStyle\n' \
              'class TestCoreAll extends ChiselFlatSpec {\n'

files_in = [s for s in files if 'rv32ui-p-' in s]  # select rv32ui-p-*.* file
files_in2 = [s for s in files if 'rv32mi-p-' in s] # select rv32mi-p*.* file
files_in.extend(files_in2)
files_in = [s for s in files_in if '.dump' not in s] # exclude *.dump file
# files_in = [rv32mi* and rv32ui* and not in *.dump]


# noinspection PyInterpreter
print('building hex files...\r\n')

#open scala file for write test code
f = open(test_gen_path,'w')
f.write(header_text)

for item in files_in:
    str1='riscv64-unknown-elf-objcopy --gap-fill 0 -O binary '+item+' '+item+".bin"
    if platform.system() == 'Darwin': # macOS?
        str2 = 'god -An -v -tx4 -w4 '+item+'.bin > '+item+'.hex'
    else:   # Linux or WSL?
        str2 = 'od -An -v -tx4 -w4 '+item+'.bin > '+item+'.hex'
    proc = subprocess.run(str1, shell=True, universal_newlines=True, cwd=dir_path)
    proc = subprocess.run(str2, shell=True, universal_newlines=True, cwd=dir_path)
    #print(str1)
    #print(str2)
    code ='\t"'+item+'.hex test using Driver.execute" should "be pass test." in {\n' \
          '\t\tiotesters.Driver.execute(Array(), () => new CpuBus())(testerGen = c => {\n' \
          '\t\t\tCpuBusTester(c, "src/sw/' + item + '.hex", "src/sw/'+ item +'_tester.log")\n' \
                                              '\t\t}) should be (true)\n\t}\n'
    f.write(code)

f.write('}\n')
proc = subprocess.run('rm -rf *.bin', shell=True, universal_newlines=True, cwd=dir_path)
str3 = 'mv *.hex '+old_path+'/src/sw/'
#print(str3)
proc = subprocess.run(str3, shell=True, universal_newlines=True, cwd=dir_path)