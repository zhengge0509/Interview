# chipdev.io SystemVerilog 面試練習環境

這個目錄包含從原始 RTL 與 testbench **反推**出的 30 道題目（原 repository 沒有 Q27），
以及額外新增的進階經典面試題 Q32–Q45，共 44 題。
每個 `Qxx_*_practice.sv` 都保留了 testbench 所期待的 module 名稱與 interface，但沒有實作答案。

> 注意：題目文字不是 chipdev.io 官方原文。部分邊界行為只能依現有參考答案和 testbench 推斷，已在各題註解中說明。

## 使用方式

先進入本目錄：

```sh
cd /Users/zhenglu/Documents/Interview/chipdev.io/practice
```

列出所有題目：

```sh
make list
```

以 Q01 為例，先編輯 `Q01_Simple_Router_practice.sv`，再執行：

```sh
make run Q=01
```

`run` 會同時編譯、模擬並產生 VCD。也可以使用語意更明確的別名：

```sh
make vcd Q=01
```

你的電腦已安裝 GTKWave；若要在模擬完成後直接開啟波形：

```sh
make wave Q=01
```

也可以直接使用 runner：

```sh
./run.sh 01
./run.sh Q01
```

用 repository 原本的解答確認工具鏈與 testbench：

```sh
./run.sh 01 --solution
```

編譯產物與波形會放在：

```text
practice/build/Q01/dump.vcd
```

也可以手動用 `gtkwave build/Q01/dump.vcd` 看波形。

## Self-checking testbench

Runner 會優先使用 `practice/tests/` 裡的新版 testbench。每一次檢查都會顯示案例名稱、
`actual` 和 `expected`。只要有一項不符就會立刻 `$fatal`；只有全部相符才會印出：

```text
Qxx PASS: all expected outputs matched
```

即使測試失敗，`build/Qxx/dump.vcd` 仍會保留。各題涵蓋的 edge cases 與模擬限制列在
[`TEST_COVERAGE.md`](TEST_COVERAGE.md)。原始 RTL、原始 testbench，以及你的 practice 作答內容都不會被 runner 修改。

## Advanced interview set

| Question | Topic |
|---|---|
| Q32 | Parameterized synchronous FIFO |
| Q33 | Round-robin arbiter |
| Q34 | Ready/valid elastic buffer |
| Q35 | APB register slave |
| Q36 | CDC pulse synchronizer |
| Q37 | Asynchronous FIFO with Gray-code pointers |
| Q38 | True dual-port synchronous RAM |
| Q39 | Glitch-free clock multiplexer |
| Q40 | Ready/valid bit serializer with backpressure |
| Q41 | Programmable-length and bit-order serializer |
| Q42 | Wide-to-narrow ready/valid width converter |
| Q43 | Double-buffered zero-bubble serializer |
| Q44 | Variable-length packet byte serializer |
| Q45 | Round-robin two-source serializer |
