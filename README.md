The Simple RISC-V KyogenRV(響玄RV)
=======================
## 5-Stage Pipelined RV32I written in Chisel.
##### 日本語のREADMEは[こちら](README_J.md)
- Arch:RV32I
- Privilege : only M-mode 
    - User-Level ISA Version 2.2
    - Privileged ISA Version 1.11
- Interrupt:External
- Pipelines: 5-stage(IF/ID/EX/MEM/WB)
- Written: in Chisel-lang v.3.3 + Makefile

### I.Usage
#### 1.Simulation
```
git clone http://github.com/panda5mt/KyogenRV  
cd KyogenRV/
make clean
make test
```
#### 2.Simulating with riscv-tests
```
git clone http://github.com/panda5mt/KyogenRV  
```
clone from riscv-tests
```
git clone https://github.com/riscv/riscv-tests
cd riscv-tests
git submodule update --init --recursive
```
then modify linker script
```
nano env/p/link.ld
```
change start address of '.text' section to start 0x00000000

```
SECTIONS
{
  . = 0x00000000;   # -> change this 
  .text.init : { *(.text.init) }
  . = ALIGN(0x1000);
  .tohost : { *(.tohost) }
  . = ALIGN(0x1000);
  .text : { *(.text) }
  . = ALIGN(0x1000);
  .data : { *(.data) }
  .bss : { *(.bss) }
  _end = .;
}
```
save link.d and make riscv-tests
```
autoconf
./configure --prefix=<your-kyogenRVs-root-dir>/tests/
make
make install
cd ../
```

```
cd KyogenRV/
make clean
make riscv-tests
```
#### 3.Generate Verilog
```
git clone http://github.com/panda5mt/KyogenRV  
cd KyogenRV/
make clean
make hdl
```
##### The following instructions is written for who want to explore this "KyogenRV" RV32I design step by step. 
##### Otherwise, please clone the latest from GitHub. 
### II.Basically Logic 
#### 1.Instruction Fetch Stage(IF)  
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.2 --depth 1 
cd KyogenRV/
make test
```
#### 2.Instruction Decode Stage(ID) and Integer ALU
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.9 --depth 1 
cd KyogenRV/
make test
```
#### 3.Branch (PC update)
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.10.3 --depth 1 
cd KyogenRV/
```

write asm file and save to <code>[src/sw/test.s](src/sw/test.s)</code>
then build as follows 

```
make asm
```
you'll get <code>[src/sw/test.hex](src/sw/test.hex)</code>
then build test module in chisel project as follows
```
make test
```

#### 4.Multi-staged pipeline (5-staged-pipeline)
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.10.10 --depth 1 
cd KyogenRV/
```

write asm file and save to <code>[src/sw/test.s](src/sw/test.s)</code>
then build as follows 

```
make clean
make asm
```
you'll get <code>[src/sw/test.hex](src/sw/test.hex)</code>
then build test module in chisel project as follows
```
make test
```
when you modified <code>[src/sw/test.hex](src/sw/test.hex)</code>, just type as follows
```
make test
```
so makefile scan test.hex is changed and re-assemble then build chisel project.

#### 5. Added Stage-Stall and Stage-fowardings
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.10.15 --depth 1 
cd KyogenRV/
```

write asm file and save to <code>[src/sw/test.s](src/sw/test.s)</code>
then build as follows 

```
make clean
make asm
```
you'll get <code>[src/sw/test.hex](src/sw/test.hex)</code>
then build test module in chisel project as follows
```
make test
```
when you modified <code>[src/sw/test.hex](src/sw/test.hex)</code>, just type as follows
```
make test
```
so makefile scan test.hex is changed and re-assemble then build chisel project.

#### 6. Added Exception and External Interrupt
please git clone latest one. 