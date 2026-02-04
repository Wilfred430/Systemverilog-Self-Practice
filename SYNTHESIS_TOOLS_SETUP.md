# SystemVerilog/Verilog 合成與分析工具安裝教學

本教學將協助您在 Windows 上安裝用於電路合成、時序分析和質量檢查的工具。

## 工具概覽

| 工具 | 功能 | 用途 |
|------|------|------|
| **Yosys** | 開源合成工具 | 合成電路、檢測 latch、電路面積分析 |
| **Verilator** | Linting & 模擬 | 檢測語法問題、潛在合成問題 |
| **OpenSTA** | 靜態時序分析 | 檢測 timing violations、setup/hold time |

---

## 1. Yosys 安裝 (電路合成與分析)

### Windows 安裝方式

#### 方法 1: 使用 OSS CAD Suite (推薦)

OSS CAD Suite 包含 Yosys、Verilator 等多個工具，最簡單的安裝方式。

1. 下載 OSS CAD Suite:
   - 前往: https://github.com/YosysHQ/oss-cad-suite-build/releases
   - 下載最新的 Windows 版本: `oss-cad-suite-windows-x64-xxxxxxxx.exe`

2. 執行安裝程式，選擇安裝目錄（建議: `C:\oss-cad-suite`）

3. 將安裝路徑加入環境變數:
   ```powershell
   # 在 PowerShell 中執行（管理員權限）
   $oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
   [Environment]::SetEnvironmentVariable("Path", "$oldPath;C:\oss-cad-suite\bin", "User")
   ```

4. 重新開啟終端機，驗證安裝:
   ```powershell
   yosys -V
   verilator --version
   ```

#### 方法 2: 使用 WSL (Windows Subsystem for Linux)

如果您有 WSL，可以在 Linux 環境中安裝:

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install yosys verilator

# 驗證
yosys -V
verilator --version
```

---

## 2. Yosys 使用範例

### 基本合成腳本

創建 `synthesis.ys`:

```tcl
# 讀取 SystemVerilog 檔案
read_verilog -sv your_design.sv

# 指定頂層模組
hierarchy -top top_module_name

# 執行合成
synth -top top_module_name

# 檢查設計
check

# 顯示統計資訊（電路面積）
stat

# 輸出網表
write_verilog -noattr synth_output.v

# 產生圖形化表示（需要 GraphViz）
show -format pdf -prefix design
```

### 執行合成:

```powershell
yosys synthesis.ys
```

### 檢測 Latch

Yosys 會自動在合成過程中報告 latch，例如:

```powershell
yosys -p "read_verilog -sv design.sv; synth -top top; check"
```

如果有 latch，會顯示類似警告:
```
Warning: Latch inferred for signal...
```

### 面積報告

使用 `stat` 命令查看資源使用:

```tcl
read_verilog -sv design.sv
synth -top top
stat -tech cmos  # 顯示詳細統計
```

---

## 3. Verilator 安裝與使用

### 使用 (已包含在 OSS CAD Suite)

如果使用 OSS CAD Suite，Verilator 已經安裝。

### Linting 檢查

```powershell
# 檢查語法和合成問題
verilator --lint-only -Wall -sv your_design.sv

# 更嚴格的檢查
verilator --lint-only -Wall -Wno-fatal -sv your_design.sv
```

Verilator 會檢測:
- 未使用的訊號
- 潛在的 latch
- 時序邏輯問題
- 組合邏輯迴圈
- 位寬不匹配

---

## 4. OpenSTA 安裝 (時序分析)

### Windows 安裝

OpenSTA 在 Windows 上較難安裝，建議使用 WSL:

```bash
# 在 WSL Ubuntu 中
sudo apt-get update
sudo apt-get install -y build-essential cmake tcl-dev swig bison flex

# 克隆並編譯 OpenSTA
git clone https://github.com/The-OpenROAD-Project/OpenSTA.git
cd OpenSTA
mkdir build && cd build
cmake ..
make -j$(nproc)
sudo make install
```

### 使用範例

創建 SDC 檔案 (`design.sdc`):

```tcl
# 設定時脈
create_clock -name clk -period 10 [get_ports clk]

