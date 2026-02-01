`timescale 1ns/1ps

module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q );

  always @(posedge clk)
  begin
    if(load)
      q<=data;
    else
    begin
      for(integer i=0;i<512;i=i+1)
      begin
        if(i == 0)
          q[0] <= q[1];
        else if(i == 511)
          q[511] <= q[510];
        else
          q[i] <= q[i+1] ^ q[i-1];
      end
    end
  end

endmodule
