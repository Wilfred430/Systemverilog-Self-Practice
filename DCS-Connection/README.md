# DCS-Connection RTL 合成流程指南

本指南說明如何從 RTL 設計合成為工業級的 gate-level 電路，包含面積、功耗、時序分析。

---

## 📋 工作流程概覽

```
RTL Design (SystemVerilog)
    ↓
✓ 確認 Testbench 通過
    ↓
[Yosys] RTL Synthesis
    ↓
Gate-level Netlist (.v)
    ↓
[OpenSTA] Timing Analysis
    ↓
報告：面積、時序、Slack
```

---

## ✅ 前置檢查

在合成之前，確保：

1. **RTL 設計完成**
   - 檔案位置：`Lab{X}/Module_dcs076.sv`（或你的模組名稱）
   - 檔案格式：SystemVerilog (.sv)

2. **Testbench 通過**
   ```bash
   # 運行模擬（確保功能正確）
   cd Lab{X}
   python run_sim.py
   # 確認所有測試通過後，才進行合成
   ```

3. **Docker 環境就緒**
   ```powershell
   docker --version  # 確認 Docker 已安裝
   ```

---

## 🚀 快速開始（3 步驟）

假設你已完成 Lab1 的 `Comb_dcs076.sv`：

### 步驟 1️⃣：準備合成腳本

```powershell
# 進入工作目錄
cd D:\Systemverilog-Verilog-Learning

# 已自動準備的腳本位置：
# - scripts/synth_module.ys         (Yosys 合成腳本)
# - scripts/sta_module.tcl          (OpenSTA 時序分析)
# - constraints/module.sdc          (時序約束)
```

### 步驟 2️⃣：執行 RTL 合成

```powershell
# 合成為 gate-level netlist（使用 sky130 標準單元庫）
docker run --rm -v D:\Systemverilog-Verilog-Learning:/workspace openroad/orfs sh -c `
  'export PATH=/OpenROAD-flow-scripts/tools/install/OpenROAD/bin:$PATH; `
   /usr/local/bin/yosys -s /workspace/scripts/synth_module.ys'
```

**預期輸出：**
```
output/module_synth.v        ← 合成後的網表
reports/module_stat.rpt      ← 面積統計
```

### 步驟 3️⃣：執行時序分析

```powershell
# 分析合成結果的時序、Slack、violations
docker run --rm -v D:\Systemverilog-Verilog-Learning:/workspace openroad/orfs sh -c `
  'export PATH=/OpenROAD-flow-scripts/tools/install/OpenROAD/bin:$PATH; `
   /OpenROAD-flow-scripts/tools/install/OpenROAD/bin/sta /workspace/scripts/sta_module.tcl'
```

**預期輸出：**
```
reports/module_sta.rpt       ← 詳細時序報告
reports/module_worst_slack.rpt ← 最差 slack 值
```

---

## 📝 為你的設計自動配置腳本

### 方法 1：使用現成腳本（推薦）

已為 Lab1 準備好的腳本：
```
scripts/synth_comb_yosys.ys  → Module 名稱: Comb
scripts/sta_comb.tcl         → 時序約束已配置
constraints/comb.sdc         → 時脈: 10ns, 輸入/輸出延遲: 2ns
```

### 方法 2：為新的 Lab 配置（以 Lab2 為例）

#### 第 1 步：複製並修改合成腳本

複製 [scripts/synth_comb_yosys.ys](../scripts/synth_comb_yosys.ys)，改名為 `synth_counter.ys`：

```tcl
# synth_counter.ys
read_verilog -sv /workspace/DCS-Connection/Lab2/Counter_dcs076.sv
hierarchy -check -top Counter              # ← 改成你的 top module 名稱

proc; opt; fsm; opt; memory; opt
techmap; opt
abc -liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
clean
check

tee -o /workspace/reports/counter_stat.rpt stat -liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
write_verilog -noattr /workspace/output/counter_synth.v
```

**修改重點：**
- `read_verilog` 路徑改為你的檔案
- `hierarchy -top` 改為你的 top module 名稱
- 輸出檔案名改為對應名稱（counter 等）

#### 第 2 步：複製並修改 STA 腳本

複製 [scripts/sta_comb.tcl](../scripts/sta_comb.tcl)，改名為 `sta_counter.tcl`：

```tcl
# sta_counter.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog /workspace/output/counter_synth.v
link_design Counter              # ← 改成你的 top module 名稱

read_sdc /workspace/constraints/counter.sdc

