## Verilog-Self-Practice
Improving the verilog skills.    
Source : https://josh-gao.top/posts/53b8b42e.html  
Pipeline : https://blog.csdn.net/luoganttcc/article/details/127990165




## Simulation Step:
For /DCS-Connection/Lab1 as example:

### 1) Compile RTL code and testbench
```bash
iverilog -o comb_test.vvp Comb_dcs076.sv PATTERN_Lab01.sv
```

### 2) Run simulation
```bash
vvp comb_test.vvp
```

### 3) Open waveform with Surfer
Make sure the testbench contains $dumpfile and $dumpvars so that comb_dcs076.vcd is generated.
```bash
surfer comb_dcs076.vcd
```

### 4) Synthesize circuit (Yosys)
Open OSS CAD Suite shell first, then run synthesis.

1. Start the OSS CAD Suite shell by running:
	C:\Tool\oss-cad-suite\start.bat

2. In the OSS CAD Suite shell, run:
```bash
yosys -p "read_verilog -sv Comb_dcs076.sv; synth; write_verilog comb_synth.v"
```

If you see errors about SystemVerilog keywords (for example logic), make sure -sv is present.
