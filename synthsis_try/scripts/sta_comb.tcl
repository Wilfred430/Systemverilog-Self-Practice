# OpenSTA analysis for Comb_dcs076

read_liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog /workspace/output/comb_synth.v
link_design Comb

read_sdc /workspace/constraints/comb.sdc
report_checks -path_delay max -from [all_inputs] -to [all_outputs] -format full_clock_expanded > /workspace/reports/comb_sta.rpt
report_worst_slack -max > /workspace/reports/comb_worst_slack.rpt
