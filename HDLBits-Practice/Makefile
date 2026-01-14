# Makefile

# 這是預設的模擬器語言
TOPLEVEL_LANG = verilog

# 指定你的 Verilog 原始碼檔案
VERILOG_SOURCES = $(shell pwd)/counter.sv

# 指定頂層模組名稱 (對應 counter.sv 裡的 module counter)
TOPLEVEL = counter

# 指定 Python 測試檔的模組名稱 (對應 test_counter.py 檔名)
COCOTB_TEST_MODULES = test_counter

# 告訴 Cocotb 我們用的是 Icarus Verilog
SIM = icarus

# 包含 Cocotb 的標準規則
include $(shell cocotb-config --makefiles)/Makefile.sim