`timescale 1ns/1ps

module top_module (
    input clk,
    input d,
    output q);

  reg q_pos,q_neg;

  always @(posedge clk)
  begin
