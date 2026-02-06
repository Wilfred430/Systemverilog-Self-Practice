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
    begin
      tmp <= data;
    end
    else if(tmp > 0)
      tmp <= tmp-1;
  end

  assign tc = (tmp == 0);

endmodule
