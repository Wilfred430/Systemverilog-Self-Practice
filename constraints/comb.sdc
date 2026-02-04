# SDC constraints for combinational design
create_clock -name vclk -period 10.0
set_input_delay -clock vclk -max 2.0 [all_inputs]
set_input_delay -clock vclk -min 0.5 [all_inputs]
set_output_delay -clock vclk -max 2.0 [all_outputs]
set_output_delay -clock vclk -min 0.5 [all_outputs]
set_input_transition 0.1 [all_inputs]
set_load 0.05 [all_outputs]
