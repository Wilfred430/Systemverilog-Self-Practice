# test_counter.py
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_my_counter(dut):
    """ 這是我們要執行的測試任務 """

    # 1. 啟動時脈 (產生一個 10ns 週期的 Clock)
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # 2. 初始化訊號 (先按下 Reset)
    dut.rst_n.value = 0
    await Timer(20, units="ns")  # 等待 20ns
    dut.rst_n.value = 1          # 放開 Reset
    
    # 3. 觀察並驗證 (等待 5 個 Clock 週期)
    for i in range(5):
        await RisingEdge(dut.clk)
        # 這裡印出當下的計數值，證明它在跑
        dut._log.info(f"Current Count: {dut.count.value}")