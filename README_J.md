響玄RV:soft-core RISC-V(RV32I) 
=======================
### 
- アーキテクチャ:RV32I
- 特権モード: Machine modeのみ
    - User-Level ISA Version 2.2
    - Privileged ISA Version 1.11
- 割り込み:外部割り込み
- パイプライン: 5ステージ(IF/ID/EX/MEM/WB stage)
- 言語:Chisel v.3.3


##### 以下の手順はRISC-V CPUの設計を順を追って調べたい方向けです。それ以外の方は最新のgitをcloneしてください。 
### 各ステージのロジック 
#### 1.フェッチステージ(IF)
CPUの初歩的なステートマシンと命令メモリを読み込むロジックです  
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.2 --depth 1 
cd KyogenRV/
make test
```
#### 2.命令デコードステージ(ID)とALU
RISCVの基本的な命令のデコードと演算のためのALUの実装です
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.9 --depth 1 
cd KyogenRV/
make test
```
#### 3.Branch (PC update)
分岐命令の実装とフェッチした命令をフラッシュする実装です
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.10.3 --depth 1 
cd KyogenRV/
```

<code>[src/sw/test.s](src/sw/test.s)</code>にアセンブラファイルを記述し、
プロジェクトのルートフォルダで以下の方法でアセンブルしてください。(riscv-toolchainが必要となります)

```
make asm
```
その後<code>[src/sw/test.hex](src/sw/test.hex)</code>が生成されます。このhexをCPUにロードし実行結果を見るには

```
make test
```
を実行します。

#### 4.5段パイプライン化
項目3までシングルパイプラインでした。ここで5段パイプラインにします
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.10.10 --depth 1 
cd KyogenRV/
```

<code>[src/sw/test.s](src/sw/test.s)</code>にアセンブラファイルを記述し、
プロジェクトのルートフォルダで以下の方法でアセンブルしてください。(riscv-toolchainが必要となります)


```
make clean
make asm
```
その後<code>[src/sw/test.hex](src/sw/test.hex)</code>が生成されます。
このhexをChiselプロジェクトでCPUにロードし実行結果を見るには、

```
make test
```
とします。なお、asmファイルを書き換えた場合、Makefileが自動認識するので
```
make test
```
するだけでOKです.

#### 5. ストールとフォワーディングの実装
項目4でパイプライン化をしたため、状況によってはデータハザードが発生します。
この解決を行います。
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

#### 6. 例外と割り込み(外部割り込みのみ)実装
please git clone latest one. 