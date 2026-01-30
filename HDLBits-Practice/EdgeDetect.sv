`timescale 1ns/1ps

module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
  );

  reg [7:0] in_dly;

  always @(posedge clk)
  begin
    pedge <= (~in_dly) & in; // 正緣偵測：從 0 → 1 的位元
    in_dly <= in;            // 更新延遲版本
  end

endmodule
