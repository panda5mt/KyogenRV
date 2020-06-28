The Simple RISC-V KyogenRV(響玄RV)
=======================
## 5-Stage Pipelined RV32I written in Chisel.
##### 日本語のREADMEはこちら。 [README_J.md](日本語はこちら)
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

#### 6. Added Exception
please git clone latest one. 