`timescale 1ns/1ps

module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
  );
  reg [31:0] tmp;
  reg [31:0] det;

  assign det = (tmp & (~in));
  always @(posedge clk)
  begin
    if(reset)
      out <= 32'b0;
    else if(det>0 && ~reset)
      out <= (tmp & (~in)) | out;

    tmp <= in;

  end
endmodule
