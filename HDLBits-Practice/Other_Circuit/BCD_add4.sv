module top_module (
    input [15:0] a, b,
    input cin,
    output cout,
    output [15:0] sum );

  wire [4:0] out;
  assign out[0] = cin;
  genvar i;
  generate
    for(i=0;i<4;i=i+1)
    begin : bcdadd_4_loop
      bcd_fadd bcd(
                 a[4*i+:4],
                 b[4*i+:4],
                 out[i],
                 out[i+1],
                 sum[4*i+:4] );
    end
  endgenerate

  assign cout = out[4];

endmodule

module bcd_fadd (
    input [3:0] a,
    input [3:0] b,
    input     cin,
    output   cout,
    output [3:0] sum );

  assign {cout,sum} = a + b + cin;
endmodule
