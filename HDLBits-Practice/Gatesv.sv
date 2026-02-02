`timescale 1ns/1ps

module top_module(
    input [3:0] in,
    output [2:0] out_both,
    output [3:1] out_any,
    output [3:0] out_different );

  always @(*)
  begin
    for(int i=0;i<4;i=i+1)
    begin
      if(i<3)
        out_both[i] = (in[i] & in[i+1])? 1:0;
      if(i>0)
        out_any[i] = (in[i] | in[i-1])?1:0;
      out_different[i] = ((in[i] & !in[(i+1)%4])|(!in[i] & in[(i+1)%4]))?1:0;
    end
  end

endmodule
