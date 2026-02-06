`timescale 1ns/1ps

module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
  );//
  wire cout_1,cout_2;
  add16 a1(a[15:0],b[15:0],1'b0,sum[15:0],cout_1);
  add16 a2(a[31:16],b[31:16],cout_1,sum[31:16],cout_2);
endmodule

module add16 ( input[15:0] a, input[15:0] b, input cin, output[15:0] sum, output cout );

  wire cout_1,cout_2,cout_3,cout_4,
       cout_5,cout_6,cout_7,cout_8,
       cout_9,cout_10,cout_11,cout_12,
       cout_13,cout_14,cout_15;

  add1 a1(a[0],b[0],cin,sum[0],cout_1);
  add1 a2(a[1],b[1],cout_1,sum[1],cout_2);
  add1 a3(a[2],b[2],cout_2,sum[2],cout_3);
  add1 a4(a[3],b[3],cout_3,sum[3],cout_4);
  add1 a5(a[4],b[4],cout_4,sum[4],cout_5);
  add1 a6(a[5],b[5],cout_5,sum[5],cout_6);
  add1 a7(a[6],b[6],cout_6,sum[6],cout_7);
  add1 a8(a[7],b[7],cout_7,sum[7],cout_8);
  add1 a9(a[8],b[8],cout_8,sum[8],cout_9);
  add1 a10(a[9],b[9],cout_9,sum[9],cout_10);
  add1 a11(a[10],b[10],cout_10,sum[10],cout_11);
  add1 a12(a[11],b[11],cout_11,sum[11],cout_12);
  add1 a13(a[12],b[12],cout_12,sum[12],cout_13);
  add1 a14(a[13],b[13],cout_13,sum[13],cout_14);
  add1 a15(a[14],b[14],cout_14,sum[14],cout_15);
  add1 a16(a[15],b[15],cout_15,sum[15],cout);
endmodule

module add1 ( input a, input b, input cin,   output sum, output cout );

  // Full adder module here
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) + (cin & (a + b));
endmodule
