import os
from pathlib import Path

# --- 關鍵修改開始 ---
# 自動偵測：如果是舊版就從 cocotb 抓，如果是新版就從 cocotb_tools 抓
try:
    from cocotb.runner import get_runner
except ImportError:
    # 針對 Cocotb 2.0+ 或使用了 cocotb-tools 的環境
    from cocotb_tools.runner import get_runner
# --- 關鍵修改結束 ---

def test_counter():
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent

    # 1. 指定你的 Verilog 來源檔
    sources = [proj_path / "counter.sv"]

    # 2. 取得模擬器執行器
    runner = get_runner(sim)

    # 3. 編譯 (Build)
    runner.build(
        sources=sources,
        hdl_toplevel="counter",
        always=True
    )

    # 4. 執行測試 (Test)
    runner.test(
        hdl_toplevel="counter",      # Verilog 上層模組名
        test_module="test_counter",  # Python 測試檔名 (不含 .py)
    )

if __name__ == "__main__":
    test_counter()