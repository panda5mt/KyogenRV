KyogenRV(響玄RV):The Simple RISC-V for intel FPGA
=======================
## 5-Stage Pipelined RV32I written in Chisel.
##### 日本語のREADMEは[こちら](README_J.md)
- Arch:RV32I
- Privilege : only M-mode 
    - User-Level ISA Version 2.2
    - Privileged ISA Version 1.11
- Interrupt:External
- CPU Bus: Intel Avalon-MM Interface
- Pipelines: 5-stage(IF/ID/EX/MEM/WB)
- Written: in Chisel-lang v.3.4 + Makefile

## I.Usage
#### 0.using with intel FPGA

The standard environment assumption is using Cyclone10LP(10CL025YU256C8G).

##### Recommended development environment
- Cross development environment: Environment that satisfies all of the following conditions
  - An environment running Windows 10/WSL2
  - Running Quartus Prime Lite v.20.1.1 or higher
  - A scala/sbt environment must be available.
  - Pyhton 3.7 or higher is required.
- FPGA requirements: Devices that satisfied one of the following requirements
  - Cyclone 10LP (device with 10CL010 or more logic elements)
  - An intel FPGA with at least 1-block PLL, at least 7000 LEs of logic elements, and at least 1-KiB of On-Chip RAM
##### Preparing the riscv-toolchain
```
git clone https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain
./configure --prefix=/opt/riscv --with-arch=rv32i 
sudo make
```
##### Install KyogenRV and rebuild FPGA logic related
```
cd -
git clone http://github.com/panda5mt/KyogenRV  
cd KyogenRV/
make sdk
```
##### Starting Quartus Prime
You can choose between GUI or CUI, the CUI method is useful when using a cloud or on-premises Windows PC.

###### Compiling with GUI
Run Quartus Prime and open the <code>[fpga/kyogenrv_fpga_top.qpf](fpga/kyogenrv_fpga_top.qpf)</code> project.
Menu -> Processing -> Start Compilation to start compilation.
###### Compiling with CUI
Open the build script <code>[build_sdk.sh](build_sdk.sh)</code> with an editor and set the Quartus Prime installation folder, KyogenRV directory, etc.
After confirming that everything PATH is correct, just run the following at the root of the project.
```
./build_sdk.sh
```
Regardless of which method CUI or GUI you use above, make sure that there are no build errors before modifying the project to fit your board environment using Pin Planner or Platform Designer.
The following files will be generated in the <code>[fpga](fpga)</code> folder.
- kyogenrv_fpga_top.sof

If you use CUI, the following file will also be generated.
- kyogenrv_fpga_top.svf
##### Modify the sample code(led.c as exam)
You may find it helpful to know how does this RISC-V CPU and its project works to modify <code>[src/sw/led.c](src/sw/led.c)</code>.
If the code consists of multiple files or the file names are changed, please rewrite <code>[src/sw/common2.mk](src/sw/common2.mk)</code> to Makefile build all fixed and modified files.

##### Rebuild the project
###### Rebuild with GUI
After saving the file, run
```
make c_all
./mk_intel_hex.py
```
to compile project and re-generate the intel hex files.
If you are build all FPGA project, you can run,
```
make sdk
```
Start compiling by going to Menu -> Processing -> Start Compilation.
The generated *.sof file is used to configure the FPGA via Quartus Programmer.
###### Rebuild with CUI
Compared with GUI, the procedure is simple.
just run following to rebuild.
```
./build_sdk.sh
```
Configure the FPGA using *.sof or *.svf.
##
#### 1.Simulation
```
git clone http://github.com/panda5mt/KyogenRV  
cd KyogenRV/
make clean
make test
```
to generate your *.hex files from your *.s,
put your *.s file to <code>[src/sw/](src/sw)</code> and then execute below
```
./build_asm.py        # generate *.hex file from *.s
./mk_intel_hex.py     # generate intel hex files
```

#### 2.Simulating with riscv-tests (need python 3.7 or later)
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
save link.ld and make riscv-tests
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
##
## II.Basically Logic 
##### The following instructions is written for who want to explore this "KyogenRV" RV32I design step by step. Otherwise, please clone the latest from GitHub. 
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
when you modified <code>[src/sw/test.s](src/sw/test.s)</code>, just type as follows
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