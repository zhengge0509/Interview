# SystemVerilog RTL Interview Practice

這個 repository 收錄 SystemVerilog／RTL 面試練習、self-checking testbench，以及 Clock Domain Crossing（CDC）相關參考資料。

`chipdev.io/practice/` 共有 44 題：原始題組 Q01–Q26、Q28–Q31（原始資料沒有 Q27），以及進階題 Q32–Q45。每題的 practice 檔案保留 testbench 所需的 module name 與 interface，供自行完成 RTL 實作。

## 目錄結構

```text
.
├── chipdev.io/
│   ├── Qxx_*_rtl.sv          # Q01–Q31 的參考 RTL（沒有 Q27）
│   ├── Qxx_*_tb.sv           # 原始 testbench
│   └── practice/
│       ├── Qxx_*_practice.sv # 練習用 RTL，請在這裡作答
│       ├── tests/             # self-checking testbench
│       ├── Makefile
│       ├── run.sh
│       └── TEST_COVERAGE.md
└── doc/                       # CDC／Asynchronous FIFO 參考資料
```

## 需要的環境

| 工具 | 用途 | 是否必要 |
|---|---|---|
| Verilator 5.x | 編譯及執行 SystemVerilog testbench | 必要 |
| C++ compiler | 編譯 Verilator 產生的模擬程式 | 必要 |
| GNU Make | 提供簡化的執行指令 | 必要 |
| Bash | 執行 `run.sh` | 必要 |
| GTKWave | 開啟 `.vcd` 波形 | 選用 |
| Git | clone repository | 建議 |

本專案已使用 Verilator 5.048、GNU Make 3.81 與 Bash 3.2 驗證。建議使用 Verilator 5.x。

### macOS

先安裝 Xcode Command Line Tools 與 [Homebrew](https://brew.sh/)，再執行：

```sh
xcode-select --install
brew install verilator
brew install --cask gtkwave  # 選用：查看波形
```

macOS 內建的 `make` 與 Bash 即可使用。

### Ubuntu／Debian

```sh
sudo apt update
sudo apt install -y verilator make g++ gtkwave
```

若不需要圖形化波形工具，可以省略 `gtkwave`。

### Windows

建議使用 WSL2（Ubuntu），並在 WSL 中依照上方 Ubuntu 步驟安裝工具。GTKWave 需要 WSLg 或其他可顯示 Linux GUI 的環境；若只執行 testbench，則不需要 GTKWave。

### 確認安裝

```sh
verilator --version
make --version
bash --version
```

## 下載與進入練習目錄

```sh
git clone https://github.com/zhengge0509/Interview.git
cd Interview/chipdev.io/practice
```

列出全部題目：

```sh
make list
```

## 如何作答與執行 testbench

以 Q01 為例：

1. 開啟 `chipdev.io/practice/Q01_Simple_Router_practice.sv`。
2. 保留原有 module name、parameters 與 ports，完成 RTL 實作。
3. 在 `chipdev.io/practice/` 目錄執行：

```sh
make run Q=01
```

也可以直接呼叫 runner，題號可寫成 `1`、`01` 或 `Q01`：

```sh
./run.sh 01
./run.sh Q01
```

runner 會依序：

1. 以 Verilator 編譯 practice RTL 與 `tests/` 裡的 self-checking testbench。
2. 執行模擬並比較 actual 與 expected 結果。
3. 將編譯檔與波形輸出至 `practice/build/Qxx/`。

全部檢查通過時會看到：

```text
Q01 PASS: all expected outputs matched
```

若結果不符，testbench 會顯示失敗案例、actual、expected，並以 `$fatal` 結束。即使測試失敗，通常仍會保留 VCD 波形供除錯。

## 執行參考解答

Q01–Q26、Q28–Q31 提供參考 RTL，可用它確認環境與 testbench 是否正常：

```sh
make solution Q=01
# 或
./run.sh 01 --solution
```

Q32–Q45 是額外的進階練習題，沒有 `--solution` 參考 RTL。

## 查看波形

執行模擬並自動開啟 GTKWave：

```sh
make wave Q=01
# 或
./run.sh 01 --wave
```

只產生 VCD、不開啟 GUI：

```sh
make vcd Q=01
```

波形位置：

```text
chipdev.io/practice/build/Q01/dump.vcd
```

也可以手動開啟：

```sh
gtkwave build/Q01/dump.vcd
```

## 批次執行

執行所有已完成的 practice RTL：

```sh
for file in Q*_practice.sv; do
  name=${file##*/}
  q=${name#Q}
  q=${q%%_*}
  ./run.sh "$q" || exit 1
done
```

執行所有現有參考解答：

```sh
for file in ../Q*_rtl.sv; do
  name=${file##*/}
  q=${name#Q}
  q=${q%%_*}
  ./run.sh "$q" --solution || exit 1
done
```

## 清除編譯產物

```sh
make clean
```

這會刪除 `practice/build/`，不會修改 RTL、testbench 或作答內容。

## 測試範圍與限制

各題涵蓋的案例請參考 [`chipdev.io/practice/TEST_COVERAGE.md`](chipdev.io/practice/TEST_COVERAGE.md)。這些測試適合快速練習與 regression，但不等同 formal verification；CDC 題目的模擬也無法模擬類比 metastability，不能取代 CDC structural analysis 與 signoff。

更詳細的練習說明請見 [`chipdev.io/practice/README.md`](chipdev.io/practice/README.md)。