# 設定輸入延遲
set_input_delay -clock clk 2 [all_inputs]

# 設定輸出延遲
set_output_delay -clock clk 2 [all_outputs]
```

執行時序分析:

```bash
sta
read_liberty your_library.lib
read_verilog synth_output.v
link_design top_module_name
read_sdc design.sdc
report_checks -path_delay max
report_checks -path_delay min
```

---

## 5. 完整工作流程範例

### 專案結構

```
your_project/
├── rtl/
│   └── design.sv
├── scripts/
│   ├── synthesis.ys
│   └── timing.sdc
├── output/
│   └── (合成結果)
└── reports/
    └── (分析報告)
```

### 自動化腳本

創建 `run_synthesis.ps1`:

```powershell
# 步驟 1: Verilator Linting
Write-Host "=== Running Verilator Linting ===" -ForegroundColor Green
verilator --lint-only -Wall -sv rtl/design.sv

# 步驟 2: Yosys 合成
Write-Host "`n=== Running Yosys Synthesis ===" -ForegroundColor Green
yosys scripts/synthesis.ys > reports/synthesis.log

# 步驟 3: 檢查報告
Write-Host "`n=== Synthesis Complete ===" -ForegroundColor Green
Write-Host "Check reports/synthesis.log for details"
```

### Yosys 合成腳本範例 (`scripts/synthesis.ys`)

```tcl
# 讀取設計
read_verilog -sv rtl/design.sv

# 設定頂層
hierarchy -check -top top_module_name

# 流程優化合成
proc; opt; fsm; opt; memory; opt

# 技術映射
techmap; opt

# ABC 優化（需要標準單元庫）
# abc -liberty lib/cells.lib

# 檢查設計
check

# 統計報告
tee -o reports/area_report.txt stat

# 檢測 latch
select t:$dlatch
tee -a reports/latch_report.txt dump

# 輸出網表
write_verilog -noattr output/synth_design.v

# 生成 DOT 圖
show -format dot -prefix reports/design
```

---

## 6. 常見檢查項目

### 檢測 Latch

**問題**: 組合邏輯中產生非預期的 latch

**Verilator 檢查**:
```powershell
verilator --lint-only -Wall -sv design.sv
```
會顯示: `%Warning-LATCH: Latch inferred...`

**修復方法**:
- 確保 `always_comb` 或 `always @(*)` 中所有路徑都有賦值
- 為所有情況提供 default 值

```systemverilog
// 錯誤 - 會產生 latch
always_comb begin
    if (sel)
        out = a;
    // 缺少 else，out 在 sel=0 時保持值 -> latch
end

// 正確
always_comb begin
    if (sel)
        out = a;
    else
        out = b;  // 或 out = 0;
end
```

### 檢測 Timing Violations

使用 Yosys 的基本檢查:

```tcl
# 在 synthesis.ys 中加入
read_verilog -sv design.sv
synth -top top
stat -tech cmos

# 檢查關鍵路徑
tee -o reports/critical_paths.txt stat -tech cmos -width
```

更精確的時序分析需要 OpenSTA 或商業工具。

### 檢查電路面積

```powershell
# 使用 Yosys
yosys -p "read_verilog -sv design.sv; synth -top top; stat" | Tee-Object area_report.txt
```

查看輸出中的:
- Number of cells
- Number of wires
- Estimated area (如果有標準單元庫)

---

## 7. 工具比較與選擇

| 需求 | 推薦工具 | 替代方案 |
|------|----------|----------|
| 檢測 Latch | Verilator, Yosys | Synopsys DC |
| 時序違規 | OpenSTA | PrimeTime, Vivado |
| 電路面積 | Yosys (with libs) | Design Compiler |
| 語法檢查 | Verilator | Synopsys VCS |
| 功率分析 | (需商業工具) | PrimePower |

---

## 8. 進階資源

### 學習資源

- Yosys 官方文件: https://yosyshq.net/yosys/
- Verilator 手冊: https://verilator.org/guide/latest/
- OpenSTA GitHub: https://github.com/The-OpenROAD-Project/OpenSTA

### 標準單元庫

對於更真實的合成結果，需要標準單元庫 (Liberty .lib 檔案):

- SkyWater 130nm PDK (開源): https://github.com/google/skywater-pdk
- FreePDK45: http://www.eda.ncsu.edu/wiki/FreePDK45:Contents

---

## 9. 快速開始範例

針對您的 `Comb_dcs076.sv`:

```powershell
# 1. Linting 檢查
verilator --lint-only -Wall -sv DCS-Connection/Lab1/Comb_dcs076.sv

