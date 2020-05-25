Tiny RISC-V KyogenRV(響玄RV) in chisel3 based on RV32I.
=======================
## 5-Stage Pipelined soft-core CPU for mid-range FPGAs.
### Basically Logic 
#### 1.Instruction Fetch Stage(IF)  
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.2 --depth 1 
cd KyogenRV/
make test
```
#### 2.Instruction Decode Stage(ID) and ALU
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
#### 4.Branch (PC update)
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
when you modified <code>[src/sw/test.hex](src/sw/test.hex)</code>,just type as follows
```
make test
```
so makefile scan test.hex is changed and re-assemble then build chisel project.
