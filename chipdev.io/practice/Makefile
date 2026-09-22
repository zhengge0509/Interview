.PHONY: help list run vcd wave solution clean

help:
	@echo "make list                 列出所有練習題"
	@echo "make run Q=01             編譯、模擬並產生 VCD"
	@echo "make vcd Q=01             同 run，明確產生並驗證 VCD"
	@echo "make wave Q=01            產生 VCD 並用 GTKWave 開啟"
	@echo "make solution Q=01        執行 repository 原答案"
	@echo "make clean                清除 build 產物"

list:
	@for file in Q*_practice.sv; do basename "$$file" _practice.sv; done

run:
	@if [ -z "$(Q)" ]; then echo "請指定題號，例如 make run Q=01"; exit 2; fi
	@./run.sh "$(Q)"

vcd: run

wave:
	@if [ -z "$(Q)" ]; then echo "請指定題號，例如 make wave Q=01"; exit 2; fi
	@./run.sh "$(Q)" --wave

solution:
	@if [ -z "$(Q)" ]; then echo "請指定題號，例如 make solution Q=01"; exit 2; fi
	@./run.sh "$(Q)" --solution

clean:
	rm -rf build