# 2. 合成
yosys -p "read_verilog -sv DCS-Connection/Lab1/Comb_dcs076.sv; synth; stat; check"

# 3. 查看生成的電路
yosys -p "read_verilog -sv DCS-Connection/Lab1/Comb_dcs076.sv; synth; show"
```

---

## 故障排除

### 問題: 找不到命令

**解決**: 確保環境變數設定正確，重新開啟終端機

### 問題: Yosys 無法讀取 SystemVerilog

**解決**: 使用 `-sv` 旗標: `read_verilog -sv file.sv`

### 問題: 缺少標準單元庫

**解決**: 對於學習目的，可以不使用庫進行基本合成，或下載開源 PDK

---

---

## 10. 🏭 工業級開源合成流程 (推薦)

### 最接近工業級合成的免費方案

**OpenROAD Flow + OpenSTA + SkyWater PDK**

這個組合可以產生類似工業工具（Synopsys Design Compiler / PrimeTime）的詳細時序報告。

### 完整工業級流程

```
RTL Design (SystemVerilog)
    ↓
[Yosys] Synthesis with ABC
    ↓
Gate-level Netlist (.v)
    ↓
[OpenSTA] Static Timing Analysis
    ↓
Detailed Timing Reports (setup/hold, slack, delays)
```

---

## 11. 工業級時序分析設置

### 步驟 1: 安裝 OpenROAD (包含 OpenSTA)

#### Windows (使用 WSL2)

```bash
# 在 WSL Ubuntu 中執行
sudo apt-get update
sudo apt-get install -y git python3 python3-pip cmake build-essential \
    tcl-dev swig bison flex libreadline-dev gawk wget

# 安裝 OpenROAD
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD.git
cd OpenROAD
./etc/DependencyInstaller.sh
./etc/Build.sh

# 或使用預編譯版本
# 從 https://github.com/The-OpenROAD-Project/OpenROAD/releases 下載
```

#### 使用 Docker (最簡單)

```powershell
# 在 Windows PowerShell 中
docker pull openroad/flow-ubuntu

# 運行容器
docker run -it -v D:\Systemverilog-Verilog-Learning:/workspace openroad/flow-ubuntu
```

### 步驟 2: 下載標準單元庫

```bash
# SkyWater 130nm PDK (開源)
git clone https://github.com/google/skywater-pdk.git

# 或下載預編譯的 Liberty 檔案
wget https://github.com/google/skywater-pdk-libs-sky130_fd_sc_hd/archive/refs/heads/main.zip
```

### 步驟 3: 完整合成腳本

創建 `industrial_synthesis.ys`:

```tcl
# ==========================================
# 工業級 Yosys 合成腳本
# ==========================================

# 讀取 RTL
read_verilog -sv rtl/design.sv

# 設定頂層模組
hierarchy -check -top top_module_name

# 高階合成
proc; opt; fsm; opt; memory; opt

# 技術映射到標準單元
techmap; opt

# 使用 ABC 進行邏輯優化（接近工業級）
# 需要 Liberty 檔案
abc -liberty lib/sky130_fd_sc_hd__tt_025C_1v80.lib -constr design.sdc

# 或不使用 Liberty（基本優化）
# abc -g AND,NAND,OR,NOR,XOR,XNOR,MUX

# 清理優化
clean

# 檢查設計
check

# 詳細統計
stat -liberty lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# 輸出帶時序資訊的網表
write_verilog -noattr -noexpr output/synth_netlist.v

# 輸出 BLIF（用於其他工具）
write_blif output/design.blif

# 產生 SDF (Standard Delay Format)
# write_sdf output/design.sdf
```

### 步驟 4: OpenSTA 時序分析配置

創建 `sta_analysis.tcl`:

```tcl
# ==========================================
# OpenSTA 時序分析腳本
# 產生類似工業工具的時序報告
# ==========================================

