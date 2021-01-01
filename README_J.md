KyogenRV(響玄RV):The Simple RISC-V for intel FPGA
=======================
##### English README is [here](README.md)
- アーキテクチャ:RV32I
- 特権モード: Machine modeのみ
    - User-Level ISA Version 2.2
    - Privileged ISA Version 1.11
- 割り込み:外部割り込み
- CPUバス:インテル Avalon-MM インターフェース
- パイプライン: 5ステージ(IF/ID/EX/MEM/WB stage)
- 言語:Chisel v.3.4

## I.使い方
#### 1.シミュレーション
riscv-toolchainが必要となります。以下の手順は導入が済んでいる前提で進めていきます。
```
git clone http://github.com/panda5mt/KyogenRV  
cd KyogenRV/
make clean
make test
```
アセンブラファイルを書き換える場合は、<code>[src/sw/test.s](src/sw/test_interrupt.s)</code>にアセンブラファイルを記述し、
make testでアセンブル、実行が可能となります。
コンソール上で各命令処理時の各ステージの挙動、終了後の汎用レジスタ(x0 ~ x31)の値を確認することができます。

任意のファイル名のriscvのアセンブラファイル*.sを<code>[src/sw/](src/sw)</code>に置き、以下を実行することでhexファイルを生成することができます。(複数ファイル可)
```
./build_asm.py
./mk_intel_hex.py
```
#### 2.riscv-testsのシミュレーション (python 3.7以降が必要)
```
git clone http://github.com/panda5mt/KyogenRV  
```
riscv-testsをcloneします。
```
git clone https://github.com/riscv/riscv-tests
cd riscv-tests
git submodule update --init --recursive
```
リンカスクリプトを修正します。
```
nano env/p/link.ld
```
'.text'セクションが0x00000000から開始するように修正します。

```
SECTIONS
{
  . = 0x00000000;   # -> ここを修正 
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
link.ldを保存しriscv-testsをビルドします。
```
autoconf
./configure --prefix=<your-kyogenRVs-root-dir>/tests/
make
make install
cd ../
```
KyogenRVのルートディレクトリに移動し、下記のようにコマンドを入力することにより、riscv-testsのシミュレーションが行えます。
```
cd KyogenRV/
make clean
make riscv-tests
```
#### 3.Verilogファイルの生成
```
git clone http://github.com/panda5mt/KyogenRV  
cd KyogenRV/
make clean
make hdl
```
##
##### 以下の手順はこのKyogenRVの設計を順を追って調べたい方向けです。それ以外の方は最新のgitをcloneしてください。 
## II. 各ステージのロジック 
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
#### 3.分岐の実装(PC update)
分岐命令の実装とフェッチした命令をフラッシュする実装です
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.10.3 --depth 1 
cd KyogenRV/
```

<code>[src/sw/test.s](src/sw/test_interrupt.s)</code>にアセンブラファイルを記述し、
プロジェクトのルートフォルダで以下の方法でアセンブルしてください。(riscv-toolchainが必要となります)

```
make asm
```
その後<code>[src/sw/test.hex](src/sw/test.hex)</code>が生成されます。このhexをCPUにロードし実行結果を見るには

```
make test
```
を実行します。

#### 4.マルチパイプライン(5ステージ)化
項目3までシングルパイプラインでした。ここで5段パイプラインにします
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.10.10 --depth 1 
cd KyogenRV/
```

<code>[src/sw/test.s](src/sw/test_interrupt.s)</code>にアセンブラファイルを記述し、
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

<code>[src/sw/test.s](src/sw/test_interrupt.s)</code>にアセンブラファイルを記述し、
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

#### 6. 例外と割り込み(外部割り込みのみ)実装
最新のプロジェクトをCloneしてください