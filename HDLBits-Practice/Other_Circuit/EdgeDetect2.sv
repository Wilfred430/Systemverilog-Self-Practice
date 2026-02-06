`timescale 1ns/1ps

module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
  );

  reg [7:0] tmp;

  always @(posedge clk)
  begin
    anyedge <=((~tmp) & in) | (tmp & (~in));
    tmp <= in;
  end
endmodule
