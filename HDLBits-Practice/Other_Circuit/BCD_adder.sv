`timescale 1ns/1ps

module top_module(
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );

  wire [100:0] out;
  assign out[0] = cin;
  genvar i;
  generate
    for(i=0;i<100;i=i+1)
    begin : fadd_loop
      bcd_fadd a1(a[4*i+3:4*i],b[4*i+3:4*i],out[i],out[i+1],sum[4*i+3:4*i]);
    end
  endgenerate

  assign cout = out[100];
endmodule
