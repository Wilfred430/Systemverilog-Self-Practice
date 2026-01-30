`timescale 1ns/1ps

module top_module (
    input clk,
    input x,
    output z
  );
  wire tmp1,tmp2,tmp3;
  wire tmp2_n,tmp3_n;
  wire tmp1_p,tmp2_p,tmp3_p;

  assign tmp1_p = x ^ tmp1;
  assign tmp2_p = x & tmp2_n;
  assign tmp3_p = x | tmp3_n;

  always @(posedge clk)
  begin
    tmp1 <= tmp1_p;
    tmp2 <= tmp2_p;
    tmp3 <= tmp3_p;
  end

  assign tmp2_n = ~tmp2;
  assign tmp3_n = ~tmp3;
  assign z = ~(tmp1 | tmp2 | tmp3);


endmodule
