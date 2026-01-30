# SystemVerilog-Self-Practice

## 這個 Repository 是做什麼的？ / What is this repository for?

### 中文說明

這是一個 **SystemVerilog 自我練習專案**，主要用於提升 Verilog/SystemVerilog 的設計與驗證能力。

**主要內容：**
- **HDLBits 練習題解**：包含多個來自 HDLBits 網站的練習題實作
  - BCD 加法器 (BCD_add4.sv, BCD_adder.sv)
  - 計數器設計 (Counter1000.sv, CountBCD.sv)
  - 邊緣檢測電路 (EdgeDetect.sv, EdgeCapture.sv)
  - 正反器設計 (DFF_gates.sv, JK_DFF.sv, Dualedge.sv)
  - 算術邏輯單元 (Sign_add_overflow.sv)
  - 時序控制器 (Cs450_timer.sv)
  - 其他基礎數位邏輯電路

- **測試驗證環境**：使用 cocotb (Python-based testbench) 進行模擬驗證
  - 支援 Icarus Verilog 模擬器
  - 提供範例測試框架 (Template_counter/)

**學習資源：**
- HDLBits 練習來源：https://josh-gao.top/posts/53b8b42e.html  
- Pipeline 設計參考：https://blog.csdn.net/luoganttcc/article/details/127990165

---

### English Description

This is a **SystemVerilog self-practice project** aimed at improving Verilog/SystemVerilog design and verification skills.

**Main Contents:**
- **HDLBits Exercise Solutions**: Multiple implementations of exercises from the HDLBits website
  - BCD Adders (BCD_add4.sv, BCD_adder.sv)
  - Counter Designs (Counter1000.sv, CountBCD.sv)
  - Edge Detection Circuits (EdgeDetect.sv, EdgeCapture.sv)
  - Flip-Flop Designs (DFF_gates.sv, JK_DFF.sv, Dualedge.sv)
  - Arithmetic Logic Units (Sign_add_overflow.sv)
  - Timer Controllers (Cs450_timer.sv)
  - Other fundamental digital logic circuits

- **Testing Environment**: Verification using cocotb (Python-based testbench)
  - Supports Icarus Verilog simulator
  - Includes example test framework (Template_counter/)

**Learning Resources:**
- HDLBits exercises source: https://josh-gao.top/posts/53b8b42e.html  
- Pipeline design reference: https://blog.csdn.net/luoganttcc/article/details/127990165

## 如何使用 / How to Use

### 環境需求 / Requirements
- Icarus Verilog (iverilog)
- Python 3.x
- cocotb (for testing)

### 執行測試範例 / Running Test Examples
```bash
cd HDLBits-Practice/Template_counter
make
```

## 授權 / License
MIT License - See [LICENSE](LICENSE) file for details