report_checks -path_delay max -from [all_inputs] -to [all_outputs] -format full_clock_expanded > /workspace/reports/counter_sta.rpt
report_worst_slack -max > /workspace/reports/counter_worst_slack.rpt
```

#### 第 3 步：建立 SDC 約束檔

複製 [constraints/comb.sdc](../constraints/comb.sdc)，改名為 `counter.sdc`：

```tcl
# counter.sdc
create_clock -name clk -period 10.0 [get_ports clk]  # 調整 clk 名稱和週期
set_input_delay -clock clk -max 2.0 [all_inputs]
set_input_delay -clock clk -min 0.5 [all_inputs]
set_output_delay -clock clk -max 2.0 [all_outputs]
set_output_delay -clock clk -min 0.5 [all_outputs]
set_input_transition 0.1 [all_inputs]
set_load 0.05 [all_outputs]
```

**修改重點：**
- `create_clock` 中的 `clk` 改為實際時脈訊號名稱
- `-period 10.0` 改為實際時脈週期（單位：ns）

#### 第 4 步：執行合成和 STA

```powershell
# 合成
docker run --rm -v D:\Systemverilog-Verilog-Learning:/workspace openroad/orfs sh -c `
  'export PATH=/OpenROAD-flow-scripts/tools/install/OpenROAD/bin:$PATH; `
   /usr/local/bin/yosys -s /workspace/scripts/synth_counter.ys'

# 時序分析
docker run --rm -v D:\Systemverilog-Verilog-Learning:/workspace openroad/orfs sh -c `
  'export PATH=/OpenROAD-flow-scripts/tools/install/OpenROAD/bin:$PATH; `
   /OpenROAD-flow-scripts/tools/install/OpenROAD/bin/sta /workspace/scripts/sta_counter.tcl'
```

---

## 📊 報告解讀

### 面積報告 (comb_stat.rpt)

```
=== Comb ===
      178 wires
      187 cells
   Chip area for module '\Comb': 1222.422400
```

**含義：**
- `187 cells` - 使用的標準單元個數
- `1222.42` - 電路面積（µm²），使用 sky130 工藝

### 時序報告 (comb_sta.rpt)

典型的時序路徑報告：

```
Startpoint: in_num0[0] (input port clocked by vclk)
Endpoint: out_num0[0] (output port clocked by vclk)
Path Group: vclk
Path Type: max

Point                              Incr       Path
-------------------------------------------------------
clock vclk (rise edge)             0.00       0.00
input_external_delay               2.00       2.00
in_num0[0] (input port)            0.00       2.00 r
U1/A (AND2)                        0.00       2.00 r
U1/Y (AND2)                        0.15       2.15 f
...
out_num0[0] (output port)          0.00       3.45 f

data arrival time                              3.45

clock vclk (rise edge)            10.00      10.00
output_external_delay             -2.00       8.00
data required time                             8.00

slack (MET)                                    4.55
```

**關鍵指標：**
| 項目 | 含義 | 目標 |
|------|------|------|
| **slack** | 剩餘時間裕度 | > 0 (正值) ✓ |
| **data arrival time** | 信號實際到達時間 | 越小越好 |
| **data required time** | 信號須到達的時間 | 由時脈和延遲決定 |

### Slack 報告 (comb_worst_slack.rpt)

```
worst slack 5.23
```

**含義：**
- 所有路徑中剩餘時間最少的值
- `> 0` 表示沒有 timing violation ✓
- `< 0` 表示有路徑超時，需優化

---

## 🔧 常見問題與調整

### 問題：找不到標準單元庫

**症狀：** `Error: Cannot open Liberty file`

**解決：** 確保使用正確的 Docker image
```powershell
docker pull openroad/orfs
```

### 問題：時序違規 (Slack < 0)

**症狀：** 報告顯示負的 slack

**解決方案：**
1. **增加時脈週期** - 修改 SDC 中的 `create_clock -period`
2. **減少時序延遲** - 優化組合邏輯深度，使用 pipeline
3. **調整輸入延遲** - 修改 `set_input_delay` / `set_output_delay`

**例子：從 10ns 改為 20ns**
```tcl
# constraints/comb.sdc
create_clock -name vclk -period 20.0 [get_ports clk]  # ← 從 10.0 改為 20.0
```

### 問題：合成出現警告 "No latch inferred for signal..."

**含義：** 設計中有訊號在所有 always_comb 分支中都有賦值，正常。✓

### 問題：輸出訊號有多個 bit 沒有驅動

**症狀：** `Warning: Wire out_num1 [7] is used but has no driver`

**原因：** 輸出位寬不匹配

**解決：** 檢查 RTL 中的輸出位寬定義

---

## 📂 完整目錄結構

```
DCS-Connection/
├── README.md                    ← 本檔案
├── Lab1/
│   ├── Comb_dcs076.sv          ← RTL 源代碼
│   ├── PATTERN_Lab01.sv         ← Testbench
│   └── ...
├── Lab2/
│   ├── Counter_dcs076.sv
│   ├── PATTERN_Lab02.sv
│   └── ...
├── scripts/
│   ├── synth_comb_yosys.ys      ← Lab1 合成腳本
│   ├── sta_comb.tcl             ← Lab1 STA 腳本
│   ├── synth_counter.ys         ← Lab2 合成腳本（自己建立）
│   ├── sta_counter.tcl          ← Lab2 STA 腳本（自己建立）
│   └── ...
├── constraints/
│   ├── comb.sdc                 ← Lab1 時序約束
│   ├── counter.sdc              ← Lab2 時序約束（自己建立）
│   └── ...
├── output/
│   ├── comb_synth.v             ← Lab1 合成後的網表
│   ├── counter_synth.v          ← Lab2 合成後的網表
│   └── ...
└── reports/
    ├── comb_stat.rpt            ← Lab1 面積統計
    ├── comb_sta.rpt             ← Lab1 時序報告
    ├── counter_stat.rpt         ← Lab2 面積統計
    ├── counter_sta.rpt          ← Lab2 時序報告
    └── ...
