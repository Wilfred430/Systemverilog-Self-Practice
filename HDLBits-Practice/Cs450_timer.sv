`timescale 1ns/1ps

module top_module(
    input clk,
    input load,
    input [9:0] data,
    output tc
  );

  logic [9:0] tmp;

  always_ff @(posedge clk)
  begin
    if(load)
      tmp <= data;
    else if(tmp > 0)
      tmp <= tmp-1;
    else if(tmp == 0)
      tc <= 1;
  end


endmodule
