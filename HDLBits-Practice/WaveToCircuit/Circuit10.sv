module top_module (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

  always @(posedge clk) begin

    state <= (a == 1 & b == 1) ? 1 : (a == 0 & b == 0) ? 0 : state;
  end
  assign q = state == 1 ? !(a ^ b) : (a ^ b);

endmodule