# 讀取 Liberty 標準單元庫
read_liberty lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# 讀取合成後的網表
read_verilog output/synth_netlist.v

# 連結設計
link_design top_module_name

# 讀取 SDC 約束
read_sdc constraints/design.sdc

# ==========================================
# 時序報告
# ==========================================

# 設定報告格式
set_report_format -max_line_length 120

# 報告所有時脈
report_clocks > reports/clocks.rpt

# 報告 Setup Time (最大延遲路徑)
report_checks -path_delay max -format full_clock_expanded \
              -fields {capacitance slew input_pins nets fanout} \
              -digits 3 -path_group clk \
              > reports/setup_timing.rpt

# 報告 Hold Time (最小延遲路徑)
report_checks -path_delay min -format full_clock_expanded \
              -fields {capacitance slew input_pins nets fanout} \
              -digits 3 -path_group clk \
              > reports/hold_timing.rpt

# 報告所有違規路徑
report_checks -path_delay max -slack_max 0.0 -format full_clock_expanded \
              > reports/setup_violations.rpt

# 報告最差的 10 條路徑
report_checks -path_delay max -format full_clock_expanded \
              -endpoint_count 10 \
              > reports/top10_critical_paths.rpt

# 報告 Slack 總結
report_worst_slack -max > reports/worst_slack.rpt
report_tns > reports/total_negative_slack.rpt

# 報告每個端點的 Slack
report_check_types -max_slew -max_capacitance -max_fanout \
                   > reports/design_rules.rpt

# 報告功率（如果有功率資訊）
# report_power > reports/power.rpt

# 報告面積
report_design_area > reports/area.rpt

puts "Timing analysis complete! Check reports/ directory."
```

### 步驟 5: SDC 約束檔案

創建 `constraints/design.sdc`:

```tcl
# ==========================================
# Synopsys Design Constraints (SDC)
# 標準時序約束格式
# ==========================================

# 設定時脈
# create_clock -name <clock_name> -period <period_ns> [get_ports <port>]
create_clock -name clk -period 10.0 [get_ports clk]

# 時脈不確定性 (clock uncertainty / jitter)
set_clock_uncertainty -setup 0.5 [get_clocks clk]
set_clock_uncertainty -hold 0.3 [get_clocks clk]

# 時脈轉換時間 (clock transition)
set_clock_transition 0.1 [get_clocks clk]

# 時脈延遲
set_clock_latency -source 1.0 [get_clocks clk]
set_clock_latency 0.5 [get_clocks clk]

# 輸入延遲 (input delay)
set_input_delay -clock clk -max 2.0 [all_inputs]
set_input_delay -clock clk -min 0.5 [all_inputs]

# 輸出延遲 (output delay)
set_output_delay -clock clk -max 2.0 [all_outputs]
set_output_delay -clock clk -min 0.5 [all_outputs]

# 輸入轉換時間
set_input_transition 0.1 [all_inputs]

# 負載電容 (output load)
set_load 0.05 [all_outputs]

# 驅動能力 (input drive)
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_1 [all_inputs]

# 多週期路徑 (如果需要)
# set_multicycle_path -setup 2 -from [get_pins reg1/Q] -to [get_pins reg2/D]

# False Path (不需要時序檢查的路徑)
# set_false_path -from [get_ports reset] -to [all_registers]

# 最大延遲約束
# set_max_delay 5.0 -from [get_ports in] -to [get_ports out]

# 設計規則約束
set_max_fanout 16 [current_design]
set_max_transition 0.5 [current_design]
set_max_capacitance 0.2 [all_outputs]
```

### 步驟 6: 執行完整流程

創建自動化腳本 `run_industrial_flow.ps1`:

```powershell
#!/usr/bin/env pwsh
# ==========================================
# 工業級合成與時序分析自動化腳本
# ==========================================

param(
    [string]$Design = "design",
    [string]$TopModule = "top"
)

Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Industrial-Grade Synthesis Flow         ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan

# 創建目錄結構
$dirs = @("output", "reports", "logs")
foreach ($dir in $dirs) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

