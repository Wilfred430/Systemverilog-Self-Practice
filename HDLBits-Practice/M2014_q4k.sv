`timescale 1ns/1ps

module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output out);

  reg Q1,Q2,Q3;

  always @(posedge clk)
  begin
    if(!resetn)
    begin
      out <= 0;
      Q3 <= 0;
      Q2 <= 0;
      Q1 <= 0;
    end
    else
    begin
      Q1 <= in;
      Q2 <= Q1;
      Q3 <= Q2;
      out <= Q3;
    end
  end

endmodule
