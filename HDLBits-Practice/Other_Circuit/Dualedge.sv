`timescale 1ns/1ps

module top_module (
    input clk,
    input d,
    output q);

  reg q_pos,q_neg;

  always @(posedge clk) q_pos <= q;
  always @(negedge clk) q_neg <= q;

  assign q = (clk)? q_pos:q_neg;

endmodule

