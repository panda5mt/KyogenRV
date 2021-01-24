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
#### 0.intel FPGAで使用する
標準ではCyclone10LP(10CL025YU256C8G)を使用する前提となっています．
##### 推奨開発環境
- クロス開発環境:下記条件全てを満たす環境
  - Windows 10/WSL2が動作する環境
  - Quartus Prime Lite v.20.1.1以上が動作すること
  - scala/sbt環境が用意されていること
  - Pyhton 3.7以上が動作すること
- FPGA要件:以下のいずれかの要件を満たすデバイス
  - Cyclone 10LP(10CL010またはそれ以上のロジックエレメントを有するデバイス)
  - PLLが1つ以上搭載，7000LE以上のロジック・エレメント，1KByte以上のOn-Chip RAMを確保できるintel FPGA
##### riscv-toolchainの準備
```
git clone https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain
./configure --prefix=/opt/riscv --with-arch=rv32i 
sudo make
```
##### KyogenRVの導入とFPGAロジック関連のリビルド
```
cd -
git clone http://github.com/panda5mt/KyogenRV  
cd KyogenRV/
make sdk
```
##### Quartus Primeの起動
GUI/CUIいずれかを選択することができます．CUIを使う手法はクラウド上またはオンプレのPCを使用する際に有用です．
###### GUIでコンパイル
Quartus Primeを起動し，<code>[fpga/kyogenrv_fpga_top.qpf](fpga/kyogenrv_fpga_top.qpf)</code>プロジェクトを開きます．
メニュー -> Processing -> Start Compilation でコンパイルを開始します．
###### CUIでコンパイル
ビルド用スクリプト<code>[build_sdk.sh](build_sdk.sh)</code>をエディタで開き，Quartus Primeのインストールフォルダ，KyogenRVのディレクトリなどを設定します．
間違いがないことを確認したら，プロジェクトのルートで以下を実行します．
```
./build_sdk.sh
```
上記いずれの方法を採用した場合においても，先ずビルドエラーがないことを確認したのちに，Pin PlannerやPlatform Designerを用い各自のボード環境に適合するプロジェクトに修正するようにしてください．
<code>[fpga](fpga)</code>フォルダに下記のファイルが生成されます．
- kyogenrv_fpga_top.sof

CUIを使用した場合は下記のファイルも生成されます．  
- kyogenrv_fpga_top.svf

##### サンプルコードの確認・変更
<code>[src/sw/led.c](src/sw/led.c)</code>を変更，改変すると参考になると思われます．
コードが複数のファイルから構成される場合，またはファイル名が異なる場合は，変更または追加されたファイルに応じ<code>[src/sw/common2.mk](src/sw/common2.mk)</code>を書き換えてください．

##### プロジェクトのリビルド
###### GUIでのリビルド
保存後，
```
make c_all
./mk_intel_hex.py
```
によりintel hexを生成できます．
もしFPGAプロジェクトをふくめて全てをビルドし直す場合は
```
make sdk
```
です．再度Quartus Primeを起動し，<code>[fpga/kyogenrv_fpga_top.qpf](fpga/kyogenrv_fpga_top.qpf)</code>プロジェクトを開きます．
メニュー -> Processing -> Start Compilation でコンパイルを開始します．
###### CUIでのリビルド
下記を実行します．
```
./build_sdk.sh
```
全てを再ビルドします．
## 
#### 1.シミュレーション
riscv-toolchainが必要となります．以下の手順は導入が済んでいる前提で進めていきます．
```
git clone http://github.com/panda5mt/KyogenRV  
cd KyogenRV/
make clean
make test
```
アセンブラファイルを書き換える場合は，<code>[src/sw/test.s](src/sw/test.s)</code>にアセンブラファイルを記述し，
make testでアセンブル，実行が可能となります．
コンソール上で各命令処理時の各ステージの挙動，終了後の汎用レジスタ(x0 ~ x31)の値を確認することができます．

任意のファイル名のriscvのアセンブラファイル*.sを<code>[src/sw/](src/sw)</code>に置き，以下を実行することでhexファイルを生成することができます．(複数ファイル可)
```
./build_asm.py
./mk_intel_hex.py
```
#### 2.riscv-testsのシミュレーション (python 3.7以降が必要)
```
git clone http://github.com/panda5mt/KyogenRV  
```
riscv-testsをcloneします．
```
git clone https://github.com/riscv/riscv-tests
cd riscv-tests
git submodule update --init --recursive
```
リンカスクリプトを修正します．
```
nano env/p/link.ld
```
'.text'セクションが0x00000000から開始するように修正します．

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
link.ldを保存しriscv-testsをビルドします．
```
autoconf
./configure --prefix=<your-kyogenRVs-root-dir>/tests/
make
make install
cd ../
```
KyogenRVのルートディレクトリに移動し，下記のようにコマンドを入力することにより，riscv-testsのシミュレーションが行えます．
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
##### 以下の手順はこのKyogenRVの設計を順を追って調べたい方向けです．それ以外の方は最新のgitをcloneしてください． 
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

<code>[src/sw/test.s](src/sw/test.s)</code>にアセンブラファイルを記述し，
プロジェクトのルートフォルダで以下の方法でアセンブルしてください．(riscv-toolchainが必要となります)

```
make asm
```
その後<code>[src/sw/test.hex](src/sw/test.hex)</code>が生成されます．このhexをCPUにロードし実行結果を見るには

```
make test
```
を実行します．

#### 4.マルチパイプライン(5ステージ)化
項目3までシングルパイプラインでした．ここで5段パイプラインにします
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.10.10 --depth 1 
cd KyogenRV/
```

<code>[src/sw/test.s](src/sw/test.s)</code>にアセンブラファイルを記述し，
プロジェクトのルートフォルダで以下の方法でアセンブルしてください．(riscv-toolchainが必要となります)

```
make clean
make asm
```
その後<code>[src/sw/test.hex](src/sw/test.hex)</code>が生成されます．
このhexをChiselプロジェクトでCPUにロードし実行結果を見るには，

```
make test
```
とします．なお，asmファイルを書き換えた場合，Makefileが自動認識するので
```
make test
```
するだけでOKです.

#### 5. ストールとフォワーディングの実装
項目4でパイプライン化をしたため，状況によってはデータハザードが発生します．
この解決を行います．
```
git clone http://github.com/panda5mt/KyogenRV -b 0.0.10.15 --depth 1 
cd KyogenRV/
```

<code>[src/sw/test.s](src/sw/test.s)</code>にアセンブラファイルを記述し，
プロジェクトのルートフォルダで以下の方法でアセンブルしてください．(riscv-toolchainが必要となります)

```
make clean
make asm
```
その後<code>[src/sw/test.hex](src/sw/test.hex)</code>が生成されます．
このhexをChiselプロジェクトでCPUにロードし実行結果を見るには，
```
make test
```
とします．なお，asmファイルを書き換えた場合，Makefileが自動認識するので
```
make test
```
するだけでOKです.

#### 6. 例外と割り込み(外部割り込みのみ)実装
最新のプロジェクトをCloneしてください