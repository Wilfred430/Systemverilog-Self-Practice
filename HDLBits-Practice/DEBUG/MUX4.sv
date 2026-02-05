module top_module (
    input  [1:0] sel,
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] out
);  //

  wire [7:0] m0, m1;
  mux2 x0 (
      sel[0],
      a,
      b,
      m0
  );
  mux2 x1 (
      sel[0],
      c,
      d,
      m1
  );
  mux2 x2 (
      sel[1],
      m0,
      m1,
      out
  );

endmodule
