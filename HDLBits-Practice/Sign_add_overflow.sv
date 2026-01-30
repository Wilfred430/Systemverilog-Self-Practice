`timescale 1ns/1ps

module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
  ); //

  wire out[8:0];
  assign out[0] = 1'b0;
  genvar i;
  generate
    for(i=0;i<8;i=i+1)
    begin: fadd_loop
      add1 fadd(a[i],b[i],out[i],s[i],out[i+1]);
    end
  endgenerate

  assign overflow = (a[7] == b[7]) & (s[7] != a[7]);

endmodule

module add1 ( input a, input b, input cin,   output sum, output cout );

  // Full adder module here
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) + (cin & (a + b));
endmodule