```

---

## 🎯 Lab-by-Lab 快速參考

| Lab | Module | Top Name | Testbench | 腳本位置 |
|-----|--------|----------|-----------|---------|
| Lab1 | 組合邏輯 | `Comb` | PATTERN_Lab01.sv | scripts/synth_comb_yosys.ys |
| Lab2 | 計數器 | `Counter` | PATTERN_Lab02.sv | 需自建 |
| Lab3 | 序列邏輯 | `Seq` | PATTERN_Lab03.sv | 需自建 |
| Lab4 | FIFO | `FIFO` | PATTERN_Lab04.sv | 需自建 |
| Lab5 | FSM | `FSM` | PATTERN_Lab05.sv | 需自建 |

---

## 📋 合成檢查清單

完成每個 Lab 的合成前，確認：

- [ ] Testbench 執行通過 (python run_sim.py 無錯誤)
- [ ] RTL 檔案位置正確
- [ ] 合成腳本中的 top module 名稱正確
- [ ] STA 腳本中的 top module 名稱正確
- [ ] SDC 中的時脈訊號名稱正確
- [ ] Docker 可用 (docker --version)
- [ ] 輸出目錄存在 (output/, reports/)

---

## 🔄 一鍵自動化腳本（PowerShell）

創建 `synth.ps1`，放在根目錄：

```powershell
#!/usr/bin/env pwsh
param(
    [string]$Module = "Comb",
    [string]$LabNum = "1"
)

Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  RTL to Gate-level Synthesis Flow      ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan

$synth_script = "scripts/synth_${Module}.ys".ToLower()
$sta_script = "scripts/sta_${Module}.tcl".ToLower()

if (!(Test-Path $synth_script)) {
    Write-Host "❌ 找不到合成腳本: $synth_script" -ForegroundColor Red
    exit 1
}

Write-Host "`n[1/2] Running Yosys Synthesis..." -ForegroundColor Yellow
docker run --rm -v ${pwd}:/workspace openroad/orfs sh -c `
  "export PATH=/OpenROAD-flow-scripts/tools/install/OpenROAD/bin:`$PATH; " + `
  "/usr/local/bin/yosys -s /workspace/$synth_script" | Out-Host

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Synthesis complete" -ForegroundColor Green
} else {
    Write-Host "❌ Synthesis failed" -ForegroundColor Red
    exit 1
}

if (Test-Path $sta_script) {
    Write-Host "`n[2/2] Running Static Timing Analysis..." -ForegroundColor Yellow
    docker run --rm -v ${pwd}:/workspace openroad/orfs sh -c `
      "export PATH=/OpenROAD-flow-scripts/tools/install/OpenROAD/bin:`$PATH; " + `
      "/OpenROAD-flow-scripts/tools/install/OpenROAD/bin/sta /workspace/$sta_script" | Out-Host
    
    Write-Host "`n✓ Analysis complete" -ForegroundColor Green
} else {
    Write-Host "⚠ STA script not found: $sta_script" -ForegroundColor Yellow
}

Write-Host "`n📊 Results:" -ForegroundColor Green
Write-Host "   Gate-level netlist: output/${Module}_synth.v"
Write-Host "   Area report:        reports/${Module}_stat.rpt"
Write-Host "   Timing report:      reports/${Module}_sta.rpt"
```

**使用方法：**
```powershell
# Lab1 合成
.\synth.ps1 -Module "Comb" -LabNum "1"

# Lab2 合成
.\synth.ps1 -Module "Counter" -LabNum "2"
```

---

## 📚 進階資源

- **Yosys 文檔**: https://yosyshq.net/yosys/
- **OpenSTA 文檔**: https://github.com/The-OpenROAD-Project/OpenSTA
- **SkyWater 130nm PDK**: https://github.com/google/skywater-pdk
- **OpenROAD Flow Scripts**: https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts

---

## 💡 工業級工具對照

你的開源流程 vs 工業工具：

| 功能 | 開源工具 | 工業工具 | 相似度 |
|------|----------|----------|--------|
| Synthesis | Yosys + ABC | Design Compiler | 70% |
| Timing | OpenSTA | PrimeTime | 85% |
| P&R | OpenROAD | ICC2 | 60% |
| Libraries | SkyWater 130nm | 商業 PDK | ✓ |

---

**最後更新**：2026年2月4日  
**相關文檔**：[SYNTHESIS_TOOLS_SETUP.md](../SYNTHESIS_TOOLS_SETUP.md)
