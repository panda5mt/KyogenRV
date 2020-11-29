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

hex_in_path = os.getcwd() + '/src/sw/test.hex'
hex_out_path = os.getcwd() + '/fpga/chisel_generated/test_intel.hex'

# intel hex
hex_start_code  = ':'
hex_byte_count  = '04'
hex_start_addr  = 0x0000
hex_record_type = '00'
hex_end_of_file = ':00000001FF'

# noinspection PyInterpreter
print('Convert intel hex ...\r\n')

#open scala file for write test code
fw = open(hex_out_path,'w')
fr = open(hex_in_path,'r')


line = fr.readline()
while line:
    hexdata = line.strip()
    li_hexdata = conv_hexlist(split_n(hexdata,2)) # read hexdata -> list
    li_hexaddr = conv_hexlist(split_n(format(hex_start_addr,'04x'),2))
    checksum = (0 - (int(hex_byte_count) + sum(li_hexaddr) + int(hex_record_type) + sum(li_hexdata))) & 0xff

    wr_hex = hex_start_code+hex_byte_count+format(hex_start_addr,'04x')+hexdata+format(checksum,'02x')+'\n'
    fw.write(wr_hex)

    hex_start_addr = hex_start_addr + 1 #increment address
    line = fr.readline()
fw.write(hex_end_of_file+'\n')
fw.close
fr.close

