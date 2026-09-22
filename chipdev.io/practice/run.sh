#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <question-number|Qxx> [--solution|--wave]"
  echo "Example: $0 01"
  echo "         $0 Q24 --solution"
  echo "         $0 Q01 --wave"
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 2
fi

raw_question="$1"
mode="${2:-}"

if [[ "$raw_question" =~ ^Q?([0-9]{1,2})$ ]]; then
  question_number=$(printf '%02d' "$((10#${BASH_REMATCH[1]}))")
else
  echo "Error: 題號必須像 1、01 或 Q01。" >&2
  exit 2
fi

if [[ -n "$mode" && "$mode" != "--solution" && "$mode" != "--wave" ]]; then
  usage
  exit 2
fi

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source_dir=$(cd "$script_dir/.." && pwd)

shopt -s nullglob
testbenches=("$script_dir"/tests/Q"$question_number"_*_tb.sv)
if [[ ${#testbenches[@]} -eq 0 ]]; then
  testbenches=("$source_dir"/Q"$question_number"_*_tb.sv)
fi

if [[ "$mode" == "--solution" ]]; then
  designs=("$source_dir"/Q"$question_number"_*_rtl.sv)
  design_label="repository solution"
else
  designs=("$script_dir"/Q"$question_number"_*_practice.sv)
  design_label="practice answer"
fi

if [[ ${#designs[@]} -ne 1 || ${#testbenches[@]} -ne 1 ]]; then
  echo "Error: 找不到唯一的 Q${question_number} design/testbench（Q27 不存在）。" >&2
  exit 1
fi

design="${designs[0]}"
testbench="${testbenches[0]}"
top_module=$(sed -nE 's/^[[:space:]]*module[[:space:]]+([A-Za-z_][A-Za-z0-9_]*).*/\1/p' "$testbench" | head -n 1)

if [[ -z "$top_module" ]]; then
  echo "Error: 無法從 $testbench 找到 testbench module。" >&2
  exit 1
fi

build_dir="$script_dir/build/Q${question_number}"
object_dir="$build_dir/obj"
mkdir -p "$build_dir"

echo "[Q${question_number}] Compiling $design_label"
echo "  RTL: $(basename "$design")"
echo "  TB : $(basename "$testbench")"

verilator \
  --binary \
  --timing \
  --trace \
  --Wno-fatal \
  -I"$script_dir/tests" \
  --Mdir "$object_dir" \
  --top-module "$top_module" \
  "$design" "$testbench"

echo "[Q${question_number}] Running simulation"
simulation_status=0
(
  cd "$build_dir"
  "$object_dir/V${top_module}"
) || simulation_status=$?

vcd_file="$build_dir/dump.vcd"
if [[ ! -s "$vcd_file" ]]; then
  echo "Error: 模擬結束，但沒有產生有效的 VCD：$vcd_file" >&2
  exit 1
fi
echo "  Waveform: $vcd_file"

if [[ $simulation_status -ne 0 ]]; then
  echo "[Q${question_number}] FAILED: self-checking testbench reported an error." >&2
  echo "  失敗波形仍已保留，可用 GTKWave 檢查：$vcd_file" >&2
  exit "$simulation_status"
fi

echo "[Q${question_number}] Done"

if [[ "$mode" == "--wave" ]]; then
  if ! command -v gtkwave >/dev/null 2>&1; then
    echo "Error: 找不到 GTKWave；VCD 已正常產生於 $vcd_file" >&2
    exit 1
  fi
  echo "[Q${question_number}] Opening waveform with GTKWave"
  gtkwave "$vcd_file" >/dev/null 2>&1 &
fi

echo "  Self-checking testbench completed; coverage details: TEST_COVERAGE.md"
