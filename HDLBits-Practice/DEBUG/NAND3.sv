module top_module (
    input  a,
    input  b,
    input  c,
    output out
);  //

  wire tmp;
  assign out = ~tmp;

  // module andgate ( output out, input a, input b, input c, input d, input e );
  andgate inst1 (
      tmp,
      a,
      b,
      c,
      1'b1,
      1'b1
  );

endmodule
