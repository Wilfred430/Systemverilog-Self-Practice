`timescale 1ns/1ps

module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
  ); //

  MUXDFF M1(KEY[0],KEY[3],SW[3],KEY[1],KEY[2],LEDR[3]);
  MUXDFF M2(KEY[0],LEDR[3],SW[2],KEY[1],KEY[2],LEDR[2]);
  MUXDFF M3(KEY[0],LEDR[2],SW[1],KEY[1],KEY[2],LEDR[1]);
  MUXDFF M4(KEY[0],LEDR[1],SW[0],KEY[1],KEY[2],LEDR[0]);

endmodule

// clk to KEY[0],
// E to KEY[1],
// L to KEY[2], and
// w to KEY[3].

module MUXDFF (input clk,input w,input R,input E,input L,output Q);

  wire tmp1,tmp2;
  assign tmp1 = (E)?w:Q;
  assign tmp2 = (L)?R:tmp1;

  always @(posedge clk) Q <= tmp2;

endmodule
