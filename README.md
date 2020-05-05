Tiny RISC-V KyogenRV(響玄RV) in chisel3 based on RV32I.
=======================
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
git clone http://github.com/panda5mt/KyogenRV -b 0.0.10 --depth 1 
cd KyogenRV/
```

write asm file and save to <code>src/sw/test.s</code>
then build as follows 

```
make asm
```
you'll get <code>test.hex</code> in <code>src/sw/</code>
then build test module in chisel project
```
make test
```