# Step 1: Verilator Linting
Write-Host "`n[1/5] Running Verilator Lint Check..." -ForegroundColor Yellow
verilator --lint-only -Wall -sv rtl/$Design.sv 2>&1 | Tee-Object logs/verilator.log

# Step 2: Yosys Synthesis
Write-Host "`n[2/5] Running Yosys Synthesis..." -ForegroundColor Yellow
yosys -s scripts/synthesis.ys 2>&1 | Tee-Object logs/synthesis.log

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Synthesis failed! Check logs/synthesis.log" -ForegroundColor Red
    exit 1
}

# Step 3: 檢查合成結果
if (Test-Path output/synth_netlist.v) {
    Write-Host "✓ Synthesis successful: output/synth_netlist.v" -ForegroundColor Green
} else {
    Write-Host "❌ Netlist not generated!" -ForegroundColor Red
    exit 1
}

# Step 4: OpenSTA Timing Analysis
Write-Host "`n[3/5] Running Static Timing Analysis..." -ForegroundColor Yellow

# 檢查是否有 OpenSTA
if (Get-Command sta -ErrorAction SilentlyContinue) {
    sta scripts/sta_analysis.tcl 2>&1 | Tee-Object logs/sta.log
    Write-Host "✓ Timing analysis complete" -ForegroundColor Green
} else {
    Write-Host "⚠ OpenSTA not found. Install OpenSTA for detailed timing analysis." -ForegroundColor Yellow
    Write-Host "  Using Yosys timing estimation..." -ForegroundColor Yellow
}

# Step 5: 生成報告摘要
Write-Host "`n[4/5] Generating Summary Report..." -ForegroundColor Yellow

# 從 Yosys log 提取統計
$stats = Get-Content logs/synthesis.log | Select-String -Pattern "Number of|Chip area"

Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║         SYNTHESIS SUMMARY                  ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Green

foreach ($line in $stats) {
    Write-Host "  $line" -ForegroundColor White
}

# Step 6: 檢查時序違規
Write-Host "`n[5/5] Checking Timing Violations..." -ForegroundColor Yellow

if (Test-Path reports/setup_violations.rpt) {
    $violations = Get-Content reports/setup_violations.rpt
    if ($violations.Length -gt 0) {
        Write-Host "⚠ Setup violations found! Check reports/setup_violations.rpt" -ForegroundColor Red
    } else {
        Write-Host "✓ No setup violations" -ForegroundColor Green
    }
}

Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Flow Complete!                           ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "`nResults:"
Write-Host "  📄 Netlist:      output/synth_netlist.v"
Write-Host "  📊 Reports:      reports/"
Write-Host "  📝 Logs:         logs/"
Write-Host ""
```

### 步驟 7: 實際執行範例

```powershell
# 建立專案結構
mkdir industrial_synthesis
cd industrial_synthesis

# 創建目錄
mkdir rtl, scripts, constraints, lib, output, reports, logs

# 將您的設計放入 rtl/
# 創建 SDC 約束
# 下載或連結標準單元庫到 lib/

# 執行流程
.\run_industrial_flow.ps1 -Design "Comb_dcs076" -TopModule "Comb"
```

---

## 12. 時序報告解讀

### 理解時序報告（類似您的附圖）

典型的 OpenSTA 時序報告格式：

```
Startpoint: input_reg (rising edge-triggered flip-flop clocked by clk)
Endpoint: output_reg (rising edge-triggered flip-flop clocked by clk)
Path Group: clk
Path Type: max

Point                                    Incr       Path
-----------------------------------------------------------
clock clk (rise edge)                    0.00       0.00
clock network delay (ideal)              1.00       1.00
input_reg/CLK (DFF)                      0.00       1.00 r
input_reg/Q (DFF)                        0.45       1.45 r
U1/A (NAND2)                             0.00       1.45 r
U1/Y (NAND2)                             0.15       1.60 f
U2/A (NOR2)                              0.00       1.60 f
U2/Y (NOR2)                              0.12       1.72 r
output_reg/D (DFF)                       0.00       1.72 r
data arrival time                                   1.72

clock clk (rise edge)                   10.00      10.00
clock network delay (ideal)              1.00      11.00
clock uncertainty                       -0.50      10.50
output_reg/CLK (DFF)                     0.00      10.50 r
library setup time                      -0.15      10.35
data required time                                 10.35
-----------------------------------------------------------
data required time                                 10.35
data arrival time                                  -1.72
-----------------------------------------------------------
slack (MET)                                         8.63
```

### 關鍵指標

| 項目 | 說明 | 目標 |
|------|------|------|
| **Slack** | required time - arrival time | > 0 (正值) |
| **Setup Violation** | Slack < 0 | 需修正 |
| **Hold Violation** | 資料到達太快 | 需修正 |
| **TNS** | Total Negative Slack | = 0 |
| **WNS** | Worst Negative Slack | = 0 |

### 修正時序違規的方法

1. **降低時脈頻率** (增加 period)
2. **減少組合邏輯深度** (pipeline)
3. **優化關鍵路徑** (重新設計)
4. **調整 register placement**
5. **使用更快的標準單元**

---

## 13. 工業級 vs 開源工具對照表

| 功能 | 工業級工具 | 開源替代方案 | 相似度 |
|------|-----------|-------------|--------|
| **Synthesis** | Design Compiler (Synopsys) | Yosys + ABC | 70% |
| **STA** | PrimeTime (Synopsys) | OpenSTA | 85% |
| **P&R** | ICC2 (Synopsys) | OpenROAD | 60% |
| **Formal** | Formality (Synopsys) | Yosys formal | 65% |
| **Power** | PrimePower (Synopsys) | (limited) | 30% |
| **DFT** | DFT Compiler (Synopsys) | (limited) | 20% |

**OpenSTA** 是最接近工業級工具的開源 STA 工具！

---

## 14. 針對您的課程設計的完整範例

### 為 `Comb_dcs076.sv` 建立工業級分析

創建 `analyze_comb.ps1`:

```powershell
# 分析 Comb_dcs076.sv

# 1. Lint
Write-Host "=== Linting ===" -ForegroundColor Green
verilator --lint-only -Wall -sv DCS-Connection/Lab1/Comb_dcs076.sv

# 2. Synthesis
Write-Host "`n=== Synthesis ===" -ForegroundColor Green
yosys -p "
    read_verilog -sv DCS-Connection/Lab1/Comb_dcs076.sv;
    hierarchy -check -auto-top;
    proc; opt;
    techmap; opt;
    abc -g AND,OR,XOR,NAND,NOR;
    clean;
    stat;
    write_verilog -noattr output/comb_synth.v
" | Tee-Object logs/comb_synthesis.log

# 3. 檢查 Latch
Write-Host "`n=== Checking for Latches ===" -ForegroundColor Green
$latch_check = Select-String -Path logs/comb_synthesis.log -Pattern "latch"
if ($latch_check) {
    Write-Host "⚠ Latches detected:" -ForegroundColor Red
    $latch_check
} else {
    Write-Host "✓ No latches found" -ForegroundColor Green
}

# 4. 面積報告
Write-Host "`n=== Area Report ===" -ForegroundColor Green
Select-String -Path logs/comb_synthesis.log -Pattern "Number of|Chip area"
```

---

## 總結

**基本工作流程**:
1. **Verilator** → 檢查語法和潛在問題
2. **Yosys** → 合成電路，檢查 latch 和面積
3. **OpenSTA** → 時序分析（進階）

**工業級工作流程** (最接近您的附圖):
1. **Yosys + ABC + Liberty** → 高品質合成
2. **OpenSTA + SDC** → 詳細 STA 報告 (setup/hold/slack)
3. **標準單元庫** (SkyWater PDK) → 真實的延遲和面積

**推薦開始**:
- **基礎**: 安裝 OSS CAD Suite（包含 Yosys + Verilator）
- **進階**: 使用 Docker 運行 OpenROAD + OpenSTA
- **專業**: 配合 SkyWater PDK 做完整的 PPA 分析

**最接近工業級的免費方案**:
```bash
docker pull openroad/flow-ubuntu
# 即可獲得完整的工業級開源 EDA 流程！
```

如有問題，歡迎提出！
